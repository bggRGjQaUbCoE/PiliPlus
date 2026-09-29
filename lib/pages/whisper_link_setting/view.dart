import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/msg/im_user_infos/datum.dart';
import 'package:PiliPlus/models_new/msg/msg_dnd/uid_setting.dart';
import 'package:PiliPlus/models_new/msg/session_ss/data.dart';
import 'package:PiliPlus/pages/whisper_link_setting/controller.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class WhisperLinkSettingPage extends StatefulWidget {
  const WhisperLinkSettingPage({
    super.key,
    required this.talkerUid,
  });

  final int talkerUid;

  @override
  State<WhisperLinkSettingPage> createState() => _WhisperLinkSettingPageState();
}

class _WhisperLinkSettingPageState extends State<WhisperLinkSettingPage> {
  late final WhisperLinkSettingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      WhisperLinkSettingController(talkerUid: widget.talkerUid),
      tag: Utils.generateRandomString(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final divider = Divider(
      height: 12,
      thickness: 12,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );
    final divider2 = Divider(
      height: 1,
      indent: 16,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    );
    return SimpleScaffold(
      appBar: AppBar(title: Text(L10n.current.whisperLinkSettingPageTitle)),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
        ),
        children: [
          divider,
          Obx(
            () => _buildUserInfo(theme, divider, _controller.userState.value),
          ),
          Obx(
            () => _buildSessionSs(
              theme,
              divider,
              divider2,
              _controller.sessionSs.value,
            ),
          ),
          Obx(
            () {
              if (_controller.sessionSs.value case Success(:final response)) {
                return _buildBlockItem(response.followStatus == 128);
              }
              return const SizedBox.shrink();
            },
          ),
          divider2,
          ListTile(
            dense: true,
            onTap: _controller.report,
            title: Text(
              L10n.current.report,
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: theme.colorScheme.outline,
            ),
          ),
          divider,
        ],
      ),
    );
  }

  Widget _buildBlockItem(bool isBlocked) {
    return ListTile(
      dense: true,
      onTap: () => _controller.setBlock(isBlocked),
      title: Text(
        L10n.current.memberPageActionsChildren5,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Transform.scale(
        alignment: Alignment.centerRight,
        scale: 0.8,
        child: Switch(
          value: isBlocked,
          onChanged: (value) => _controller.setBlock(isBlocked),
        ),
      ),
    );
  }

  Widget _buildUserInfo(
    ThemeData theme,
    Widget divider,
    LoadingState<List<ImUserInfosData>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final ImUserInfosData item = response.first;
                      return ListTile(
                        onTap: () => Get.toNamed('/member?mid=${item.mid}'),
                        leading: PendantAvatar(
                          item.face,
                          size: 42,
                          badgeSize: 14,
                          vipStatus: item.vip?.status,
                          pendantImage: item.pendant?.image,
                          officialType: item.official?.type,
                        ),
                        title: Text(
                          item.name!,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                item.vip?.status != null &&
                                    item.vip!.status > 0 &&
                                    item.vip?.type == 2
                                ? theme.colorScheme.vipColor
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          'UID: ${item.mid}${item.sign?.isNotEmpty == true ? '\n${item.sign}' : ''}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        trailing: Icon(
                          size: 22,
                          Icons.keyboard_arrow_right,
                          color: theme.colorScheme.outline,
                        ),
                      );
                    },
                  ),
                  divider,
                ],
              )
            : const SizedBox.shrink(),
      Error(:final errMsg) => _errWidget(errMsg, _controller.getUserInfo),
    };
  }

  Widget _buildSessionSs(
    ThemeData theme,
    Widget divider,
    Widget divider2,
    LoadingState<SessionSsData> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success(:final response) => Builder(
        builder: (context) {
          late final subTitleS = TextStyle(
            fontSize: 13,
            color: theme.colorScheme.outline,
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (response.showPushSetting == 1)
                ListTile(
                  dense: true,
                  onTap: () => _controller.setPush(response.pushSetting == 0),
                  title: Text(
                    L10n.current.whisperLinkSettingPageBuildSessionSsTitle2,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    L10n.current.whisperLinkSettingControllerSetPushContent,
                    style: subTitleS,
                  ),
                  trailing: Transform.scale(
                    alignment: Alignment.centerRight,
                    scale: 0.8,
                    child: Switch(
                      value: response.pushSetting == 0,
                      onChanged: (value) =>
                          _controller.setPush(response.pushSetting == 0),
                    ),
                  ),
                ),
              divider2,
              Obx(
                () => ListTile(
                  dense: true,
                  onTap: _controller.setPin,
                  title: Text(
                    L10n.current.whisperLinkSettingPageBuildSessionSsTitle,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Transform.scale(
                    alignment: Alignment.centerRight,
                    scale: 0.8,
                    child: Switch(
                      value: _controller.isPinned.value,
                      onChanged: (value) => _controller.setPin(),
                    ),
                  ),
                ),
              ),
              divider2,
              Obx(() => _buildMuteItem(_controller.msgDnd.value)),
              divider,
            ],
          );
        },
      ),
      Error(:final errMsg) => _errWidget(errMsg, _controller.getSessionSs),
    };
  }

  Widget _buildMuteItem(LoadingState<List<UidSetting>?> loadingState) {
    return switch (loadingState) {
      Loading() => const SizedBox.shrink(),
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? ListTile(
                dense: true,
                onTap: () => _controller.setMute(response.first.setting == 1),
                title: Text(
                  L10n.current.whisperLinkSettingPageBuildMuteItemTitle,
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: Transform.scale(
                  alignment: Alignment.centerRight,
                  scale: 0.8,
                  child: Switch(
                    value: response.first.setting == 1,
                    onChanged: (value) =>
                        _controller.setMute(response.first.setting == 1),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      Error(:final errMsg) => _errWidget(errMsg, _controller.getMsgDnd),
    };
  }

  Widget _errWidget(String? errMsg, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          errMsg ?? '',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
