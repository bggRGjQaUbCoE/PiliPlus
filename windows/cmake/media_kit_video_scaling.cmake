get_target_property(MEDIA_KIT_VIDEO_SOURCE_DIR media_kit_video_plugin SOURCE_DIR)
set(MEDIA_KIT_VIDEO_OUTPUT "${MEDIA_KIT_VIDEO_SOURCE_DIR}/video_output.cc")
file(READ "${MEDIA_KIT_VIDEO_OUTPUT}" MEDIA_KIT_VIDEO_OUTPUT_CONTENT)

foreach(DIMENSION_PAIR "width;height" "height;width")
  list(GET DIMENSION_PAIR 0 NUMERATOR)
  list(GET DIMENSION_PAIR 1 DENOMINATOR)
  string(TOUPPER "${DENOMINATOR}" LIMIT_DIMENSION)
  set(OLD_EXPRESSION "${NUMERATOR} / ${DENOMINATOR} * SW_RENDERING_MAX_${LIMIT_DIMENSION}")
  set(NEW_EXPRESSION "${NUMERATOR} * SW_RENDERING_MAX_${LIMIT_DIMENSION} / ${DENOMINATOR}")
  string(FIND "${MEDIA_KIT_VIDEO_OUTPUT_CONTENT}" "${OLD_EXPRESSION}" EXPRESSION_POSITION)
  if(EXPRESSION_POSITION EQUAL -1)
    message(FATAL_ERROR "media_kit video scaling changed; review the local scaling patch")
  endif()
  string(REPLACE "${OLD_EXPRESSION}" "${NEW_EXPRESSION}"
    MEDIA_KIT_VIDEO_OUTPUT_CONTENT "${MEDIA_KIT_VIDEO_OUTPUT_CONTENT}")
endforeach()

include("${CMAKE_CURRENT_LIST_DIR}/media_kit_video_texture_callbacks.cmake")

set(PATCHED_VIDEO_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/media_kit_video_output.cc")
file(CONFIGURE OUTPUT "${PATCHED_VIDEO_OUTPUT}"
  CONTENT "${MEDIA_KIT_VIDEO_OUTPUT_CONTENT}" @ONLY)
get_target_property(MEDIA_KIT_VIDEO_SOURCES media_kit_video_plugin SOURCES)
list(FILTER MEDIA_KIT_VIDEO_SOURCES EXCLUDE REGEX "(^|[/\\])video_output\\.cc$")
set_property(TARGET media_kit_video_plugin PROPERTY SOURCES
  ${MEDIA_KIT_VIDEO_SOURCES} "${PATCHED_VIDEO_OUTPUT}")
target_include_directories(media_kit_video_plugin PRIVATE "${MEDIA_KIT_VIDEO_SOURCE_DIR}")

# Keep native symbols for diagnosing release crash dumps.
target_compile_options(media_kit_video_plugin PRIVATE "$<$<CONFIG:Release>:/Zi>")
target_link_options(media_kit_video_plugin PRIVATE
  "$<$<CONFIG:Release>:/DEBUG:FULL>"
  "$<$<CONFIG:Release>:/OPT:REF>"
  "$<$<CONFIG:Release>:/OPT:ICF>")
