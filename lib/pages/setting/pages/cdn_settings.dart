import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/setting/models/video_settings.dart';
import 'package:material_ui/material_ui.dart';

class CdnSettingsPage extends StatelessWidget {
  const CdnSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = videoSettings
        .where((item) => item.effectiveTitle.contains('CDN'))
        .toList(growable: false);
    return SimpleScaffold(
      appBar: AppBar(title: const Text('CDN 设置与诊断')),
      body: ListView.builder(
        itemCount: settings.length,
        itemBuilder: (context, index) => settings[index].widget,
      ),
    );
  }
}
