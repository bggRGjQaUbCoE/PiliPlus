import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/index.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

enum ProfileType { uname, sign, sex, birthday }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  LoadingState _loadingState = LoadingState.loading();
  late final _textController = TextEditingController();
  late final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getInfo();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账号资料')),
      body: _buildBody(_loadingState),
    );
  }

  _getInfo() async {
    Map<String, String> data = {
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
    };
    Request()
        .get('${HttpString.appBaseUrl}/x/v2/account/myinfo',
            queryParameters: data)
        .then((data) {
      setState(() {
        if (data.data['code'] == 0) {
          _loadingState = LoadingState.success(data.data['data']);
        } else {
          _loadingState = LoadingState.error(data.data['message']);
        }
      });
    });
  }

  Widget get _divider => Divider(
        height: 1,
        color: Theme.of(context).dividerColor.withOpacity(0.1),
      );

  Widget get _divider1 => Divider(
        thickness: 16,
        color: Theme.of(context).dividerColor.withOpacity(0.1),
      );

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => SingleChildScrollView(
          child: Column(
            children: [
              _item(
                title: '头像',
                widget: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          (loadingState.response['face'] as String).http2https,
                    ),
                  ),
                ),
                onTap: () {
                  EasyThrottle.throttle(
                      'imagePicker', const Duration(milliseconds: 500),
                      () async {
                    _pickImg();
                  });
                },
              ),
              _divider,
              _item(
                title: '昵称',
                text: loadingState.response['name'],
                onTap: () {
                  if (loadingState.response['coins'] < 6) {
                    SmartDialog.showToast('硬币不足');
                  } else {
                    _editDialog(
                      type: ProfileType.uname,
                      title: '昵称',
                      text: loadingState.response['name'],
                    );
                  }
                },
              ),
              _divider,
              _item(
                title: '性别',
                text: _sex(loadingState.response['sex']),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context_) =>
                        _sexDialog(loadingState.response['sex']),
                  );
                },
              ),
              _divider,
              _item(
                title: '出生年月',
                text: loadingState.response['birthday'],
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.parse(loadingState.response['birthday']),
                    firstDate: DateTime(1900, 1, 1),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      _update(
                        type: ProfileType.birthday,
                        datum: DateFormat('yyyy-MM-dd').format(date),
                      );
                    }
                  });
                },
              ),
              _divider,
              _item(
                title: '个性签名',
                text: loadingState.response['sign'].isEmpty
                    ? '无'
                    : loadingState.response['sign'],
                onTap: () {
                  _editDialog(
                    type: ProfileType.sign,
                    title: '个性签名',
                    text: loadingState.response['sign'],
                  );
                },
              ),
              _divider1,
              _item(
                title: '头像挂件',
                onTap: () => Utils.launchURL(
                    'https://www.bilibili.com/h5/mall/pendant/home'),
              ),
              _divider1,
              _item(
                title: 'UID',
                needIcon: false,
                text: loadingState.response['mid'].toString(),
                onTap: () =>
                    Utils.copyText(loadingState.response['mid'].toString()),
              ),
              // _divider,
              // _item(
              //   title: '二维码名片',
              //   widget: Icon(
              //     Icons.qr_code,
              //     color: Theme.of(context).colorScheme.outline,
              //   ),
              //   onTap: () {},
              // ),
              _divider1,
              _item(
                title: '哔哩哔哩认证',
                onTap: () => Utils.launchURL(
                    'https://account.bilibili.com/official/mobile/home'),
              ),
              _divider,
              SizedBox(height: 25 + MediaQuery.paddingOf(context).bottom),
            ],
          ),
        ),
      Error() => errorWidget(
          errMsg: loadingState.errMsg,
          callback: _getInfo,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }

  Widget _sexDialog(int current) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sexDialogItem(1, current, '男'),
          _sexDialogItem(0, current, '保密'),
          _sexDialogItem(2, current, '女'),
        ],
      ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改$title'),
          content: TextField(
            controller: _textController,
            minLines: type == ProfileType.uname ? 1 : 4,
            maxLines: type == ProfileType.uname ? 1 : 4,
            autofocus: true,
            style: TextStyle(fontSize: 14),
            textInputAction:
                type == ProfileType.sign ? TextInputAction.newline : null,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  type == ProfileType.uname ? 16 : 70),
            ],
            decoration: InputDecoration(
              hintText: text,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text == text) {
                  SmartDialog.showToast('与原$title相同');
                } else {
                  _update(type: type);
                }
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    ).then((_) {
      _textController.clear();
    });
  }

  _update({
    required ProfileType type,
    dynamic datum,
  }) async {
    Map<String, String> data = {
      'build': '1462100',
      'c_locale': 'zh_CN',
      'channel': 'yingyongbao',
      'mobi_app': 'android_hd',
      'platform': 'android',
      's_locale': 'zh_CN',
      'statistics': Constants.statistics,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      if (type == ProfileType.uname)
        'uname': _textController.text
      else if (type == ProfileType.sign)
        'user_sign': _textController.text
      else if (type == ProfileType.birthday)
        'birthday': datum
      else if (type == ProfileType.sex)
        'sex': datum.toString(),
    };
    Request()
        .post(
      '/x/member/app/${type.name}/update',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    )
        .then((data) {
      if (data.data['code'] == 0) {
        if (type == ProfileType.uname) {
          (_loadingState as Success).response['name'] = _textController.text;
          (_loadingState as Success).response['coins'] -= 6;
        } else if (type == ProfileType.sign) {
          (_loadingState as Success).response['sign'] = _textController.text;
        } else if (type == ProfileType.birthday) {
          (_loadingState as Success).response['birthday'] = datum;
        } else if (type == ProfileType.sex) {
          (_loadingState as Success).response['sex'] = datum;
        }
        SmartDialog.showToast('修改成功');
        setState(() {});
        if (type == ProfileType.uname || type == ProfileType.sign) {
          Get.back();
        }
      } else {
        SmartDialog.showToast(data.data['message']);
      }
    });
  }

  String _sex(int sex) {
    return switch (sex) {
      0 => '保密',
      1 => '男',
      2 => '女',
      _ => '未知',
    };
  }

  Widget _item({
    required String title,
    Widget? widget,
    String? text,
    GestureTapCallback? onTap,
    bool needIcon = true,
  }) {
    return ListTile(
      onTap: onTap,
      dense: title != '头像',
      leading: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (text != null)
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          else if (widget != null)
            widget,
          if (needIcon)
            Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).colorScheme.outline,
            )
        ],
      ),
    );
  }

  void _pickImg() async {
    try {
      XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile != null && mounted) {
        String? mimeType =
            lookupMimeType(pickedFile.path)?.split('/').getOrNull(1);
        if (mimeType == 'gif') {
          SmartDialog.showToast('不能选GIF');
          return;
        }
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: '裁剪',
              toolbarColor: Theme.of(context).colorScheme.secondaryContainer,
              toolbarWidgetColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              aspectRatioPresets: [
                CropAspectRatioPresetCustom(),
              ],
              lockAspectRatio: true,
              hideBottomControls: true,
              cropStyle: CropStyle.circle,
              initAspectRatio: CropAspectRatioPresetCustom(),
            ),
            IOSUiSettings(
              title: '裁剪',
              aspectRatioPresets: [
                CropAspectRatioPresetCustom(),
              ],
              cropStyle: CropStyle.circle,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
              aspectRatioPickerButtonHidden: true,
            ),
          ],
        );
        if (croppedFile != null) {
          Request()
              .post(
            '/x/member/web/face/update',
            queryParameters: {
              'csrf': await Request.getCsrf(),
            },
            data: FormData.fromMap({
              'dopost': 'save',
              'DisplayRank': 10000,
              'face': await MultipartFile.fromFile(croppedFile.path),
            }),
          )
              .then((data) {
            if (data.data['code'] == 0) {
              (_loadingState as Success).response['face'] = data.data['data'];
              SmartDialog.showToast('修改成功');
              setState(() {});
            } else {
              SmartDialog.showToast(data.data['message']);
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
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1 (customized)';
}
