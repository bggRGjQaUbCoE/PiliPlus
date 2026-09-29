import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/search/controller.dart' show DebounceStreamState;
import 'package:PiliPlus/pages/setting/models/extra_settings.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/models/play_settings.dart';
import 'package:PiliPlus/pages/setting/models/privacy_settings.dart';
import 'package:PiliPlus/pages/setting/models/recommend_settings.dart';
import 'package:PiliPlus/pages/setting/models/style_settings.dart';
import 'package:PiliPlus/pages/setting/models/video_settings.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:waterfall_flow/waterfall_flow.dart'
    hide SliverWaterfallFlowDelegateWithMaxCrossAxisExtent;

class SettingsSearchPage extends StatefulWidget {
  const SettingsSearchPage({super.key});

  @override
  State<SettingsSearchPage> createState() => _SettingsSearchPageState();
}

class _SettingsSearchPageState
    extends DebounceStreamState<SettingsSearchPage, String> {
  final _textEditingController = TextEditingController();
  final RxList<SettingsModel> _list = <SettingsModel>[].obs;
  List<SettingsModel> get _settings => [
    ...extraSettings,
    ...privacySettings,
    ...recommendSettings,
    ...videoSettings,
    ...playSettings,
    ...styleSettings,
  ];

  @override
  void initState() {
    super.initState();
    L10n.changes.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() => onValueChanged(_textEditingController.text);

  @override
  void onValueChanged(String value) {
    if (value.isEmpty) {
      _list.clear();
    } else {
      value = value.toLowerCase();
      _list.value = _settings
          .where(
            (item) =>
                item.effectiveTitle.toLowerCase().contains(value) ||
                item.effectiveSubtitle?.toLowerCase().contains(value) == true,
          )
          .toList();
    }
  }

  @override
  void dispose() {
    L10n.changes.removeListener(_onLanguageChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                _textEditingController.clear();
                _list.clear();
              } else {
                Get.back();
              }
            },
            icon: const Icon(Icons.clear),
          ),
          const SizedBox(width: 10),
        ],
        title: TextField(
          autofocus: true,
          controller: _textEditingController,
          textAlignVertical: TextAlignVertical.center,
          onChanged: ctr!.add,
          decoration: InputDecoration(
            isDense: true,
            hintText: L10n.current.search,
            visualDensity: .standard,
            border: InputBorder.none,
          ),
        ),
      ),
      body: ViewInsetsSafeArea(
        child: CustomScrollView(
          slivers: [
            ViewSliverSafeArea(
              sliver: Obx(
                () => _list.isEmpty
                    ? const HttpError()
                    : SliverWaterfallFlow(
                        gridDelegate:
                            SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: Grid.smallCardWidth * 2,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => _list[index].widget,
                          childCount: _list.length,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
