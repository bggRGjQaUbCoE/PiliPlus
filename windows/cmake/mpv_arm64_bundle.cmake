if(NOT CMAKE_GENERATOR_PLATFORM STREQUAL "ARM64")
  message(FATAL_ERROR "PILIPLUS_ARM64_MPV_BUNDLE requires an ARM64 build")
endif()

function(verify_mpv_bundle_file NAME EXPECTED_SHA256)
  set(FILE_PATH "${PILIPLUS_ARM64_MPV_BUNDLE}/${NAME}")
  if(NOT EXISTS "${FILE_PATH}")
    message(FATAL_ERROR "Missing ${FILE_PATH}; run tool/prepare_windows_arm64_mpv.ps1")
  endif()
  file(SHA256 "${FILE_PATH}" ACTUAL_SHA256)
  if(NOT ACTUAL_SHA256 STREQUAL EXPECTED_SHA256)
    message(FATAL_ERROR "ARM64 mpv bundle checksum mismatch: ${NAME}")
  endif()
endfunction()

verify_mpv_bundle_file(libmpv-2.dll
  820ba5b5259d9db0ef37cc16248c3986c390db113b9adddd58021b15057d40ed)
verify_mpv_bundle_file(vulkan-1.dll
  664e7dad1ad21ae26cfbfaf467b6ff1fdc1d73a7f82af62d48c90920a6a35d85)
foreach(NOTICE LICENSE.vulkan-loader.txt MPV-BUNDLE.txt)
  if(NOT EXISTS "${PILIPLUS_ARM64_MPV_BUNDLE}/${NOTICE}")
    message(FATAL_ERROR "Missing ARM64 mpv bundle notice: ${NOTICE}")
  endif()
endforeach()

# The replacement exports the same libmpv API, so the plugin import library
# remains compatible. Replace only the installed runtime and its new dependency.
list(FILTER PLUGIN_BUNDLED_LIBRARIES EXCLUDE REGEX "[/\\]libmpv-2\\.dll$")
list(APPEND PLUGIN_BUNDLED_LIBRARIES
  "${PILIPLUS_ARM64_MPV_BUNDLE}/libmpv-2.dll"
  "${PILIPLUS_ARM64_MPV_BUNDLE}/vulkan-1.dll"
  "${PILIPLUS_ARM64_MPV_BUNDLE}/LICENSE.vulkan-loader.txt"
  "${PILIPLUS_ARM64_MPV_BUNDLE}/MPV-BUNDLE.txt")
