import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private func applyOpaqueWindowAppearance() {
    // 恢复系统默认的不透明窗口背景
    self.isOpaque = true
    self.backgroundColor = .windowBackgroundColor

    // 正常显示标题栏时禁用透明效果
    if self.titleVisibility == .visible {
      self.titlebarAppearsTransparent = false
      self.styleMask.remove(.fullSizeContentView)
    }
  }

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    // 先不显示窗口
    self.isReleasedWhenClosed = false
    self.contentViewController = flutterViewController
    self.setFrame(self.frame, display: true)

    applyOpaqueWindowAppearance()

    RegisterGeneratedPlugins(registry: flutterViewController)

    // 监听首帧渲染完成再显示窗口
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name("io.flutter.embedding.engine.firstFrame"),
      object: flutterViewController.engine, queue: .main
    ) { [weak self] _ in
      guard let self else { return }
      // window_manager 配置完成后恢复不透明样式
      self.applyOpaqueWindowAppearance()
      self.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
    // 不在这里调用 makeKeyAndOrderFront
    super.awakeFromNib()
  }
}
