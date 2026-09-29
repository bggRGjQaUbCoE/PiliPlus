import 'dart:async';
import 'dart:io' show File;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/member/profile_type.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models_new/account_myinfo/data.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_sign.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mime/mime.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  LoadingState<AccountMyInfoData> _loadingState =
      LoadingState<AccountMyInfoData>.loading();
  late final TextEditingController _textController;
  late final _imagePicker = ImagePicker();
  AccountService accountService = Get.find<AccountService>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _getInfo();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(title: Text(L10n.current.editProfilePageTitle)),
      body: _buildBody(theme, _loadingState),
    );
  }

  Future<void> _getInfo() async {
    Map<String, String> data = {
      'build': '2001100',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
    };
    Request()
        .get(
          '${HttpString.appBaseUrl}/x/v2/account/myinfo',
          queryParameters: data,
        )
        .then((res) {
          if (mounted) {
            setState(() {
              if (res.data['code'] == 0) {
                AccountMyInfoData data = AccountMyInfoData.fromJson(
                  res.data['data'],
                );
                _loadingState = Success(data);
                accountService.face.value = data.face!;
                try {
                  UserInfoData userInfo = Pref.userInfoCache!
                    ..uname = data.name
                    ..face = data.face;
                  GStorage.userInfo.put('userInfoCache', userInfo);
                } catch (_) {}
                try {
                  Get.find<MineController>().userInfo
                    ..value.uname = data.name
                    ..value.face = data.face
                    ..refresh();
                } catch (_) {}
              } else {
                _loadingState = Error(res.data['message']);
              }
            });
          }
        });
  }

  Widget _buildBody(
    ThemeData theme,
    LoadingState<AccountMyInfoData> loadingState,
  ) {
    late final divider = Divider(
      height: 1,
      color: theme.dividerColor.withValues(alpha: 0.1),
    );

    late final divider1 = Divider(
      thickness: 16,
      color: theme.dividerColor.withValues(alpha: 0.1),
    );

    return switch (loadingState) {
      Loading() => m3eLoading,
      Success(:final response) => ListView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewPaddingOf(context).bottom + 25,
        ),
        children: [
          divider1,
          _item(
            theme: theme,
            title: L10n.current.avatar,
            widget: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: NetworkImgLayer(
                width: 55,
                height: 55,
                type: .avatar,
                src: response.face,
              ),
            ),
            onTap: () => EasyThrottle.throttle(
              'imagePicker',
              const Duration(milliseconds: 500),
              () {
                _pickImg(theme);
              },
            ),
          ),
          divider,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle2,
            text: response.name,
            onTap: () {
              if (response.coins! < 6) {
                SmartDialog.showToast(
                  L10n.current.editProfilePageBuildBodyOnTap,
                );
              } else {
                _editDialog(
                  type: ProfileType.uname,
                  title: L10n.current.editProfilePageBuildBodyTitle2,
                  text: response.name!,
                );
              }
            },
          ),
          divider,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle3,
            text: _sex(response.sex!),
            onTap: () => showDialog(
              context: context,
              builder: (context_) => _sexDialog(response.sex!),
            ),
          ),
          divider,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle4,
            text: response.birthday,
            onTap: () =>
                showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(response.birthday!),
                  firstDate: DateTime(0001, 1, 1),
                  lastDate: DateTime.now(),
                ).then((res) {
                  if (res != null) {
                    _update(
                      type: ProfileType.birthday,
                      datum: DateFormatUtils.longFormat.format(res),
                    );
                  }
                }),
          ),
          divider,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle5,
            text: response.sign,
            onTap: () => _editDialog(
              type: ProfileType.sign,
              title: L10n.current.editProfilePageBuildBodyTitle5,
              text: response.sign ?? '',
            ),
          ),
          divider1,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle6,
            onTap: () => PageUtils.inAppWebview(
              'https://www.bilibili.com/h5/mall/pendant/home',
            ),
          ),
          divider1,
          _item(
            theme: theme,
            title: 'UID',
            needIcon: false,
            text: response.mid.toString(),
            onTap: () => Utils.copyText(response.mid.toString()),
          ),
          divider1,
          _item(
            theme: theme,
            title: L10n.current.editProfilePageBuildBodyTitle7,
            onTap: () => PageUtils.inAppWebview(
              'https://account.bilibili.com/official/mobile/home',
            ),
          ),
          divider1,
        ],
      ),
      Error(:final errMsg) => scrollErrorWidget(
        errMsg: errMsg,
        onReload: _getInfo,
      ),
    };
  }

  Widget _sexDialog(int current) {
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        _sexDialogItem(1, current, L10n.current.male),
        _sexDialogItem(0, current, L10n.current.undisclosed),
        _sexDialogItem(2, current, L10n.current.female),
      ],
    );
  }

  Widget _sexDialogItem(
    int sex,
    int current,
    String text,
  ) {
    return ListTile(
      dense: true,
      enabled: current != sex,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      trailing: current == sex ? const Icon(size: 22, Icons.check) : null,
      onTap: () {
        Get.back();
        _update(type: ProfileType.sex, datum: sex);
      },
    );
  }

  void _editDialog({
    required ProfileType type,
    required String title,
    required String text,
  }) {
    _textController.text = text;
    final lines = type == ProfileType.uname ? 1 : 4;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            L10n.current.editProfilePageEditDialogTitle(title),
          ),
          content: TextField(
            controller: _textController,
            minLines: lines,
            maxLines: lines,
            autofocus: true,
            style: const TextStyle(fontSize: 14),
            textInputAction: type == ProfileType.sign
                ? TextInputAction.newline
                : null,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                type == ProfileType.uname ? 16 : 70,
              ),
            ],
            decoration: InputDecoration(
              hintText: text,
              hintStyle: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                L10n.current.cancel,
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text == text) {
                  SmartDialog.showToast(
                    L10n.current.editProfilePageEditDialogOnPressed(
                      title,
                    ),
                  );
                } else {
                  _update(type: type);
                }
              },
              child: Text(L10n.current.ok),
            ),
          ],
        );
      },
    ).whenComplete(_textController.clear);
  }

  Future<void> _update({
    required ProfileType type,
    dynamic datum,
  }) async {
    final accessKey = Accounts.main.accessKey;
    if (accessKey == null || accessKey.isEmpty) {
      SmartDialog.showToast(L10n.current.videoPopupMenuItemBuilder5);
      return;
    }
    final data = <String, String>{
      'access_key': accessKey,
      'build': '2001100',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      if (type == ProfileType.uname)
        'uname': _textController.text
      else if (type == ProfileType.sign)
        'user_sign': _textController.text
      else if (type == ProfileType.birthday)
        'birthday': datum
      else if (type == ProfileType.sex)
        'sex': datum.toString(),
    };
    AppSign.appSign(data);
    Request()
        .post(
          '/x/member/app/${type.name}/update',
          data: data,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        )
        .then((res) {
          if (res.data['code'] == 0) {
            AccountMyInfoData data = _loadingState.data;
            if (type == ProfileType.uname) {
              data
                ..name = _textController.text
                ..coins = data.coins! - 6;
              try {
                UserInfoData userInfo = Pref.userInfoCache!
                  ..uname = _textController.text;
                GStorage.userInfo.put('userInfoCache', userInfo);
              } catch (_) {}
              try {
                Get.find<MineController>().userInfo
                  ..value.uname = _textController.text
                  ..refresh();
              } catch (_) {}
            } else if (type == ProfileType.sign) {
              data.sign = _textController.text;
            } else if (type == ProfileType.birthday) {
              data.birthday = datum;
            } else if (type == ProfileType.sex) {
              data.sex = datum;
            }
            SmartDialog.showToast(L10n.current.followControllerOnUpdateTagText);
            if (mounted) {
              setState(() {});
            }
            if (type == ProfileType.uname || type == ProfileType.sign) {
              Get.back();
            }
          } else {
            SmartDialog.showToast(res.data['message']);
          }
        });
  }

  String _sex(int sex) {
    return switch (sex) {
      0 => L10n.current.undisclosed,
      1 => L10n.current.male,
      2 => L10n.current.female,
      _ => L10n.current.unknown,
    };
  }

  Widget _item({
    required ThemeData theme,
    required String title,
    Widget? widget,
    String? text,
    GestureTapCallback? onTap,
    bool needIcon = true,
  }) {
    return ListTile(
      onTap: onTap,
      dense: title != L10n.current.avatar,
      leading: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (text != null)
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.outline,
                ),
              ),
            )
          else
            ?widget,
          if (needIcon)
            Icon(
              Icons.keyboard_arrow_right,
              color: theme.colorScheme.outline,
            )
          else
            const SizedBox(width: 24),
        ],
      ),
    );
  }

  Future<void> _pickImg(ThemeData theme) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        requestFullMetadata: false,
      );
      if (pickedFile != null && mounted) {
        String? imagePath = pickedFile.path;
        String? mimeType = (pickedFile.mimeType ?? lookupMimeType(imagePath))
            ?.split('/')
            .elementAtOrNull(1);
        if (mimeType == 'gif') {
          SmartDialog.showToast(L10n.current.editProfilePagePickImgText);
          return;
        }
        if (PlatformUtils.isMobile) {
          final croppedFile = await ImageCropper.platform.cropImage(
            sourcePath: imagePath,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: L10n.current.videoFitTypeCoverDesc,
                toolbarColor: theme.colorScheme.secondaryContainer,
                toolbarWidgetColor: theme.colorScheme.onSecondaryContainer,
                statusBarLight: theme.isLight,
                aspectRatioPresets: const [CropAspectRatioPresetCustom()],
                lockAspectRatio: true,
                hideBottomControls: true,
                cropStyle: CropStyle.circle,
                initAspectRatio: const CropAspectRatioPresetCustom(),
              ),
              IOSUiSettings(
                title: L10n.current.videoFitTypeCoverDesc,
                aspectRatioPresets: const [CropAspectRatioPresetCustom()],
                cropStyle: CropStyle.circle,
                aspectRatioLockEnabled: true,
                resetAspectRatioEnabled: false,
                aspectRatioPickerButtonHidden: true,
              ),
            ],
          );
          File(imagePath).tryDel();
          imagePath = croppedFile?.path;
        }
        if (imagePath != null) {
          Request()
              .post(
                '/x/member/web/face/update',
                queryParameters: {
                  'csrf': Accounts.main.csrf,
                },
                data: FormData.fromMap({
                  'dopost': 'save',
                  'DisplayRank': 10000,
                  'face': await MultipartFile.fromFile(imagePath),
                }),
              )
              .then((res) {
                if (res.data['code'] == 0) {
                  SmartDialog.showToast(
                    L10n.current.followControllerOnUpdateTagText,
                  );
                  Timer(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      _getInfo();
                    }
                  });
                } else {
                  SmartDialog.showToast(res.data['message']);
                }
                if (PlatformUtils.isMobile && imagePath != null) {
                  File(imagePath).tryDel();
                }
              });
        }
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  const CropAspectRatioPresetCustom();

  @override
  (int, int) get data => const (1, 1);

  @override
  String get name => '1x1 (customized)';
}
