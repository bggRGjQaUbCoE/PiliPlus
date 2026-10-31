cmake_minimum_required(VERSION 3.14)
project(media_kit_libs_windows_video LANGUAGES CXX)
if(NOT CMAKE_GENERATOR_PLATFORM STREQUAL "ARM64")
  message(FATAL_ERROR "The CI media library override requires ARM64")
endif()
option(MEDIA_KIT_LIBS_AVAILABLE "package:media_kit libraries are available." ON)
add_compile_definitions(_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR)
set(LIBMPV_SRC "${CMAKE_BINARY_DIR}/libmpv")
set(ANGLE_SRC "${CMAKE_BINARY_DIR}/ANGLE")
foreach(LIBRARY "${LIBMPV_SRC}/libmpv.dll.a" "${ANGLE_SRC}/lib/libEGL.dll.lib" "${ANGLE_SRC}/lib/libGLESv2.dll.lib")
  if(NOT EXISTS "${LIBRARY}")
    message(FATAL_ERROR "Missing ARM64 import library: ${LIBRARY}")
  endif()
endforeach()
set(PLUGIN_NAME "media_kit_libs_windows_video_plugin")
add_library(${PLUGIN_NAME} SHARED
  "include/media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h"
  "media_kit_libs_windows_video_plugin_c_api.cpp")
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)
file(GLOB MEDIA_LICENSES "${ANGLE_SRC}/LICENSE.*.txt")
set(media_kit_libs_windows_video_bundled_libraries
  "${LIBMPV_SRC}/libmpv-2.dll"
  "${ANGLE_SRC}/libEGL.dll"
  "${ANGLE_SRC}/libGLESv2.dll"
  "${ANGLE_SRC}/libc++.dll"
  "${ANGLE_SRC}/zlib1.dll"
  ${MEDIA_LICENSES}
  PARENT_SCOPE)
