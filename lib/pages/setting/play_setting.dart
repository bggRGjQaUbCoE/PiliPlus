import 'package:PiliPlus/pages/setting/models/play_settings.dart';
import 'package:flutter/material.dart';

class PlaySetting extends StatefulWidget {
  const PlaySetting({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  State<PlaySetting> createState() => _PlaySettingState();
}

class _PlaySettingState extends State<PlaySetting> {
  final settings = playSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : AppBar(title: const Text('播放器设置')),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        children: settings.map((item) => item.widget).toList(),
      ),
    );
  }
}
