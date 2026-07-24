import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    // 先不显示窗口
    self.isReleasedWhenClosed = false
    self.contentViewController = flutterViewController
    self.setFrame(self.frame, display: true)

    // 使用系统窗口背景色，避免启动防闪时把标题栏/窗口背景透成透明
    self.isOpaque = true
    self.backgroundColor = .windowBackgroundColor

    RegisterGeneratedPlugins(registry: flutterViewController)

    // 监听首帧渲染完成再显示窗口
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name("io.flutter.embedding.engine.firstFrame"),
      object: flutterViewController.engine, queue: .main
    ) { [weak self] _ in
      self?.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
    // 不在这里调用 makeKeyAndOrderFront
    super.awakeFromNib()
  }
}
