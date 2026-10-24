# ARM64 adaptation of the upstream package pinned in pubspec.lock.
cmake_minimum_required(VERSION 3.14)

if(NOT FLUTTER_TARGET_PLATFORM STREQUAL "windows-arm64"
    AND NOT CMAKE_VS_PLATFORM_NAME STREQUAL "ARM64")
  include("${CMAKE_CURRENT_SOURCE_DIR}/x64.cmake")
  return()
endif()

project(media_kit_libs_windows_video LANGUAGES CXX)
option(MEDIA_KIT_LIBS_AVAILABLE "package:media_kit libraries are available." ON)
add_compile_definitions(_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR)

function(download_verified URL SHA256 DESTINATION)
  if(EXISTS "${DESTINATION}")
    file(SHA256 "${DESTINATION}" ACTUAL_HASH)
    if(ACTUAL_HASH STREQUAL SHA256)
      return()
    endif()
  endif()
  message(STATUS "Downloading ${URL}")
  file(DOWNLOAD "${URL}" "${DESTINATION}"
    EXPECTED_HASH "SHA256=${SHA256}" TLS_VERIFY ON SHOW_PROGRESS)
endfunction()

set(LIBMPV_SRC "${CMAKE_BINARY_DIR}/libmpv")
set(ANGLE_SRC "${CMAKE_BINARY_DIR}/ANGLE")
set(LIBMPV_ARCHIVE "${CMAKE_BINARY_DIR}/mpv-dev-aarch64-20260607.7z")
set(ANGLE_HEADERS_ARCHIVE "${CMAKE_BINARY_DIR}/ANGLE-headers.7z")
set(ANGLE_ARCHIVE "${CMAKE_BINARY_DIR}/electron-v37.7.0-win32-arm64.zip")

download_verified(
  "https://github.com/bggRGjQaUbCoE/mpv-winbuild-cmake/releases/download/20260607/mpv-dev-aarch64-20260607-git-43b14a4.7z"
  "9769066de97aed0b100d5f1eb002c7c47bc9808ea3ad26c19fd3fa47ea73f335"
  "${LIBMPV_ARCHIVE}")
download_verified(
  "https://github.com/alexmercerind/flutter-windows-ANGLE-OpenGL-ES/releases/download/v1.0.1/ANGLE.7z"
  "cc5911bb15d596fd5a2b362613ad35b7093b427117269a7359054a65746a5f9a"
  "${ANGLE_HEADERS_ARCHIVE}")
download_verified(
  "https://github.com/electron/electron/releases/download/v37.7.0/electron-v37.7.0-win32-arm64.zip"
  "875ff30aa3148665fc028abb762cf265e5f0a79ed98d1cceec2441afa17b76ea"
  "${ANGLE_ARCHIVE}")

file(MAKE_DIRECTORY "${LIBMPV_SRC}" "${ANGLE_SRC}/lib")
find_program(SEVEN_ZIP_EXECUTABLE NAMES 7z 7za 7zr
  HINTS "$ENV{ProgramFiles}/7-Zip")
if(NOT SEVEN_ZIP_EXECUTABLE)
  message(FATAL_ERROR "7-Zip is required to extract the ARM64 mpv libraries. Add 7z or 7zr to PATH.")
endif()
if(NOT EXISTS "${LIBMPV_SRC}/.arm64-extracted")
  execute_process(COMMAND "${SEVEN_ZIP_EXECUTABLE}" x -y "${LIBMPV_ARCHIVE}"
    WORKING_DIRECTORY "${LIBMPV_SRC}" RESULT_VARIABLE RESULT)
  if(NOT RESULT EQUAL 0)
    message(FATAL_ERROR "Could not extract ARM64 libmpv")
  endif()
  # media_kit_video expects the headers directly under libmpv/include.
  file(COPY "${LIBMPV_SRC}/include/mpv/" DESTINATION "${LIBMPV_SRC}/include")
  file(WRITE "${LIBMPV_SRC}/.arm64-extracted" "")
endif()

if(NOT EXISTS "${ANGLE_SRC}/include/EGL/egl.h")
  execute_process(
    COMMAND "${SEVEN_ZIP_EXECUTABLE}" x -y "${ANGLE_HEADERS_ARCHIVE}" "include/*"
    WORKING_DIRECTORY "${ANGLE_SRC}" RESULT_VARIABLE RESULT)
  if(NOT RESULT EQUAL 0)
    message(FATAL_ERROR "Could not extract ANGLE headers")
  endif()
endif()
if(NOT EXISTS "${ANGLE_SRC}/libEGL.dll")
  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E tar xf "${ANGLE_ARCHIVE}"
      libEGL.dll libGLESv2.dll d3dcompiler_47.dll LICENSE LICENSES.chromium.html
    WORKING_DIRECTORY "${ANGLE_SRC}" RESULT_VARIABLE RESULT)
  if(NOT RESULT EQUAL 0)
    message(FATAL_ERROR "Could not extract ARM64 ANGLE")
  endif()
endif()

# Electron provides DLLs; create the MSVC import libraries used by media_kit_video.
get_filename_component(MSVC_BIN_DIR "${CMAKE_LINKER}" DIRECTORY)
find_program(POWERSHELL_EXECUTABLE NAMES pwsh powershell)
if(NOT POWERSHELL_EXECUTABLE)
  message(FATAL_ERROR "PowerShell is required to prepare ARM64 ANGLE")
endif()
execute_process(
  COMMAND "${POWERSHELL_EXECUTABLE}" -NoProfile -ExecutionPolicy Bypass
    -File "${CMAKE_CURRENT_SOURCE_DIR}/build_import_libs.ps1"
    -AngleDirectory "${ANGLE_SRC}" -LibmpvDirectory "${LIBMPV_SRC}"
    -ToolDirectory "${MSVC_BIN_DIR}"
  RESULT_VARIABLE RESULT)
if(NOT RESULT EQUAL 0)
  message(FATAL_ERROR "Could not generate ARM64 ANGLE import libraries")
endif()

set(PLUGIN_NAME "media_kit_libs_windows_video_plugin")
add_library(${PLUGIN_NAME} SHARED
  "media_kit_libs_windows_video_plugin_c_api.cpp")
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

set(media_kit_libs_windows_video_bundled_libraries
  "${LIBMPV_SRC}/libmpv-2.dll"
  "${ANGLE_SRC}/libEGL.dll"
  "${ANGLE_SRC}/libGLESv2.dll"
  "${ANGLE_SRC}/d3dcompiler_47.dll"
  "${ANGLE_SRC}/LICENSE"
  "${ANGLE_SRC}/LICENSES.chromium.html"
  PARENT_SCOPE)
