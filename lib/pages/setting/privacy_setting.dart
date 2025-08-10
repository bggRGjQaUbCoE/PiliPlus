import 'package:PiliPlus/pages/setting/models/privacy_settings.dart';
import 'package:flutter/material.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key, this.showAppBar});

  final bool? showAppBar;

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  final settings = privacySettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : AppBar(title: const Text('隐私设置')),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        children: settings.map((item) => item.widget).toList(),
      ),
    );
  }
}
