final class WindowsNetworkInfo {
  const WindowsNetworkInfo({this.rssi, this.wifiMbps, this.wiredMbps});

  final int? rssi;
  final int? wifiMbps;
  final int? wiredMbps;
}

abstract final class WindowsNetworkInfoReader {
  static const _empty = WindowsNetworkInfo();

  static WindowsNetworkInfo read() => _empty;
}
