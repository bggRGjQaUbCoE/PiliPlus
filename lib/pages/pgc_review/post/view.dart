import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PgcReviewPostPanel extends StatefulWidget {
  const PgcReviewPostPanel({
    super.key,
    required this.name,
    required this.mediaId,
    this.reviewId,
    this.score,
    this.content,
  });

  final String name;
  final dynamic mediaId;
  // modify
  final dynamic reviewId;
  final int? score;
  final String? content;

  @override
  State<PgcReviewPostPanel> createState() => _PgcReviewPostPanelState();
}

class _PgcReviewPostPanelState extends State<PgcReviewPostPanel> {
  late final _controller = TextEditingController(text: widget.content);
  late final RxInt _score = (widget.score ?? 0).obs;
  late final RxBool _shareFeed = false.obs;
  late final RxBool _enablePost = _isMod.obs;
  late final _isMod = widget.reviewId != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScore(double dx) {
    int index = (dx / 50).toInt().clamp(0, 4);
    _enablePost.value = true;
    _score.value = index + 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            toolbarHeight: 45,
            title: Text(widget.name),
            actions: [
              iconButton(
                context: context,
                icon: Icons.clear,
                onPressed: Get.back,
                iconSize: 22,
                bgColor: Colors.transparent,
              ),
              const SizedBox(width: 12),
            ],
            shape: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) =>
                  _onScore(details.localPosition.dx),
              onTapDown: (details) => _onScore(details.localPosition.dx),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) {
                    return Obx(
                      () => index <= _score.value - 1
                          ? const Icon(
                              CustomIcons.star_favorite_solid,
                              size: 50,
                              color: Color(0xFFFFAD35),
                            )
                          : const Icon(
                              CustomIcons.star_favorite_line,
                              size: 50,
                              color: Colors.grey,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Obx(
            () {
              final score = _score.value;
              return Text(
                switch (score) {
                  1 => '很差',
                  2 => '较差',
                  3 => '还行',
                  4 => '很好',
                  5 => '佳作',
                  _ => '轻触评分',
                },
                style: TextStyle(
                  fontSize: 16,
                  color: score == 0
                      ? theme.colorScheme.outline
                      : const Color(0xFFFFAD35),
                ),
              );
            },
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              maxLength: 100,
              minLines: 5,
              maxLines: 5,
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
        if (!_isMod)
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _shareFeed.value = !_shareFeed.value,
              child: Obx(
                () {
                  final shareFeed = _shareFeed.value;
                  Color color = shareFeed
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        size: 22,
                        shareFeed
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: color,
                      ),
                      Text(
                        ' 分享到动态',
                        style: TextStyle(color: color),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 6,
            bottom:
                MediaQuery.paddingOf(context).bottom +
                MediaQuery.viewInsetsOf(context).bottom +
                6,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.onInverseSurface,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Obx(
            () => FilledButton.tonal(
              style: FilledButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
              onPressed: _enablePost.value ? _onPost : null,
              child: _isMod ? const Text('编辑') : const Text('发布'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onPost() async {
    if (_isMod) {
      var res = await PgcHttp.pgcReviewMod(
        mediaId: widget.mediaId,
        score: _score.value * 2,
        content: _controller.text,
        reviewId: widget.reviewId,
      );
      if (res['status']) {
        Get.back();
        SmartDialog.showToast('编辑成功');
      } else {
        SmartDialog.showToast(res['msg']);
      }
      return;
    }
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var res = await PgcHttp.pgcReviewPost(
      mediaId: widget.mediaId,
      score: _score.value * 2,
      content: _controller.text,
      shareFeed: _isMod ? false : _shareFeed.value,
    );
    if (res['status']) {
      Get.back();
      SmartDialog.showToast('点评成功');
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
