cmake_minimum_required(VERSION 3.13)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
set(PILI_RUNNER_SOURCES
  "main.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)
if(DEFINED ENV{PILI_UBUNTU_TOUCH})
  list(APPEND PILI_RUNNER_SOURCES
    "ubuntu_touch_main.cc"
    "ubuntu_touch_scale.cc"
  )
else()
  list(APPEND PILI_RUNNER_SOURCES
    "my_application.cc"
    "plugins/linux_webview_plugin.cc"
  )
endif()

add_executable(${BINARY_NAME}
  ${PILI_RUNNER_SOURCES}
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the application ID.
add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

# Add dependency libraries. Add any application-specific dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)
if(DEFINED ENV{PILI_UBUNTU_TOUCH})
  target_compile_definitions(${BINARY_NAME} PRIVATE "PILI_UBUNTU_TOUCH=1")
  # libflutter looks up GTK symbols globally. Exporting the scale wrappers
  # lets them replace the Wayland scale of 1 for the Flutter view only.
  target_link_options(${BINARY_NAME} PRIVATE "-Wl,--export-dynamic")
  target_link_libraries(${BINARY_NAME} PRIVATE ${CMAKE_DL_LIBS})
else()
  target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::WEBKIT)
endif()

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
