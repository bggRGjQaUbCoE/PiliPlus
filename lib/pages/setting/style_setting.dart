import 'package:PiliPlus/pages/setting/models/style_settings.dart';
import 'package:flutter/material.dart';

class StyleSetting extends StatefulWidget {
  const StyleSetting({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  State<StyleSetting> createState() => _StyleSettingState();
}

class _StyleSettingState extends State<StyleSetting> {
  final settings = styleSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : AppBar(title: const Text('外观设置')),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        children: settings.map((item) => item.widget).toList(),
      ),
    );
  }
}
