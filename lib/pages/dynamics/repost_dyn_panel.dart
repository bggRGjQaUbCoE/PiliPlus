import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_publish_page.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/pages/video/detail/reply_new/toolbar_icon_button.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class RepostPanel extends CommonPublishPage {
  const RepostPanel({
    super.key,
    this.item,
    this.callback,
    // video
    this.rid,
    this.dynType,
    this.pic,
    this.title,
    this.uname,
    this.isMax,
  });

  // video
  final int? rid;
  final int? dynType;
  final String? pic;
  final String? title;
  final String? uname;
  final bool? isMax;

  final DynamicItemModel? item;
  final VoidCallback? callback;

  @override
  State<RepostPanel> createState() => _RepostPanelState();
}

class _RepostPanelState extends CommonPublishPageState<RepostPanel> {
  late bool _isMax = widget.isMax ?? false;

  late final _pic = widget.pic ??
      widget.item?.modules.moduleDynamic?.major?.archive?.cover ??
      widget.item?.modules.moduleDynamic?.major?.pgc?.cover ??
      widget.item?.modules.moduleDynamic?.major?.opus?.pics?.firstOrNull?.url;

  late final _text = widget.title ??
      widget.item?.modules.moduleDynamic?.major?.opus?.summary?.text ??
      widget.item?.modules.moduleDynamic?.desc?.text ??
      widget.item?.modules.moduleDynamic?.major?.archive?.title ??
      widget.item?.modules.moduleDynamic?.major?.pgc?.title ??
      '';

  late final _uname = widget.uname ?? widget.item?.modules.moduleAuthor?.name;

  @override
  void dispose() {
    try {
      Get.delete<EmotePanelController>();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: _isMax ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: _isMax ? 16 : 10),
          _buildAppBar,
          if (_isMax) Expanded(child: _buildEditPanel) else _buildEditPanel,
          if (_isMax.not)
            ..._biuldDismiss
          else ...[
            _buildToolbar,
            buildPanelContainer(Colors.transparent),
          ]
        ],
      ),
    );
  }

  Widget get _buildEditPanel => Column(
        mainAxisSize: _isMax ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: _isMax.not
                    ? BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : null,
                child: _isMax.not ? _buildEditPlaceHolder : _buildEditWidget,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildRefWidget,
        ],
      );

  Widget get _buildRefWidget => Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh ==
                  Theme.of(context).colorScheme.surface
              ? Theme.of(context).colorScheme.onInverseSurface
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (_pic != null) ...[
              NetworkImgLayer(
                radius: 8,
                width: 40,
                height: 40,
                src: _pic,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_uname?.isNotEmpty == true)
                    Text(
                      '@$_uname',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  Text(
                    _text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget get _buildEditPlaceHolder => GestureDetector(
        onTap: () async {
          setState(() => _isMax = true);
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            focusNode.requestFocus();
          }
        },
        child: Text(
          '说点什么吧',
          style: TextStyle(
            height: 1.75,
            fontSize: 15,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      );

  Widget get _buildEditWidget => Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Listener(
          onPointerUp: (event) {
            if (readOnly.value) {
              updatePanelType(PanelType.keyboard);
              selectKeyboard.value = true;
            }
          },
          child: Obx(
            () => TextField(
              controller: editController,
              minLines: 4,
              maxLines: null,
              focusNode: focusNode,
              readOnly: readOnly.value,
              decoration: const InputDecoration(
                hintText: '说点什么吧',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
      );

  Widget get _buildAppBar => _isMax.not
      ? Row(
          children: [
            const SizedBox(width: 16),
            Text(
              widget.rid != null ? '分享至动态' : '转发动态',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: onPublish,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                visualDensity: const VisualDensity(
                  horizontal: -2,
                  vertical: -2,
                ),
              ),
              child: Text(widget.rid != null ? '立即发布' : '立即转发'),
            ),
            const SizedBox(width: 16),
          ],
        )
      : Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: IconButton(
                    tooltip: '返回',
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        return Theme.of(context).colorScheme.secondaryContainer;
                      }),
                    ),
                    onPressed: Get.back,
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.rid != null ? '分享至动态' : '转发动态',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: onPublish,
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                  child: Text(widget.rid != null ? '发布' : '转发'),
                ),
              ),
            ],
          ),
        );

  Widget get _buildToolbar => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Obx(
              () => ToolbarIconButton(
                onPressed: () {
                  selectKeyboard.value = PanelType.emoji == currentPanelType;
                  updatePanelType(
                    PanelType.emoji == currentPanelType
                        ? PanelType.keyboard
                        : PanelType.emoji,
                  );
                },
                icon: const Icon(Icons.emoji_emotions, size: 22),
                tooltip: '表情',
                selected: !selectKeyboard.value,
              ),
            ),
          ],
        ),
      );

  List<Widget> get _biuldDismiss => [
        const SizedBox(height: 10),
        Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        ListTile(
          dense: true,
          onTap: Get.back,
          title: Center(
            child: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
        SizedBox(height: 10 + MediaQuery.of(context).padding.bottom),
      ];

  @override
  Widget? customPanel(double height) => SizedBox(
        height: height,
        child: EmotePanel(onChoose: onChooseEmote),
      );

  @override
  Future onCustomPublish({required String message, List? pictures}) async {
    dynamic result = await MsgHttp.createDynamic(
      mid: Accounts.main.mid,
      dynIdStr: widget.item?.idStr,
      rid: widget.rid,
      dynType: widget.dynType,
      rawText: editController.text,
    );
    if (result['status']) {
      Get.back();
      SmartDialog.showToast('转发成功');
      widget.callback?.call();
      RequestUtils.insertCreatedDyn(result);
      RequestUtils.checkCreatedDyn(
        id: result['data']?['dyn_id'],
        dynText: editController.text,
      );
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }
}
