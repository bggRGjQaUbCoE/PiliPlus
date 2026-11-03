#include <flutter_linux/flutter_linux.h>

#include <cmath>
#include <cstring>
#include <limits>

namespace {

struct MenuState {
  GWeakRef view;
  GtkWidget* menu = nullptr;
};

constexpr char kChannelName[] = "com.example.piliplus/linux_context_menu";
constexpr char kMenuData[] = "linux_context_menu_data";
constexpr char kItemIndex[] = "linux_context_menu_index";

struct MenuData {
  FlMethodCall* call;
  gint64 request_id;
  int selected = -1;
  bool responded = false;
  bool closing = false;
};

static void respond(MenuData* data, int selected) {
  if (data->responded) return;
  data->responded = true;
  g_autoptr(FlValue) result = fl_value_new_int(selected);
  fl_method_call_respond_success(data->call, result, nullptr);
}

static void close_menu(MenuState* self) {
  if (self->menu == nullptr) return;
  GtkWidget* menu = self->menu;
  self->menu = nullptr;
  gtk_widget_destroy(menu);
  g_object_unref(menu);
}

static void menu_destroyed(GtkWidget* menu, MenuState* self) {
  auto* data =
      static_cast<MenuData*>(g_object_get_data(G_OBJECT(menu), kMenuData));
  respond(data, -1);
  if (self->menu == menu) {
    self->menu = nullptr;
    g_object_unref(menu);
  }
}

static void selection_done(GtkMenuShell* menu, gpointer) {
  auto* data =
      static_cast<MenuData*>(g_object_get_data(G_OBJECT(menu), kMenuData));
  respond(data, data->selected);
  if (data->closing) return;
  data->closing = true;
  // Finish GTK's selection signal before destroying its menu hierarchy.
  g_idle_add_full(
      G_PRIORITY_DEFAULT_IDLE,
      [](gpointer value) -> gboolean {
        gtk_widget_destroy(GTK_WIDGET(value));
        return G_SOURCE_REMOVE;
      },
      g_object_ref(menu), g_object_unref);
}

static bool coordinate(FlValue* args, const char* key, int* value) {
  FlValue* item = fl_value_lookup_string(args, key);
  if (item == nullptr) return false;
  double number;
  switch (fl_value_get_type(item)) {
    case FL_VALUE_TYPE_INT:
      number = static_cast<double>(fl_value_get_int(item));
      break;
    case FL_VALUE_TYPE_FLOAT:
      number = fl_value_get_float(item);
      break;
    default:
      return false;
  }
  if (!std::isfinite(number) || number < std::numeric_limits<int>::min() ||
      number > std::numeric_limits<int>::max())
    return false;
  *value = static_cast<int>(std::round(number));
  return true;
}

static void method_call(FlMethodChannel*, FlMethodCall* call,
                        gpointer user_data) {
  auto* self = static_cast<MenuState*>(user_data);
  const char* method = fl_method_call_get_name(call);
  FlValue* args = fl_method_call_get_args(call);
  if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
    fl_method_call_respond_error(call, "bad_arguments", "Expected a map",
                                 nullptr, nullptr);
    return;
  }
  FlValue* id = fl_value_lookup_string(args, "requestId");
  if (id == nullptr || fl_value_get_type(id) != FL_VALUE_TYPE_INT) {
    fl_method_call_respond_error(call, "bad_arguments", "Missing requestId",
                                 nullptr, nullptr);
    return;
  }
  if (std::strcmp(method, "dismiss") == 0) {
    if (self->menu != nullptr) {
      auto* data = static_cast<MenuData*>(
          g_object_get_data(G_OBJECT(self->menu), kMenuData));
      if (data->request_id == fl_value_get_int(id)) close_menu(self);
    }
    fl_method_call_respond_success(call, nullptr, nullptr);
    return;
  }
  if (std::strcmp(method, "show") != 0) {
    fl_method_call_respond_not_implemented(call, nullptr);
    return;
  }
  FlValue* items = fl_value_lookup_string(args, "items");
  GdkRectangle anchor;
  if (items == nullptr || fl_value_get_type(items) != FL_VALUE_TYPE_LIST ||
      !coordinate(args, "x", &anchor.x) || !coordinate(args, "y", &anchor.y) ||
      !coordinate(args, "width", &anchor.width) ||
      !coordinate(args, "height", &anchor.height) || anchor.width <= 0 ||
      anchor.height <= 0) {
    fl_method_call_respond_error(call, "bad_arguments",
                                 "Invalid items or anchor", nullptr, nullptr);
    return;
  }
  bool selectable = false;
  for (size_t index = 0; index < fl_value_get_length(items); ++index) {
    FlValueType type = fl_value_get_type(fl_value_get_list_value(items, index));
    if (type == FL_VALUE_TYPE_STRING)
      selectable = true;
    else if (type != FL_VALUE_TYPE_NULL) {
      fl_method_call_respond_error(call, "bad_arguments", "Invalid menu item",
                                   nullptr, nullptr);
      return;
    }
  }
  if (!selectable) {
    g_autoptr(FlValue) result = fl_value_new_int(-1);
    fl_method_call_respond_success(call, result, nullptr);
    return;
  }
  g_autoptr(GObject) view = G_OBJECT(g_weak_ref_get(&self->view));
  GtkWidget* toplevel =
      view == nullptr ? nullptr : gtk_widget_get_toplevel(GTK_WIDGET(view));
  GdkWindow* window = toplevel == nullptr || !GTK_IS_WINDOW(toplevel)
                          ? nullptr
                          : gtk_widget_get_window(toplevel);
  // FlView is a windowless GtkBox. Translate into its toplevel's coordinates
  // so a native header bar or other runner layout does not shift the popup.
  if (window == nullptr ||
      !gtk_widget_translate_coordinates(GTK_WIDGET(view), toplevel, anchor.x,
                                        anchor.y, &anchor.x, &anchor.y)) {
    fl_method_call_respond_error(
        call, "no_window", "Flutter view is unavailable", nullptr, nullptr);
    return;
  }
  close_menu(self);
  GtkWidget* menu = gtk_menu_new();
  g_object_ref_sink(menu);
  self->menu = menu;
  auto* data =
      new MenuData{FL_METHOD_CALL(g_object_ref(call)), fl_value_get_int(id)};
  g_object_set_data_full(G_OBJECT(menu), kMenuData, data, [](gpointer value) {
    auto* data = static_cast<MenuData*>(value);
    g_object_unref(data->call);
    delete data;
  });
  g_signal_connect(menu, "destroy", G_CALLBACK(menu_destroyed), self);
  g_signal_connect(menu, "selection-done", G_CALLBACK(selection_done), nullptr);
  gtk_menu_attach_to_widget(GTK_MENU(menu), GTK_WIDGET(view), nullptr);
  for (size_t index = 0; index < fl_value_get_length(items); ++index) {
    FlValue* entry = fl_value_get_list_value(items, index);
    GtkWidget* item;
    if (fl_value_get_type(entry) == FL_VALUE_TYPE_NULL) {
      item = gtk_separator_menu_item_new();
    } else {
      item = gtk_menu_item_new_with_label(fl_value_get_string(entry));
      g_object_set_data(G_OBJECT(item), kItemIndex,
                        GINT_TO_POINTER(static_cast<int>(index) + 1));
      g_signal_connect(
          item, "activate", G_CALLBACK(+[](GtkMenuItem* item, gpointer value) {
            auto* data = static_cast<MenuData*>(value);
            data->selected =
                GPOINTER_TO_INT(g_object_get_data(G_OBJECT(item), kItemIndex)) -
                1;
          }),
          data);
    }
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), item);
  }
  gtk_widget_show_all(menu);
  gtk_menu_popup_at_rect(GTK_MENU(menu), window, &anchor,
                         GDK_GRAVITY_SOUTH_EAST, GDK_GRAVITY_NORTH_EAST,
                         nullptr);
}

}  // namespace

void RegisterLinuxContextMenu(FlView* view) {
  auto* state = new MenuState();
  g_weak_ref_init(&state->view, G_OBJECT(view));
  g_autoptr(FlPluginRegistrar) registrar =
      fl_plugin_registry_get_registrar_for_plugin(FL_PLUGIN_REGISTRY(view),
                                                  "LinuxContextMenu");
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call, state, [](gpointer value) {
        auto* state = static_cast<MenuState*>(value);
        close_menu(state);
        g_weak_ref_clear(&state->view);
        delete state;
      });
}
