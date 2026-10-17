import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/crisis_helper.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// 搜索高危词时展示的整页关怀卡片。
///
/// 对应官方客户端在「自杀」等关键词下的页面样式：
/// 大标题 + 求助提示 + 热线号码 + 可点击复制的按钮。
/// 与 SearchTipItem（服务端下发的小卡片）区分开：这里会同时屏蔽搜索结果。
class CrisisCard extends StatelessWidget {
  const CrisisCard({super.key});

  static const _pink = Color(0xFFFB7299);

  /// 优先唤起官方 App 的原生客服会话（体验最好），
  /// 未安装官方 App 时降级到 Web 版 PC 会话页，
  /// 并以 `desktop=1` 让 WebView 按桌面宽度渲染。
  static Future<void> _openConsult() async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(CrisisHelper.customerChatScheme),
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (opened) {
      return;
    }
    PageUtils.toDupNamed(
      '/webview',
      parameters: {
        'url': CrisisHelper.customerServiceUrl,
        'desktop': '1',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 430),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFF4F8),
                Color(0xFFEAF2FF),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '你不孤单，我们都在',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '如果需要帮助，请拨打全国24小时免费心理咨询热线',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: Color(0xFF3D3D3D),
                ),
              ),
              const SizedBox(height: 56),
              const Text(
                '全国24小时免费心理咨询',
                style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 6),
              const Text(
                CrisisHelper.hotline,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () => Utils.copyText(
                    CrisisHelper.hotline,
                    toastText: '已复制心理咨询热线',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text('复制号码'),
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 4,
                children: [
                  TextButton(
                    onPressed: () => PiliScheme.routePushFromUrl(
                      CrisisHelper.energyStationUrl,
                    ),
                    child: const Text('进入能量加油站'),
                  ),
                  TextButton(
                    onPressed: _openConsult,
                    child: const Text('人工咨询'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
