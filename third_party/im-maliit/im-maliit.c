/*
 * im-maliit -- a GTK3 input method module for Maliit.
 *
 * Ubuntu Touch's on-screen keyboard is Maliit, and Lomiri's session already
 * sets GTK_IM_MODULE=maliit -- but no GTK module by that name exists on the
 * device, only a Qt5 platform input context plugin. GTK applications therefore
 * have no way to raise the keyboard: Mir advertises no text-input Wayland
 * protocol (checked with WAYLAND_DEBUG; it offers only wl_compositor, wl_seat,
 * wl_shm, wl_subcompositor, xdg_wm_base, zxdg_shell_v6 and friends), so
 * im-wayland.so cannot help either.
 *
 * This module speaks Maliit's D-Bus protocol directly, which works regardless
 * of whether the app is running on Wayland or through XWayland.
 *
 * Protocol, as implemented by maliit-framework 2.3.0:
 *
 *   session bus  org.maliit.server /org/maliit/server/address
 *                org.maliit.Server.Address.address  -> peer socket address
 *
 *   peer conn    we call   com.meego.inputmethod.uiserver1
 *                          at /com/meego/inputmethod/uiserver1
 *                we export com.meego.inputmethod.inputcontext1
 *                          at /com/meego/inputmethod/inputcontext1
 *
 * The peer address is /run/user/<uid>/maliit-server, which Ubuntu Touch's
 * click AppArmor policy already grants a rule for run/user/<uid>/maliit-server,
 * so a confined click app can use this without policy changes.
 *
 * Copyright (C) 2026 Hans Kramer
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version. See the LICENSE file for the full text.
 */

#include <gtk/gtk.h>
#include <gtk/gtkimmodule.h>
#include <gdk/gdk.h>
#include <gdk/gdkkeysyms.h>
#include <gio/gio.h>
#include <string.h>

#define MALIIT_BUS_NAME   "org.maliit.server"
#define MALIIT_ADDR_PATH  "/org/maliit/server/address"
#define MALIIT_ADDR_IFACE "org.maliit.Server.Address"

#define SERVER_PATH   "/com/meego/inputmethod/uiserver1"
#define SERVER_IFACE  "com.meego.inputmethod.uiserver1"
/* Note the asymmetry, which is easy to get wrong: the interface carries a
 * trailing "1" but the object path does not. maliit-framework registers the
 * client adaptor at InputContextAdaptorPath in connection/dbusserverconnection.cpp.
 * Exporting at ".../inputcontext1" lets the keyboard appear but silently drops
 * every commitString and keyEvent coming back. */
#define CONTEXT_PATH  "/com/meego/inputmethod/inputcontext"
#define CONTEXT_IFACE "com.meego.inputmethod.inputcontext1"

/* QEvent::Type */
#define QEVENT_KEY_PRESS   6
#define QEVENT_KEY_RELEASE 7

#define IM_MALIIT_TYPE (im_maliit_type)
#define IM_MALIIT(o)   (G_TYPE_CHECK_INSTANCE_CAST((o), IM_MALIIT_TYPE, ImMaliit))

typedef struct {
    GtkIMContext parent;
    GdkWindow *client_window;
    gchar *preedit;
    gint preedit_cursor;
    gboolean focused;
    GdkRectangle cursor_rect; /* caret, in client-window coordinates */
} ImMaliit;

typedef struct {
    GtkIMContextClass parent;
} ImMaliitClass;

static GType im_maliit_type = 0;
static GObjectClass *parent_class = NULL;

/* One peer connection per process; callbacks are routed to whichever context
 * currently holds focus. */
static GDBusConnection *maliit_conn = NULL;
static gboolean maliit_conn_failed = FALSE;
static ImMaliit *focused_context = NULL;

static void im_maliit_register_type(GTypeModule *module);

/* ------------------------------------------------------------------ */
/* Server calls                                                        */
/* ------------------------------------------------------------------ */

static void server_call(const gchar *method, GVariant *params)
{
    if (!maliit_conn) {
        if (params) {
            g_variant_ref_sink(params);
            g_variant_unref(params);
        }
        return;
    }
    g_dbus_connection_call(maliit_conn, NULL, SERVER_PATH, SERVER_IFACE, method,
                           params, NULL, G_DBUS_CALL_FLAGS_NO_AUTO_START, -1,
                           NULL, NULL, NULL);
}

/* Maliit decides whether to show a keyboard, which layout, and what to predict
 * from this property bag. focusState is what raises the keyboard; the
 * surrounding text and caret rectangle are what make prediction,
 * autocapitalisation and keyboard placement work. */
static void send_widget_information(ImMaliit *self, gboolean focus_changed)
{
    GVariantBuilder b;
    g_variant_builder_init(&b, G_VARIANT_TYPE("a{sv}"));
    g_variant_builder_add(&b, "{sv}", "focusState",
                          g_variant_new_boolean(self->focused));
    g_variant_builder_add(&b, "{sv}", "contentType", g_variant_new_int32(0));
    g_variant_builder_add(&b, "{sv}", "correctionEnabled",
                          g_variant_new_boolean(TRUE));
    g_variant_builder_add(&b, "{sv}", "predictionEnabled",
                          g_variant_new_boolean(TRUE));
    g_variant_builder_add(&b, "{sv}", "autocapitalizationEnabled",
                          g_variant_new_boolean(TRUE));
    g_variant_builder_add(&b, "{sv}", "hiddenText", g_variant_new_boolean(FALSE));
    g_variant_builder_add(&b, "{sv}", "inputMethodMode", g_variant_new_int32(0));
    g_variant_builder_add(&b, "{sv}", "visualizationPriority",
                          g_variant_new_boolean(FALSE));

    /* Asks the client widget for the text around the caret. Gecko answers this;
     * widgets that do not simply return FALSE, which is why the keys are only
     * added on success rather than sent as empty strings. */
    gchar *surrounding = NULL;
    gint cursor_index = 0;
    if (gtk_im_context_get_surrounding(GTK_IM_CONTEXT(self), &surrounding,
                                       &cursor_index)) {
        /* Maliit counts in characters; GTK reports a byte offset. */
        glong cursor_chars =
            g_utf8_pointer_to_offset(surrounding, surrounding + cursor_index);

        g_variant_builder_add(&b, "{sv}", "surroundingText",
                              g_variant_new_string(surrounding));
        g_variant_builder_add(&b, "{sv}", "cursorPosition",
                              g_variant_new_int32((gint)cursor_chars));
        g_variant_builder_add(&b, "{sv}", "anchorPosition",
                              g_variant_new_int32((gint)cursor_chars));
        g_variant_builder_add(&b, "{sv}", "hasSelection",
                              g_variant_new_boolean(FALSE));
        g_free(surrounding);
    }

    if (self->cursor_rect.width > 0 || self->cursor_rect.height > 0) {
        gint x = self->cursor_rect.x;
        gint y = self->cursor_rect.y;

        /* set_cursor_location gives client-window coordinates; Maliit positions
         * itself on screen, so translate. */
        if (self->client_window) {
            gint ox = 0, oy = 0;
            gdk_window_get_origin(self->client_window, &ox, &oy);
            x += ox;
            y += oy;
        }
        g_variant_builder_add(
            &b, "{sv}", "cursorRectangle",
            g_variant_new("(iiii)", x, y, self->cursor_rect.width,
                          self->cursor_rect.height));
    }

    server_call("updateWidgetInformation",
                g_variant_new("(a{sv}b)", &b, focus_changed));
}

/* ------------------------------------------------------------------ */
/* Server -> client callbacks                                          */
/* ------------------------------------------------------------------ */

/* Maliit reports keys as Qt::Key values. Only the editing keys need
 * translating: printable characters arrive through commitString, or in the
 * text argument below. */
static guint qt_key_to_gdk(gint qt_key)
{
    switch (qt_key) {
    case 0x01000000: return GDK_KEY_Escape;
    case 0x01000001: return GDK_KEY_Tab;
    case 0x01000003: return GDK_KEY_BackSpace;
    case 0x01000004: return GDK_KEY_Return;
    case 0x01000005: return GDK_KEY_KP_Enter;
    case 0x01000007: return GDK_KEY_Delete;
    case 0x01000010: return GDK_KEY_Home;
    case 0x01000011: return GDK_KEY_End;
    case 0x01000012: return GDK_KEY_Left;
    case 0x01000013: return GDK_KEY_Up;
    case 0x01000014: return GDK_KEY_Right;
    case 0x01000015: return GDK_KEY_Down;
    case 0x01000016: return GDK_KEY_Page_Up;
    case 0x01000017: return GDK_KEY_Page_Down;
    case 0x20:       return GDK_KEY_space;
    default:         return 0;
    }
}

static void deliver_key(ImMaliit *self, gint key_type, gint qt_key,
                        const gchar *text)
{
    guint keyval = qt_key_to_gdk(qt_key);

    /* Editing keys go through GTK's own surrounding-text API rather than a
     * synthesised key event. gdk_event_put() has to guess its way back through
     * the focus chain, which works unevenly -- deleting text that was typed
     * before the widget last lost focus would fail. delete_surrounding asks the
     * widget directly and is what GTK input methods are meant to use. */
    if (key_type == QEVENT_KEY_PRESS) {
        if (keyval == GDK_KEY_BackSpace) {
            if (gtk_im_context_delete_surrounding(GTK_IM_CONTEXT(self), -1, 1)) {
                return;
            }
        } else if (keyval == GDK_KEY_Delete) {
            if (gtk_im_context_delete_surrounding(GTK_IM_CONTEXT(self), 0, 1)) {
                return;
            }
        }
    }

    /* Anything printable is far more reliably delivered as a commit than as a
     * synthesised key event. */
    if (!keyval) {
        if (key_type == QEVENT_KEY_PRESS && text && *text) {
            g_signal_emit_by_name(self, "commit", text);
        }
        return;
    }

    if (!self->client_window) {
        return;
    }

    GdkEvent *ev = gdk_event_new(key_type == QEVENT_KEY_PRESS ? GDK_KEY_PRESS
                                                              : GDK_KEY_RELEASE);
    ev->key.window = g_object_ref(self->client_window);
    ev->key.send_event = TRUE;
    ev->key.time = GDK_CURRENT_TIME;
    ev->key.state = 0;
    ev->key.keyval = keyval;
    ev->key.length = 0;
    ev->key.string = NULL;
    ev->key.hardware_keycode = 0;
    ev->key.group = 0;
    ev->key.is_modifier = 0;

    GdkDisplay *display = gdk_window_get_display(self->client_window);
    GdkSeat *seat = gdk_display_get_default_seat(display);
    if (seat) {
        gdk_event_set_device(ev, gdk_seat_get_keyboard(seat));
    }

    gdk_event_put(ev);
    gdk_event_free(ev);
}

static void set_preedit(ImMaliit *self, const gchar *text, gint cursor)
{
    gboolean had = self->preedit && *self->preedit;
    gboolean has = text && *text;

    g_free(self->preedit);
    self->preedit = g_strdup(text ? text : "");
    self->preedit_cursor = cursor;

    if (!had && has) {
        g_signal_emit_by_name(self, "preedit-start");
    }
    g_signal_emit_by_name(self, "preedit-changed");
    if (had && !has) {
        g_signal_emit_by_name(self, "preedit-end");
    }
}

static void context_method_call(GDBusConnection *conn, const gchar *sender,
                                const gchar *path, const gchar *iface,
                                const gchar *method, GVariant *params,
                                GDBusMethodInvocation *invocation,
                                gpointer user_data)
{
    ImMaliit *self = focused_context;

    if (!g_strcmp0(method, "commitString")) {
        const gchar *text = NULL;
        gint rs, rl, cp;
        g_variant_get(params, "(&siii)", &text, &rs, &rl, &cp);
        if (self) {
            if (self->preedit && *self->preedit) {
                set_preedit(self, "", 0);
            }
            /* A non-zero replace range means Maliit is correcting or completing
             * an already-typed word; without honouring it the new word is
             * appended to the old one instead of replacing it. */
            if (rl > 0) {
                gtk_im_context_delete_surrounding(GTK_IM_CONTEXT(self), rs, rl);
            }
            if (text && *text) {
                g_signal_emit_by_name(self, "commit", text);
            }
        }
        g_dbus_method_invocation_return_value(invocation, NULL);
        return;
    }

    if (!g_strcmp0(method, "updatePreedit")) {
        const gchar *text = NULL;
        GVariantIter *fmt = NULL;
        gint rs, rl, cp;
        g_variant_get(params, "(&sa(iii)iii)", &text, &fmt, &rs, &rl, &cp);
        if (fmt) {
            g_variant_iter_free(fmt);
        }
        if (self) {
            set_preedit(self, text, cp);
        }
        g_dbus_method_invocation_return_value(invocation, NULL);
        return;
    }

    if (!g_strcmp0(method, "keyEvent")) {
        gint type, key, mods, count;
        const gchar *text = NULL;
        gboolean autorep;
        guchar req;
        g_variant_get(params, "(iii&sbiy)", &type, &key, &mods, &text,
                      &autorep, &count, &req);
        if (self) {
            deliver_key(self, type, key, text);
        }
        g_dbus_method_invocation_return_value(invocation, NULL);
        return;
    }

    if (!g_strcmp0(method, "imInitiatedHide")) {
        if (self && self->preedit && *self->preedit) {
            set_preedit(self, "", 0);
        }
        g_dbus_method_invocation_return_value(invocation, NULL);
        return;
    }

    /* Methods with return values must be answered or the server blocks. */
    if (!g_strcmp0(method, "preeditRectangle")) {
        g_dbus_method_invocation_return_value(
            invocation, g_variant_new("(biiii)", FALSE, 0, 0, 0, 0));
        return;
    }
    if (!g_strcmp0(method, "selection")) {
        g_dbus_method_invocation_return_value(
            invocation, g_variant_new("(bs)", FALSE, ""));
        return;
    }

    /* activationLostEvent, setRedirectKeys, setDetectableAutoRepeat,
     * setGlobalCorrectionEnabled, setLanguage, setSelection,
     * updateInputMethodArea, notifyExtendedAttributeChanged,
     * pluginSettingsLoaded -- nothing to do, but still acknowledge. */
    g_dbus_method_invocation_return_value(invocation, NULL);
}

static const gchar context_introspection[] =
    "<node>"
    "  <interface name='" CONTEXT_IFACE "'>"
    "    <method name='activationLostEvent'/>"
    "    <method name='imInitiatedHide'/>"
    "    <method name='commitString'>"
    "      <arg type='s' direction='in'/><arg type='i' direction='in'/>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "    </method>"
    "    <method name='updatePreedit'>"
    "      <arg type='s' direction='in'/><arg type='a(iii)' direction='in'/>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "      <arg type='i' direction='in'/>"
    "    </method>"
    "    <method name='keyEvent'>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "      <arg type='i' direction='in'/><arg type='s' direction='in'/>"
    "      <arg type='b' direction='in'/><arg type='i' direction='in'/>"
    "      <arg type='y' direction='in'/>"
    "    </method>"
    "    <method name='updateInputMethodArea'>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "    </method>"
    "    <method name='setGlobalCorrectionEnabled'>"
    "      <arg type='b' direction='in'/>"
    "    </method>"
    "    <method name='preeditRectangle'>"
    "      <arg type='b' direction='out'/><arg type='i' direction='out'/>"
    "      <arg type='i' direction='out'/><arg type='i' direction='out'/>"
    "      <arg type='i' direction='out'/>"
    "    </method>"
    "    <method name='setRedirectKeys'><arg type='b' direction='in'/></method>"
    "    <method name='setDetectableAutoRepeat'>"
    "      <arg type='b' direction='in'/>"
    "    </method>"
    "    <method name='setSelection'>"
    "      <arg type='i' direction='in'/><arg type='i' direction='in'/>"
    "    </method>"
    "    <method name='selection'>"
    "      <arg type='b' direction='out'/><arg type='s' direction='out'/>"
    "    </method>"
    "    <method name='setLanguage'><arg type='s' direction='in'/></method>"
    "    <method name='notifyExtendedAttributeChanged'>"
    "      <arg type='i' direction='in'/><arg type='s' direction='in'/>"
    "      <arg type='s' direction='in'/><arg type='s' direction='in'/>"
    "      <arg type='v' direction='in'/>"
    "    </method>"
    "    <method name='pluginSettingsLoaded'>"
    "      <arg type='a(sssia(ssibva{sv}))' direction='in'/>"
    "    </method>"
    "  </interface>"
    "</node>";

static const GDBusInterfaceVTable context_vtable = {
    context_method_call, NULL, NULL, {0}
};

/* ------------------------------------------------------------------ */
/* Connection setup                                                    */
/* ------------------------------------------------------------------ */

static gboolean ensure_connection(void)
{
    if (maliit_conn) {
        return TRUE;
    }
    if (maliit_conn_failed) {
        return FALSE;
    }

    GError *err = NULL;
    GDBusConnection *session =
        g_bus_get_sync(G_BUS_TYPE_SESSION, NULL, &err);
    if (!session) {
        g_warning("im-maliit: no session bus: %s", err ? err->message : "?");
        g_clear_error(&err);
        maliit_conn_failed = TRUE;
        return FALSE;
    }

    GVariant *reply = g_dbus_connection_call_sync(
        session, MALIIT_BUS_NAME, MALIIT_ADDR_PATH,
        "org.freedesktop.DBus.Properties", "Get",
        g_variant_new("(ss)", MALIIT_ADDR_IFACE, "address"),
        G_VARIANT_TYPE("(v)"), G_DBUS_CALL_FLAGS_NONE, 3000, NULL, &err);
    g_object_unref(session);

    if (!reply) {
        g_warning("im-maliit: cannot read maliit address: %s",
                  err ? err->message : "?");
        g_clear_error(&err);
        maliit_conn_failed = TRUE;
        return FALSE;
    }

    GVariant *boxed = NULL;
    g_variant_get(reply, "(v)", &boxed);
    const gchar *address = g_variant_get_string(boxed, NULL);

    maliit_conn = g_dbus_connection_new_for_address_sync(
        address, G_DBUS_CONNECTION_FLAGS_AUTHENTICATION_CLIENT, NULL, NULL,
        &err);

    g_variant_unref(boxed);
    g_variant_unref(reply);

    if (!maliit_conn) {
        g_warning("im-maliit: cannot connect to maliit: %s",
                  err ? err->message : "?");
        g_clear_error(&err);
        maliit_conn_failed = TRUE;
        return FALSE;
    }

    GDBusNodeInfo *info =
        g_dbus_node_info_new_for_xml(context_introspection, &err);
    if (!info) {
        g_warning("im-maliit: bad introspection XML: %s",
                  err ? err->message : "?");
        g_clear_error(&err);
        maliit_conn_failed = TRUE;
        return FALSE;
    }

    g_dbus_connection_register_object(maliit_conn, CONTEXT_PATH,
                                      info->interfaces[0], &context_vtable,
                                      NULL, NULL, &err);
    g_dbus_node_info_unref(info);

    if (err) {
        g_warning("im-maliit: cannot export input context: %s", err->message);
        g_clear_error(&err);
        maliit_conn_failed = TRUE;
        return FALSE;
    }

    return TRUE;
}

/* ------------------------------------------------------------------ */
/* GtkIMContext implementation                                         */
/* ------------------------------------------------------------------ */

static void im_maliit_focus_in(GtkIMContext *context)
{
    ImMaliit *self = IM_MALIIT(context);
    self->focused = TRUE;
    focused_context = self;

    if (!ensure_connection()) {
        return;
    }
    server_call("activateContext", NULL);
    send_widget_information(self, TRUE);
    server_call("showInputMethod", NULL);
}

static void im_maliit_focus_out(GtkIMContext *context)
{
    ImMaliit *self = IM_MALIIT(context);
    self->focused = FALSE;

    if (maliit_conn) {
        send_widget_information(self, TRUE);
        server_call("hideInputMethod", NULL);
    }
    if (self->preedit && *self->preedit) {
        set_preedit(self, "", 0);
    }
    if (focused_context == self) {
        focused_context = NULL;
    }
}

static void im_maliit_reset(GtkIMContext *context)
{
    ImMaliit *self = IM_MALIIT(context);
    if (self->preedit && *self->preedit) {
        set_preedit(self, "", 0);
    }
    server_call("reset", NULL);
}

static void im_maliit_set_client_window(GtkIMContext *context,
                                        GdkWindow *window)
{
    ImMaliit *self = IM_MALIIT(context);
    if (self->client_window) {
        g_object_unref(self->client_window);
    }
    self->client_window = window ? g_object_ref(window) : NULL;
}

static void im_maliit_get_preedit_string(GtkIMContext *context, gchar **str,
                                         PangoAttrList **attrs,
                                         gint *cursor_pos)
{
    ImMaliit *self = IM_MALIIT(context);
    const gchar *text = self->preedit ? self->preedit : "";

    if (str) {
        *str = g_strdup(text);
    }
    if (attrs) {
        *attrs = pango_attr_list_new();
        if (*text) {
            PangoAttribute *ul = pango_attr_underline_new(PANGO_UNDERLINE_SINGLE);
            ul->start_index = 0;
            ul->end_index = strlen(text);
            pango_attr_list_insert(*attrs, ul);
        }
    }
    if (cursor_pos) {
        *cursor_pos = self->preedit_cursor;
    }
}

/* Gecko calls this whenever the caret moves. Maliit uses it to place the
 * keyboard clear of the text being edited, and it is also the natural moment to
 * refresh the surrounding text used for prediction. Deduplicated because the
 * caret moves on every keystroke. */
static void im_maliit_set_cursor_location(GtkIMContext *context,
                                          GdkRectangle *area)
{
    ImMaliit *self = IM_MALIIT(context);

    if (!area) {
        return;
    }
    if (area->x == self->cursor_rect.x && area->y == self->cursor_rect.y &&
        area->width == self->cursor_rect.width &&
        area->height == self->cursor_rect.height) {
        return;
    }

    self->cursor_rect = *area;

    if (self->focused && maliit_conn) {
        send_widget_information(self, FALSE);
    }
}

/* filter_keypress is deliberately left at the GtkIMContext default: hardware
 * key presses want GTK's normal handling, and Maliit input arrives over D-Bus
 * rather than through the key-event path. */

static void im_maliit_finalize(GObject *obj)
{
    ImMaliit *self = IM_MALIIT(obj);

    if (focused_context == self) {
        focused_context = NULL;
    }
    if (self->client_window) {
        g_object_unref(self->client_window);
        self->client_window = NULL;
    }
    g_free(self->preedit);
    self->preedit = NULL;

    parent_class->finalize(obj);
}

static void im_maliit_class_init(ImMaliitClass *klass)
{
    GtkIMContextClass *im = GTK_IM_CONTEXT_CLASS(klass);
    GObjectClass *object_class = G_OBJECT_CLASS(klass);

    parent_class = g_type_class_peek_parent(klass);

    im->set_client_window = im_maliit_set_client_window;
    im->focus_in = im_maliit_focus_in;
    im->focus_out = im_maliit_focus_out;
    im->reset = im_maliit_reset;
    im->get_preedit_string = im_maliit_get_preedit_string;
    im->set_cursor_location = im_maliit_set_cursor_location;

    object_class->finalize = im_maliit_finalize;
}

static void im_maliit_init(ImMaliit *self)
{
    self->client_window = NULL;
    self->preedit = g_strdup("");
    self->preedit_cursor = 0;
    self->focused = FALSE;
}

static void im_maliit_register_type(GTypeModule *module)
{
    static const GTypeInfo info = {
        sizeof(ImMaliitClass),
        NULL, NULL,
        (GClassInitFunc)im_maliit_class_init,
        NULL, NULL,
        sizeof(ImMaliit),
        0,
        (GInstanceInitFunc)im_maliit_init,
        NULL,
    };

    im_maliit_type = g_type_module_register_type(module, GTK_TYPE_IM_CONTEXT,
                                                 "ImMaliit", &info, 0);
}

/* ------------------------------------------------------------------ */
/* GTK module entry points                                             */
/* ------------------------------------------------------------------ */

static const GtkIMContextInfo maliit_info = {
    "maliit",
    "Maliit",
    "gtk30",
    "",
    "",
};

static const GtkIMContextInfo *info_list[] = { &maliit_info };

G_MODULE_EXPORT void im_module_init(GTypeModule *module)
{
    im_maliit_register_type(module);
}

G_MODULE_EXPORT void im_module_exit(void)
{
}

G_MODULE_EXPORT void im_module_list(const GtkIMContextInfo ***contexts,
                                    int *n_contexts)
{
    *contexts = info_list;
    *n_contexts = G_N_ELEMENTS(info_list);
}

G_MODULE_EXPORT GtkIMContext *im_module_create(const gchar *context_id)
{
    if (g_strcmp0(context_id, "maliit") != 0) {
        return NULL;
    }
    return GTK_IM_CONTEXT(g_object_new(im_maliit_type, NULL));
}
