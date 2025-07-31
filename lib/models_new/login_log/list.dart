class LoginLogItem {
  final String ip;
  final int? time;
  final String timeAt;
  final bool? status;
  final int? type;
  final String geo;

  const LoginLogItem({
    required this.ip,
    this.time,
    required this.timeAt,
    this.status,
    this.type,
    required this.geo,
  });

  factory LoginLogItem.fromJson(Map<String, dynamic> json) => LoginLogItem(
    ip: json['ip'] ?? '',
    time: json['time'] as int?,
    timeAt: json['time_at'] ?? '',
    status: json['status'] as bool?,
    type: json['type'] as int?,
    geo: json['geo'] ?? '',
  );
}
