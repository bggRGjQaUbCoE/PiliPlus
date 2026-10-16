#include "taskbar_plugin.h"

#include <flutter/standard_method_codec.h>

#include <cwchar>

#include "resource.h"

namespace {

constexpr UINT kPlayPauseButtonId = 1;

HICON LoadSmallIcon(int resource_id) {
  // Not `LoadIconWithScaleDown`, which needs comctl32 v6 in the manifest.
  return static_cast<HICON>(LoadImage(
      GetModuleHandle(nullptr), MAKEINTRESOURCE(resource_id), IMAGE_ICON,
      GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON),
      LR_DEFAULTCOLOR));
}

bool SystemUsesLightTheme() {
  DWORD light_mode;
  DWORD light_mode_size = sizeof(light_mode);
  LSTATUS result = RegGetValue(
      HKEY_CURRENT_USER,
      L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
      L"SystemUsesLightTheme", RRF_RT_REG_DWORD, nullptr, &light_mode,
      &light_mode_size);
  return result == ERROR_SUCCESS && light_mode != 0;
}

}  // namespace

TaskbarPlugin::TaskbarPlugin(flutter::BinaryMessenger* messenger, HWND window)
    : window_(window),
      taskbar_button_created_(RegisterWindowMessage(L"TaskbarButtonCreated")),
      channel_(std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger, "com.example.piliplus/taskbar",
          &flutter::StandardMethodCodec::GetInstance())),
      light_theme_(SystemUsesLightTheme()),
      white_icons_{LoadSmallIcon(IDI_PLAY_WHITE),
                   LoadSmallIcon(IDI_PAUSE_WHITE)},
      black_icons_{LoadSmallIcon(IDI_PLAY_BLACK),
                   LoadSmallIcon(IDI_PAUSE_BLACK)} {
  // Let the messages through when running elevated.
  ChangeWindowMessageFilterEx(window_, taskbar_button_created_, MSGFLT_ALLOW,
                              nullptr);
  ChangeWindowMessageFilterEx(window_, WM_COMMAND, MSGFLT_ALLOW, nullptr);

  channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandleMethodCall(call, std::move(result));
  });
}

TaskbarPlugin::~TaskbarPlugin() {
  channel_->SetMethodCallHandler(nullptr);
  for (HICON icon : {white_icons_.play, white_icons_.pause, black_icons_.play,
                     black_icons_.pause}) {
    if (icon) DestroyIcon(icon);
  }
}

std::optional<LRESULT> TaskbarPlugin::HandleMessage(UINT message,
                                                    WPARAM wparam,
                                                    LPARAM lparam) {
  if (message == taskbar_button_created_) {
    // Not consumed, other plugins may need it too.
    AddButtons();
    return std::nullopt;
  }
  if (message == WM_COMMAND && HIWORD(wparam) == THBN_CLICKED &&
      LOWORD(wparam) == kPlayPauseButtonId) {
    channel_->InvokeMethod("onPlayPause", nullptr);
    return 0;
  }
  if (message == WM_SETTINGCHANGE && lparam &&
      wcscmp(reinterpret_cast<LPCWSTR>(lparam), L"ImmersiveColorSet") == 0) {
    bool light_theme = SystemUsesLightTheme();
    if (light_theme_ != light_theme) {
      light_theme_ = light_theme;
      UpdateButton();
    }
  }
  return std::nullopt;
}

void TaskbarPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (call.method_name() == "update") {
    const auto* playing = std::get_if<bool>(call.arguments());
    if (!playing) {
      result->Error("bad-args", "Expected a bool");
      return;
    }
    visible_ = true;
    playing_ = *playing;
    UpdateButton();
    result->Success();
  } else if (call.method_name() == "hide") {
    visible_ = false;
    UpdateButton();
    result->Success();
  } else {
    result->NotImplemented();
  }
}

void TaskbarPlugin::AddButtons() {
  buttons_added_ = false;
  taskbar_.Reset();
  if (FAILED(CoCreateInstance(CLSID_TaskbarList, nullptr, CLSCTX_INPROC_SERVER,
                              IID_PPV_ARGS(&taskbar_))) ||
      FAILED(taskbar_->HrInit())) {
    taskbar_.Reset();
    return;
  }
  THUMBBUTTON button = CreateButton();
  buttons_added_ = SUCCEEDED(taskbar_->ThumbBarAddButtons(window_, 1, &button));
}

void TaskbarPlugin::UpdateButton() {
  if (!buttons_added_) return;
  THUMBBUTTON button = CreateButton();
  taskbar_->ThumbBarUpdateButtons(window_, 1, &button);
}

THUMBBUTTON TaskbarPlugin::CreateButton() const {
  THUMBBUTTON button = {};
  button.dwMask = THB_ICON | THB_TOOLTIP | THB_FLAGS;
  button.iId = kPlayPauseButtonId;
  const Icons& icons = light_theme_ ? black_icons_ : white_icons_;
  button.hIcon = playing_ ? icons.pause : icons.play;
  wcscpy_s(button.szTip, playing_ ? L"暂停" : L"播放");
  button.dwFlags = visible_ ? THBF_ENABLED : THBF_HIDDEN;
  return button;
}
