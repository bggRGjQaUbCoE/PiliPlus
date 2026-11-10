#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

namespace {

constexpr char kChannelName[] = "com.example.piliplus/window";
constexpr char kRelaxShadowKey[] = "piliplus-relax-shadow";

// 旧版本已经保存 showWindowTitleBar=false 的用户没有 hide_title_bar 标记，
// 本次启动仍会创建 GtkHeaderBar。GTK 会在每次分配时把 shadow width 设回 0，
// nativeapi 又把它设回 132，Wayland 下会因此反复 configure/重绘。
// 这里持续把 container border 压回 0，直到本次进程退出；下次启动由标记
// 文件跳过 GtkHeaderBar，恢复正常的 nativeapi 阴影。
gboolean ForceNoGutter(gpointer data) {
  auto* window = GTK_WINDOW(data);
  if (!gtk_widget_get_realized(GTK_WIDGET(window))) {
    g_object_unref(window);
    return G_SOURCE_REMOVE;
  }
  if (gtk_container_get_border_width(GTK_CONTAINER(window)) != 0) {
    gtk_container_set_border_width(GTK_CONTAINER(window), 0);
  }
  return G_SOURCE_CONTINUE;
}

void method_call(FlMethodChannel*, FlMethodCall* call, gpointer user_data) {
  auto* view = FL_VIEW(user_data);
  const gchar* method = fl_method_call_get_name(call);

  if (g_strcmp0(method, "relaxShadow") == 0) {
    GtkWidget* toplevel = gtk_widget_get_toplevel(GTK_WIDGET(view));
    if (!GTK_IS_WINDOW(toplevel)) {
      fl_method_call_respond_error(call, "no-window", "No GtkWindow",
                                   nullptr, nullptr);
      return;
    }
    if (!g_object_get_data(G_OBJECT(toplevel), kRelaxShadowKey)) {
      g_object_set_data(G_OBJECT(toplevel), kRelaxShadowKey,
                        GINT_TO_POINTER(1));
      g_timeout_add(100, ForceNoGutter, g_object_ref(toplevel));
    }
    fl_method_call_respond_success(call, nullptr, nullptr);
    return;
  }

  fl_method_call_respond_not_implemented(call, nullptr);
}

}  // namespace

void RegisterLinuxWindow(FlView* view) {
  g_autoptr(FlPluginRegistrar) registrar =
      fl_plugin_registry_get_registrar_for_plugin(FL_PLUGIN_REGISTRY(view),
                                                  "LinuxWindow");
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      fl_plugin_registrar_get_messenger(registrar), kChannelName,
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call, g_object_ref(view), g_object_unref);
}
