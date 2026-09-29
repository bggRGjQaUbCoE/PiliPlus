import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/webdav/webdav.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

class WebDavSettingPage extends StatefulWidget {
  const WebDavSettingPage({
    super.key,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  State<WebDavSettingPage> createState() => _WebDavSettingPageState();
}

class _WebDavSettingPageState extends State<WebDavSettingPage> {
  final _uriCtr = TextEditingController(text: Pref.webdavUri);
  final _usernameCtr = TextEditingController(text: Pref.webdavUsername);
  final _passwordCtr = TextEditingController(text: Pref.webdavPassword);
  final _directoryCtr = TextEditingController(text: Pref.webdavDirectory);
  bool _obscureText = true;

  @override
  void dispose() {
    _uriCtr.dispose();
    _usernameCtr.dispose();
    _passwordCtr.dispose();
    _directoryCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showAppBar = widget.showAppBar;
    final padding = MediaQuery.viewPaddingOf(context);
    return SimpleScaffold(
      appBar: showAppBar
          ? AppBar(title: Text(L10n.current.webdavSettings))
          : null,
      body: ViewInsetsSafeArea(
        child: ListView(
          padding: padding.copyWith(
            top: 20,
            left: 20 + (showAppBar ? padding.left : 0),
            right: 20 + (showAppBar ? padding.right : 0),
            bottom: padding.bottom + 100,
          ),
          children: [
            TextField(
              controller: _uriCtr,
              decoration: InputDecoration(
                labelText: L10n.current.webDavSettingPageLabelText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameCtr,
              decoration: InputDecoration(
                labelText: L10n.current.user,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordCtr,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: L10n.current.loginPageLoginByPasswordLabelText2,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: _obscureText
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              obscureText: _obscureText,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _directoryCtr,
              decoration: InputDecoration(
                labelText: L10n.current.webDavSettingPageLabelText2,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: Style.mdRadius,
                      ),
                    ),
                    onPressed: WebDav().backup,
                    child: Text(L10n.current.webDavSettingPageChild),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: Style.mdRadius,
                      ),
                    ),
                    onPressed: WebDav().restore,
                    child: Text(L10n.current.webDavSettingPageChild2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      fab: Padding(
        padding: .only(
          right: kFloatingActionButtonMargin + (showAppBar ? padding.right : 0),
          bottom: kFloatingActionButtonMargin + padding.bottom,
        ),
        child: ViewInsetsSafeArea(
          child: FloatingActionButton(
            child: const Icon(Icons.save),
            onPressed: () async {
              await GStorage.setting.putAll({
                SettingBoxKey.webdavUri: _uriCtr.text,
                SettingBoxKey.webdavUsername: _usernameCtr.text,
                SettingBoxKey.webdavPassword: _passwordCtr.text,
                SettingBoxKey.webdavDirectory: _directoryCtr.text,
              });
              if (_uriCtr.text.isEmpty) {
                return;
              }
              try {
                final res = await WebDav().init();
                if (res.first) {
                  SmartDialog.showToast(
                    L10n.current.webDavSettingPageOnPressed,
                  );
                } else {
                  SmartDialog.showToast('配置失败: ${res.second}');
                }
              } catch (e) {
                SmartDialog.showToast('配置失败: ${e.toString()}');
                return;
              }
            },
          ),
        ),
      ),
    );
  }
}
