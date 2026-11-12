part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveSCMixin on GetxController, _LiveDataMixin {
  late final fsSC = Rxn<SuperChatItem>();
  late final enableFSSC = Pref.enableFullScreenSC;
  late final fsSCScale = Pref.fullScreenSCScale;
  late final fsSCOpacity = Pref.fullScreenSCOpacity;

  final superChatType = Pref.superChatType;
  late final showSuperChat = superChatType != SuperChatType.disable;
  late final RxList<SuperChatItem> superChatMsg = <SuperChatItem>[].obs;

  late final RxInt pageIndex = 0.obs;
  PageController? pageController;

  @override
  void onInit() {
    if (showSuperChat) pageController = PageController();
    super.onInit();
  }

  Future<void> getSuperChatMsg() async {
    final res = await LiveHttp.superChatMsg(roomId);
    if (isClosed) return;
    if (res.dataOrNull?.list case final list? when list.isNotEmpty) {
      superChatMsg.addAll(list);
    }
  }

  void clearSC() {
    superChatMsg.removeWhere((e) => e.expired);
  }

  @override
  void onClose() {
    pageController?.dispose();
    pageController = null;
    if (showSuperChat) {
      superChatMsg.clear();
      if (enableFSSC) fsSC.value = null;
    }
    super.onClose();
  }
}
