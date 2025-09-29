import 'package:PiliPlus/common/widgets/draggable_sheet/draggable_scrollable_sheet_dyn.dart'
    show DraggableScrollableSheet;
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/text_field/text_field.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart' hide DraggableScrollableSheet, TextField;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class RepostPanel extends CommonRichTextPubPage {
  const RepostPanel({
    super.key,
    this.item,
    this.dynIdStr,
    this.callback,
    // video
    this.rid,
    this.dynType,
    this.pic,
    this.title,
    this.uname,
  });

  // video
  final int? rid;
  final int? dynType;
  final String? pic;
  final String? title;
  final String? uname;

  final DynamicItemModel? item;
  final String? dynIdStr;
  final VoidCallback? callback;

  @override
  State<RepostPanel> createState() => _RepostPanelState();
}

class _RepostPanelState extends CommonRichTextPubPageState<RepostPanel> {
  late bool _isMax = false;
  late bool _isExpanded = false;

  late final _key = GlobalKey();

  late final String? _pic;
  late final String _text;
  late final String? _uname;

  @override
  void initState() {
    super.initState();
    late final modules = widget.item?.modules;
    late final moduleDynamic = modules?.moduleDynamic;
    late final major = moduleDynamic?.major;

    _pic =
        widget.pic ??
        major?.archive?.cover ??
        major?.pgc?.cover ??
        major?.opus?.pics?.firstOrNull?.url;

    _text =
        widget.title ??
        major?.opus?.summary?.text ??
        major?.archive?.title ??
        major?.pgc?.title ??
        moduleDynamic?.desc?.text ??
        '';

    _uname = widget.uname ?? modules?.moduleAuthor?.name;
  }

  @override
  void dispose() {
    Get
      ..delete<EmotePanelController>()
      ..delete<DynMentionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget page([ScrollController? scrollController]) => Column(
      key: _isMax ? _key : null,
      mainAxisSize: _isMax ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isMax) const SizedBox(height: 10),
        _buildAppBar(theme),
        if (_isMax) ...[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              children: _buildEditPanel(theme),
            ),
          ),
          _buildToolbar,
          buildPanelContainer(theme, Colors.transparent),
        ] else ...[
          ..._buildEditPanel(theme),
          ..._biuldDismiss(theme),
        ],
      ],
    );

    Widget child() => _isMax
        ? DraggableScrollableSheet(
            snap: true,
            expand: false,
            initialChildSize: 1,
            minChildSize: 0,
            maxChildSize: 1,
            snapSizes: const [1],
            builder: (context, scrollController) => page(scrollController),
          )
        : page();

    return _isExpanded
        ? child()
        : AnimatedSize(
            alignment: Alignment.topCenter,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
            child: child(),
          );
  }

  List<Widget> _buildEditPanel(ThemeData theme) => [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _isMax
          ? _buildEditWidget(theme)
          : DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              child: _buildEditPlaceHolder(theme),
            ),
    ),
    const SizedBox(height: 10),
    _buildRefWidget(theme),
  ];

  Widget _buildRefWidget(ThemeData theme) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          if (_pic != null) ...[
            NetworkImgLayer(
              radius: 6,
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
                      color: theme.colorScheme.primary,
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
    ),
  );

  Widget _buildEditPlaceHolder(ThemeData theme) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() => _isMax = true);
      Future.delayed(const Duration(milliseconds: 300), () {
        _isExpanded = true;
        if (mounted) {
          focusNode.requestFocus();
        }
      });
    },
    child: SizedBox(
      width: double.infinity,
      child: Text(
        '说点什么吧',
        style: TextStyle(
          height: 1.75,
          fontSize: 15,
          color: theme.colorScheme.outline,
        ),
      ),
    ),
  );

  Widget _buildEditWidget(ThemeData theme) => Form(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Listener(
      onPointerUp: (event) {
        if (readOnly.value) {
          updatePanelType(PanelType.keyboard);
        }
      },
      child: Obx(
        () => RichTextField(
          key: key,
          controller: editController,
          minLines: 4,
          maxLines: null,
          focusNode: focusNode,
          readOnly: readOnly.value,
          decoration: InputDecoration(
            hintText: '说点什么吧',
            hintStyle: TextStyle(color: theme.colorScheme.outline),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          // inputFormatters: [LengthLimitingTextInputFormatter(1000)],
        ),
      ),
    ),
  );

  Widget _buildAppBar(ThemeData theme) => !_isMax
      ? Row(
          children: [
            const SizedBox(width: 16),
            Text(
              widget.rid != null ? '分享至动态' : '转发动态',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: onPublish,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(widget.rid != null ? '立即发布' : '立即转发'),
            ),
            const SizedBox(width: 16),
          ],
        )
      : Container(
          height: 66,
          padding: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: IconButton(
                    tooltip: '返回',
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                      backgroundColor: WidgetStatePropertyAll(
                        theme.colorScheme.secondaryContainer,
                      ),
                    ),
                    onPressed: Get.back,
                    icon: Icon(
                      Icons.arrow_back_outlined,
                      size: 18,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.rid != null ? '分享至动态' : '转发动态',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
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
                    visualDensity: VisualDensity.compact,
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
      spacing: 16,
      children: [
        emojiBtn,
        atBtn,
      ],
    ),
  );

  List<Widget> _biuldDismiss(ThemeData theme) => [
    const SizedBox(height: 10),
    Divider(
      height: 1,
      color: theme.colorScheme.outline.withValues(alpha: 0.1),
    ),
    ListTile(
      dense: true,
      onTap: Get.back,
      title: Center(
        child: Text(
          '取消',
          style: TextStyle(color: theme.colorScheme.outline),
        ),
      ),
    ),
    SizedBox(height: 10 + MediaQuery.viewPaddingOf(context).bottom),
  ];

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  List<Map<String, dynamic>>? getRepostContent(DynamicItemModel item) {
    try {
      return [
        {"raw_text": "//", "type": 1, "biz_id": ""},
        {
          "raw_text": "@${item.modules.moduleAuthor!.name}",
          "type": 2,
          "biz_id": item.modules.moduleAuthor!.mid.toString(),
        },
        {"raw_text": ":", "type": 1, "biz_id": ""},
        ...item.modules.moduleDynamic!.desc!.richTextNodes!.map(
          (e) {
            int type;
            String bizId;
            switch (e.type) {
              case 'RICH_TEXT_NODE_TYPE_EMOJI':
                type = 9;
                bizId = '';
              case 'RICH_TEXT_NODE_TYPE_AT':
                type = 2;
                bizId = e.rid ?? '';
              case 'RICH_TEXT_NODE_TYPE_TEXT':
              default:
                type = 1;
                bizId = '';
            }
            return {
              "raw_text": e.origText,
              "type": type,
              "biz_id": bizId,
            };
          },
        ),
      ];
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> onCustomPublish({List? pictures}) async {
    SmartDialog.showLoading();
    List<Map<String, dynamic>>? richContent = getRichContent();
    final hasRichText = richContent != null;
    List<Map<String, dynamic>>? repostContent = widget.item?.orig != null
        ? getRepostContent(widget.item!)
        : null;
    if (hasRichText && repostContent != null) {
      richContent.addAll(repostContent);
    }
    var result = await DynamicsHttp.createDynamic(
      mid: Accounts.main.mid,
      dynIdStr: widget.item?.idStr ?? widget.dynIdStr,
      rid: widget.rid,
      dynType: widget.dynType,
      rawText: hasRichText ? null : editController.text,
      extraContent: richContent ?? repostContent,
    );
    SmartDialog.dismiss();
    if (result['status']) {
      hasPub = true;
      Get.back();
      SmartDialog.showToast('转发成功');
      widget.callback?.call();
      var id = result['data']?['dyn_id'];
      RequestUtils.insertCreatedDyn(id);
      RequestUtils.checkCreatedDyn(
        id: id,
        dynText: editController.rawText,
      );
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  @override
  void onSave() {}
}
