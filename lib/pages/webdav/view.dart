import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/pages/webdav/webdav.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class WebDavSettingPage extends StatefulWidget {
  const WebDavSettingPage({
    super.key,
    this.showAppBar,
  });

  final bool? showAppBar;

  @override
  State<WebDavSettingPage> createState() => _WebDavSettingPageState();
}

class _WebDavSettingPageState extends State<WebDavSettingPage> {
  final _uriCtr = TextEditingController(text: GStorage.webdavUri);
  final _usernameCtr = TextEditingController(text: GStorage.webdavUsername);
  final _passwordCtr = TextEditingController(text: GStorage.webdavPassword);
  final _directoryCtr = TextEditingController(text: GStorage.webdavDirectory);

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
    EdgeInsets padding = MediaQuery.paddingOf(context);
    return Scaffold(
      appBar: widget.showAppBar == false
          ? null
          : AppBar(title: const Text('WebDAV 设置')),
      body: ListView(
        padding: padding.copyWith(
          top: 20,
          left: padding.left + 20,
          right: padding.right + 20,
          bottom: padding.bottom + 90,
        ),
        children: [
          TextField(
            controller: _uriCtr,
            decoration: const InputDecoration(
              labelText: '地址',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameCtr,
            decoration: const InputDecoration(
              labelText: '用户',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordCtr,
            decoration: const InputDecoration(
              labelText: '密码',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _directoryCtr,
            decoration: const InputDecoration(
              labelText: '路径',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: StyleString.mdRadius,
                    ),
                  ),
                  onPressed: WebDav().backup,
                  child: const Text('备份设置'),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: StyleString.mdRadius,
                    ),
                  ),
                  onPressed: WebDav().restore,
                  child: const Text('恢复设置'),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (_uriCtr.text.isEmpty) {
            SmartDialog.showToast('地址不能为空');
            return;
          }
          await GStorage.setting.put(SettingBoxKey.webdavUri, _uriCtr.text);
          await GStorage.setting
              .put(SettingBoxKey.webdavUsername, _usernameCtr.text);
          await GStorage.setting
              .put(SettingBoxKey.webdavPassword, _passwordCtr.text);
          await GStorage.setting
              .put(SettingBoxKey.webdavDirectory, _directoryCtr.text);
          try {
            final res = await WebDav().init();
            if (res.first) {
              SmartDialog.showToast('配置成功');
            } else {
              SmartDialog.showToast('配置失败: ${res.second}');
            }
          } catch (e) {
            SmartDialog.showToast('配置失败: ${e.toString()}');
            return;
          }
        },
      ),
    );
  }
}
