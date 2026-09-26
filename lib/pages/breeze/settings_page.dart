import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/setting/models/breeze_settings.dart';
import 'package:material_ui/material_ui.dart';

/// Opened from 其它设置 > 哔哩清风, like the SponsorBlock settings.
class BreezeSettingsPage extends StatelessWidget {
  const BreezeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = breezeSettings;
    final padding = MediaQuery.viewPaddingOf(context);
    return SimpleScaffold(
      appBar: AppBar(title: const Text('哔哩清风')),
      body: ListView.builder(
        padding: EdgeInsets.only(
          left: padding.left,
          right: padding.right,
          bottom: padding.bottom + 100,
        ),
        itemCount: settings.length,
        itemBuilder: (context, index) => settings[index].widget,
      ),
    );
  }
}
