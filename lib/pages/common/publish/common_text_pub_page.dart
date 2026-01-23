import 'package:PiliPlus/pages/common/publish/common_publish_page.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';

abstract class CommonTextPubPage extends CommonPublishPage<String> {
  const CommonTextPubPage({
    super.key,
    super.initialValue,
    super.onSave,
  });
}

abstract class CommonTextPubPageState<T extends CommonTextPubPage>
    extends CommonPublishPageState<T> {
  @override
  late final TextEditingController editController = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void initPubState() {
    if (widget.initialValue?.trim().isNotEmpty == true) {
      enablePublish.value = true;
    }
  }

  @override
  void onSave() => widget.onSave?.call(editController.text);

  @override
  Future<void> onPublish() {
    feedBack();
    return onCustomPublish();
  }
}
