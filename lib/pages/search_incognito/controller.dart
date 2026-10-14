import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 隐身搜索控制器：搜索历史与普通搜索完全隔离存储。
class SearchIncognitoController extends GetxController {
  static const String _historyKey = 'incognitoCacheList';

  final historyList = List<String>.from(
    GStorage.historyWord.get(_historyKey) ?? const <String>[],
  ).obs;

  final textController = TextEditingController();
  final searchFocusNode = FocusNode();

  void onSubmitted(String text) {
    text = text.trim();
    if (text.isEmpty) return;
    // 单独存储隐身搜索历史
    final index = historyList.indexOf(text);
    if (index != -1) historyList.removeAt(index);
    historyList.insert(0, text);
    if (historyList.length > 20) {
      historyList.removeRange(20, historyList.length);
    }
    GStorage.historyWord.put(_historyKey, historyList);
    searchFocusNode.unfocus();
    // 跳转搜索结果页，带上隐身标记
    Get.toNamed(
      '/searchResult',
      parameters: {'keyword': text, 'incognito': '1'},
    );
  }

  void onClearHistory() {
    historyList.clear();
    GStorage.historyWord.delete(_historyKey);
  }

  void onDeleteOne(String text) {
    historyList.remove(text);
    GStorage.historyWord.put(_historyKey, historyList);
  }

  @override
  void onClose() {
    textController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
