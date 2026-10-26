import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show FoldCard;
import 'package:PiliPlus/pages/common/reply/fold/reply_fold_mixin.dart';
import 'package:material_ui/material_ui.dart';

mixin ReplyFooterMixin<T extends StatefulWidget, R> on State<T> {
  late EdgeInsets padding;
  ColorScheme get colorScheme;
  BaseReplyFoldMixin<R> get controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    padding = MediaQuery.viewPaddingOf(context);
  }

  Widget buildFooter() {
    final fold = controller.foldCard;
    if (fold != null) return _buildFoldItem(fold);

    controller.onLoadMore();
    return _buildEndItem();
  }

  Widget _buildFoldItem(FoldCard fold) {
    return Container(
      height: 125,
      alignment: .topCenter,
      margin: .only(bottom: padding.bottom),
      child: Material(
        type: .transparency,
        child: InkWell(
          onTap: controller.loadFoldList,
          child: SizedBox(
            width: .infinity,
            child: Padding(
              padding: const .symmetric(vertical: 12),
              child: Text(
                fold.bottomText,
                textAlign: .center,
                style: TextStyle(fontSize: 12, color: colorScheme.outline),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndItem() {
    return Container(
      height: 125,
      alignment: .center,
      margin: .only(bottom: padding.bottom),
      child: Text(
        controller.isEnd ? '没有更多了' : '加载中...',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: colorScheme.outline),
      ),
    );
  }

  Widget emptyWidget() {
    return HttpError(
      errMsg: '还没有评论',
      onReload: controller.onReload,
    );
  }
}
