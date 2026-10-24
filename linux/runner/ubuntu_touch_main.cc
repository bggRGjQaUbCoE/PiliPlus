#include <flutter_linux/flutter_linux.h>

#include <gdk/gdk.h>
#include <gdk/gdkwayland.h>
#include <gtk/gtk.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits.h>
#include <unistd.h>

#include "flutter/generated_plugin_registrant.h"

void pili_ut_set_scale(int scale);

namespace {

void log_scale_environment() {
  const char* names[] = {"GDK_SCALE", "GDK_DPI_SCALE", "GRID_UNIT_PX",
                         "QT_SCALE_FACTOR", nullptr};
  for (int i = 0; names[i] != nullptr; i++) {
    const char* value = g_getenv(names[i]);
    g_message("env %s=%s", names[i], value != nullptr ? value : "(unset)");
  }
}

// UITK treats 8 device pixels as one grid unit at scale 1. GTK and the
// Flutter Linux embedder only accept an integer scale factor.
int scale_from_grid_unit(const char* grid) {
  if (grid == nullptr || grid[0] == '\0') return 0;
  char* end = nullptr;
  double gu = g_ascii_strtod(grid, &end);
  if (end == grid || gu < 8.0) return 0;
  int scale = static_cast<int>(std::lround(gu / 8.0));
  if (scale < 1) scale = 1;
  if (scale > 4) scale = 4;
  return scale;
}

int scale_from_monitor_mm(GdkMonitor* monitor) {
  int width_mm = gdk_monitor_get_width_mm(monitor);
  GdkRectangle geom;
  gdk_monitor_get_geometry(monitor, &geom);
  if (width_mm <= 0 || geom.width <= 0) return 0;
  double inches = width_mm / 25.4;
  double dpi = geom.width / inches;
  int scale = static_cast<int>(std::lround(dpi / 160.0));
  if (scale < 1) scale = 1;
  if (scale > 4) scale = 4;
  return scale;
}

int flutter_scale() {
  const char* grid = g_getenv("GRID_UNIT_PX");
  int scale = scale_from_grid_unit(grid);
  if (scale > 1) {
    std::fprintf(stderr,
                 "piliplus: flutter scale %d = round(GRID_UNIT_PX/8) "
                 "GRID_UNIT_PX=%s\n",
                 scale, grid);
    return scale;
  }
  return 0;
}

// The 6T exposes the panel and a larger virtual output. The panel is the
// smaller one. Geometry is in GTK logical pixels.
GdkMonitor* choose_panel(GdkDisplay* display) {
  int count = gdk_display_get_n_monitors(display);
  GdkMonitor* best = nullptr;
  int best_area = 0;
  for (int i = 0; i < count; i++) {
    GdkMonitor* monitor = gdk_display_get_monitor(display, i);
    GdkRectangle geom;
    gdk_monitor_get_geometry(monitor, &geom);
    int area = geom.width * geom.height;
    g_message(
        "monitor %d model=%s geometry=%dx%d+%d+%d scale=%d size_mm=%dx%d", i,
        gdk_monitor_get_model(monitor), geom.width, geom.height, geom.x,
        geom.y, gdk_monitor_get_scale_factor(monitor),
        gdk_monitor_get_width_mm(monitor), gdk_monitor_get_height_mm(monitor));
    if (area <= 0) continue;
    if (best == nullptr || area < best_area) {
      best = monitor;
      best_area = area;
    }
  }
  return best;
}

// Fullscreen tells Lomiri to hide the indicator panel. Maximized fills the
// stage underneath the panel.
void use_application_stage(GtkWindow* window) {
  gtk_window_set_decorated(window, FALSE);
  gtk_window_unfullscreen(window);
  gtk_window_maximize(window);
}

gboolean on_configure(GtkWidget*, GdkEventConfigure* event, gpointer) {
  static int last_width = 0;
  static int last_height = 0;
  if (event->width == last_width && event->height == last_height) return FALSE;
  last_width = event->width;
  last_height = event->height;
  g_message("configure %dx%d+%d+%d", event->width, event->height, event->x,
            event->y);
  return FALSE;
}

gboolean on_window_state(GtkWidget*, GdkEventWindowState* event, gpointer) {
  g_message("window state new=0x%x changed=0x%x", event->new_window_state,
            event->changed_mask);
  return FALSE;
}

void on_destroy(GtkWidget*, gpointer) { gtk_main_quit(); }

// Lomiri sets GTK_IM_MODULE=Maliit. The 6T image has no im-maliit.so, so GTK
// would look up a module that is not there. Drop the session value before
// gtk_init; choose_input_method() puts a real module in place afterwards.
void clear_session_im_module() {
  const char* value = g_getenv("GTK_IM_MODULE");
  g_message("GTK_IM_MODULE from session=%s",
            value != nullptr ? value : "(unset)");
  if (value != nullptr) {
    g_unsetenv("GTK_IM_MODULE");
  }
}

bool wayland_registry_has(GdkDisplay* display, const char* name) {
  if (display == nullptr || !GDK_IS_WAYLAND_DISPLAY(display)) return false;
  return gdk_wayland_display_query_registry(display, name);
}

// Mir on this image does not advertise a text-input global, so im-wayland.so
// has nothing to bind. The Click ships im-maliit.so and talks to maliit-server
// over the D-Bus socket the default Click policy already allows.
bool use_bundled_maliit() {
  char exe[PATH_MAX];
  ssize_t length = readlink("/proc/self/exe", exe, sizeof(exe) - 1);
  if (length < 0) {
    g_warning("readlink /proc/self/exe failed");
    return false;
  }
  exe[length] = '\0';
  g_autofree char* dir = g_path_get_dirname(exe);
  g_autofree char* so_path =
      g_build_filename(dir, "lib", "im-maliit.so", nullptr);
  if (!g_file_test(so_path, G_FILE_TEST_IS_REGULAR)) {
    g_warning("im-maliit.so missing at %s", so_path);
    return false;
  }

  g_autofree char* cache_dir =
      g_build_filename(g_get_user_cache_dir(), "piliplus.alphaliu01", nullptr);
  if (g_mkdir_with_parents(cache_dir, 0700) != 0) {
    g_warning("cannot create %s", cache_dir);
    return false;
  }
  g_autofree char* cache_path =
      g_build_filename(cache_dir, "immodules.cache", nullptr);
  g_autofree char* body = g_strdup_printf(
      "# GTK+ Input Method Modules file\n"
      "\"%s\"\n"
      "\"maliit\" \"Maliit\" \"gtk30\" \"\" \"\"\n",
      so_path);
  g_autoptr(GError) error = nullptr;
  if (!g_file_set_contents(cache_path, body, -1, &error)) {
    g_warning("cannot write %s: %s", cache_path,
              error != nullptr ? error->message : "unknown");
    return false;
  }

  g_setenv("GTK_IM_MODULE_FILE", cache_path, TRUE);
  g_setenv("GTK_IM_MODULE", "maliit", TRUE);
  g_message("GTK_IM_MODULE=maliit so=%s cache=%s", so_path, cache_path);
  return true;
}

void choose_input_method() {
  GdkDisplay* display = gdk_display_get_default();
  bool text_input_v3 =
      wayland_registry_has(display, "zwp_text_input_manager_v3");
  bool gtk_text_input = wayland_registry_has(display, "gtk_text_input_manager");
  g_message("wayland text-input v3=%d gtk_text_input_manager=%d",
            text_input_v3, gtk_text_input);
  if (text_input_v3) {
    g_message("Wayland text-input v3 is present; GTK selects im-wayland");
    return;
  }
  if (gtk_text_input) {
    g_setenv("GTK_IM_MODULE", "waylandgtk", TRUE);
    g_message("GTK_IM_MODULE=waylandgtk");
    return;
  }
  g_message("no Wayland text-input global; using the bundled Maliit module");
  use_bundled_maliit();
}

void log_im_context(GtkWidget* window) {
  GtkIMContext* im = gtk_im_multicontext_new();
  GdkWindow* gdk_window = gtk_widget_get_window(window);
  if (gdk_window != nullptr) {
    gtk_im_context_set_client_window(im, gdk_window);
  }
  const char* id = gtk_im_multicontext_get_context_id(GTK_IM_MULTICONTEXT(im));
  const char* module = g_getenv("GTK_IM_MODULE");
  g_message("im context id=%s GTK_IM_MODULE=%s", id != nullptr ? id : "(null)",
            module != nullptr ? module : "(unset)");
  g_object_unref(im);
}

}  // namespace

// Lomiri gives this process a Wayland surface and libhybris EGL. GTK's
// default desktop GL context fails there; GLES is the context that painted
// the Phase 0 hello. This runner is a plain GtkWindow: GtkApplication's
// D-Bus name is rejected. Desktop builds do not call this function.
extern "C" int pili_ubuntu_touch_main(int argc, char** argv) {
  setenv("GDK_GL", "gles", 1);
  clear_session_im_module();
  int scale = flutter_scale();
  gtk_init(&argc, &argv);
  g_message("GDK_GL=gles context created");
  choose_input_method();
  log_scale_environment();
  if (scale <= 1) {
    GdkMonitor* panel = choose_panel(gdk_display_get_default());
    scale = panel != nullptr ? scale_from_monitor_mm(panel) : 1;
    std::fprintf(stderr,
                 "piliplus: flutter scale %d = round(dpi/160) from monitor\n",
                 scale);
  }
  if (scale < 1) scale = 1;
  pili_ut_set_scale(scale);
  g_message("flutter view scale=%d; Wayland output scale is left unchanged",
            scale);

  GtkWidget* window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "PiliPlus");
  g_signal_connect(window, "destroy", G_CALLBACK(on_destroy), nullptr);
  g_signal_connect(window, "configure-event", G_CALLBACK(on_configure),
                   nullptr);
  g_signal_connect(window, "window-state-event", G_CALLBACK(on_window_state),
                   nullptr);
  use_application_stage(GTK_WINDOW(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_enable_impeller(project, FALSE);
  fl_dart_project_set_dart_entrypoint_arguments(project, argv + 1);
  FlView* view = fl_view_new(project);
  // Opaque white. A failed GL context otherwise leaves the default black, and
  // a transparent view lets a later expose paint over the Flutter frame.
  GdkRGBA background = {1.0, 1.0, 1.0, 1.0};
  fl_view_set_background_color(view, &background);
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));
  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_show_all(window);
  use_application_stage(GTK_WINDOW(window));
  log_im_context(window);
  g_message("GDK_GL=gles; paint context left unset");

  gtk_main();
  return 0;
}
