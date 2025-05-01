import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../http/user.dart';
import '../../http/video.dart';
import '../../models/home/rcmd/result.dart';
import '../../pages/mine/controller.dart';
import '../../utils/storage.dart';
import 'package:PiliPlus/models/space_archive/item.dart';

class VideoCustomAction {
  String title;
  String value;
  Widget icon;
  VoidCallback? onTap;
  VideoCustomAction(this.title, this.value, this.icon, this.onTap);
}

class VideoCustomActions {
  BaseSimpleVideoItemModel videoItem;
  BuildContext context;
  late List<VideoCustomAction> actions;
  VoidCallback? onRemove;

  VideoCustomActions(this.videoItem, this.context, [this.onRemove]) {
    actions = [
      if (videoItem.bvid?.isNotEmpty == true) ...[
        VideoCustomAction(
          videoItem.bvid!,
          'copy',
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(MdiIcons.identifier, size: 16),
              Icon(MdiIcons.circleOutline, size: 16),
            ],
          ),
          () {
            Utils.copyText(videoItem.bvid!);
          },
        ),
        VideoCustomAction(
          '稍后再看',
          'pause',
          Icon(MdiIcons.clockTimeEightOutline, size: 16),
          () async {
            var res = await UserHttp.toViewLater(bvid: videoItem.bvid);
            SmartDialog.showToast(res['msg']);
          },
        ),
      ],
      if (videoItem is! Item)
        VideoCustomAction(
          '访问：${videoItem.owner.name}',
          'visit',
          Icon(MdiIcons.accountCircleOutline, size: 16),
          () async {
            Get.toNamed('/member?mid=${videoItem.owner.mid}', arguments: {
              'heroTag': '${videoItem.owner.mid}',
            });
          },
        ),
      if (videoItem is! Item)
        VideoCustomAction(
            '不感兴趣', 'dislike', Icon(MdiIcons.thumbDownOutline, size: 16),
            () async {
          String? accessKey = Accounts.get(AccountType.recommend).accessKey;
          if (accessKey == null || accessKey == "") {
            SmartDialog.showToast("请退出账号后重新登录");
            return;
          }
          if (videoItem is RecVideoItemAppModel) {
            RecVideoItemAppModel v = videoItem as RecVideoItemAppModel;
            ThreePoint? tp = v.threePoint;
            if (tp == null) {
              SmartDialog.showToast("未能获取threePoint");
              return;
            }
            if (tp.dislikeReasons == null && tp.feedbacks == null) {
              SmartDialog.showToast("未能获取dislikeReasons或feedbacks");
              return;
            }
            Widget actionButton(Reason? r, Reason? f) {
              return SearchText(
                text: r?.name ?? f?.name ?? '未知',
                onTap: (_) async {
                  Get.back();
                  SmartDialog.showLoading(msg: '正在提交');
                  var res = await VideoHttp.feedDislike(
                    reasonId: r?.id,
                    feedbackId: f?.id,
                    id: v.param!,
                    goto: v.goto!,
                  );
                  SmartDialog.dismiss();
                  SmartDialog.showToast(
                    res['status'] ? (r?.toast ?? f?.toast) : res['msg'],
                  );
                  if (res['status']) {
                    onRemove?.call();
                  }
                },
              );
            }

            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tp.dislikeReasons != null) ...[
                          Text('我不想看'),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: tp.dislikeReasons!.map((item) {
                              return actionButton(item, null);
                            }).toList(),
                          ),
                        ],
                        if (tp.feedbacks != null) ...[
                          const SizedBox(height: 5),
                          Text('反馈'),
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: tp.feedbacks!.map((item) {
                              return actionButton(null, item);
                            }).toList(),
                          ),
                        ],
                        const Divider(),
                        Center(
                          child: FilledButton.tonal(
                            onPressed: () async {
                              SmartDialog.showLoading(msg: '正在提交');
                              var res = await VideoHttp.feedDislikeCancel(
                                id: v.param!,
                                goto: v.goto!,
                              );
                              SmartDialog.dismiss();
                              SmartDialog.showToast(
                                  res['status'] ? "成功" : res['msg']);
                              Get.back();
                            },
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity(
                                horizontal: -2,
                                vertical: -2,
                              ),
                            ),
                            child: const Text("撤销"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        const Text("web端暂不支持精细选择"),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 2.0,
                          children: [
                            FilledButton.tonal(
                              onPressed: () async {
                                Get.back();
                                SmartDialog.showLoading(msg: '正在提交');
                                var res = await VideoHttp.dislikeVideo(
                                    bvid: videoItem.bvid as String, type: true);
                                SmartDialog.dismiss();
                                SmartDialog.showToast(
                                  res['status'] ? "点踩成功" : res['msg'],
                                );
                                if (res['status']) {
                                  onRemove?.call();
                                }
                              },
                              style: FilledButton.styleFrom(
                                visualDensity: VisualDensity(
                                  horizontal: -2,
                                  vertical: -2,
                                ),
                              ),
                              child: const Text("点踩"),
                            ),
                            FilledButton.tonal(
                              onPressed: () async {
                                Get.back();
                                SmartDialog.showLoading(msg: '正在提交');
                                var res = await VideoHttp.dislikeVideo(
                                    bvid: videoItem.bvid as String,
                                    type: false);
                                SmartDialog.dismiss();
                                SmartDialog.showToast(
                                    res['status'] ? "取消踩" : res['msg']);
                              },
                              style: FilledButton.styleFrom(
                                visualDensity: VisualDensity(
                                  horizontal: -2,
                                  vertical: -2,
                                ),
                              ),
                              child: const Text("撤销"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
      if (videoItem is! Item)
        VideoCustomAction('拉黑：${videoItem.owner.name}', 'block',
            Icon(MdiIcons.cancel, size: 16), () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('提示'),
                content:
                    Text('确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
                        '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      '点错了',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var res = await VideoHttp.relationMod(
                        mid: videoItem.owner.mid!,
                        act: 5,
                        reSrc: 11,
                      );
                      GStorage.setBlackMid(videoItem.owner.mid!);
                      Get.back();
                      SmartDialog.showToast(res['msg'] ?? '成功');
                    },
                    child: const Text('确认'),
                  )
                ],
              );
            },
          );
        }),
      VideoCustomAction(
          "${MineController.anonymity.value ? '退出' : '进入'}无痕模式",
          'anonymity',
          Icon(
            MineController.anonymity.value
                ? MdiIcons.incognitoOff
                : MdiIcons.incognito,
            size: 16,
          ),
          () => MineController.onChangeAnonymity(context))
    ];
  }
}

class VideoPopupMenu extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final double menuItemHeight = 45;
  final dynamic videoItem;
  final VoidCallback? onRemove;

  const VideoPopupMenu({
    super.key,
    required this.size,
    required this.iconSize,
    required this.videoItem,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
        child: SizedBox(
      width: size,
      height: size,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: iconSize,
        ),
        position: PopupMenuPosition.under,
        onSelected: (String type) {},
        itemBuilder: (BuildContext context) =>
            VideoCustomActions(videoItem, context, onRemove).actions.map((e) {
          return PopupMenuItem<String>(
            value: e.value,
            height: menuItemHeight,
            onTap: e.onTap,
            child: Row(
              children: [
                e.icon,
                const SizedBox(width: 6),
                Text(e.title, style: const TextStyle(fontSize: 13))
              ],
            ),
          );
        }).toList(),
      ),
    ));
  }
}
