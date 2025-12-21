import 'package:PiliPlus/models_new/live/live_dm_info/host_list.dart';

class LiveDmInfoData {
  String? token;
  List<HostList>? hostList;

  LiveDmInfoData({this.token, this.hostList});

  factory LiveDmInfoData.fromJson(Map<String, dynamic> json) => LiveDmInfoData(
    token: json['token'] as String?,
    hostList: (json['host_list'] as List<dynamic>?)
        ?.map((e) => HostList.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
