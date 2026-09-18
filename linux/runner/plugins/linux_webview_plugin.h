#ifndef PLUGINS_LINUX_WEBVIEW_PLUGIN_H_
#define PLUGINS_LINUX_WEBVIEW_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

void LinuxWebviewPluginRegister(FlView* view, GtkOverlay* overlay);

#endif  // PLUGINS_LINUX_WEBVIEW_PLUGIN_H_
