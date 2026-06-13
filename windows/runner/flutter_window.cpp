#include "flutter_window.h"

#include <optional>
#include <string>
#include <windowsx.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

constexpr int kMediaPlayPauseHotKeyId = 1;
constexpr UINT kMediaPlayPauseKey = VK_MEDIA_PLAY_PAUSE;
constexpr char kSystemMediaPlayPauseMethod[] =
    "SystemMediaControl.playPause";
constexpr char kSystemMediaPlayMethod[] = "SystemMediaControl.play";
constexpr char kSystemMediaPauseMethod[] = "SystemMediaControl.pause";
constexpr char kEnablePlayPauseHotKeyMethod[] =
    "SystemMediaControl.enablePlayPauseHotKey";
constexpr char kDisablePlayPauseHotKeyMethod[] =
    "SystemMediaControl.disablePlayPauseHotKey";

void InvokeMediaControl(
    const std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>&
        channel,
    const std::string& method) {
  if (channel) {
    channel->InvokeMethod(method, nullptr);
  }
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
  media_control_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "PiliPlus",
          &flutter::StandardMethodCodec::GetInstance());
  media_control_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        if (call.method_name() == kEnablePlayPauseHotKeyMethod) {
          EnableMediaPlayPauseHotKey();
          result->Success();
        } else if (call.method_name() == kDisablePlayPauseHotKeyMethod) {
          DisableMediaPlayPauseHotKey();
          result->Success();
        } else {
          result->NotImplemented();
        }
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
  DisableMediaPlayPauseHotKey();
  media_control_channel_ = nullptr;

  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

void FlutterWindow::EnableMediaPlayPauseHotKey() {
  if (media_play_pause_hot_key_registered_) {
    return;
  }
  media_play_pause_hot_key_registered_ =
      RegisterHotKey(GetHandle(), kMediaPlayPauseHotKeyId, MOD_NOREPEAT,
                     kMediaPlayPauseKey) != 0;
}

void FlutterWindow::DisableMediaPlayPauseHotKey() {
  if (!media_play_pause_hot_key_registered_) {
    return;
  }
  UnregisterHotKey(GetHandle(), kMediaPlayPauseHotKeyId);
  media_play_pause_hot_key_registered_ = false;
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  switch (message) {
    case WM_HOTKEY:
      if (wparam == kMediaPlayPauseHotKeyId) {
        InvokeMediaControl(media_control_channel_, kSystemMediaPlayPauseMethod);
        return 0;
      }
      break;

    case WM_APPCOMMAND: {
      const int command = GET_APPCOMMAND_LPARAM(lparam);
      switch (command) {
        case APPCOMMAND_MEDIA_PLAY_PAUSE:
          InvokeMediaControl(media_control_channel_,
                             kSystemMediaPlayPauseMethod);
          return 1;
        case APPCOMMAND_MEDIA_PLAY:
          InvokeMediaControl(media_control_channel_, kSystemMediaPlayMethod);
          return 1;
        case APPCOMMAND_MEDIA_PAUSE:
          InvokeMediaControl(media_control_channel_, kSystemMediaPauseMethod);
          return 1;
      }
      break;
    }
  }

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
