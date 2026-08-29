import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatorCenterPage extends StatelessWidget {
  const CreatorCenterPage({super.key});

  static const _items =
      <({IconData icon, String title, String subtitle, String url})>[
        (
          icon: Icons.dashboard_outlined,
          title: '创作中心',
          subtitle: '官方创作首页与任务入口',
          url: 'https://member.bilibili.com/platform/home',
        ),
        (
          icon: Icons.video_library_outlined,
          title: '稿件管理',
          subtitle: '管理视频、图文和投稿状态',
          url: 'https://member.bilibili.com/platform/upload-manager/article',
        ),
        (
          icon: Icons.upload_outlined,
          title: '稿件发布',
          subtitle: '打开官方网页投稿页面',
          url: 'https://member.bilibili.com/platform/upload/video/frame',
        ),
        (
          icon: Icons.analytics_outlined,
          title: '数据中心',
          subtitle: '查看播放、粉丝和内容数据',
          url: 'https://member.bilibili.com/platform/data-up',
        ),
        (
          icon: Icons.live_tv_outlined,
          title: '主播中心',
          subtitle: '直播开播、房间和主播管理',
          url: 'https://link.bilibili.com/p/center/index',
        ),
      ];

  Future<void> _open(String url) async {
    await LoginUtils.setWebCookie();
    Get.toNamed(
      '/webview',
      parameters: {'url': url, 'uaType': 'pc'},
      arguments: {'inApp': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('创作服务')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _open(item.url),
          );
        },
      ),
    );
  }
}
