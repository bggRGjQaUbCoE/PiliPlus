cmake_minimum_required(VERSION 3.10)
project(piliplus_click NONE)

set(BUNDLE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bundle")
if(NOT EXISTS "${BUNDLE_DIR}/piliplus")
  message(FATAL_ERROR "Prebuilt Flutter bundle is missing: ${BUNDLE_DIR}/piliplus")
endif()

configure_file(manifest.json.in manifest.json COPYONLY)
configure_file(piliplus.apparmor.in piliplus.apparmor COPYONLY)
configure_file(piliplus.desktop.in piliplus.desktop COPYONLY)
configure_file(piliplus.png piliplus.png COPYONLY)

install(DIRECTORY "${BUNDLE_DIR}/" DESTINATION . USE_SOURCE_PERMISSIONS)
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/manifest.json"
  "${CMAKE_CURRENT_BINARY_DIR}/piliplus.apparmor"
  "${CMAKE_CURRENT_BINARY_DIR}/piliplus.desktop"
  "${CMAKE_CURRENT_BINARY_DIR}/piliplus.png"
  DESTINATION .
)
