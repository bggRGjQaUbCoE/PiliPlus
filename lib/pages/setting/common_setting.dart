import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/setting_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:material_ui/material_ui.dart';

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
  late EdgeInsets padding;
  late List<SettingsModel> settings;

  void _initSetting() {
    settings = widget.settingType.settings;
  }

  @override
  void initState() {
    super.initState();
    _initSetting();
    L10n.changes.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() => setState(_initSetting);

  @override
  void dispose() {
    L10n.changes.removeListener(_onLanguageChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(CommonSetting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settingType != oldWidget.settingType) {
      _initSetting();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    padding = MediaQuery.viewPaddingOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final showAppBar = widget.showAppBar;
    return SimpleScaffold(
      appBar: showAppBar ? AppBar(title: Text(widget.settingType.title)) : null,
      body: ListView.builder(
        key: ValueKey(widget.settingType),
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
