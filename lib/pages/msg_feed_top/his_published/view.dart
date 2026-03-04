import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/comment_record.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/msg_feed_top/his_published/controller.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/date_utils.dart' show DateFormatUtils;
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class HisPublishedPage extends StatefulWidget {
  const HisPublishedPage({super.key});

  @override
  State<HisPublishedPage> createState() => _HisPublishedPageState();
}

class _HisPublishedPageState extends State<HisPublishedPage> {
  final _controller = Get.put(HisPublishedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的评论')),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
              ),
              sliver: Obx(() => _buildBody(_controller.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<CommentRecord>?> loadingState) {
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      Error() => HttpError(
        onReload: _controller.onReload,
        errMsg: loadingState.errMsg,
      ),
      Success(:final response) =>
        response == null || response.isEmpty
            ? HttpError(
                onReload: _controller.onReload,
                errMsg: '暂无评论记录',
              )
            : SliverList.separated(
                itemCount: response.length,
                itemBuilder: (context, index) {
                  final record = response[index];
                  final hasPictures = record.pictures?.isNotEmpty == true;
                  return ListTile(
                    onTap: () {
                      if (record.rpid != null) {
                        Uri? uri;
                        switch (record.type) {
                          case 1: // 视频评论
                            final bvid = IdUtils.av2bv(record.oid);
                            uri = Uri.parse('bilibili://video/$bvid');
                            break;
                          case 17: // 动态评论
                            uri = Uri.parse(
                              'bilibili://following/detail/${record.oid}',
                            );
                            break;
                        }

                        final isSecondLevel =
                            record.root != null && record.root != 0;
                        VideoReplyReplyPanel.toReply(
                          oid: record.oid,
                          rootId: isSecondLevel ? record.root! : record.rpid!,
                          rpIdStr: isSecondLevel
                              ? record.rpid.toString()
                              : null,
                          type: record.type,
                          uri: uri,
                        );
                      }
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('删除评论记录'),
                        content: const Text('确定要删除这条记录吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _controller.onRemove(index);
                            },
                            child: const Text('删除'),
                          ),
                        ],
                      ),
                    ),
                    leading: record.senderFace != null
                        ? NetworkImgLayer(
                            width: 40,
                            height: 40,
                            type: ImageType.avatar,
                            src: record.senderFace,
                          )
                        : const Icon(Icons.comment_outlined),
                    title: Text(
                      record.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormatUtils.dateFormat(
                            record.timestamp.millisecondsSinceEpoch ~/ 1000,
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (hasPictures) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: record.pictures!.map((pic) {
                              final imgUrl = pic['img_src'] ?? '';
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: NetworkImgLayer(
                                  width: 60,
                                  height: 60,
                                  src: imgUrl,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => Divider(
                  indent: 72,
                  endIndent: 20,
                  height: 6,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
    };
  }
}
