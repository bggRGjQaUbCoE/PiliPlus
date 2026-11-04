# Old Flutter callbacks can run after texture_id_ changes during Resize.
# Bind each callback to its own descriptor and tolerate registration gaps.
function(replace_video_callback OLD_CALLBACK NEW_CALLBACK)
  string(FIND "${MEDIA_KIT_VIDEO_OUTPUT_CONTENT}" "${OLD_CALLBACK}" CALLBACK_POSITION)
  if(CALLBACK_POSITION EQUAL -1)
    message(FATAL_ERROR "media_kit texture callback changed; review the local callback patch")
  endif()
  string(REPLACE "${OLD_CALLBACK}" "${NEW_CALLBACK}"
    UPDATED_CONTENT "${MEDIA_KIT_VIDEO_OUTPUT_CONTENT}")
  set(MEDIA_KIT_VIDEO_OUTPUT_CONTENT "${UPDATED_CONTENT}" PARENT_SCOPE)
endfunction()

replace_video_callback([=[kFlutterDesktopGpuSurfaceTypeDxgiSharedHandle, [&](auto, auto) {
              std::lock_guard<std::mutex> lock(textures_mutex_);
              if (texture_id_) {
                surface_manager_->Read();
                return textures_.at(texture_id_).get();
              } else {
                return (FlutterDesktopGpuSurfaceDescriptor*)nullptr;
              }
            }]=]
  [=[kFlutterDesktopGpuSurfaceTypeDxgiSharedHandle,
            [&, descriptor = texture.get()](auto, auto) {
              std::lock_guard<std::mutex> lock(textures_mutex_);
              const auto entry = textures_.find(texture_id_);
              if (entry == textures_.end() || entry->second.get() != descriptor) {
                return (FlutterDesktopGpuSurfaceDescriptor*)nullptr;
              }
              surface_manager_->Read();
              return descriptor;
            }]=])

replace_video_callback([=[flutter::PixelBufferTexture([&](auto, auto) {
          std::lock_guard<std::mutex> lock(textures_mutex_);
          if (texture_id_) {
            return pixel_buffer_textures_.at(texture_id_).get();
          } else {
            return (FlutterDesktopPixelBuffer*)nullptr;
          }
        })]=]
  [=[flutter::PixelBufferTexture(
        [&, descriptor = pixel_buffer_texture.get()](auto, auto) {
          std::lock_guard<std::mutex> lock(textures_mutex_);
          const auto entry = pixel_buffer_textures_.find(texture_id_);
          if (entry == pixel_buffer_textures_.end() || entry->second.get() != descriptor) {
            return (FlutterDesktopPixelBuffer*)nullptr;
          }
          return descriptor;
        })]=])

# Publish IDs and descriptors together under the callback's mutex. RegisterTexture
# itself stays outside the lock because Flutter may request a frame immediately.
replace_video_callback([=[texture_id_ =
        registrar_->texture_registrar()->RegisterTexture(texture_variant.get());]=]
  [=[const auto registered_texture_id =
        registrar_->texture_registrar()->RegisterTexture(texture_variant.get());]=])
replace_video_callback([=[std::cout << "media_kit: VideoOutput: Create Texture: " << texture_id_]=]
  [=[std::cout << "media_kit: VideoOutput: Create Texture: " << registered_texture_id]=])
replace_video_callback([=[std::lock_guard<std::mutex> lock(textures_mutex_);
    textures_.emplace]=]
  [=[std::lock_guard<std::mutex> lock(textures_mutex_);
    texture_id_ = registered_texture_id;
    textures_.emplace]=])
replace_video_callback([=[std::lock_guard<std::mutex> lock(textures_mutex_);
    pixel_buffer_textures_.emplace]=]
  [=[std::lock_guard<std::mutex> lock(textures_mutex_);
    texture_id_ = registered_texture_id;
    pixel_buffer_textures_.emplace]=])
replace_video_callback([=[texture_id_ = 0;]=]
  [=[{
    std::lock_guard<std::mutex> lock(textures_mutex_);
    texture_id_ = 0;
  }]=])
