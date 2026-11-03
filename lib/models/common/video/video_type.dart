import 'package:PiliPlus/http/api.dart';

enum VideoType {
  ugc(
    type: 3,
    api: Api.ugcUrl,
    fallbackApi: Api.ugcUrl,
  ),
  pgc(
    type: 4,
    api: Api.ogvUrl,
    fallbackApi: Api.pgcUrl,
    bizType: 'ogv',
  ),
  pugv(
    type: 10,
    replyType: 33,
    api: Api.ogvUrl,
    fallbackApi: Api.pugvUrl,
    bizType: 'pugv',
  ),
  ;

  final int type;
  final String api;
  final String fallbackApi;
  final int replyType;
  final String? bizType;

  const VideoType({
    required this.api,
    required this.fallbackApi,
    required this.type,
    this.replyType = 1,
    this.bizType,
  });
}
