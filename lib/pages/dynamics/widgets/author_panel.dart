import 'dart:math';

import 'package:PiliPlus/common/widgets/report.dart';
import 'package:PiliPlus/common/widgets/save_panel.dart';
import 'package:PiliPlus/http/index.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/utils.dart';

import '../../../http/constants.dart';
import '../controller.dart';

class AuthorPanel extends StatelessWidget {
  final dynamic item;
  final Function? addBannedList;
  final String? source;
  final Function? onRemove;
  final bool isSave;

  const AuthorPanel({
    super.key,
    required this.item,
    this.addBannedList,
    this.source,
    this.onRemove,
    this.isSave = false,
  });

  Widget _buildAvatar(double size) => NetworkImgLayer(
        width: size,
        height: size,
        type: 'avatar',
        src: item.modules.moduleAuthor.face,
      );

  @override
  Widget build(BuildContext context) {
    String? pubTime = item.modules.moduleAuthor.pubTs != null
        ? isSave
            ? DateTime.fromMillisecondsSinceEpoch(
                    item.modules.moduleAuthor.pubTs * 1000)
                .toString()
                .substring(0, 19)
            : Utils.dateFormat(item.modules.moduleAuthor.pubTs)
        : item.modules.moduleAuthor.pubTime;
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // 番剧
                  if (item.modules.moduleAuthor.type == 'AUTHOR_TYPE_PGC' ||
                      item.modules.moduleAuthor.type ==
                          'AUTHOR_TYPE_UGC_SEASON') {
                    return;
                  }
                  feedBack();
                  Get.toNamed(
                    '/member?mid=${item.modules.moduleAuthor.mid}',
                    arguments: {
                      'face': item.modules.moduleAuthor.face,
                    },
                  );
                },
                child: (item.modules.moduleAuthor?.pendant?['image'] as String?)
                            ?.isNotEmpty ==
                        true
                    ? Padding(
                        padding: const EdgeInsets.all(3),
                        child: _buildAvatar(34),
                      )
                    : _buildAvatar(40),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.modules.moduleAuthor.name,
                    // semanticsLabel: "UP主：${item.modules.moduleAuthor.name}",
                    style: TextStyle(
                      color: item.modules.moduleAuthor!.vip != null &&
                              item.modules.moduleAuthor!.vip['status'] > 0 &&
                              item.modules.moduleAuthor!.vip['type'] == 2
                          ? context.vipColor
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                    ),
                  ),
                  if (pubTime != null)
                    Text(
                      '$pubTime${item.modules.moduleAuthor.pubAction != null ? ' ${item.modules.moduleAuthor.pubAction}' : ''}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: source != 'detail' && item.modules?.moduleTag?.text != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                          width: 1.25,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        item.modules.moduleTag.text,
                        style: TextStyle(
                          height: 1,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        strutStyle: const StrutStyle(
                          leading: 0,
                          height: 1,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _moreWidget(context),
                  ],
                )
              : item.modules.moduleAuthor.decorate != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // GestureDetector(
                        //   onTap:
                        //       item.modules.moduleAuthor.decorate['jump_url'] != null
                        //           ? () {
                        //               Get.toNamed(
                        //                 '/webview',
                        //                 parameters: {
                        //                   'url':
                        //                       '${item.modules.moduleAuthor.decorate['jump_url']}'
                        //                 },
                        //               );
                        //             }
                        //           : null,
                        //   child:
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.centerRight,
                          children: [
                            CachedNetworkImage(
                              height: 32,
                              imageUrl: item
                                  .modules.moduleAuthor.decorate['card_url'],
                            ),
                            if ((item.modules.moduleAuthor.decorate?['fan']
                                        ?['num_str'] as String?)
                                    ?.isNotEmpty ==
                                true)
                              Padding(
                                padding: const EdgeInsets.only(right: 32),
                                child: Text(
                                  '${item.modules.moduleAuthor.decorate['fan']['num_str']}',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 11,
                                    fontFamily: 'digital_id_num',
                                    color: (item.modules.moduleAuthor
                                                        .decorate?['fan']
                                                    ?['color'] as String?)
                                                ?.startsWith('#') ==
                                            true
                                        ? Color(
                                            int.parse(
                                              item.modules.moduleAuthor
                                                  .decorate['fan']['color']
                                                  .replaceFirst('#', '0xFF'),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // ),
                        _moreWidget(context),
                      ],
                    )
                  : _moreWidget(context),
        )
      ],
    );
  }

  Widget _moreWidget(BuildContext context) => isSave
      ? const SizedBox.shrink()
      : SizedBox(
          width: 32,
          height: 32,
          child: IconButton(
            tooltip: '更多',
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxWidth: min(640, min(Get.width, Get.height)),
                ),
                builder: (context) {
                  return morePanel(context);
                },
              );
            },
            icon: const Icon(Icons.more_vert_outlined, size: 18),
          ),
        );

  Widget morePanel(context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          if (item.type == 'DYNAMIC_TYPE_AV')
            ListTile(
              onTap: () async {
                try {
                  String bvid = item.modules.moduleDynamic.major.archive.bvid;
                  var res = await UserHttp.toViewLater(bvid: bvid);
                  SmartDialog.showToast(res['msg']);
                  Get.back();
                } catch (err) {
                  SmartDialog.showToast('出错了：${err.toString()}');
                }
              },
              minLeadingWidth: 0,
              // dense: true,
              leading: const Icon(Icons.watch_later_outlined, size: 19),
              title: Text(
                '稍后再看',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ListTile(
            title: Text(
              '分享动态',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            leading: const Icon(Icons.share_outlined, size: 19),
            onTap: () {
              Get.back();
              Utils.shareText(
                  '${HttpString.dynamicShareBaseUrl}/${item.idStr}');
            },
            minLeadingWidth: 0,
          ),
          ListTile(
            title: Text(
              '临时屏蔽：${item.modules.moduleAuthor.name}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            leading: const Icon(Icons.visibility_off_outlined, size: 19),
            onTap: () {
              Get.back();
              DynamicsController dynamicsController =
                  Get.find<DynamicsController>();
              dynamicsController.tempBannedList
                  .add(item.modules.moduleAuthor.mid);
              SmartDialog.showToast(
                  '已临时屏蔽${item.modules.moduleAuthor.name}(${item.modules.moduleAuthor.mid})，重启恢复');
            },
            minLeadingWidth: 0,
          ),
          ListTile(
            onTap: () {
              Get.back();
              SavePanel.toSavePanel(item: item);
            },
            minLeadingWidth: 0,
            leading: const Icon(Icons.save_alt, size: 19),
            title: Text('保存动态', style: Theme.of(context).textTheme.titleSmall!),
          ),
          if (item.modules.moduleAuthor.mid == Accounts.main.mid) ...[
            ListTile(
              onTap: () {
                Get.back();
                Utils.checkCreatedDyn(id: item.idStr, isManual: true);
              },
              minLeadingWidth: 0,
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 19),
                  const Icon(Icons.published_with_changes_sharp, size: 12),
                ],
              ),
              title:
                  Text('检查动态', style: Theme.of(context).textTheme.titleSmall!),
            ),
            if (onRemove != null)
              ListTile(
                onTap: () {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('确定删除该动态?'),
                      actions: [
                        TextButton(
                          onPressed: Get.back,
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            onRemove?.call(item.idStr);
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                },
                minLeadingWidth: 0,
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error, size: 19),
                title: Text('删除',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).colorScheme.error)),
              ),
          ],
          if (Accounts.main.isLogin)
            ListTile(
              title: Text(
                '举报',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              leading: Icon(
                Icons.error_outline_outlined,
                size: 19,
                color: Theme.of(context).colorScheme.error,
              ),
              onTap: () {
                Get.back();
                autoWrapReportDialog(
                  context,
                  ReportOptions.dynamicReport,
                  (reasonType, reasonDesc, banUid) async {
                    if (banUid) {
                      VideoHttp.relationMod(
                        mid: item.modules.moduleAuthor.mid,
                        act: 5,
                        reSrc: 11,
                      );
                    }
                    final res = await Request().post(
                      '/x/dynamic/feed/dynamic_report/add',
                      queryParameters: {
                        'csrf': await Request.getCsrf(),
                      },
                      data: {
                        "accused_uid": item.modules.moduleAuthor.mid,
                        "dynamic_id": item.idStr,
                        "reason_type": reasonType,
                        "reason_desc": reasonType == 0 ? reasonDesc : null,
                      },
                      options: Options(
                        contentType: Headers.formUrlEncodedContentType,
                      ),
                    );
                    return res.data as Map;
                  },
                );
              },
              minLeadingWidth: 0,
            ),
          const Divider(thickness: 0.1, height: 1),
          ListTile(
            onTap: Get.back,
            minLeadingWidth: 0,
            dense: true,
            title: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
