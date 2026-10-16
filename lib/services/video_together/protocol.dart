abstract final class VideoTogetherProtocol {
  static const defaultServer = 'https://vt.panghair.com:5000';
  static const roomUpdate = '/room/update';
  static const roomJoin = '/room/join';
  static const memberUpdate = '/room/update_member';
  static const timestampReply = 'replay_timestamp';
  static const textMessage = 'send_txtmsg';

  static Uri serverUri(String value) {
    final uri = Uri.parse(value.trim());
    if (!uri.hasScheme ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const FormatException('服务器地址必须是有效的 http/https 地址');
    }
    return uri.replace(path: _trimTrailingSlash(uri.path)).removeFragment();
  }

  static Uri webSocketUri(String server, {String language = 'zh-cn'}) {
    final uri = serverUri(server);
    final path = '${_trimTrailingSlash(uri.path)}/ws';
    return uri.replace(
      scheme: uri.scheme == 'https' ? 'wss' : 'ws',
      path: path,
      queryParameters: {...uri.queryParameters, 'language': language},
    );
  }

  static Uri timestampUri(String server) {
    final uri = serverUri(server);
    return uri.replace(path: '${_trimTrailingSlash(uri.path)}/timestamp');
  }

  static Map<String, dynamic> joinRequest({
    required String roomName,
    required String password,
  }) => {
    'method': roomJoin,
    'data': {'password': password, 'name': roomName},
  };

  static Map<String, dynamic> roomUpdateRequest({
    required String tempUser,
    required String password,
    required String roomName,
    required double playbackRate,
    required double currentTime,
    required bool paused,
    required String url,
    required double lastUpdateClientTime,
    required double duration,
    required bool isProtected,
    required String videoTitle,
    required double sendLocalTimestamp,
  }) => {
    'method': roomUpdate,
    'data': {
      'tempUser': tempUser,
      'password': password,
      'name': roomName,
      'playbackRate': playbackRate,
      'currentTime': currentTime,
      'paused': paused,
      'url': url,
      'lastUpdateClientTime': lastUpdateClientTime,
      'duration': duration,
      'protected': isProtected,
      'videoTitle': videoTitle,
      'sendLocalTimestamp': sendLocalTimestamp,
      'm3u8Url': '',
    },
  };

  static Map<String, dynamic> memberUpdateRequest({
    required String roomName,
    required String password,
    required String userId,
    required bool isLoading,
    required String currentUrl,
    required double sendLocalTimestamp,
  }) => {
    'method': memberUpdate,
    'data': {
      'password': password,
      'roomName': roomName,
      'sendLocalTimestamp': sendLocalTimestamp,
      'userId': userId,
      'isLoadding': isLoading,
      'currentUrl': currentUrl,
    },
  };

  static Map<String, dynamic> textMessageRequest({
    required String sender,
    required String text,
  }) => {
    'method': textMessage,
    'data': {'msg': text, 'id': sender, 'voiceId': ''},
  };

  static double clockOffset({
    required double localSend,
    required double serverReceive,
    required double serverSend,
    required double localReceive,
  }) => ((serverReceive - localSend) + (serverSend - localReceive)) / 2;

  static double roundTrip({
    required double localSend,
    required double serverReceive,
    required double serverSend,
    required double localReceive,
  }) => (localReceive - localSend) - (serverSend - serverReceive);

  static String _trimTrailingSlash(String value) {
    var result = value;
    while (result.endsWith('/')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}
