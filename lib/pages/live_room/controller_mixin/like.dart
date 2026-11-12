part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveLikeMixin on GetxController, _LiveDataMixin {
  Timer? _likeClickTimer;
  final RxInt likeClickTime = 0.obs;

  void _stopLiveLikeTimer() {
    _likeClickTimer?.cancel();
    _likeClickTimer = null;
  }

  void onLikeTapDown(_) {
    _stopLiveLikeTimer();
    likeClickTime.value++;
  }

  void onLikeTapUp([_]) {
    _likeClickTimer ??= Timer(const Duration(milliseconds: 800), onLike);
  }

  Future<void> onLike() async {
    if (!isMainLogin) {
      likeClickTime.value = 0;
      return;
    }
    final res = await LiveHttp.liveLikeReport(
      clickTime: likeClickTime.value,
      roomId: roomId,
      uid: mid,
      anchorId: roomInfoH5.value?.roomInfo?.uid,
    );
    if (res.isSuccess) {
      SmartDialog.showToast('点赞成功');
    } else {
      res.toast();
    }
    likeClickTime.value = 0;
  }

  @override
  void onClose() {
    _stopLiveLikeTimer();
    super.onClose();
  }
}
