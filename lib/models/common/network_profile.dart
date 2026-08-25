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
    this.downstreamKbps,
    this.upstreamKbps,
    this.networkType,
    this.carrierName,
    this.adapterName,
    this.adapterDescription,
    this.receiveLinkSpeedMbps,
    this.transmitLinkSpeedMbps,
    this.interfaceMetric,
    this.mtu,
    this.metered = false,
    this.captivePortal,
    this.congested,
    this.bandwidthConstrained,
    this.validated,
    this.internet,
    this.vpn,
    this.roaming,
    this.weakHint = false,
  });

  final NetworkTransport transport;
  final bool useCellularPreferences;
  final int? rssi;
  final int? linkSpeedMbps;
  final int? signalLevel;
  final int? downstreamKbps;
  final int? upstreamKbps;
  final int? networkType;
  final String? carrierName;
  final String? adapterName;
  final String? adapterDescription;
  final int? receiveLinkSpeedMbps;
  final int? transmitLinkSpeedMbps;
  final int? interfaceMetric;
  final int? mtu;
  final bool metered;
  final bool? captivePortal;
  final bool? congested;
  final bool? bandwidthConstrained;
  final bool? validated;
  final bool? internet;
  final bool? vpn;
  final bool? roaming;
  final bool weakHint;

  String get preferenceLabel => useCellularPreferences ? '等效移网' : '等效宽带';

  Object get identity => (transport, useCellularPreferences);
}

final class NetworkPolicyChange {
  const NetworkPolicyChange(this.profile, this.reason);

  final NetworkProfile profile;
  final NetworkPolicyReason reason;
}
