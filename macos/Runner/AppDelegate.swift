import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      let mainWindow = NSApp.windows.first(where: { $0 is MainFlutterWindow })
      if let mainWindow {
        mainWindow.setIsVisible(true)
        mainWindow.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
      }
    }
    return true
  }
}
