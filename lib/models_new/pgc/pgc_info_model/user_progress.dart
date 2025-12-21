class UserProgress {
  UserProgress({this.lastEpId, this.lastEpIndex, this.lastTime});
  int? lastEpId;
  String? lastEpIndex;
  int? lastTime;
  UserProgress.fromJson(Map<String, dynamic> json) {
    lastEpId = json['last_ep_id'];
    lastEpIndex = json['last_ep_index'];
    lastTime = json['last_time'];
  }
}
