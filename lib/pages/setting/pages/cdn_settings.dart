import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/setting/models/video_settings.dart';
import 'package:material_ui/material_ui.dart';

class CdnSettingsPage extends StatelessWidget {
  const CdnSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    final settings = cdnSettings;
    return SimpleScaffold(
      appBar: AppBar(title: const Text('CDN 设置')),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: padding.bottom + 100),
        itemCount: settings.length,
        itemBuilder: (context, index) => settings[index].widget,
      ),
    );
  }
}
