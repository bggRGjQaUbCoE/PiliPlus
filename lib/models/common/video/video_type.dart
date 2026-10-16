import 'package:PiliPlus/http/api.dart';

enum VideoType {
  ugc(
    type: 3,
    api: Api.ugcUrl,
  ),
  pgc(
    type: 4,
    api: Api.ogvUrl,
    method: 'POST',
  ),
  pugv(
    type: 10,
    replyType: 33,
    api: Api.ogvUrl,
  ),
  ;

  final int type;
  final String api;
  final String method;
  final int replyType;

  const VideoType({
    required this.api,
    required this.type,
    this.method = 'GET',
    this.replyType = 1,
  });
}
