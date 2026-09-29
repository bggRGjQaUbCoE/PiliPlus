import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/device_utils.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/update.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final currentVersion =
      '${BuildConfig.versionName}+${BuildConfig.versionCode}';
  RxString cacheSize = ''.obs;

  late int _pressCount = 0;

  @override
  void initState() {
    super.initState();
    getCacheSize();
  }

  @override
  void dispose() {
    cacheSize.close();
    super.dispose();
  }

  void getCacheSize() {
    CacheManager.loadApplicationCache().then((res) {
      if (mounted) {
        cacheSize.value = CacheManager.formatSize(res);
      }
    });
  }

  void _showDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      constraints: Style.dialogFixedConstraints,
      content: TextField(
        autofocus: true,
        onSubmitted: (value) {
          Get.back();
          if (value.isNotEmpty) {
            PiliScheme.routePushFromUrl(value);
          }
        },
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const style = TextStyle(fontSize: 15);
    final outline = theme.colorScheme.outline;
    final subTitleStyle = TextStyle(fontSize: 13, color: outline);
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    return SimpleScaffold(
      appBar: showAppBar ? AppBar(title: Text(L10n.current.about)) : null,
      body: ListView(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        children: [
          GestureDetector(
            onTap: () {
              if (++_pressCount == 5) {
                _pressCount = 0;
                _showDialog();
              }
            },
            onSecondaryTap: PlatformUtils.isDesktop ? _showDialog : null,
            child: Image.asset(
              width: 150,
              height: 150,
              excludeFromSemantics: true,
              cacheWidth: 150.cacheSize(context),
              Assets.logo,
            ),
          ),
          ListTile(
            title: Text(
              Constants.appName,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium!.copyWith(height: 2),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  L10n.current.aboutPageChildren,
                  style: TextStyle(color: outline),
                  semanticsLabel: L10n.current.aboutPageSemanticsLabel,
                ),
                Icon(
                  Icons.accessibility_new,
                  semanticLabel: L10n.current.aboutPageSemanticLabel,
                  size: 18,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => Update.checkUpdate(false),
            onLongPress: () => Utils.copyText(currentVersion),
            onSecondaryTap: PlatformUtils.isMobile
                ? null
                : () => Utils.copyText(currentVersion),
            title: Text(L10n.current.aboutPageTitle),
            leading: const Icon(Icons.commit_outlined),
            trailing: Text(
              currentVersion,
              style: subTitleStyle,
            ),
          ),
          ListTile(
            title: Text(
              L10n.current.buildInformation(
                DateFormatUtils.format(
                  BuildConfig.buildTime,
                  format: DateFormatUtils.longFormatDs,
                ),
                BuildConfig.commitHash,
              ),
              style: const TextStyle(fontSize: 14),
            ),
            leading: const Icon(Icons.info_outline),
            onTap: () => PageUtils.launchURL(
              '${Constants.sourceCodeUrl}/commit/${BuildConfig.commitHash}',
            ),
            onLongPress: () => Utils.copyText(BuildConfig.commitHash),
            onSecondaryTap: PlatformUtils.isMobile
                ? null
                : () => Utils.copyText(BuildConfig.commitHash),
          ),
          Divider(
            thickness: 1,
            height: 30,
            color: theme.colorScheme.outlineVariant,
          ),
          ListTile(
            onTap: () => PageUtils.launchURL(Constants.sourceCodeUrl),
            leading: const Icon(Icons.code),
            title: Text(L10n.current.sourceCode),
            subtitle: Text(Constants.sourceCodeUrl, style: subTitleStyle),
          ),
          if (Platform.isAndroid)
            ListTile(
              onTap: PiliAndroidHelper.openLinkVerifySettings,
              leading: const Icon(MdiIcons.linkBoxOutline),
              title: Text(L10n.current.aboutPageTitle7),
              trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
            ),
          ListTile(
            onTap: () =>
                PageUtils.launchURL('${Constants.sourceCodeUrl}/issues'),
            leading: const Icon(Icons.feedback_outlined),
            title: Text(L10n.current.aboutPageTitle2),
            trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
          ),
          ListTile(
            onTap: () => Get.toNamed('/logs'),
            onLongPress: LoggerUtils.clearLogs,
            onSecondaryTap: PlatformUtils.isMobile
                ? null
                : LoggerUtils.clearLogs,
            leading: const Icon(Icons.bug_report_outlined),
            title: Text(L10n.current.aboutPageTitle3),
            subtitle: Text(
              L10n.current.aboutPageSubtitle,
              style: subTitleStyle,
            ),
            trailing: Icon(Icons.arrow_forward, size: 16, color: outline),
          ),
          ListTile(
            onTap: () {
              if (cacheSize.value.isNotEmpty) {
                showConfirmDialog(
                  context: context,
                  title: Text(L10n.current.notice),
                  content: Text(L10n.current.aboutPageContent),
                  onConfirm: () async {
                    SmartDialog.showLoading(msg: L10n.current.aboutPageMsg);
                    try {
                      await CacheManager.clearLibraryCache();
                      SmartDialog.showToast(L10n.current.aboutPageOnConfirm);
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    } finally {
                      SmartDialog.dismiss();
                    }
                    getCacheSize();
                  },
                );
              }
            },
            leading: const Icon(Icons.delete_outline),
            title: Text(L10n.current.clearCache),
            subtitle: Obx(
              () => Text(
                L10n.current.aboutPageSubtitle2(cacheSize.value),
                style: subTitleStyle,
              ),
            ),
          ),
          ListTile(
            title: Text(L10n.current.aboutPageTitle8),
            leading: const Icon(Icons.import_export_outlined),
            onTap: () => showImportExportDialog<Map>(
              context,
              title: L10n.current.aboutPageTitle4,
              localFileName: () => 'account',
              onExport: () =>
                  Utils.jsonEncoder.convert(Accounts.account.toMap()),
              onImport: (json) async {
                final res = json.map(
                  (key, value) => MapEntry(key, LoginAccount.fromJson(value)),
                );
                await Accounts.account.putAll(res);
                await Accounts.refresh();
                MineController.anonymity.value = !Accounts.heartbeat.isLogin;
                if (Accounts.main.isLogin) {
                  await LoginUtils.onLoginMain();
                }
              },
            ),
          ),
          ListTile(
            title: Text(L10n.current.aboutPageTitle6),
            dense: false,
            leading: const Icon(Icons.import_export_outlined),
            onTap: () => showImportExportDialog<Map<String, dynamic>>(
              context,
              title: L10n.current.settings,
              localFileName: () => 'setting_${DeviceUtils.platformName}',
              onExport: GStorage.exportAllSettings,
              onImport: GStorage.importAllJsonSettings,
            ),
          ),
          ListTile(
            title: Text(L10n.current.aboutPageTitle5),
            leading: const Icon(Icons.settings_backup_restore_outlined),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  clipBehavior: Clip.hardEdge,
                  title: Text(L10n.current.aboutPageTitle9),
                  children: [
                    DialogOption(
                      onPressed: () async {
                        Get.back();
                        await Future.wait([
                          GStorage.setting.clear(),
                          GStorage.video.clear(),
                        ]);
                        SmartDialog.showToast(L10n.current.aboutPageOnPressed);
                      },
                      child: Text(L10n.current.aboutPageChild, style: style),
                    ),
                    DialogOption(
                      onPressed: () async {
                        Get.back();
                        await GStorage.clear();
                        SmartDialog.showToast(L10n.current.aboutPageOnPressed);
                      },
                      child: Text(L10n.current.aboutPageChild2, style: style),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
