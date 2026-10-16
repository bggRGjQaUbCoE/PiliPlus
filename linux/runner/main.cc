#ifdef PILI_UBUNTU_TOUCH
extern "C" int pili_ubuntu_touch_main(int argc, char** argv);
#else
#include "my_application.h"
#endif

int main(int argc, char** argv) {
#ifdef PILI_UBUNTU_TOUCH
  return pili_ubuntu_touch_main(argc, argv);
#else
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
#endif
}
