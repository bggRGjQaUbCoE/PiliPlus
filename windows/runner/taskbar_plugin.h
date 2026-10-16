#ifndef RUNNER_TASKBAR_PLUGIN_H_
#define RUNNER_TASKBAR_PLUGIN_H_

#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <windows.h>
// windows.h must come first.
#include <shobjidl.h>
#include <wrl/client.h>

#include <memory>
#include <optional>

// Play/pause button in the taskbar thumbnail toolbar, controlled by
// `lib/utils/windows/taskbar_helper.dart`.
class TaskbarPlugin {
 public:
  TaskbarPlugin(flutter::BinaryMessenger* messenger, HWND window);
  ~TaskbarPlugin();

  TaskbarPlugin(const TaskbarPlugin&) = delete;
  TaskbarPlugin& operator=(const TaskbarPlugin&) = delete;

  // Returns a result if |message| was handled.
  std::optional<LRESULT> HandleMessage(UINT message, WPARAM wparam,
                                       LPARAM lparam);

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // The taskbar button is recreated when the window is shown again after
  // being hidden (e.g. minimized to tray) or when Explorer restarts, so the
  // toolbar is added on every `TaskbarButtonCreated` message.
  void AddButtons();
  void UpdateButton();
  THUMBBUTTON CreateButton() const;

  struct Icons {
    HICON play;
    HICON pause;
  };

  HWND window_;
  UINT taskbar_button_created_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  Microsoft::WRL::ComPtr<ITaskbarList3> taskbar_;
  bool buttons_added_ = false;
  bool visible_ = false;
  bool playing_ = false;
  // Whether the taskbar, thus the thumbnail flyout, uses the light theme.
  bool light_theme_;
  Icons white_icons_;
  Icons black_icons_;
};

#endif  // RUNNER_TASKBAR_PLUGIN_H_
