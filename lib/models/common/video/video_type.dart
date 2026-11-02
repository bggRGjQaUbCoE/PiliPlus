import 'package:PiliPlus/http/api.dart';

enum VideoType {
  ugc(
    type: 3,
    api: Api.ugcUrl,
  ),
  pgc(
    type: 4,
    api: Api.ogvUrl,
    bizType: 'ogv',
  ),
  pugv(
    type: 10,
    replyType: 33,
    api: Api.ogvUrl,
    bizType: 'pugv',
  ),
  ;

  final int type;
  final String api;
  final int replyType;
  final String? bizType;

  const VideoType({
    required this.api,
    required this.type,
    this.replyType = 1,
    this.bizType,
  });
}
