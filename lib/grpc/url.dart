class GrpcUrl {
  // static const playerOnline =
  //     '/bilibili.app.playeronline.v1.PlayerOnline/PlayerOnline';
  // static const popular = '/bilibili.app.show.v1.Popular/Index';

  // dynamic
  static const dynV1 = '/bilibili.app.dynamic.v1.Dynamic';
  // static const dynV2 = '/bilibili.app.dynamic.v2.Dynamic';
  static const opusV2 = '/bilibili.app.dynamic.v2.Opus';
  static const dynRed = '$dynV1/DynRed';
  static const opusSpaceFlow = '$opusV2/OpusSpaceFlow';
  static const opusDetail = '$opusV2/OpusDetail';
  // static const dynSpace = '$dynV2/DynSpace';

  // danmaku
  static const dmSegMobile = '/bilibili.community.service.dm.v1.DM/DmSegMobile';

  // reply
  static const reply = '/bilibili.main.community.reply.v1.Reply';
  static const mainList = '$reply/MainList';
  static const detailList = '$reply/DetailList';
  static const dialogList = '$reply/DialogList';
  // static const replyInfo = '$reply/ReplyInfo';
  static const searchItem = '$reply/SearchItem';

  // im
  static const im = '/bilibili.im.interface.v1.ImInterface';
  static const im2 = '/bilibili.app.im.v1.im';
  static const sendMsg = '$im/SendMsg';
  static const shareList = '$im/ShareList';
  static const sessionMain = '$im2/SessionMain';
  static const sessionSecondary = '$im2/SessionSecondary';
  static const clearUnread = '$im2/ClearUnread';
  static const sessionUpdate = '$im2/SessionUpdate';
  static const pinSession = '$im2/PinSession';
  static const unpinSession = '$im2/UnpinSession';
  static const deleteSessionList = '$im2/DeleteSessionList';
  static const getImSettings = '$im2/GetImSettings';
  static const setImSettings = '$im2/SetImSettings';
  static const keywordBlockingList = '$im2/KeywordBlockingList';
  static const keywordBlockingAdd = '$im2/KeywordBlockingAdd';
  static const keywordBlockingDelete = '$im2/KeywordBlockingDelete';
  static const syncFetchSessionMsgs = '$im/SyncFetchSessionMsgs';
  static const getTotalUnread = '$im/GetTotalUnread';

  // view
  static const viewunite = '/bilibili.app.viewunite.v1.View';
  static const view = '$viewunite/View';

  // audio
  static const audio = '/bilibili.app.listener.v1.Listener';
  static const audioPlayUrl = '$audio/PlayURL';
  static const audioPlayList = '$audio/Playlist';
  static const audioThumbUp = '$audio/ThumbUp';
  static const audioTripleLike = '$audio/TripleLike';
  static const audioCoinAdd = '$audio/CoinAdd';
}
