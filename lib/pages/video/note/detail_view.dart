import 'package:PiliPlus/pages/webview/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoNoteDetailPage extends StatelessWidget {
  const VideoNoteDetailPage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: AppBar(
              primary: false,
              automaticallyImplyLeading: false,
              titleSpacing: 16,
              toolbarHeight: 45,
              backgroundColor: Colors.transparent,
              title: const Text('完整笔记'),
              shape: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: '关闭',
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: Get.back,
                ),
                const SizedBox(width: 2),
              ],
            ),
          ),
          Expanded(child: WebviewPage(url: url)),
        ],
      ),
    );
  }
}
