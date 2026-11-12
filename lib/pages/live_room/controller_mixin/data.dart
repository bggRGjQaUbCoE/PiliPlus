part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveDataMixin on GetxController {
  final isLoaded = false.obs;

  int? ruid;
  int get roomId;
  late final int mid;
  late final bool isMainLogin;
  late final Account heartbeat;
  bool get isHeartbeatLogin => heartbeat.isLogin;

  DanmakuController<DanmakuExtra>? danmakuController;
  PlPlayerController get plPlayerController;

  late final RxBool isPortrait = false.obs;
  late final roomInfoH5 = Rxn<RoomInfoH5Data>();
  late List<LiveQuality> acceptQnList = [];
  late final Rxn<LiveQuality> currentQn = Rxn<LiveQuality>(
    PlatformUtils.isMobile || Platform.isLinux
        ? null
        : .fromCode(Pref.liveQuality),
  );

  bool? isPlaying;
  String? videoUrl;
  late bool isFullScreen = false;

  @override
  void onInit() {
    final mainAccount = Accounts.main;
    heartbeat = Accounts.heartbeat;
    isMainLogin = mainAccount.isLogin;
    mid = mainAccount.mid;
    super.onInit();
  }

  @override
  void onClose() {
    danmakuController = null;
    super.onClose();
  }
}
