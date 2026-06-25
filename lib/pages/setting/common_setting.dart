import 'package:PiliPlus/models/common/setting_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:flutter/material.dart';

class CommonSetting extends StatefulWidget {
  const CommonSetting({
    super.key,
    required this.settingType,
    this.showAppBar = true,
  });

  final bool showAppBar;
  final SettingType settingType;

  @override
  State<CommonSetting> createState() => _CommonSettingState();
}

class _CommonSettingState extends State<CommonSetting> {
  late final List<SettingsModel> settings;

  @override
  void initState() {
    super.initState();
    settings = widget.settingType.settings;
  }

  @override
  Widget build(BuildContext context) {
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: showAppBar ? AppBar(title: Text(widget.settingType.title)) : null,
      body: ListView.builder(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        itemCount: settings.length,
        itemBuilder: (context, index) => settings[index].widget,
      ),
    );
  }
}
