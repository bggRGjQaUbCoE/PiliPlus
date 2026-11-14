#include "flutter_window.h"

#include <cstring>
#include <limits>
#include <optional>

#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

// Flutter decodes all supported image formats, including the first animated
// frame, before handing straight RGBA pixels to Windows.
bool CopyImage(HWND owner, int32_t width, int32_t height,
               const std::vector<uint8_t>& pixels) {
  if (width <= 0 || height <= 0 ||
      static_cast<size_t>(width) >
          (std::numeric_limits<size_t>::max() - sizeof(BITMAPV5HEADER)) /
              4 / static_cast<size_t>(height)) {
    return false;
  }
  const size_t pixel_bytes = static_cast<size_t>(width) * height * 4;
  if (pixels.size() != pixel_bytes ||
      pixel_bytes > std::numeric_limits<DWORD>::max()) {
    return false;
  }
  HGLOBAL memory = GlobalAlloc(GMEM_MOVEABLE, sizeof(BITMAPV5HEADER) + pixel_bytes);
  if (!memory) return false;
  auto* header = static_cast<BITMAPV5HEADER*>(GlobalLock(memory));
  if (!header) {
    GlobalFree(memory);
    return false;
  }
  std::memset(header, 0, sizeof(*header));
  header->bV5Size = sizeof(*header);
  header->bV5Width = width;
  header->bV5Height = height;
  header->bV5Planes = 1;
  header->bV5BitCount = 32;
  header->bV5Compression = BI_BITFIELDS;
  header->bV5SizeImage = static_cast<DWORD>(pixel_bytes);
  header->bV5RedMask = 0x00ff0000;
  header->bV5GreenMask = 0x0000ff00;
  header->bV5BlueMask = 0x000000ff;
  header->bV5AlphaMask = 0xff000000;
  header->bV5CSType = LCS_sRGB;
  header->bV5Intent = LCS_GM_IMAGES;
  auto* destination = reinterpret_cast<uint8_t*>(header + 1);
  for (int32_t y = 0; y < height; ++y) {
    for (int32_t x = 0; x < width; ++x) {
      const size_t source = (static_cast<size_t>(y) * width + x) * 4;
      const size_t target =
          (static_cast<size_t>(height - 1 - y) * width + x) * 4;
      destination[target] = pixels[source + 2];
      destination[target + 1] = pixels[source + 1];
      destination[target + 2] = pixels[source];
      destination[target + 3] = pixels[source + 3];
    }
  }
  GlobalUnlock(memory);
  if (!OpenClipboard(owner)) {
    GlobalFree(memory);
    return false;
  }
  const bool success = EmptyClipboard() && SetClipboardData(CF_DIBV5, memory);
  CloseClipboard();
  // SetClipboardData transfers ownership only on success.
  if (!success) GlobalFree(memory);
  return success;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());

  image_clipboard_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "piliplus/image_clipboard",
          &flutter::StandardMethodCodec::GetInstance());
  image_clipboard_channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        if (call.method_name() != "copyImage") {
          result->NotImplemented();
          return;
        }
        const auto* arguments =
            std::get_if<flutter::EncodableMap>(call.arguments());
        if (!arguments) {
          result->Error("invalid_image", "Missing image data");
          return;
        }
        const auto width = arguments->find(flutter::EncodableValue("width"));
        const auto height = arguments->find(flutter::EncodableValue("height"));
        const auto pixels = arguments->find(flutter::EncodableValue("pixels"));
        if (width == arguments->end() || height == arguments->end() ||
            pixels == arguments->end() ||
            !std::holds_alternative<int32_t>(width->second) ||
            !std::holds_alternative<int32_t>(height->second) ||
            !std::holds_alternative<std::vector<uint8_t>>(pixels->second)) {
          result->Error("invalid_image", "Invalid image data");
          return;
        }
        if (!CopyImage(GetHandle(), std::get<int32_t>(width->second),
                       std::get<int32_t>(height->second),
                       std::get<std::vector<uint8_t>>(pixels->second))) {
          result->Error("clipboard_error", "Could not copy image to clipboard");
          return;
        }
        result->Success();
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // flutter_controller_->engine()->SetNextFrameCallback([&]() {
  //   this->Show();
  // });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  image_clipboard_channel_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
