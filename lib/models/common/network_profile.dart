enum NetworkTransport {
  wifi('Wi-Fi'),
  wired('有线网络'),
  cellular('蜂窝网络'),
  other('其他网络');

  const NetworkTransport(this.label);
  final String label;
}

enum NetworkPolicyReason { network, peak }

final class NetworkProfile {
  const NetworkProfile({
    required this.transport,
    required this.useCellularPreferences,
    this.rssi,
    this.linkSpeedMbps,
    this.signalLevel,
    this.metered = false,
    this.weakHint = false,
  });

  final NetworkTransport transport;
  final bool useCellularPreferences;
  final int? rssi;
  final int? linkSpeedMbps;
  final int? signalLevel;
  final bool metered;
  final bool weakHint;

  String get preferenceLabel => useCellularPreferences ? '等效移网' : '等效宽带';

  Object get identity => (transport, useCellularPreferences);
}

final class NetworkPolicyChange {
  const NetworkPolicyChange(this.profile, this.reason);

  final NetworkProfile profile;
  final NetworkPolicyReason reason;
}
