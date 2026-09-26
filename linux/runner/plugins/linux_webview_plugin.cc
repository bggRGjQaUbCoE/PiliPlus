#include "linux_webview_plugin.h"

#include <webkit2/webkit2.h>

#include <algorithm>
#include <cmath>
#include <iostream>
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>

namespace {

static const char* kChannelName = "com.example.piliplus/linux_webview";

static GtkOverlay* s_overlay = nullptr;
static FlView* s_fl_view = nullptr;
static FlMethodChannel* s_channel = nullptr;

struct WebviewSession;
static std::unordered_map<int64_t, WebviewSession*> s_sessions;

static double get_double_from_map(FlValue* map, const gchar* key,
                                  double def_val = 0.0) {
  if (map == nullptr || fl_value_get_type(map) != FL_VALUE_TYPE_MAP)
    return def_val;
  FlValue* val = fl_value_lookup_string(map, key);
  if (val == nullptr) return def_val;
  if (fl_value_get_type(val) == FL_VALUE_TYPE_FLOAT) {
    return fl_value_get_float(val);
  }
  if (fl_value_get_type(val) == FL_VALUE_TYPE_INT) {
    return static_cast<double>(fl_value_get_int(val));
  }
  return def_val;
}

static int64_t get_int_from_map(FlValue* map, const gchar* key,
                                int64_t def_val = 0) {
  if (map == nullptr || fl_value_get_type(map) != FL_VALUE_TYPE_MAP)
    return def_val;
  FlValue* val = fl_value_lookup_string(map, key);
  if (val == nullptr) return def_val;
  if (fl_value_get_type(val) == FL_VALUE_TYPE_INT) {
    return fl_value_get_int(val);
  }
  if (fl_value_get_type(val) == FL_VALUE_TYPE_FLOAT) {
    return static_cast<int64_t>(fl_value_get_float(val));
  }
  return def_val;
}

static const gchar* get_string_from_map(FlValue* map, const gchar* key,
                                        const gchar* def_val = nullptr) {
  if (map == nullptr || fl_value_get_type(map) != FL_VALUE_TYPE_MAP)
    return def_val;
  FlValue* val = fl_value_lookup_string(map, key);
  if (val == nullptr || fl_value_get_type(val) != FL_VALUE_TYPE_STRING)
    return def_val;
  return fl_value_get_string(val);
}

static bool get_bool_from_map(FlValue* map, const gchar* key,
                              bool def_val = false) {
  if (map == nullptr || fl_value_get_type(map) != FL_VALUE_TYPE_MAP)
    return def_val;
  FlValue* val = fl_value_lookup_string(map, key);
  if (val == nullptr || fl_value_get_type(val) != FL_VALUE_TYPE_BOOL)
    return def_val;
  return fl_value_get_bool(val);
}

struct WebviewSession {
  int64_t view_id = 0;
  GtkWidget* container = nullptr;
  GtkWidget* web_view = nullptr;
  WebKitUserContentManager* content_manager = nullptr;
  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;
  bool visible = true;

  ~WebviewSession() { Cleanup(); }

  void Cleanup() {
    if (web_view != nullptr) {
      g_signal_handlers_disconnect_by_data(web_view, this);
      webkit_web_view_stop_loading(WEBKIT_WEB_VIEW(web_view));
      web_view = nullptr;
    }
    if (content_manager != nullptr) {
      g_signal_handlers_disconnect_by_data(content_manager, this);
      webkit_user_content_manager_unregister_script_message_handler(
          content_manager, "msgToNative");
      g_object_unref(content_manager);
      content_manager = nullptr;
    }
    if (container != nullptr) {
      GtkWidget* c = container;
      container = nullptr;
      gtk_widget_hide(c);
      g_object_ref(c);
      g_idle_add_full(G_PRIORITY_DEFAULT_IDLE,
                      G_SOURCE_FUNC(+[](gpointer data) -> gboolean {
                        GtkWidget* widget = GTK_WIDGET(data);
                        if (GTK_IS_WIDGET(widget)) {
                          GtkWidget* parent = gtk_widget_get_parent(widget);
                          if (parent != nullptr && GTK_IS_CONTAINER(parent)) {
                            gtk_container_remove(GTK_CONTAINER(parent), widget);
                          }
                          gtk_widget_destroy(widget);
                        }
                        g_object_unref(widget);
                        return G_SOURCE_REMOVE;
                      }),
                      c, nullptr);
    }
    if (s_fl_view != nullptr) {
      gtk_widget_grab_focus(GTK_WIDGET(s_fl_view));
    }
    if (s_overlay != nullptr) {
      gtk_widget_queue_resize(GTK_WIDGET(s_overlay));
    }
  }

  void SendWebMessage(const std::string& message) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "message",
                             fl_value_new_string(message.c_str()));
    fl_method_channel_invoke_method(s_channel, "onWebMessageReceived", map,
                                    nullptr, nullptr, nullptr);
  }

  void SendNavigationRequest(const std::string& url) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "url", fl_value_new_string(url.c_str()));
    fl_method_channel_invoke_method(s_channel, "onNavigationRequest", map,
                                    nullptr, nullptr, nullptr);
  }

  void SendUrlChanged(const std::string& url) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "url", fl_value_new_string(url.c_str()));
    fl_method_channel_invoke_method(s_channel, "onUrlChanged", map, nullptr,
                                    nullptr, nullptr);
  }

  void SendProgress(double progress) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "progress", fl_value_new_float(progress));
    fl_method_channel_invoke_method(s_channel, "onProgressChanged", map,
                                    nullptr, nullptr, nullptr);
  }

  void SendTitle(const std::string& title) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "title", fl_value_new_string(title.c_str()));
    fl_method_channel_invoke_method(s_channel, "onTitleChanged", map, nullptr,
                                    nullptr, nullptr);
  }

  void SendLoadFailed(const std::string& url, const std::string& error) {
    if (s_channel == nullptr) return;
    g_autoptr(FlValue) map = fl_value_new_map();
    fl_value_set_string_take(map, "viewId", fl_value_new_int(view_id));
    fl_value_set_string_take(map, "url", fl_value_new_string(url.c_str()));
    fl_value_set_string_take(map, "error", fl_value_new_string(error.c_str()));
    fl_method_channel_invoke_method(s_channel, "onLoadFailed", map, nullptr,
                                    nullptr, nullptr);
  }
};

static void on_script_message_received(WebKitUserContentManager* manager,
                                       WebKitJavascriptResult* js_result,
                                       gpointer user_data) {
  WebviewSession* session = static_cast<WebviewSession*>(user_data);
  if (session == nullptr) return;

  JSCValue* value = webkit_javascript_result_get_js_value(js_result);
  if (value != nullptr) {
    gchar* msg = jsc_value_to_string(value);
    if (msg != nullptr) {
      session->SendWebMessage(msg);
      g_free(msg);
    }
  }
}

static gboolean on_decide_policy(WebKitWebView* web_view,
                                 WebKitPolicyDecision* decision,
                                 WebKitPolicyDecisionType type,
                                 gpointer user_data) {
  if (type == WEBKIT_POLICY_DECISION_TYPE_NAVIGATION_ACTION) {
    WebKitNavigationPolicyDecision* nav_decision =
        WEBKIT_NAVIGATION_POLICY_DECISION(decision);
    WebKitNavigationAction* action =
        webkit_navigation_policy_decision_get_navigation_action(nav_decision);
    WebKitURIRequest* request = webkit_navigation_action_get_request(action);
    const gchar* uri = webkit_uri_request_get_uri(request);
    WebviewSession* session = static_cast<WebviewSession*>(user_data);

    if (uri != nullptr && session != nullptr) {
      std::string url(uri);
      // If it's a custom scheme, ignore decision and notify Flutter
      if (url.rfind("http://", 0) != 0 && url.rfind("https://", 0) != 0 &&
          url.rfind("about:", 0) != 0 && url.rfind("data:", 0) != 0 &&
          url.rfind("blob:", 0) != 0) {
        session->SendNavigationRequest(url);
        webkit_policy_decision_ignore(decision);
        return TRUE;
      }
    }
  }
  return FALSE;
}

static gboolean on_load_failed(WebKitWebView* web_view,
                               WebKitLoadEvent load_event,
                               const gchar* failing_uri, GError* error,
                               gpointer user_data) {
  if (g_error_matches(error, WEBKIT_NETWORK_ERROR,
                      WEBKIT_NETWORK_ERROR_CANCELLED)) {
    return FALSE;
  }
  WebviewSession* session = static_cast<WebviewSession*>(user_data);
  if (session != nullptr) {
    std::string uri_str = (failing_uri != nullptr) ? failing_uri : "";
    std::string err_str = (error != nullptr && error->message != nullptr)
                              ? error->message
                              : "Unknown error";
    session->SendLoadFailed(uri_str, err_str);
  }
  return FALSE;
}

static void on_uri_changed(GObject* object, GParamSpec* pspec,
                           gpointer user_data) {
  WebKitWebView* web_view = WEBKIT_WEB_VIEW(object);
  const gchar* uri = webkit_web_view_get_uri(web_view);
  WebviewSession* session = static_cast<WebviewSession*>(user_data);
  if (session != nullptr && uri != nullptr) {
    session->SendUrlChanged(uri);
  }
}

static void on_progress_changed(GObject* object, GParamSpec* pspec,
                                gpointer user_data) {
  WebKitWebView* web_view = WEBKIT_WEB_VIEW(object);
  gdouble progress = webkit_web_view_get_estimated_load_progress(web_view);
  WebviewSession* session = static_cast<WebviewSession*>(user_data);
  if (session != nullptr) {
    session->SendProgress(progress);
  }
}

static void on_title_changed(GObject* object, GParamSpec* pspec,
                             gpointer user_data) {
  WebKitWebView* web_view = WEBKIT_WEB_VIEW(object);
  const gchar* title = webkit_web_view_get_title(web_view);
  WebviewSession* session = static_cast<WebviewSession*>(user_data);
  if (session != nullptr && title != nullptr) {
    session->SendTitle(title);
  }
}

static GtkWidget* on_create_web_view(WebKitWebView* web_view,
                                     WebKitNavigationAction* action,
                                     gpointer user_data) {
  WebKitURIRequest* request = webkit_navigation_action_get_request(action);
  const gchar* uri = webkit_uri_request_get_uri(request);
  if (uri != nullptr) {
    webkit_web_view_load_uri(web_view, uri);
  }
  return nullptr;
}

static void HandleMethodCall(FlMethodChannel* channel,
                             FlMethodCall* method_call, gpointer user_data) {
  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  if (strcmp(method, "create") == 0) {
    if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
      fl_method_call_respond_error(method_call, "BAD_ARGS",
                                   "Expected map argument", nullptr, nullptr);
      return;
    }
    if (s_overlay == nullptr) {
      fl_method_call_respond_error(method_call, "NO_OVERLAY",
                                   "GtkOverlay not initialized", nullptr,
                                   nullptr);
      return;
    }

    int64_t view_id = get_int_from_map(args, "viewId", 0);
    if (s_sessions.find(view_id) != s_sessions.end()) {
      delete s_sessions[view_id];
      s_sessions.erase(view_id);
    }

    auto* session = new WebviewSession();
    session->view_id = view_id;
    s_sessions[view_id] = session;

    double x = get_double_from_map(args, "x", 0.0);
    double y = get_double_from_map(args, "y", 0.0);
    double width = get_double_from_map(args, "width", 0.0);
    double height = get_double_from_map(args, "height", 0.0);
    session->x = static_cast<int>(std::round(x));
    session->y = static_cast<int>(std::round(y));
    session->width = static_cast<int>(std::round(width));
    session->height = static_cast<int>(std::round(height));

    bool incognito = get_bool_from_map(args, "incognito", false);
    g_autoptr(WebKitWebContext) context =
        incognito ? webkit_web_context_new_ephemeral()
                  : g_object_ref(webkit_web_context_get_default());

    session->content_manager = webkit_user_content_manager_new();

    // Register script message handler for 'msgToNative'
    webkit_user_content_manager_register_script_message_handler(
        session->content_manager, "msgToNative");
    g_signal_connect(session->content_manager,
                     "script-message-received::msgToNative",
                     G_CALLBACK(on_script_message_received), session);

    // Add user scripts if present
    FlValue* scripts_val = fl_value_lookup_string(args, "userScripts");
    if (scripts_val != nullptr &&
        fl_value_get_type(scripts_val) == FL_VALUE_TYPE_LIST) {
      size_t script_count = fl_value_get_length(scripts_val);
      for (size_t i = 0; i < script_count; ++i) {
        FlValue* item = fl_value_get_list_value(scripts_val, i);
        if (item != nullptr && fl_value_get_type(item) == FL_VALUE_TYPE_MAP) {
          const gchar* src = get_string_from_map(item, "source", "");
          int injection_time =
              static_cast<int>(get_int_from_map(item, "injectionTime", 0));
          bool for_all_frames = get_bool_from_map(item, "forAllFrames", true);

          WebKitUserScript* script = webkit_user_script_new(
              src,
              for_all_frames ? WEBKIT_USER_CONTENT_INJECT_ALL_FRAMES
                             : WEBKIT_USER_CONTENT_INJECT_TOP_FRAME,
              injection_time == 0 ? WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_START
                                  : WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_END,
              nullptr, nullptr);
          webkit_user_content_manager_add_script(session->content_manager,
                                                 script);
          webkit_user_script_unref(script);
        }
      }
    }

    session->web_view = GTK_WIDGET(g_object_new(
        WEBKIT_TYPE_WEB_VIEW, "web-context", context, "user-content-manager",
        session->content_manager, nullptr));

    WebKitSettings* settings =
        webkit_web_view_get_settings(WEBKIT_WEB_VIEW(session->web_view));
    webkit_settings_set_enable_javascript(settings, TRUE);
    webkit_settings_set_enable_smooth_scrolling(settings, TRUE);
    webkit_settings_set_enable_developer_extras(settings, TRUE);

    const gchar* ua = get_string_from_map(args, "userAgent", nullptr);
    if (ua != nullptr && strlen(ua) > 0) {
      webkit_settings_set_user_agent(settings, ua);
    } else {
      webkit_settings_set_user_agent(
          settings,
          "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like "
          "Gecko) Chrome/128.0.0.0 Safari/537.36");
    }

    g_signal_connect(session->web_view, "decide-policy",
                     G_CALLBACK(on_decide_policy), session);
    g_signal_connect(session->web_view, "load-failed",
                     G_CALLBACK(on_load_failed), session);
    g_signal_connect(session->web_view, "notify::uri",
                     G_CALLBACK(on_uri_changed), session);
    g_signal_connect(session->web_view, "notify::estimated-load-progress",
                     G_CALLBACK(on_progress_changed), session);
    g_signal_connect(session->web_view, "notify::title",
                     G_CALLBACK(on_title_changed), session);
    g_signal_connect(session->web_view, "create",
                     G_CALLBACK(on_create_web_view), session);

    session->container = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_box_pack_start(GTK_BOX(session->container), session->web_view, TRUE,
                       TRUE, 0);
    gtk_widget_show_all(session->container);

    gtk_overlay_add_overlay(s_overlay, session->container);
    gtk_overlay_set_overlay_pass_through(s_overlay, session->container, FALSE);
    gtk_widget_queue_resize(GTK_WIDGET(s_overlay));
    gtk_widget_grab_focus(session->web_view);

    const gchar* url = get_string_from_map(args, "url", nullptr);
    if (url != nullptr && strlen(url) > 0) {
      webkit_web_view_load_uri(WEBKIT_WEB_VIEW(session->web_view), url);
    }

    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "loadHtml") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      const gchar* html = get_string_from_map(args, "html", "");
      const gchar* base_uri = get_string_from_map(args, "baseUri", nullptr);
      webkit_web_view_load_html(WEBKIT_WEB_VIEW(it->second->web_view), html,
                                base_uri);
      fl_method_call_respond_success(method_call, nullptr, nullptr);
    } else {
      fl_method_call_respond_error(method_call, "NOT_FOUND",
                                   "Session not found", nullptr, nullptr);
    }
  } else if (strcmp(method, "loadUrl") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      const gchar* url = get_string_from_map(args, "url", "");
      webkit_web_view_load_uri(WEBKIT_WEB_VIEW(it->second->web_view), url);
      fl_method_call_respond_success(method_call, nullptr, nullptr);
    } else {
      fl_method_call_respond_error(method_call, "NOT_FOUND",
                                   "Session not found", nullptr, nullptr);
    }
  } else if (strcmp(method, "updateBounds") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end()) {
      auto* session = it->second;
      double x = get_double_from_map(args, "x", session->x);
      double y = get_double_from_map(args, "y", session->y);
      double width = get_double_from_map(args, "width", session->width);
      double height = get_double_from_map(args, "height", session->height);
      session->x = static_cast<int>(std::round(x));
      session->y = static_cast<int>(std::round(y));
      session->width = static_cast<int>(std::round(width));
      session->height = static_cast<int>(std::round(height));

      FlValue* vis_val = fl_value_lookup_string(args, "visible");
      if (vis_val != nullptr &&
          fl_value_get_type(vis_val) == FL_VALUE_TYPE_BOOL) {
        session->visible = fl_value_get_bool(vis_val);
      }

      if (session->container != nullptr) {
        if (session->visible) {
          gtk_widget_show(session->container);
        } else {
          gtk_widget_hide(session->container);
        }
        gtk_widget_queue_resize(session->container);
      }
      if (s_overlay != nullptr) {
        gtk_widget_queue_resize(GTK_WIDGET(s_overlay));
      }
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "evaluateJavaScript") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      const gchar* script = get_string_from_map(args, "script", "");

#if WEBKIT_CHECK_VERSION(2, 40, 0)
      webkit_web_view_evaluate_javascript(
          WEBKIT_WEB_VIEW(it->second->web_view), script, -1, nullptr, nullptr,
          nullptr,
          +[](GObject* object, GAsyncResult* res, gpointer user_data) {
            GError* error = nullptr;
            JSCValue* val = webkit_web_view_evaluate_javascript_finish(
                WEBKIT_WEB_VIEW(object), res, &error);
            FlMethodCall* call = static_cast<FlMethodCall*>(user_data);
            if (error != nullptr) {
              fl_method_call_respond_error(call, "JS_ERROR", error->message,
                                           nullptr, nullptr);
              g_error_free(error);
            } else {
              gchar* str =
                  (val != nullptr) ? jsc_value_to_string(val) : nullptr;
              g_autoptr(FlValue) result =
                  fl_value_new_string(str != nullptr ? str : "");
              fl_method_call_respond_success(call, result, nullptr);
              if (str != nullptr) g_free(str);
            }
            if (val != nullptr) {
              g_object_unref(val);
            }
            g_object_unref(call);
          },
          g_object_ref(method_call));
#else
      webkit_web_view_run_javascript(
          WEBKIT_WEB_VIEW(it->second->web_view), script, nullptr,
          +[](GObject* object, GAsyncResult* res, gpointer user_data) {
            GError* error = nullptr;
            WebKitJavascriptResult* js_result =
                webkit_web_view_run_javascript_finish(
                    WEBKIT_WEB_VIEW(object), res, &error);
            FlMethodCall* call = static_cast<FlMethodCall*>(user_data);
            if (error != nullptr) {
              fl_method_call_respond_error(call, "JS_ERROR", error->message,
                                           nullptr, nullptr);
              g_error_free(error);
            } else {
              JSCValue* val =
                  (js_result != nullptr)
                      ? webkit_javascript_result_get_js_value(js_result)
                      : nullptr;
              gchar* str =
                  (val != nullptr) ? jsc_value_to_string(val) : nullptr;
              g_autoptr(FlValue) result =
                  fl_value_new_string(str != nullptr ? str : "");
              fl_method_call_respond_success(call, result, nullptr);
              if (str != nullptr) g_free(str);
              if (js_result != nullptr) {
                webkit_javascript_result_unref(js_result);
              }
            }
            g_object_unref(call);
          },
          g_object_ref(method_call));
#endif
      return;
    }
    fl_method_call_respond_error(method_call, "NOT_FOUND", "Session not found",
                                 nullptr, nullptr);
  } else if (strcmp(method, "goBack") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      webkit_web_view_go_back(WEBKIT_WEB_VIEW(it->second->web_view));
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "goForward") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      webkit_web_view_go_forward(WEBKIT_WEB_VIEW(it->second->web_view));
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "reload") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      webkit_web_view_reload(WEBKIT_WEB_VIEW(it->second->web_view));
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "stopLoading") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end() && it->second->web_view != nullptr) {
      webkit_web_view_stop_loading(WEBKIT_WEB_VIEW(it->second->web_view));
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "close") == 0) {
    int64_t view_id = get_int_from_map(args, "viewId", 0);
    auto it = s_sessions.find(view_id);
    if (it != s_sessions.end()) {
      delete it->second;
      s_sessions.erase(it);
    }
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(method, "clearAllCookies") == 0) {
    auto* context = webkit_web_context_get_default();
    auto* data_mgr = webkit_web_context_get_website_data_manager(context);
    webkit_website_data_manager_clear(
        data_mgr, WEBKIT_WEBSITE_DATA_COOKIES, 0, nullptr,
        +[](GObject* src, GAsyncResult* res, gpointer user_data) {
          GError* error = nullptr;
          webkit_website_data_manager_clear_finish(
              WEBKIT_WEBSITE_DATA_MANAGER(src), res, &error);
          if (error != nullptr) {
            g_error_free(error);
          }
          FlMethodCall* call = static_cast<FlMethodCall*>(user_data);
          fl_method_call_respond_success(call, nullptr, nullptr);
          g_object_unref(call);
        },
        g_object_ref(method_call));
    return;
  } else if (strcmp(method, "clearCache") == 0) {
    auto* context = webkit_web_context_get_default();
    auto* data_mgr = webkit_web_context_get_website_data_manager(context);
    webkit_website_data_manager_clear(
        data_mgr, WEBKIT_WEBSITE_DATA_ALL, 0, nullptr,
        +[](GObject* src, GAsyncResult* res, gpointer user_data) {
          GError* error = nullptr;
          webkit_website_data_manager_clear_finish(
              WEBKIT_WEBSITE_DATA_MANAGER(src), res, &error);
          if (error != nullptr) {
            g_error_free(error);
          }
          FlMethodCall* call = static_cast<FlMethodCall*>(user_data);
          fl_method_call_respond_success(call, nullptr, nullptr);
          g_object_unref(call);
        },
        g_object_ref(method_call));
    return;
  } else if (strcmp(method, "showContextMenu") == 0) {
    if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
      fl_method_call_respond_error(method_call, "BAD_ARGS", "Expected map",
                                   nullptr, nullptr);
      return;
    }

    FlValue* items_val = fl_value_lookup_string(args, "items");
    if (items_val == nullptr ||
        fl_value_get_type(items_val) != FL_VALUE_TYPE_LIST) {
      fl_method_call_respond_error(method_call, "BAD_ARGS",
                                   "Expected items list", nullptr, nullptr);
      return;
    }

    struct ContextMenuData {
      FlMethodCall* method_call = nullptr;
      int selected_index = -1;
      bool responded = false;
    };

    struct ItemCallbackData {
      ContextMenuData* ctx = nullptr;
      int index = -1;
    };

    auto* data = new ContextMenuData();
    data->method_call = FL_METHOD_CALL(g_object_ref(method_call));

    GtkWidget* menu = gtk_menu_new();
    g_object_ref_sink(menu);

    auto on_item_activate = +[](GtkMenuItem* item, gpointer user_data) {
      auto* p = static_cast<ItemCallbackData*>(user_data);
      if (p != nullptr && p->ctx != nullptr) {
        p->ctx->selected_index = p->index;
      }
    };

    GClosureNotify on_item_data_destroy = +[](gpointer p, GClosure*) {
      delete static_cast<ItemCallbackData*>(p);
    };

    size_t count = fl_value_get_length(items_val);
    for (size_t i = 0; i < count; ++i) {
      FlValue* item_val = fl_value_get_list_value(items_val, i);
      const gchar* label = (item_val != nullptr &&
                            fl_value_get_type(item_val) == FL_VALUE_TYPE_STRING)
                               ? fl_value_get_string(item_val)
                               : "";
      if (strcmp(label, "---") == 0 || strcmp(label, "-") == 0) {
        GtkWidget* sep = gtk_separator_menu_item_new();
        gtk_widget_show(sep);
        gtk_menu_shell_append(GTK_MENU_SHELL(menu), sep);
      } else {
        GtkWidget* mi = gtk_menu_item_new_with_label(label);
        gtk_widget_show(mi);
        auto* item_data = new ItemCallbackData{data, static_cast<int>(i)};
        g_signal_connect_data(mi, "activate", G_CALLBACK(on_item_activate),
                              item_data, on_item_data_destroy,
                              static_cast<GConnectFlags>(0));
        gtk_menu_shell_append(GTK_MENU_SHELL(menu), mi);
      }
    }

    g_signal_connect(
        menu, "selection-done", G_CALLBACK(+[](GtkMenu* m, gpointer user_data) {
          auto* d = static_cast<ContextMenuData*>(user_data);
          if (!d->responded) {
            d->responded = true;
            g_autoptr(FlValue) res = fl_value_new_int(d->selected_index);
            fl_method_call_respond_success(d->method_call, res, nullptr);
          }
          g_idle_add_full(G_PRIORITY_DEFAULT_IDLE,
                          G_SOURCE_FUNC(+[](gpointer p) -> gboolean {
                            GtkWidget* w = GTK_WIDGET(p);
                            if (GTK_IS_WIDGET(w)) {
                              gtk_widget_destroy(w);
                            }
                            g_object_unref(w);
                            return G_SOURCE_REMOVE;
                          }),
                          m, nullptr);
        }),
        data);

    g_signal_connect(
        menu, "destroy", G_CALLBACK(+[](GtkWidget* w, gpointer user_data) {
          auto* d = static_cast<ContextMenuData*>(user_data);
          if (!d->responded) {
            d->responded = true;
            g_autoptr(FlValue) res = fl_value_new_int(-1);
            fl_method_call_respond_success(d->method_call, res, nullptr);
          }
          g_object_unref(d->method_call);
          delete d;
        }),
        data);

    double x = get_double_from_map(args, "x", -1.0);
    double y = get_double_from_map(args, "y", -1.0);
    double width = get_double_from_map(args, "width", 0.0);
    double height = get_double_from_map(args, "height", 0.0);

    GdkWindow* window = nullptr;
    if (s_fl_view != nullptr) {
      window = gtk_widget_get_window(GTK_WIDGET(s_fl_view));
    }
    if (window == nullptr && s_overlay != nullptr) {
      window = gtk_widget_get_window(GTK_WIDGET(s_overlay));
    }

    if (window != nullptr && x >= 0 && y >= 0) {
      GdkRectangle rect = {static_cast<int>(std::round(x)),
                           static_cast<int>(std::round(y)),
                           static_cast<int>(std::round(width)),
                           static_cast<int>(std::round(height))};
      gtk_menu_popup_at_rect(GTK_MENU(menu), window, &rect,
                             GDK_GRAVITY_SOUTH_EAST, GDK_GRAVITY_NORTH_EAST,
                             nullptr);
    } else {
      gtk_menu_popup_at_pointer(GTK_MENU(menu), nullptr);
    }
    return;
  } else {
    fl_method_call_respond_not_implemented(method_call, nullptr);
  }
}

}  // namespace

void LinuxWebviewPluginRegister(FlView* view, GtkOverlay* overlay) {
  s_fl_view = view;
  s_overlay = overlay;

  g_signal_connect(
      overlay, "get-child-position",
      G_CALLBACK(+[](GtkOverlay* ov, GtkWidget* widget, GtkAllocation* alloc,
                     gpointer user_data) -> gboolean {
        for (const auto& pair : s_sessions) {
          WebviewSession* session = pair.second;
          if (session != nullptr && widget == session->container) {
            if (session->width > 0 && session->height > 0) {
              alloc->x = session->x;
              alloc->y = session->y;
              alloc->width = session->width;
              alloc->height = session->height;
            } else {
              GtkAllocation ov_alloc;
              gtk_widget_get_allocation(GTK_WIDGET(ov), &ov_alloc);
              alloc->x = 0;
              alloc->y = 0;
              alloc->width = std::max(1, ov_alloc.width);
              alloc->height = std::max(1, ov_alloc.height);
            }
            return TRUE;
          }
        }
        return FALSE;
      }),
      nullptr);

  FlPluginRegistry* registry = FL_PLUGIN_REGISTRY(view);
  g_autoptr(FlPluginRegistrar) registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry,
                                                  "LinuxWebviewPlugin");

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  s_channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            kChannelName, FL_METHOD_CODEC(codec));

  fl_method_channel_set_method_call_handler(s_channel, HandleMethodCall,
                                            nullptr, nullptr);
}
