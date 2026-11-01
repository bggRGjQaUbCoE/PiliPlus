# This file is a part of media_kit (https://github.com/media-kit/media-kit).
#
# Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
# All rights reserved.
# Use of this source code is governed by MIT license that can be found in the LICENSE file.

cmake_minimum_required(VERSION 3.10)

# This option is read by the other packages which are part of package:media_kit.
option(MEDIA_KIT_LIBS_AVAILABLE "package:media_kit libraries are available." ON)

set(PROJECT_NAME "media_kit_libs_linux")
project(${PROJECT_NAME} LANGUAGES CXX)

# We use the mimalloc's object file (mimalloc.o) & link the final executable with it.
# This ensures that the standard malloc interface resolves to the mimalloc library.
#
# Refer to "Static Override" section in mimalloc's documentation:
# https://github.com/microsoft/mimalloc#static-override
function(download_and_verify url md5 locationForArchive)
  # Check if the archive exists.
  if(EXISTS "${locationForArchive}")
    file(MD5 "${locationForArchive}" ARCHIVE_MD5)

    # If MD5 doesn't match, delete the archive to download again.
    if(NOT md5 STREQUAL ARCHIVE_MD5)
      file(REMOVE "${locationForArchive}")
      message(STATUS "MD5 mismatch. File deleted.")
    endif()
  endif()

  # Download the archive if it doesn't exist.
  if(NOT EXISTS "${locationForArchive}")
    message(STATUS "Downloading archive from ${url}...")
    file(DOWNLOAD "${url}" "${locationForArchive}")
    message(STATUS "Downloaded archive to ${locationForArchive}.")

    # Verify MD5 of the newly downloaded file.
    file(MD5 "${locationForArchive}" ARCHIVE_MD5)

    if(md5 STREQUAL ARCHIVE_MD5)
      message(STATUS "${locationForArchive} Verification successful.")
    else()
      message(FATAL_ERROR "${locationForArchive} Integrity check failed, please try to rebuild project again.")
    endif()
  endif()
endfunction()

# ------------------------------------------------------------------------------
set(MIMALLOC "mimalloc-2.1.2.tar.gz")

set(MIMALLOC_URL "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz")
set(MIMALLOC_MD5 "5179c8f5cf1237d2300e2d8559a7bc55")

set(MIMALLOC_ARCHIVE "${CMAKE_BINARY_DIR}/${MIMALLOC}")
set(MIMALLOC_SRC "${CMAKE_BINARY_DIR}/mimalloc")

download_and_verify(
  ${MIMALLOC_URL}
  ${MIMALLOC_MD5}
  ${MIMALLOC_ARCHIVE}
)

function(check_directory_exists_and_not_empty dir result_var)
  # Check if the directory exists
  if(EXISTS "${dir}")
    # Check if the directory is not empty
    file(GLOB dir_contents "${dir}/*")

    if(dir_contents)
      set(${result_var} TRUE PARENT_SCOPE)
    else()
      set(${result_var} FALSE PARENT_SCOPE)
      message(STATUS "Directory ${dir} exists but is empty!")
    endif()
  else()
    set(${result_var} FALSE PARENT_SCOPE)
    message(STATUS "Directory ${dir} does not exist!")
  endif()
endfunction()

# Extract
# https://stackoverflow.com/a/19859882/12825435
set(MIMALLOC_LIB "${MIMALLOC_SRC}/out/release/mimalloc.o" CACHE INTERNAL "")

check_directory_exists_and_not_empty(${MIMALLOC_SRC} MIMALLOC_VALID)

if(NOT MIMALLOC_VALID)
  message(STATUS "Extracting ${MIMALLOC}...")
  make_directory("${MIMALLOC_SRC}")
  add_custom_command(
    OUTPUT ${MIMALLOC_LIB}
    COMMAND "${CMAKE_COMMAND}" -E tar xzf "\"${MIMALLOC_ARCHIVE}\""

    # add_subdirectory() is too much work. Alternatively building it through command line.
    COMMAND "mkdir" "-p" "out/release"
    COMMAND "cd" "out/release"
    COMMAND "${CMAKE_COMMAND}" "../../mimalloc-2.1.2"
    COMMAND "make"
    WORKING_DIRECTORY "${MIMALLOC_SRC}"
  )
endif()

add_custom_target("MIMALLOC_TARGET" ALL DEPENDS ${MIMALLOC_LIB})

# ------------------------------------------------------------------------------
set(PLUGIN_NAME "media_kit_libs_linux_plugin")

add_library(
  ${PLUGIN_NAME} SHARED
  "media_kit_libs_linux_plugin.cc"
)

apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(
  ${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)

get_filename_component(CAPTURE_PLUGIN_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}" REALPATH)
get_filename_component(CAPTURE_ROOT "${CAPTURE_PLUGIN_SOURCE}/../../../native/artifacts/linux" ABSOLUTE)
set(ENV{PKG_CONFIG_PATH} "${CAPTURE_ROOT}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
file(GLOB CAPTURE_LIBRARIES "${CAPTURE_ROOT}/lib/*.so*")
if(NOT CAPTURE_LIBRARIES)
  message(FATAL_ERROR "Build native capture libraries first: native/README.md")
endif()
set(media_kit_libs_linux_bundled_libraries ${CAPTURE_LIBRARIES} PARENT_SCOPE)
