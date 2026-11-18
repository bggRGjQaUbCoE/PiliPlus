import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

import 'model.dart';
import 'links.dart';
import 'session.dart';
import 'view.dart';
import 'panel.dart';
import 'http_request.dart';

export 'presentation.dart';

class PiliRoomTransport implements RoomTransport {
  final Account account;
  String? lastPath;
  int? lastCode;
  bool lastHadInviteToken = false;
  int? lastProgressStatus, lastProgressSeconds, lastProgressCode;
  PiliRoomTransport(this.account);
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    if (!identical(Accounts.main, account) || !account.isLogin) {
      throw const RoomApiException(-101, '账号已切换，请重新加入放映室');
    }
    final request = roomHttpRequest(
      path: path,
      post: post,
      parameters: parameters,
      csrf: account.csrf,
      accessKey: account.accessKey,
    );
    final params = request.parameters;
    if (params['content'] is Map)
      params['content'] = jsonEncode(params['content']);
    lastPath = path;
    lastCode = null;
    lastHadInviteToken = params['token']?.toString().isNotEmpty ?? false;
    final isProgress = path == 'pgc/freya/web/room/modify/progress';
    if (isProgress) {
      lastProgressStatus = roomInt(params['status']);
      lastProgressSeconds = roomInt(params['progress']);
      lastProgressCode = null;
    }
    try {
      final response = await Request.dio.request<dynamic>(
        'https://api.bilibili.com/$path',
        queryParameters: post ? null : params,
        data: post ? params : null,
        options: Options(
          method: post ? 'POST' : 'GET',
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            ...request.headers,
            if (path == 'pgc/freya/room/leave') 'buvid': account.buvid,
          },
          extra: {'account': account},
        ),
      );
      final json = roomMap(response.data);
      final code = roomInt(json['code'], -1);
      lastCode = code;
      if (isProgress) lastProgressCode = code;
      if (code != 0)
        throw RoomApiException(code, '${json['message'] ?? '房间请求失败'}');
      return roomMap(json['data']);
    } on DioException {
      throw const RoomApiException(-1, '房间网络请求失败，请检查网络后重试');
    }
  }
}

/// Connects room sessions to the active account and native player.
/// The protocol/session module communicates exclusively through primitive DTOs
/// and playback callbacks, so Android, iPadOS and Windows share the same core.
class WatchroomAdapter extends ChangeNotifier with WidgetsBindingObserver {
  static final instance = WatchroomAdapter._();
  RoomSession? session;
  Account? _account;
  StreamSubscription<void>? _subscription;
  PlPlayerController? _boundPlayer;
  String? _boundTag;
  static const entryRoute = '/watchroom-entry';
  final _pages =
      <String, ({VoidCallback open, Future<void> Function() prepare})>{};
  final _creating = <String>{};
  bool _openingPlayer = false, _drawerOpen = false;
  String chatDraft = '';
  WatchroomAdapter._() {
    WidgetsBinding.instance.addObserver(this);
  }

  Future<RoomSession> _ensureSession() async {
    final account = Accounts.main;
    if (!account.isLogin)
      throw const RoomApiException(-101, '请先登录 PiliPlus 主账号');
    if (!identical(_account, account)) {
      await session?.leave();
      await _subscription?.cancel();
      _account = account;
      session = RoomSession(
        transport: PiliRoomTransport(account),
        mid: account.mid,
        buvid: _webBuvid(account),
        currentBuvid: () => _webBuvid(account),
        openEpisode: (season, episode) => openPlayer(replace: true),
      );
      _subscription = session!.changes.listen((_) {
        if (session?.active != true) chatDraft = '';
        notifyListeners();
      });
    }
    return session!;
  }

  String _webBuvid(Account account) {
    final value = account.cookieJar
        .toList()
        .where((cookie) => cookie.name == 'buvid3')
        .firstOrNull
        ?.value;
    if (value == null || value.isEmpty)
      throw const RoomApiException(-101, '网页设备标识缺失，请重新登录');
    return value;
  }

  Future<void> join(String text) async {
    final invite = await const RoomLinkResolver().resolve(text);
    await (await _ensureSession()).join(invite);
  }

  Future<void> create({required int episode, int? season}) async {
    final current = await _ensureSession();
    if (season == null || season <= 0) {
      final result = await SearchHttp.pgcInfo(epId: episode);
      season = result.dataOrNull?.seasonId;
      if (season == null) throw StateError(result.toString());
    }
    await current.create(season, episode);
  }

  static Future<void> open({
    String? link,
    int? episodeId,
    int? seasonId,
  }) async {
    final adapter = instance;
    if (link == null && adapter.session?.active == true) {
      await adapter.session!.refresh();
      if (adapter.session?.active == true) {
        await adapter.openPlayer();
        return;
      }
      if (adapter.session!.error.isNotEmpty)
        SmartDialog.showToast(adapter.session!.error);
    }
    Get.to<void>(
      () => WatchroomPage(link: link, episodeId: episodeId, seasonId: seasonId),
      routeName: entryRoute,
    );
  }

  void attachPage(
    String identity, {
    required VoidCallback open,
    required Future<void> Function() prepare,
  }) {
    _pages[identity] = (open: open, prepare: prepare);
  }

  void detachPage(String identity) => _pages.remove(identity);

  static bool textInputHasFocus() {
    final context = FocusManager.instance.primaryFocus?.context;
    return context?.widget is EditableText ||
        context?.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  Widget entryButton() => AnimatedBuilder(
    animation: this,
    builder: (context, _) {
      final active = session?.active == true;
      return IconButton(
        tooltip: active
            ? '放映厅进行中 · ${session!.room!.playing ? '正在放映' : '已暂停'}'
            : 'B站放映厅',
        onPressed: () => open(),
        icon: Badge(
          isLabelVisible: active,
          child: const Icon(Icons.groups_outlined),
        ),
      );
    },
  );

  bool showsRoomFor(String identity, int? episode, int? season) =>
      session?.active == true &&
      (_boundTag == identity ||
          session!.room!.episodeId == episode ||
          session!.room!.seasonId == season);

  Future<void> copyInvitation() async {
    final current = session;
    if (current == null) throw StateError('请先加入放映厅');
    final invite = await current.invitationForShare();
    await Clipboard.setData(ClipboardData(text: '${invite.mobileUri}'));
  }

  Widget panel({VoidCallback? onClose}) {
    final current = session;
    if (current == null) return const Center(child: Text('尚未加入放映厅'));
    return WatchroomPanel(
      session: current,
      copyInvitation: copyInvitation,
      onClose: onClose,
      draft: chatDraft,
      onDraftChanged: (value) => chatDraft = value,
      onNotice: (value) => SmartDialog.showToast(value),
    );
  }

  Future<void> showSidePanel(BuildContext context) async {
    if (_drawerOpen || session?.active != true) return;
    _drawerOpen = true;
    try {
      await showGeneralDialog<void>(
        context: context,
        barrierDismissible: true,
        barrierLabel: '收起放映厅',
        barrierColor: Colors.black38,
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, _, _) {
          final size = MediaQuery.sizeOf(context);
          return AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            padding: MediaQuery.viewInsetsOf(context),
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: math.min(
                    size.width,
                    (size.width * .55).clamp(280, 420),
                  ),
                  height: double.infinity,
                  child: panel(onClose: () => Navigator.pop(context)),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (_, animation, _, child) => SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          ),
          child: child,
        ),
      );
    } finally {
      _drawerOpen = false;
    }
  }

  Future<void> createHere(
    BuildContext context, {
    required String identity,
    required int episode,
    required int? season,
    required String title,
  }) async {
    if (!_creating.add(identity)) return;
    notifyListeners();
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('创建放映厅'),
          content: Text('与朋友一起看《$title》当前剧集，沿用当前播放进度和播放状态。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('创建放映厅'),
            ),
          ],
        ),
      );
      if (confirmed != true || !_pages.containsKey(identity)) return;
      await create(episode: episode, season: season);
      final page = _pages[identity];
      if (page == null) return;
      await page.prepare();
      await session?.publishPlayerState();
      page.open();
      SmartDialog.showToast('放映厅已创建，可在面板右上角邀请好友');
    } catch (e) {
      SmartDialog.showToast('$e');
    } finally {
      _creating.remove(identity);
      notifyListeners();
    }
  }

  Widget creationCard(
    BuildContext context, {
    required String identity,
    required int? episode,
    required int? season,
    required bool? supported,
    required String title,
  }) => AnimatedBuilder(
    animation: this,
    builder: (context, _) {
      if (episode == null || (supported != true && session?.active != true)) {
        return const SizedBox.shrink();
      }
      final active = session?.active == true;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedButton.icon(
          icon: const Icon(Icons.groups_outlined),
          label: Text(active ? '返回当前放映厅' : '和朋友一起看 · 创建放映厅'),
          onPressed: _creating.contains(identity)
              ? null
              : () {
                  if (active) {
                    if (showsRoomFor(identity, episode, season)) {
                      _pages[identity]?.open();
                    } else {
                      unawaited(openPlayer());
                    }
                  } else {
                    unawaited(
                      createHere(
                        context,
                        identity: identity,
                        episode: episode,
                        season: season,
                        title: title,
                      ),
                    );
                  }
                },
        ),
      );
    },
  );

  Widget playerButton(
    BuildContext context, {
    required String identity,
    int? episodeId,
    int? seasonId,
    bool? supported,
    String title = '当前剧集',
  }) => AnimatedBuilder(
    animation: this,
    builder: (context, _) {
      if (session?.active != true && supported != true)
        return const SizedBox.shrink();
      return IconButton(
        tooltip: session?.active == true ? '放映厅' : '创建放映厅',
        icon: const Icon(Icons.groups_outlined, color: Colors.white, size: 20),
        onPressed: _creating.contains(identity)
            ? null
            : () {
                if (session?.active == true) {
                  if (showsRoomFor(identity, episodeId, seasonId)) {
                    _pages[identity]?.open();
                  } else {
                    unawaited(openPlayer());
                  }
                } else if (episodeId != null) {
                  unawaited(
                    createHere(
                      context,
                      identity: identity,
                      episode: episodeId,
                      season: seasonId,
                      title: title,
                    ),
                  );
                }
              },
      );
    },
  );

  bool shouldInitialize(int? episode) => session?.playbackFor(episode) != null;
  Duration? startPosition(int? episode) =>
      session?.playbackFor(episode)?.position;
  bool? initialPlaying(int? episode) => session?.playbackFor(episode)?.playing;

  Future<void> openPlayer({
    bool replace = false,
    bool replaceEntry = false,
  }) async {
    final current = session, snapshot = session?.room;
    if (snapshot == null || current == null) return;
    if (_openingPlayer) return;
    if (current.playerAttached && !replace && Get.currentRoute == '/videoV') {
      _pages[_boundTag]?.open();
      return;
    }
    _openingPlayer = true;
    try {
      await PageUtils.viewPgc(
        seasonId: snapshot.seasonId,
        epId: snapshot.episodeId,
        progress: snapshot.targetAt(DateTime.now()).inMilliseconds,
        off:
            (replace && Get.currentRoute == '/videoV') ||
            (replaceEntry && Get.currentRoute == entryRoute),
      );
    } finally {
      _openingPlayer = false;
    }
  }

  void suspend(String identity) {
    if (_boundTag == identity) {
      session?.unbindPlayer(identity);
      _boundTag = null;
      _boundPlayer = null;
    }
  }

  Future<void> bind({
    required String identity,
    required int? episodeId,
    required int? seasonId,
    required PlPlayerController player,
  }) async {
    final current = session;
    if (current == null ||
        !current.active ||
        episodeId == null ||
        seasonId == null)
      return;
    _boundTag = identity;
    _boundPlayer = player;
    await current
        .bindPlayer(
          RoomPlayer(
            identity: identity,
            episodeId: episodeId,
            seasonId: seasonId,
            position: () =>
                Duration(milliseconds: player.positionInMilliseconds),
            playing: () =>
                player.videoPlayerController?.state.playing ??
                player.playerStatus.isPlaying,
            play: () => player.play(),
            pause: () => player.pause(),
            seek: player.seekTo,
          ),
        )
        .catchError((Object _) {});
  }

  void onPlayerExit(PlPlayerController player) {
    if (!identical(player, _boundPlayer)) return;
    final identity = _boundTag;
    _boundTag = null;
    _boundPlayer = null;
    if (identity != null)
      unawaited(session?.parkPlayer(identity) ?? Future<void>.value());
  }

  void observe(PlPlayerController player, String action) {
    if (identical(player, _boundPlayer)) session?.observeLocal(action);
  }

  void observeNativeState(PlPlayerController player) {
    if (identical(player, _boundPlayer) && !player.processing) {
      session?.observeHostPlaybackState();
    }
  }

  /// Only a real application exit calls this. Minimizing/hiding the window
  /// retains membership and follows the existing playback preference.
  Future<bool> prepareDesktopExit({ValueChanged<String>? onError}) async {
    final current = session;
    if (current?.active != true) return true;
    try {
      await current!.exit();
      return true;
    } catch (e) {
      final message = '放映厅未能退出，请在房间面板重试：$e';
      if (onError != null) {
        onError(message);
      } else {
        SmartDialog.showToast(message);
      }
      return false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      unawaited(session?.refresh() ?? Future<void>.value());
  }
}
