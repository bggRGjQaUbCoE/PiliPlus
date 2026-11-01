// This file is a part of media_kit (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#include "include/media_kit_libs_linux/media_kit_libs_linux_plugin.h"

#include <stdio.h>
#include <locale.h>

void media_kit_libs_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  printf("package:media_kit_libs_linux registered.\n");
  fflush(stdout);
  setlocale(LC_NUMERIC, "C");
}
