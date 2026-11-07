import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get.dart';

/// 小窗播放所需的视频信息，用于小窗展开时重新进入视频页
class MiniPlayerVideoInfo {
  const MiniPlayerVideoInfo({
    required this.aid,
    required this.bvid,
    required this.cid,
    required this.videoType,
    this.epId,
    this.seasonId,
    this.pgcType,
    this.cover,
    this.title,
    this.isVertical = false,
  });

  final int aid;
  final String bvid;
  final int cid;
  final VideoType videoType;
  final int? epId;
  final int? seasonId;
  final int? pgcType;
  final String? cover;
  final String? title;
  final bool isVertical;
}

/// 应用内小窗播放
///
/// 视频页返回时若开启「返回时进入小窗播放」，播放器交给本服务接管，
/// 画面以悬浮小窗的形式显示在所有页面之上，可以继续浏览并挑选其他视频。
///
/// 播放器实例本身不会被销毁，而是依赖 [PlPlayerController] 的引用计数：
/// 小窗通过 [PlPlayerController.getInstance] 额外持有一个引用，
/// 因此视频页退出时只做计数减一；小窗关闭或重新打开视频页时
/// 再调用 [PlPlayerController.dispose] 归还引用。
class MiniPlayerService {
  MiniPlayerService._();

  static final MiniPlayerService instance = MiniPlayerService._();

  /// 小窗是否正在显示
  final RxBool isShowing = RxBool(false);

  /// 当前小窗播放的视频信息
  final Rxn<MiniPlayerVideoInfo> info = Rxn<MiniPlayerVideoInfo>();

  PlPlayerController? _playerController;

  PlPlayerController? get playerController => _playerController;

  /// 由视频页转入小窗播放
  ///
  /// 调用前应由视频页调用 [PlPlayerController.onPopInvokedCleanup] 完成退页清理，
  /// 并把 [PlPlayerController.handedOffToMiniPlayer] 置为 true。
  void enter({required MiniPlayerVideoInfo info}) {
    // 额外持有一个播放器引用，视频页退出时只做引用计数减一
    _playerController = PlPlayerController.getInstance();
    this.info.value = info;
    isShowing.value = true;
  }

  /// 展开为视频页，并从当前进度继续播放
  void expand() {
    final info = this.info.value;
    final progress = _playerController?.positionInMilliseconds;
    release();
    if (info == null) {
      return;
    }
    PageUtils.toVideoPage(
      videoType: info.videoType,
      aid: info.aid,
      bvid: info.bvid,
      cid: info.cid,
      epId: info.epId,
      seasonId: info.seasonId,
      pgcType: info.pgcType,
      cover: info.cover,
      title: info.title,
      progress: progress,
      isVertical: info.isVertical,
    );
  }

  /// 收回小窗持有的播放器引用
  ///
  /// 如果此时已有页面（视频页/直播页）接管播放器，引用计数减一后播放器继续存活；
  /// 否则播放器被销毁。
  void release() {
    if (!isShowing.value && _playerController == null) {
      return;
    }
    isShowing.value = false;
    info.value = null;
    final playerController = _playerController;
    _playerController = null;
    playerController?.dispose();
  }
}
