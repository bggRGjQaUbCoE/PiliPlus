#pragma once

// ANGLE extensions require the core EGL and Khronos extension types first.
#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <EGL/eglext_angle.h>

#ifndef EGL_PLATFORM_ANGLE_TYPE_D3D11_ANGLE
#error ARM64 ANGLE headers do not define the required D3D11 platform extension
#endif
