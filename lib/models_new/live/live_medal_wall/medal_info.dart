class MedalInfo {
  int? wearingStatus;

  MedalInfo({
    this.wearingStatus,
  });

  factory MedalInfo.fromJson(Map<String, dynamic> json) => MedalInfo(
    wearingStatus: json['wearing_status'] as int?,
  );
}
