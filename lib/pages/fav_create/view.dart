import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/utils/fav_utils.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreateFavPage extends StatefulWidget {
  const CreateFavPage({super.key});

  @override
  State<CreateFavPage> createState() => _CreateFavPageState();
}

class _CreateFavPageState extends State<CreateFavPage> {
  dynamic _mediaId;
  late final _titleController = TextEditingController();
  late final _introController = TextEditingController();
  String? _cover;
  bool _isPublic = true;
  late final _imagePicker = ImagePicker();
  String? _errMsg;
  int? _attr;

  @override
  void initState() {
    super.initState();
    _mediaId = Get.parameters['mediaId'];
    if (_mediaId != null) {
      _getFolderInfo();
    }
  }

  void _getFolderInfo() {
    _errMsg = null;
    FavHttp.favFolderInfo(mediaId: _mediaId).then((res) {
      if (res['status']) {
        FavFolderInfo data = res['data'];
        _titleController.text = data.title;
        _introController.text = data.intro ?? '';
        _isPublic = FavUtils.isPublicFav(data.attr);
        _cover = data.cover;
        _attr = data.attr;
      } else {
        _errMsg = res['msg'];
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_mediaId != null ? '编辑' : '创建'),
        actions: [
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                SmartDialog.showToast('名称不能为空');
                return;
              }
              FavHttp.addOrEditFolder(
                isAdd: _mediaId == null,
                mediaId: _mediaId,
                title: _titleController.text,
                privacy: _isPublic ? 0 : 1,
                cover: _cover ?? '',
                intro: _introController.text,
              ).then((res) {
                if (res['status']) {
                  Get.back(result: res['data']);
                  SmartDialog.showToast('${_mediaId != null ? '编辑' : '创建'}成功');
                } else {
                  SmartDialog.showToast(res['msg']);
                }
              });
            },
            child: const Text('完成'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _mediaId != null
          ? _titleController.text.isNotEmpty
                ? _buildBody(theme)
                : _errMsg?.isNotEmpty == true
                ? Center(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        HttpError(
                          errMsg: _errMsg,
                          onReload: _getFolderInfo,
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator())
          : _buildBody(theme),
    );
  }

  Future<void> _pickImg(BuildContext context, ThemeData theme) async {
    try {
      XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile != null && mounted) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: '裁剪',
              toolbarColor: theme.colorScheme.secondaryContainer,
              toolbarWidgetColor: theme.colorScheme.onSecondaryContainer,
              aspectRatioPresets: [
                CropAspectRatioPreset.ratio16x9,
              ],
              lockAspectRatio: true,
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.ratio16x9,
            ),
            IOSUiSettings(
              title: '裁剪',
              aspectRatioPresets: [
                CropAspectRatioPreset.ratio16x9,
              ],
              aspectRatioLockEnabled: false,
              resetAspectRatioEnabled: false,
              aspectRatioPickerButtonHidden: true,
            ),
          ],
        );
        if (croppedFile != null) {
          MsgHttp.uploadImage(
            path: croppedFile.path,
            bucket: 'medialist',
            dir: 'cover',
          ).then((res) {
            if (context.mounted) {
              if (res['status']) {
                _cover = res['data']['location'];
                (context as Element).markNeedsBuild();
              } else {
                SmartDialog.showToast(res['msg']);
              }
            }
          });
        }
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  final leadingStyle = const TextStyle(fontSize: 14);

  Widget _buildBody(ThemeData theme) => SingleChildScrollView(
    child: Column(
      children: [
        if (_attr == null || !FavUtils.isDefaultFav(_attr!)) ...[
          Builder(
            builder: (context) {
              return ListTile(
                tileColor: theme.colorScheme.onInverseSurface,
                onTap: () {
                  EasyThrottle.throttle(
                    'imagePicker',
                    const Duration(milliseconds: 500),
                    () {
                      if (_cover?.isNotEmpty == true) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              clipBehavior: Clip.hardEdge,
                              contentPadding: const EdgeInsets.fromLTRB(
                                0,
                                12,
                                0,
                                12,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    dense: true,
                                    onTap: () {
                                      Get.back();
                                      _pickImg(context, theme);
                                    },
                                    title: const Text(
                                      '替换封面',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  ListTile(
                                    dense: true,
                                    onTap: () {
                                      Get.back();
                                      _cover = null;
                                      (context as Element).markNeedsBuild();
                                    },
                                    title: const Text(
                                      '移除封面',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        _pickImg(context, theme);
                      }
                    },
                  );
                },
                leading: Text(
                  '封面',
                  style: leadingStyle,
                ),
                trailing: Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_cover?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: ImageUtils.thumbnailUrl(_cover!),
                            height: 55,
                            width: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: theme.colorScheme.outline,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        ListTile(
          tileColor: theme.colorScheme.onInverseSurface,
          leading: Text.rich(
            style: const TextStyle(
              height: 1,
              fontSize: 14,
            ),
            TextSpan(
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1,
                    color: theme.colorScheme.error,
                  ),
                ),
                const TextSpan(
                  text: '名称',
                  style: TextStyle(
                    height: 1,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          title: TextField(
            autofocus: true,
            readOnly: _attr != null && FavUtils.isDefaultFav(_attr!),
            controller: _titleController,
            style: TextStyle(
              fontSize: 14,
              color: _attr != null && FavUtils.isDefaultFav(_attr!)
                  ? theme.colorScheme.outline
                  : null,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              isDense: true,
              hintText: '名称',
              hintStyle: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.outline,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                gapPadding: 0,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_attr == null || !FavUtils.isDefaultFav(_attr!)) ...[
          ListTile(
            tileColor: theme.colorScheme.onInverseSurface,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '简介',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    minLines: 6,
                    maxLines: 6,
                    controller: _introController,
                    style: const TextStyle(fontSize: 14),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(200),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '可填写简介',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.outline,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        gapPadding: 0,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Builder(
          builder: (context) {
            void onTap() {
              _isPublic = !_isPublic;
              (context as Element).markNeedsBuild();
            }

            return ListTile(
              onTap: onTap,
              tileColor: theme.colorScheme.onInverseSurface,
              leading: Text(
                '公开',
                style: leadingStyle,
              ),
              trailing: Transform.scale(
                alignment: Alignment.centerRight,
                scale: 0.8,
                child: Switch(
                  value: _isPublic,
                  onChanged: (value) => onTap(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
