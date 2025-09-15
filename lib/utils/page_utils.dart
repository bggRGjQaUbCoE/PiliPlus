import 'dart:math';

import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:PiliPlus/common/widgets/marquee.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/fav_panel/view.dart';
import 'package:PiliPlus/pages/share/view.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/menu_row.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:floating/floating.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:url_launcher/url_launcher.dart';

abstract class PageUtils {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  static Future<void> imageView({
    int initialPage = 0,
    required List<SourceModel> imgList,
    ValueChanged<int>? onDismissed,
    int? quality,
  }) {
    return Get.key.currentState!.push<void>(
      HeroDialogRoute(
        builder: (context) => InteractiveviewerGallery(
          sources: imgList,
          initIndex: initialPage,
          onDismissed: onDismissed,
          quality: quality ?? GlobalData().imgQuality,
        ),
      ),
    );
  }

  static Future<void> pmShare(
    BuildContext context, {
    required Map content,
  }) async {
    // if (kDebugMode) debugPrint(content.toString());

    int? selectedIndex;
    List<UserModel> userList = <UserModel>[];

    final shareListRes = await ImGrpc.shareList(size: 3);
    if (shareListRes.isSuccess && shareListRes.data.sessionList.isNotEmpty) {
      userList.addAll(
        shareListRes.data.sessionList.map<UserModel>(
          (item) => UserModel(
            mid: item.talkerId.toInt(),
            name: item.talkerUname,
            avatar: item.talkerIcon,
          ),
        ),
      );
    } else if (context.mounted) {
      UserModel? userModel = await Navigator.of(context).push(
        GetPageRoute(page: () => const ContactPage()),
      );
      if (userModel != null) {
        selectedIndex = 0;
        userList.add(userModel);
      }
    }

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SharePanel(
          content: content,
          userList: userList,
          selectedIndex: selectedIndex,
        ),
        useSafeArea: true,
        enableDrag: false,
        isScrollControlled: true,
      );
    }
  }

  static void scheduleExit(
    BuildContext context,
    isFullScreen, [
    bool isLive = false,
  ]) {
    if (!context.mounted) {
      return;
    }
    const List<int> scheduleTimeChoices = [0, 15, 30, 45, 60];
    const TextStyle titleStyle = TextStyle(fontSize: 14);
    if (isLive) {
      shutdownTimerService.waitForPlayingCompleted = false;
    }
    showVideoBottomSheet(
      context,
      isFullScreen: () => isFullScreen,
      child: StatefulBuilder(
        builder: (_, setState) {
          void onTap(int choice) {
            if (choice == -1) {
              showDialog(
                context: context,
                builder: (context) {
                  final ThemeData theme = Theme.of(context);
                  String duration = '';
                  return AlertDialog(
                    title: const Text('自定义时长'),
                    content: TextField(
                      autofocus: true,
                      onChanged: (value) => duration = value,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(suffixText: 'min'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: Get.back,
                        child: Text(
                          '取消',
                          style: TextStyle(color: theme.colorScheme.outline),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          int choice = int.tryParse(duration) ?? 0;
                          shutdownTimerService
                            ..scheduledExitInMinutes = choice
                            ..startShutdownTimer();
                          setState(() {});
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  );
                },
              );
            } else {
              Get.back();
              shutdownTimerService.scheduledExitInMinutes = choice;
              shutdownTimerService.startShutdownTimer();
            }
          }

          final ThemeData theme = Theme.of(context);
          return Theme(
            data: theme,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Material(
                clipBehavior: Clip.hardEdge,
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  children: [
                    const Center(child: Text('定时关闭', style: titleStyle)),
                    const SizedBox(height: 10),
                    ...[
                      ...[
                        ...scheduleTimeChoices,
                        if (!scheduleTimeChoices.contains(
                          shutdownTimerService.scheduledExitInMinutes,
                        ))
                          shutdownTimerService.scheduledExitInMinutes,
                      ]..sort(),
                      -1,
                    ].map(
                      (choice) => ListTile(
                        dense: true,
                        onTap: () => onTap(choice),
                        title: Text(
                          choice == -1
                              ? '自定义'
                              : choice == 0
                              ? "禁用"
                              : "$choice分钟后",
                          style: titleStyle,
                        ),
                        trailing:
                            shutdownTimerService.scheduledExitInMinutes ==
                                choice
                            ? Icon(
                                size: 20,
                                Icons.done,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    if (!isLive) ...[
                      Builder(
                        builder: (context) {
                          return ListTile(
                            dense: true,
                            onTap: () {
                              shutdownTimerService.waitForPlayingCompleted =
                                  !shutdownTimerService.waitForPlayingCompleted;
                              (context as Element).markNeedsBuild();
                            },
                            title: const Text("额外等待视频播放完毕", style: titleStyle),
                            trailing: Transform.scale(
                              alignment: Alignment.centerRight,
                              scale: 0.8,
                              child: Switch(
                                thumbIcon:
                                    WidgetStateProperty.resolveWith<Icon?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.isNotEmpty &&
                                          states.first ==
                                              WidgetState.selected) {
                                        return const Icon(Icons.done);
                                      }
                                      return null;
                                    }),
                                value: shutdownTimerService
                                    .waitForPlayingCompleted,
                                onChanged: (value) {
                                  shutdownTimerService.waitForPlayingCompleted =
                                      value;
                                  (context as Element).markNeedsBuild();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 10),
                    Builder(
                      builder: (context) {
                        return Row(
                          children: [
                            const SizedBox(width: 18),
                            const Text('倒计时结束:', style: titleStyle),
                            const Spacer(),
                            ActionRowLineItem(
                              onTap: () {
                                shutdownTimerService.exitApp = false;
                                (context as Element).markNeedsBuild();
                              },
                              text: " 暂停视频 ",
                              selectStatus: !shutdownTimerService.exitApp,
                            ),
                            const Spacer(),
                            ActionRowLineItem(
                              onTap: () {
                                shutdownTimerService.exitApp = true;
                                (context as Element).markNeedsBuild();
                              },
                              text: " 退出APP ",
                              selectStatus: shutdownTimerService.exitApp,
                            ),
                            const SizedBox(width: 25),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> pushDynFromId({id, rid, bool off = false}) async {
    SmartDialog.showLoading();
    final res = await DynamicsHttp.dynamicDetail(
      id: id,
      rid: rid,
      type: rid != null ? 2 : null,
    );
    SmartDialog.dismiss();
    if (res.isSuccess) {
      final data = res.data;
      if (data.basic?.commentType == 12) {
        toDupNamed(
          '/articlePage',
          parameters: {
            'id': id,
            'type': 'opus',
          },
          off: off,
        );
      } else {
        toDupNamed(
          '/dynamicDetail',
          arguments: {
            'item': data,
          },
          off: off,
        );
      }
    } else {
      res.toast();
    }
  }

  static void showFavBottomSheet({
    required BuildContext context,
    required CommonIntroController ctr,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      sheetAnimationStyle: const AnimationStyle(curve: Curves.ease),
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          minChildSize: 0,
          maxChildSize: 1,
          initialChildSize: 0.7,
          snap: true,
          expand: false,
          snapSizes: const [0.7],
          builder: (BuildContext context, ScrollController scrollController) {
            return FavPanel(
              ctr: ctr,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  static void reportVideo(int aid) {
    Get.toNamed(
      '/webview',
      parameters: {'url': 'https://www.bilibili.com/appeal/?avid=$aid'},
    );
  }

  static void enterPip({int? width, int? height}) {
    if (width != null && height != null) {
      Rational aspectRatio = Rational(width, height);
      Floating().enable(
        EnableManual(
          aspectRatio: aspectRatio.fitsInAndroidRequirements
              ? aspectRatio
              : height > width
              ? const Rational.vertical()
              : const Rational.landscape(),
        ),
      );
    } else {
      Floating().enable(const EnableManual());
    }
  }

  static Future<void> pushDynDetail(
    DynamicItemModel item, {
    bool isPush = false,
  }) async {
    feedBack();

    void push() {
      if (item.basic?.commentType == 12) {
        toDupNamed(
          '/articlePage',
          parameters: {
            'id': item.idStr,
            'type': 'opus',
          },
        );
      } else {
        toDupNamed(
          '/dynamicDetail',
          arguments: {
            'item': item,
          },
        );
      }
    }

    /// 点击评论action 直接查看评论
    if (isPush) {
      push();
      return;
    }

    // if (kDebugMode) debugPrint('pushDynDetail: ${item.type}');

    switch (item.type) {
      case 'DYNAMIC_TYPE_AV':
        final archive = item.modules.moduleDynamic!.major!.archive!;
        // pgc
        if (archive.type == 2) {
          // jumpUrl
          if (archive.jumpUrl case final jumpUrl?) {
            if (viewPgcFromUri(jumpUrl)) {
              return;
            }
          }
          // redirectUrl from intro
          final res = await VideoHttp.videoIntro(bvid: archive.bvid!);
          if (res.dataOrNull?.redirectUrl case final redirectUrl?) {
            if (viewPgcFromUri(redirectUrl)) {
              return;
            }
          }
          // redirectUrl from jumpUrl
          if (await UrlUtils.parseRedirectUrl(
                archive.jumpUrl.http2https,
                false,
              )
              case final redirectUrl?) {
            if (viewPgcFromUri(redirectUrl)) {
              return;
            }
          }
        }

        try {
          String bvid = archive.bvid!;
          String cover = archive.cover!;
          int? cid = await SearchHttp.ab2c(bvid: bvid);
          if (cid != null) {
            toVideoPage(
              bvid: bvid,
              cid: cid,
              cover: cover,
            );
          }
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;

      /// 专栏文章查看
      case 'DYNAMIC_TYPE_ARTICLE':
        toDupNamed(
          '/articlePage',
          parameters: {
            'id': item.idStr,
            'type': 'opus',
          },
        );
        break;

      case 'DYNAMIC_TYPE_PGC':
        // if (kDebugMode) debugPrint('番剧');
        SmartDialog.showToast('暂未支持的类型，请联系开发者');
        break;

      case 'DYNAMIC_TYPE_LIVE_RCMD':
        DynamicLiveModel liveRcmd =
            item.modules.moduleDynamic!.major!.liveRcmd!;
        toLiveRoom(liveRcmd.roomId);
        break;

      case 'DYNAMIC_TYPE_SUBSCRIPTION_NEW':
        LivePlayInfo live = item
            .modules
            .moduleDynamic!
            .major!
            .subscriptionNew!
            .liveRcmd!
            .content!
            .livePlayInfo!;
        toLiveRoom(live.roomId);
        break;

      /// 合集查看
      case 'DYNAMIC_TYPE_UGC_SEASON':
        DynamicArchiveModel ugcSeason =
            item.modules.moduleDynamic!.major!.ugcSeason!;
        int aid = ugcSeason.aid!;
        String bvid = IdUtils.av2bv(aid);
        String cover = ugcSeason.cover!;
        int? cid = await SearchHttp.ab2c(bvid: bvid);
        if (cid != null) {
          toVideoPage(
            aid: aid,
            bvid: bvid,
            cid: cid,
            cover: cover,
          );
        }
        break;

      /// 番剧查看
      case 'DYNAMIC_TYPE_PGC_UNION':
        // if (kDebugMode) debugPrint('DYNAMIC_TYPE_PGC_UNION 番剧');
        DynamicArchiveModel pgc = item.modules.moduleDynamic!.major!.pgc!;
        if (pgc.epid != null) {
          viewPgc(epId: pgc.epid);
        }
        break;

      case 'DYNAMIC_TYPE_MEDIALIST':
        if (item.modules.moduleDynamic?.major?.medialist
            case final medialist?) {
          final String? url = medialist.jumpUrl;
          if (url != null) {
            if (url.contains('medialist/detail/ml')) {
              Get.toNamed(
                '/favDetail',
                parameters: {
                  'heroTag': '${medialist.cover}',
                  'mediaId': '${medialist.id}',
                },
              );
            } else {
              handleWebview(url.http2https);
            }
          }
        }
        break;

      case 'DYNAMIC_TYPE_COURSES_SEASON':
        PageUtils.viewPugv(
          seasonId: item.modules.moduleDynamic!.major!.courses!.id,
        );
        break;

      // 纯文字动态查看
      // case 'DYNAMIC_TYPE_WORD':
      // # 装扮/剧集点评/普通分享
      // case 'DYNAMIC_TYPE_COMMON_SQUARE':
      // 转发的动态
      // case 'DYNAMIC_TYPE_FORWARD':
      // 图文动态查看
      // case 'DYNAMIC_TYPE_DRAW':
      default:
        push();
        break;
    }
  }

  static void onHorizontalPreviewState(
    ScaffoldState state,
    TickerProvider vsync,
    List<SourceModel> imgList,
    int index,
  ) {
    final ctr = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    )..forward();
    state.showBottomSheet(
      constraints: const BoxConstraints(),
      (context) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(ctr),
          child: InteractiveviewerGallery(
            sources: imgList,
            initIndex: index,
            onClose: (value) async {
              if (!value) {
                try {
                  await ctr.reverse();
                } catch (_) {}
              }
              try {
                ctr.dispose();
              } catch (_) {}
              if (!value) {
                Get.back();
              }
            },
            quality: GlobalData().imgQuality,
          ),
        );
      },
      enableDrag: false,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(duration: Duration.zero),
    );
  }

  static void onHorizontalPreview(
    BuildContext context,
    List<SourceModel> imgList,
    int index,
  ) {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null) {
      onHorizontalPreviewState(
        scaffoldState,
        ContextSingleTicker(scaffoldState.context),
        imgList,
        index,
      );
    } else {
      imageView(imgList: imgList, initialPage: index);
    }
  }

  static void inAppWebview(
    String url, {
    bool off = false,
  }) {
    if (Pref.openInBrowser) {
      launchURL(url);
    } else {
      if (off) {
        Get.offNamed(
          '/webview',
          parameters: {'url': url},
          arguments: {'inApp': true},
        );
      } else {
        Get.toNamed(
          '/webview',
          parameters: {'url': url},
          arguments: {'inApp': true},
        );
      }
    }
  }

  static Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        SmartDialog.showToast('Could not launch $url');
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  static Future<void> handleWebview(
    String url, {
    bool off = false,
    bool inApp = false,
    Map? parameters,
  }) async {
    if (!inApp && Pref.openInBrowser) {
      if (!await PiliScheme.routePushFromUrl(url, selfHandle: true)) {
        launchURL(url);
      }
    } else {
      if (off) {
        Get.offNamed(
          '/webview',
          parameters: {
            'url': url,
            ...?parameters,
          },
        );
      } else {
        PiliScheme.routePushFromUrl(url, parameters: parameters);
      }
    }
  }

  static void showVideoBottomSheet(
    BuildContext context, {
    required Widget child,
    required Function isFullScreen,
    double? padding,
  }) {
    if (!context.mounted) {
      return;
    }
    Get.generalDialog(
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (buildContext, animation, secondaryAnimation) {
        return Get.context!.isPortrait
            ? SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    Expanded(flex: 7, child: child),
                    if (isFullScreen() && padding != null)
                      SizedBox(height: padding),
                  ],
                ),
              )
            : SafeArea(
                child: Row(
                  children: [
                    const Spacer(),
                    Expanded(child: child),
                  ],
                ),
              );
      },
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = Get.context!.isPortrait
            ? const Offset(0.0, 1.0)
            : const Offset(1.0, 0.0);
        var tween = Tween(
          begin: begin,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      routeSettings: RouteSettings(arguments: Get.arguments),
    );
  }

  static void toLiveRoom(
    int? roomId, {
    bool off = false,
  }) {
    if (roomId == null) {
      return;
    }
    if (off) {
      Get.offNamed('/liveRoom', arguments: roomId);
    } else {
      Get.toNamed('/liveRoom', arguments: roomId);
    }
  }

  static void toVideoPage({
    VideoType videoType = VideoType.ugc,
    int? aid,
    String? bvid,
    required int cid,
    int? seasonId,
    int? epId,
    int? pgcType,
    String? cover,
    String? title,
    int? progress,
    Map? extraArguments,
    int? id,
    bool off = false,
  }) {
    final arguments = {
      'aid': aid ?? IdUtils.bv2av(bvid!),
      'bvid': bvid ?? IdUtils.av2bv(aid!),
      'cid': cid,
      'seasonId': ?seasonId,
      'epId': ?epId,
      'pgcType': ?pgcType,
      'cover': ?cover,
      'title': ?title,
      'progress': ?progress,
      'videoType': videoType,
      'heroTag': Utils.makeHeroTag(cid),
      ...?extraArguments,
    };
    if (off) {
      Get.offNamed(
        '/videoV',
        arguments: arguments,
        id: id,
        preventDuplicates: false,
      );
    } else {
      Get.toNamed(
        '/videoV',
        arguments: arguments,
        id: id,
        preventDuplicates: false,
      );
    }
  }

  static final _pgcRegex = RegExp(r'(ep|ss)(\d+)');
  static bool viewPgcFromUri(
    String uri, {
    bool isPgc = true,
    String? progress,
    int? aid,
  }) {
    RegExpMatch? match = _pgcRegex.firstMatch(uri);
    if (match != null) {
      bool isSeason = match.group(1) == 'ss';
      String id = match.group(2)!;
      if (isPgc) {
        viewPgc(
          seasonId: isSeason ? id : null,
          epId: isSeason ? null : id,
          progress: progress,
        );
      } else {
        viewPugv(
          seasonId: isSeason ? id : null,
          epId: isSeason ? null : id,
          aid: aid,
        );
      }
      return true;
    }
    return false;
  }

  static EpisodeItem findEpisode(
    List<EpisodeItem> episodes, {
    dynamic epId,
    bool isPgc = true,
  }) {
    // epId episode -> progress episode -> first episode
    EpisodeItem? episode;
    if (epId != null) {
      epId = epId.toString();
      episode = episodes.firstWhereOrNull(
        (item) => (isPgc ? item.epId : item.id).toString() == epId,
      );
    }
    return episode ?? episodes.first;
  }

  static Future<void> viewPgc({
    dynamic seasonId,
    dynamic epId,
    String? progress,
  }) async {
    try {
      SmartDialog.showLoading(msg: '资源获取中');
      var result = await SearchHttp.pgcInfo(seasonId: seasonId, epId: epId);
      SmartDialog.dismiss();
      if (result.isSuccess) {
        PgcInfoModel data = result.data;
        final episodes = data.episodes;
        final hasEpisode = episodes != null && episodes.isNotEmpty;

        EpisodeItem? episode;

        void viewSection(EpisodeItem episode) {
          toVideoPage(
            videoType: VideoType.ugc,
            bvid: episode.bvid!,
            cid: episode.cid!,
            seasonId: data.seasonId,
            epId: episode.epId,
            cover: episode.cover,
            progress: progress == null ? null : int.tryParse(progress),
            extraArguments: {
              'pgcApi': true,
              'pgcItem': data,
            },
          );
        }

        if (epId != null) {
          epId = epId.toString();
          if (hasEpisode) {
            episode = episodes.firstWhereOrNull(
              (item) => item.epId.toString() == epId,
            );
          }

          // find section
          if (episode == null) {
            final sections = data.section;
            if (sections != null && sections.isNotEmpty) {
              for (var section in sections) {
                final episodes = section.episodes;
                if (episodes != null && episodes.isNotEmpty) {
                  for (var episode in episodes) {
                    if (episode.epId.toString() == epId) {
                      // view as ugc
                      viewSection(episode);
                      return;
                    }
                  }
                }
              }
            }
          }
        }

        if (hasEpisode) {
          episode ??= findEpisode(
            episodes,
            epId: data.userStatus?.progress?.lastEpId,
          );
          toVideoPage(
            videoType: VideoType.pgc,
            bvid: episode.bvid!,
            cid: episode.cid!,
            seasonId: data.seasonId,
            epId: episode.epId,
            pgcType: data.type,
            cover: episode.cover,
            progress: progress == null ? null : int.tryParse(progress),
            extraArguments: {
              'pgcItem': data,
            },
          );
          return;
        } else {
          episode ??= data.section?.firstOrNull?.episodes?.firstOrNull;
          if (episode != null) {
            viewSection(episode);
            return;
          }
        }

        SmartDialog.showToast('资源加载失败');
      } else {
        result.toast();
      }
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('$e');
      if (kDebugMode) debugPrint('$e');
    }
  }

  static Future<void> viewPugv({
    dynamic seasonId,
    dynamic epId,
    int? aid,
  }) async {
    try {
      SmartDialog.showLoading(msg: '资源获取中');
      var res = await SearchHttp.pugvInfo(seasonId: seasonId, epId: epId);
      SmartDialog.dismiss();
      if (res.isSuccess) {
        PgcInfoModel data = res.data;
        final episodes = data.episodes;
        if (episodes != null && episodes.isNotEmpty) {
          EpisodeItem? episode;
          if (aid != null) {
            episode = episodes.firstWhereOrNull((e) => e.aid == aid);
          }
          episode ??= findEpisode(
            episodes,
            epId: epId ?? data.userStatus?.progress?.lastEpId,
            isPgc: false,
          );
          toVideoPage(
            videoType: VideoType.pugv,
            aid: episode.aid!,
            cid: episode.cid!,
            seasonId: data.seasonId,
            epId: episode.id,
            cover: episode.cover,
            extraArguments: {
              'pgcItem': data,
            },
          );
        } else {
          SmartDialog.showToast('资源加载失败');
        }
      } else {
        res.toast();
      }
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    }
  }

  static void toDupNamed(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
    bool off = false,
  }) {
    if (off) {
      Get.offNamed(
        page,
        arguments: arguments,
        parameters: parameters,
        preventDuplicates: false,
      );
    } else {
      Get.toNamed(
        page,
        arguments: arguments,
        parameters: parameters,
        preventDuplicates: false,
      );
    }
  }
}
