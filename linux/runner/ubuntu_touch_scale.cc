#include <gdk/gdk.h>
#include <gtk/gtk.h>

#include <dlfcn.h>

// Wayland on Lomiri reports output scale 1, and GTK 3.24 ignores GDK_SCALE
// there. libflutter then treats every physical pixel as one logical pixel.
// These wrappers are exported from the executable so libflutter binds to them.
// GTK's own calls stay inside libgtk and keep the real geometry, so the
// surface still fills the panel.

namespace {

int g_scale = 1;
thread_local int g_in_wrapper = 0;

using ScaleFn = gint (*)(GtkWidget*);
using AllocationFn = void (*)(GtkWidget*, GtkAllocation*);
using CoordsFn = gboolean (*)(const GdkEvent*, gdouble*, gdouble*);

template <typename T>
T load_next(const char* name) {
  return reinterpret_cast<T>(dlsym(RTLD_NEXT, name));
}

bool is_flutter_view(GtkWidget* widget) {
  for (GtkWidget* current = widget; current != nullptr;
       current = gtk_widget_get_parent(current)) {
    if (g_strcmp0(G_OBJECT_TYPE_NAME(current), "FlView") == 0) return true;
  }
  return false;
}

}  // namespace

void pili_ut_set_scale(int scale) {
  if (scale < 1) scale = 1;
  if (scale > 4) scale = 4;
  g_scale = scale;
}

extern "C" gint gtk_widget_get_scale_factor(GtkWidget* widget) {
  static ScaleFn real = load_next<ScaleFn>("gtk_widget_get_scale_factor");
  if (g_scale > 1 && widget != nullptr && is_flutter_view(widget)) {
    return g_scale;
  }
  return real(widget);
}

extern "C" void gtk_widget_get_allocation(GtkWidget* widget,
                                          GtkAllocation* allocation) {
  static AllocationFn real =
      load_next<AllocationFn>("gtk_widget_get_allocation");
  real(widget, allocation);
  if (g_scale <= 1 || allocation == nullptr || widget == nullptr) return;
  if (g_strcmp0(G_OBJECT_TYPE_NAME(widget), "FlView") != 0) return;
  if (allocation->width <= 1 || allocation->height <= 1) return;
  allocation->x /= g_scale;
  allocation->y /= g_scale;
  allocation->width /= g_scale;
  allocation->height /= g_scale;
  if (allocation->width < 1) allocation->width = 1;
  if (allocation->height < 1) allocation->height = 1;
}

extern "C" gboolean gdk_event_get_coords(const GdkEvent* event, gdouble* x,
                                         gdouble* y) {
  static CoordsFn real = load_next<CoordsFn>("gdk_event_get_coords");
  gboolean ok = real(event, x, y);
  if (!ok || g_scale <= 1 || g_in_wrapper > 0 || x == nullptr || y == nullptr) {
    return ok;
  }
  g_in_wrapper++;
  GtkWidget* widget = gtk_get_event_widget(const_cast<GdkEvent*>(event));
  g_in_wrapper--;
  if (widget != nullptr && is_flutter_view(widget)) {
    *x /= g_scale;
    *y /= g_scale;
  }
  return ok;
}
