import 'dart:math';

import 'package:PiliPlus/common/widgets/interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:PiliPlus/grpc/im.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/bangumi/info.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/search_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/live/live_room/item.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/fav_panel/view.dart';
import 'package:PiliPlus/pages/share/view.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/menu_row.dart';
import 'package:PiliPlus/services/shutdown_timer_service.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PageUtils {
  static Future<void> pmShare(BuildContext context,
      {required Map content}) async {
    // debugPrint(content.toString());

    int? selectedIndex;
    List<UserModel> userList = <UserModel>[];

    final shareListRes = await ImGrpc.shareList(size: 3);
    if (shareListRes.isSuccess && shareListRes.data.sessionList.isNotEmpty) {
      userList.addAll(shareListRes.data.sessionList
          .map<UserModel>((item) => UserModel(
                mid: item.talkerId.toInt(),
                name: item.talkerUname,
                avatar: item.talkerIcon,
              ))
          .toList());
    } else {
      UserModel? userModel = await Get.dialog(
        const ContactPage(),
        useSafeArea: false,
        transitionDuration: const Duration(milliseconds: 120),
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

  static void scheduleExit(BuildContext context, isFullScreen,
      [bool isLive = false]) {
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
          final ThemeData theme = Theme.of(context);
          return Theme(
            data: theme,
            child: Material(
              color: Colors.transparent,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  children: [
                    const SizedBox(height: 10),
                    const Center(child: Text('定时关闭', style: titleStyle)),
                    const SizedBox(height: 10),
                    ...[
                      ...[
                        ...scheduleTimeChoices,
                        if (scheduleTimeChoices
                            .contains(
                                shutdownTimerService.scheduledExitInMinutes)
                            .not)
                          shutdownTimerService.scheduledExitInMinutes,
                      ]..sort(),
                      -1,
                    ].map(
                      (choice) => ListTile(
                        dense: true,
                        onTap: () {
                          if (choice == -1) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String duration = '';
                                return AlertDialog(
                                  title: const Text('自定义时长'),
                                  content: TextField(
                                    autofocus: true,
                                    onChanged: (value) => duration = value,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d+')),
                                    ],
                                    decoration: const InputDecoration(
                                        suffixText: 'min'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: Get.back,
                                      child: Text(
                                        '取消',
                                        style: TextStyle(
                                            color: theme.colorScheme.outline),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        int choice =
                                            int.tryParse(duration) ?? 0;
                                        shutdownTimerService
                                            .scheduledExitInMinutes = choice;
                                        shutdownTimerService
                                            .startShutdownTimer();
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
                            shutdownTimerService.scheduledExitInMinutes =
                                choice;
                            shutdownTimerService.startShutdownTimer();
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text(choice == -1
                            ? '自定义'
                            : choice == 0
                                ? "禁用"
                                : "$choice分钟后"),
                        trailing: shutdownTimerService.scheduledExitInMinutes ==
                                choice
                            ? Icon(
                                Icons.done,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: SizedBox(
                        width: 125,
                        child: Divider(height: 1),
                      ),
                    ),
                    if (isLive.not) ...[
                      const SizedBox(height: 10),
                      ListTile(
                        dense: true,
                        onTap: () {
                          shutdownTimerService.waitForPlayingCompleted =
                              !shutdownTimerService.waitForPlayingCompleted;
                          setState(() {});
                        },
                        contentPadding: EdgeInsets.zero,
                        title: const Text("额外等待视频播放完毕", style: titleStyle),
                        trailing: Transform.scale(
                          alignment: Alignment.centerRight,
                          scale: 0.8,
                          child: Switch(
                            thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                                (Set<WidgetState> states) {
                              if (states.isNotEmpty &&
                                  states.first == WidgetState.selected) {
                                return const Icon(Icons.done);
                              }
                              return null;
                            }),
                            value: shutdownTimerService.waitForPlayingCompleted,
                            onChanged: (value) => setState(() =>
                                shutdownTimerService.waitForPlayingCompleted =
                                    value),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('倒计时结束:', style: titleStyle),
                        const Spacer(),
                        ActionRowLineItem(
                          onTap: () {
                            shutdownTimerService.exitApp = false;
                            setState(() {});
                          },
                          text: " 暂停视频 ",
                          selectStatus: !shutdownTimerService.exitApp,
                        ),
                        const Spacer(),
                        ActionRowLineItem(
                          onTap: () {
                            shutdownTimerService.exitApp = true;
                            setState(() {});
                          },
                          text: " 退出APP ",
                          selectStatus: shutdownTimerService.exitApp,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
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
    dynamic res = await DynamicsHttp.dynamicDetail(
      id: id,
      rid: rid,
      type: rid != null ? 2 : null,
    );
    SmartDialog.dismiss();
    if (res['status']) {
      DynamicItemModel data = res['data'];
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
            'item': res['data'],
            'floor': 1,
            'action': 'detail',
          },
          off: off,
        );
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  static void showFavBottomSheet({
    required BuildContext context,
    required dynamic ctr,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.ease),
      constraints: BoxConstraints(
        maxWidth: min(640, min(Get.width, Get.height)),
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

  static void enterPip(Floating floating, int width, int height) {
    Rational aspectRatio = Rational(width, height);
    floating.enable(
      EnableManual(
        aspectRatio: aspectRatio.fitsInAndroidRequirements
            ? aspectRatio
            : height > width
                ? const Rational.vertical()
                : const Rational.landscape(),
      ),
    );
  }

  static Future<void> pushDynDetail(DynamicItemModel item, floor,
      {action = 'all'}) async {
    feedBack();

    /// 点击评论action 直接查看评论
    if (action == 'comment') {
      toDupNamed(
        '/dynamicDetail',
        arguments: {
          'item': item,
          'floor': floor,
          'action': action,
        },
      );
      return;
    }

    debugPrint('pushDynDetail: ${item.type}');

    switch (item.type) {
      case 'DYNAMIC_TYPE_AV':
        if (item.modules.moduleDynamic?.major?.archive?.type == 2) {
          if (item.modules.moduleDynamic!.major!.archive!.jumpUrl!
              .startsWith('//')) {
            item.modules.moduleDynamic!.major!.archive!.jumpUrl =
                'https:${item.modules.moduleDynamic!.major!.archive!.jumpUrl!}';
          }
          String? redirectUrl = await UrlUtils.parseRedirectUrl(
              item.modules.moduleDynamic!.major!.archive!.jumpUrl!, false);
          if (redirectUrl != null) {
            viewPgcFromUri(redirectUrl);
            return;
          }
        }

        try {
          String bvid = item.modules.moduleDynamic!.major!.archive!.bvid!;
          String cover = item.modules.moduleDynamic!.major!.archive!.cover!;
          int cid = await SearchHttp.ab2c(bvid: bvid);
          toVideoPage(
            'bvid=$bvid&cid=$cid',
            arguments: {
              'pic': cover,
              'heroTag': Utils.makeHeroTag(bvid),
            },
            preventDuplicates: false,
          );
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;

      /// 专栏文章查看
      case 'DYNAMIC_TYPE_ARTICLE':
        String? url = item.modules.moduleDynamic?.major?.opus?.jumpUrl;
        if (url != null) {
          if (url.contains('opus') || url.contains('read')) {
            RegExp digitRegExp = RegExp(r'\d+');
            Iterable<Match> matches = digitRegExp.allMatches(url);
            String number = matches.first.group(0)!;
            toDupNamed(
              '/articlePage',
              parameters: {
                'id': number,
                'type': url.split('//').last.split('/')[1],
              },
            );
          } else {
            handleWebview('https:$url');
          }
        }

        break;
      case 'DYNAMIC_TYPE_PGC':
        debugPrint('番剧');
        SmartDialog.showToast('暂未支持的类型，请联系开发者');
        break;

      case 'DYNAMIC_TYPE_LIVE_RCMD':
        DynamicLiveModel liveRcmd =
            item.modules.moduleDynamic!.major!.liveRcmd!;
        ModuleAuthorModel author = item.modules.moduleAuthor!;
        LiveItemModel liveItem = LiveItemModel.fromJson({
          'title': liveRcmd.title,
          'uname': author.name,
          'cover': liveRcmd.cover,
          'mid': author.mid,
          'face': author.face,
          'roomid': liveRcmd.roomId,
          'watched_show': liveRcmd.watchedShow,
        });
        toDupNamed('/liveRoom?roomid=${liveItem.roomId}');
        break;

      /// 合集查看
      case 'DYNAMIC_TYPE_UGC_SEASON':
        DynamicArchiveModel ugcSeason =
            item.modules.moduleDynamic!.major!.ugcSeason!;
        int aid = ugcSeason.aid!;
        String bvid = IdUtils.av2bv(aid);
        String cover = ugcSeason.cover!;
        int cid = await SearchHttp.ab2c(bvid: bvid);
        toVideoPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            'pic': cover,
            'heroTag': Utils.makeHeroTag(bvid),
          },
          preventDuplicates: false,
        );
        break;

      /// 番剧查看
      case 'DYNAMIC_TYPE_PGC_UNION':
        debugPrint('DYNAMIC_TYPE_PGC_UNION 番剧');
        DynamicArchiveModel pgc = item.modules.moduleDynamic!.major!.pgc!;
        if (pgc.epid != null) {
          viewBangumi(epId: pgc.epid);
        }
        break;
      case 'DYNAMIC_TYPE_MEDIALIST':
        if (item.modules.moduleDynamic?.major?.medialist != null) {
          final String? url =
              item.modules.moduleDynamic!.major!.medialist!['jump_url'];
          if (url?.contains('medialist/detail/ml') == true) {
            Get.toNamed(
              '/favDetail',
              parameters: {
                'heroTag':
                    '${item.modules.moduleDynamic!.major!.medialist!['cover']}',
                'mediaId':
                    '${item.modules.moduleDynamic!.major!.medialist!['id']}',
              },
            );
          } else if (url != null) {
            handleWebview(url.http2https);
          }
        }
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
        toDupNamed(
          '/dynamicDetail',
          arguments: {
            'item': item,
            'floor': floor,
          },
        );
        break;
    }
  }

  static void onHorizontalPreview(
    GlobalKey<ScaffoldState> key,
    transitionAnimationController,
    ctr,
    List<String> imgList,
    index,
    onClose,
  ) {
    key.currentState?.showBottomSheet(
      (context) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(ctr),
          child: InteractiveviewerGallery(
            sources: imgList.map((url) => SourceModel(url: url)).toList(),
            initIndex: index,
            setStatusBar: false,
            onClose: onClose,
          ),
        );
      },
      enableDrag: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      transitionAnimationController: transitionAnimationController,
      sheetAnimationStyle: AnimationStyle(duration: Duration.zero),
    );
  }

  static void inAppWebview(
    String url, {
    bool off = false,
  }) {
    if (GStorage.openInBrowser) {
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
    if (inApp.not && GStorage.openInBrowser) {
      if ((await PiliScheme.routePushFromUrl(url, selfHandle: true)).not) {
        launchURL(url);
      }
    } else {
      if (off) {
        Get.offNamed(
          '/webview',
          parameters: {
            'url': url,
            if (parameters != null) ...parameters,
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
        return MediaQuery.orientationOf(Get.context!) == Orientation.portrait
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
        Offset begin =
            MediaQuery.orientationOf(Get.context!) == Orientation.portrait
                ? const Offset(0.0, 1.0)
                : const Offset(1.0, 0.0);
        var tween = Tween(begin: begin, end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      routeSettings: RouteSettings(arguments: Get.arguments),
    );
  }

  static void toVideoPage(
    String page, {
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool off = false,
  }) {
    if (off) {
      Get.offNamed(
        '/videoV?$page',
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
      );
    } else {
      Get.toNamed(
        '/videoV?$page',
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
      );
    }
  }

  static bool viewPgcFromUri(String uri) {
    String? id = RegExp(r'(ep|ss)\d+').firstMatch(uri)?.group(0);
    if (id != null) {
      bool isSeason = id.startsWith('ss');
      id = id.substring(2);
      viewBangumi(
        seasonId: isSeason ? id : null,
        epId: isSeason ? null : id,
      );
      return true;
    }
    return false;
  }

  static Future<void> viewBangumi(
      {dynamic seasonId, dynamic epId, dynamic progress}) async {
    try {
      SmartDialog.showLoading(msg: '资源获取中');
      var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: epId);
      SmartDialog.dismiss();
      if (result['status']) {
        BangumiInfoModel data = result['data'];

        // epId episode -> progress episode -> first episode
        EpisodeItem? episode;

        if (epId != null) {
          if (data.episodes?.isNotEmpty == true) {
            episode = data.episodes!.firstWhereOrNull(
              (item) {
                return item.epId.toString() == epId.toString();
              },
            );
          }
          if (episode == null && data.section?.isNotEmpty == true) {
            for (Section item in data.section!) {
              if (item.episodes?.isNotEmpty == true) {
                for (EpisodeItem item in item.episodes!) {
                  if (item.epId.toString() == epId.toString()) {
                    // view as normal video
                    toVideoPage(
                      'bvid=${item.bvid}&cid=${item.cid}&seasonId=${data.seasonId}&epId=${item.epId}',
                      arguments: {
                        'pgcApi': true,
                        'pic': item.cover,
                        'heroTag': Utils.makeHeroTag(item.cid),
                        'videoType': SearchType.video,
                        if (progress != null) 'progress': int.tryParse(progress)
                      },
                      preventDuplicates: false,
                    );
                    return;
                  }
                }
              }
            }
          }
        }

        if (data.episodes.isNullOrEmpty) {
          SmartDialog.showToast('资源加载失败');
          return;
        }

        episode ??= data.userStatus?.progress?.lastEpId != null
            ? data.episodes!.firstWhereOrNull(
                  (item) => item.epId == data.userStatus?.progress?.lastEpId,
                ) ??
                data.episodes!.first
            : data.episodes!.first;
        toVideoPage(
          'bvid=${episode.bvid}&cid=${episode.cid}&seasonId=${data.seasonId}&epId=${episode.epId}&type=${data.type}',
          arguments: {
            'pic': episode.cover,
            'heroTag': Utils.makeHeroTag(episode.cid),
            'videoType': SearchType.media_bangumi,
            'bangumiItem': data,
            if (progress != null) 'progress': int.tryParse(progress)
          },
          preventDuplicates: false,
        );
      } else {
        SmartDialog.showToast(result['msg']);
      }
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('$e');
      debugPrint('$e');
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
