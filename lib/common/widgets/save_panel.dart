import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:PiliPlus/common/widgets/icon_button.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/bangumi/introduction/controller.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/video/detail/introduction/controller.dart';
import 'package:PiliPlus/pages/video/detail/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/download.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

class SavePanel extends StatefulWidget {
  const SavePanel({
    required this.item,
    // reply
    this.upMid,
    super.key,
  });

  final dynamic upMid;
  final dynamic item;

  @override
  State<SavePanel> createState() => _SavePanelState();

  static void toSavePanel({upMid, item}) {
    Get.generalDialog(
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SavePanel(upMid: upMid, item: item);
      },
      transitionDuration: const Duration(milliseconds: 255),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      routeSettings: RouteSettings(arguments: Get.arguments),
    );
  }
}

class _SavePanelState extends State<SavePanel> {
  final boundaryKey = GlobalKey();

  bool showBottom = true;

  // item
  dynamic get _item => widget.item;
  late String viewType = '查看';
  late String itemType = '内容';

  //reply
  String? cover;
  String? title;
  int? pubdate;
  String? uname;

  String uri = '';

  @override
  void initState() {
    super.initState();
    if (_item is ReplyInfo) {
      itemType = '评论';
      final currentRoute = Get.currentRoute;
      late final hasRoot = _item.hasRoot();

      if (currentRoute.startsWith('/video')) {
        try {
          final heroTag = Get.arguments?['heroTag'];
          late final ctr = Get.find<VideoIntroController>(tag: heroTag);
          cover = ctr.videoDetail.value.pic;
          title = ctr.videoDetail.value.title;
          pubdate = ctr.videoDetail.value.pubdate;
          uname = ctr.videoDetail.value.owner?.name;
        } catch (_) {}
        uri =
            'bilibili://video/${_item.oid}?comment_root_id=${hasRoot ? _item.root : _item.id}${hasRoot ? '&comment_secondary_id=${_item.id}' : ''}';

        try {
          final heroTag = Get.arguments?['heroTag'];
          late final ctr = Get.find<BangumiIntroController>(tag: heroTag);
          final type = _item.type.toInt();
          late final oid = _item.oid;
          late final rootId = hasRoot ? _item.root : _item.id;
          late final anchor = hasRoot ? 'anchor=${_item.id}&' : '';
          uri =
              'bilibili://comment/detail/$type/$oid/$rootId/?${anchor}enterUri=bilibili://pgc/season/ep/${ctr.epId}';
        } catch (_) {}
      } else if (currentRoute.startsWith('/dynamicDetail')) {
        try {
          DynamicItemModel dynItem = Get.arguments['item'];
          uname = dynItem.modules.moduleAuthor?.name;
          final type = _item.type.toInt();
          late final oid = dynItem.idStr;
          late final rootId = hasRoot ? _item.root : _item.id;
          late final anchor = hasRoot ? 'anchor=${_item.id}&' : '';
          late final enterUri = parseDyn(dynItem);
          viewType = '查看';
          itemType = '评论';
          uri = switch (type) {
            1 ||
            11 ||
            12 =>
              'bilibili://comment/detail/$type/${dynItem.basic!.ridStr}/$rootId/?${anchor}enterUri=$enterUri',
            _ =>
              'bilibili://comment/detail/$type/$oid/$rootId/?${anchor}enterUri=$enterUri',
          };
        } catch (_) {}
      } else if (currentRoute.startsWith('/Scaffold')) {
        try {
          final type = _item.type.toInt();
          late final oid = Get.arguments['oid'];
          late final rootId = hasRoot ? _item.root : _item.id;
          late final anchor = hasRoot ? 'anchor=${_item.id}&' : '';
          late final enterUri = 'bilibili://following/detail/$oid';
          uri = switch (type) {
            1 ||
            11 ||
            12 =>
              'bilibili://comment/detail/$type/$oid/$rootId/?${anchor}enterUri=${Get.arguments['enterUri']}',
            _ =>
              'bilibili://comment/detail/$type/$oid/$rootId/?${anchor}enterUri=$enterUri',
          };
        } catch (_) {}
      } else if (currentRoute.startsWith('/articlePage')) {
        try {
          final type = _item.type.toInt();
          late final oid = _item.oid;
          late final rootId = hasRoot ? _item.root : _item.id;
          late final anchor = hasRoot ? 'anchor=${_item.id}&' : '';
          late final enterUri =
              'bilibili://following/detail/${Get.parameters['id'] ?? Get.arguments?['id']}';
          uri =
              'bilibili://comment/detail/$type/$oid/$rootId/?${anchor}enterUri=$enterUri';
        } catch (_) {}
      }

      debugPrint(uri);
    } else if (_item is DynamicItemModel) {
      uri = parseDyn(_item);

      debugPrint(uri);
    }
  }

  String parseDyn(item) {
    String uri = '';
    try {
      switch (item.type) {
        case 'DYNAMIC_TYPE_AV':
          viewType = '观看';
          itemType = '视频';
          uri = 'bilibili://video/${item.basic!['comment_id_str']}';
          break;

        case 'DYNAMIC_TYPE_ARTICLE':
          itemType = '专栏';
          uri = 'bilibili://following/detail/${item.idStr}';
          break;

        case 'DYNAMIC_TYPE_LIVE_RCMD':
          viewType = '观看';
          itemType = '直播';
          final roomId = item.modules.moduleDynamic.major.liveRcmd.roomId;
          uri = 'bilibili://live/$roomId';
          break;

        case 'DYNAMIC_TYPE_UGC_SEASON':
          viewType = '观看';
          itemType = '合集';
          int aid = item.modules.moduleDynamic.major.ugcSeason.aid;
          uri = 'bilibili://video/$aid';
          break;

        case 'DYNAMIC_TYPE_PGC':
        case 'DYNAMIC_TYPE_PGC_UNION':
          viewType = '观看';
          itemType =
              item?.modules?.moduleDynamic?.major?.pgc?.badge?['text'] ?? '番剧';
          final epid = item.modules.moduleDynamic.major.pgc.epid;
          uri = 'bilibili://pgc/season/ep/$epid';
          break;

        // https://www.bilibili.com/medialist/detail/ml12345678
        case 'DYNAMIC_TYPE_MEDIALIST':
          itemType = '收藏夹';
          final mediaId = item.modules.moduleDynamic.major.medialist!['id'];
          uri = 'bilibili://medialist/detail/$mediaId';
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
          itemType = '动态';
          uri = 'bilibili://following/detail/${item.idStr}';
          break;
      }
    } catch (_) {}
    return uri;
  }

  void _onSaveOrSharePic([bool isShare = false]) async {
    if (!isShare) {
      if (mounted &&
          !await DownloadUtils.checkPermissionDependOnSdkInt(context)) {
        return;
      }
    }
    SmartDialog.showLoading();
    try {
      RenderRepaintBoundary boundary = boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      String picName =
          "plpl_reply_${DateTime.now().toString().substring(0, 19).replaceAll(RegExp(r'[- :]'), '')}";
      if (isShare) {
        Get.back();
        SmartDialog.dismiss();
        Share.shareXFiles(
          [
            XFile.fromData(
              pngBytes,
              name: picName,
              mimeType: 'image/png',
            )
          ],
          sharePositionOrigin: await Utils.isIpad()
              ? Rect.fromLTWH(0, 0, Get.width, Get.height / 2)
              : null,
        );
      } else {
        final result = await SaverGallery.saveImage(
          pngBytes,
          fileName: '$picName.png',
          androidRelativePath: "Pictures/PiliPlus",
          skipIfExists: false,
        );
        SmartDialog.dismiss();
        if (result.isSuccess) {
          Get.back();
          SmartDialog.showToast('保存成功');
        } else if (result.errorMessage?.isNotEmpty == true) {
          SmartDialog.showToast(result.errorMessage!);
        }
      }
    } catch (e) {
      debugPrint('on save/share reply: $e');
      SmartDialog.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Get.back,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 12, bottom: 80),
            child: SafeArea(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: min(Get.width, Get.height),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: RepaintBoundary(
                    key: boundaryKey,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedSize(
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        duration: const Duration(milliseconds: 255),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_item is ReplyInfo)
                              IgnorePointer(
                                child: ReplyItemGrpc(
                                  replyItem: _item,
                                  replyLevel: '',
                                  needDivider: false,
                                  upMid: widget.upMid,
                                ),
                              )
                            else if (_item is DynamicItemModel)
                              IgnorePointer(
                                child: DynamicPanel(
                                  item: _item,
                                  source: 'detail',
                                  isSave: true,
                                ),
                              ),
                            if (cover?.isNotEmpty == true &&
                                title?.isNotEmpty == true)
                              Container(
                                height: 81,
                                clipBehavior: Clip.hardEdge,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    NetworkImgLayer(
                                      radius: 6,
                                      src: cover!,
                                      height: MediaQuery.textScalerOf(context)
                                          .scale(65),
                                      width: MediaQuery.textScalerOf(context)
                                              .scale(65) *
                                          16 /
                                          9,
                                      quality: 100,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$title\n',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (pubdate != null) ...[
                                            const Spacer(),
                                            Text(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                      pubdate! * 1000)
                                                  .toString()
                                                  .substring(0, 19),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            showBottom
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      if (uri.isNotEmpty)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    if (uname?.isNotEmpty ==
                                                        true) ...[
                                                      Text(
                                                        '@$uname',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                    ],
                                                    Text(
                                                      '识别二维码，$viewType$itemType',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      DateTime.now()
                                                          .toString()
                                                          .split('.')
                                                          .first,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .outline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Container(
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: PrettyQrView.data(
                                                    data: uri,
                                                    decoration:
                                                        const PrettyQrDecoration(
                                                      shape:
                                                          PrettyQrRoundedSymbol(
                                                        borderRadius:
                                                            BorderRadius.zero,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset(
                                          'assets/images/logo/logo_2.png',
                                          width: 100,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                  ],
                ),
              ),
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconButton(
                      size: 42,
                      tooltip: '关闭',
                      context: context,
                      icon: Icons.clear,
                      onPressed: Get.back,
                      bgColor: Theme.of(context).colorScheme.onInverseSurface,
                      iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 40),
                    iconButton(
                        size: 42,
                        tooltip: showBottom ? '隐藏' : '显示',
                        context: context,
                        icon: showBottom
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () => setState(() {
                              showBottom = !showBottom;
                            })),
                    const SizedBox(width: 40),
                    iconButton(
                      size: 42,
                      tooltip: '分享',
                      context: context,
                      icon: Icons.share,
                      onPressed: () => _onSaveOrSharePic(true),
                    ),
                    const SizedBox(width: 40),
                    iconButton(
                      size: 42,
                      tooltip: '保存',
                      context: context,
                      icon: Icons.save_alt,
                      onPressed: _onSaveOrSharePic,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
