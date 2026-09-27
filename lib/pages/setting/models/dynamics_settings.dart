import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/user_whitelist.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get dynamicsSettings => [
  getListBanWordModel(
    title: '关键词过滤',
    key: SettingBoxKey.banWordForDyn,
    onChanged: (value) {
      DynamicsDataModel.banWordForDyn = value;
      DynamicsDataModel.enableFilter = value.pattern.isNotEmpty;
    },
  ),
  getListUidModel(
    title: '屏蔽用户',
    getUids: () => Pref.dynamicsBlockedMids,
    setUids: (uids) {
      Pref.dynamicsBlockedMids = uids;
      GlobalData().dynamicsBlockedMids = uids;
      DynamicsDataModel.dynamicsBlockedMids = uids;
    },
    onUpdate: () {
      // Changes are immediately reflected
    },
  ),
  getListUidWithNameModel(
    title: '白名单用户',
    leading: const Icon(Icons.person_add_alt_1_outlined),
    emptySubtitle: '点击添加白名单用户',
    countSubtitleBuilder: (count) => '已加入白名单 $count 个用户',
    getUidsMap: () => Pref.whitelistMids,
    setUidsMap: UserWhitelist.save,
    onUpdate: () {
      // Changes are immediately reflected
    },
  ),
  SwitchModel(
    title: '屏蔽带货动态',
    subtitle: '过滤包含商品推广的动态',
    leading: const Icon(Icons.shopping_bag_outlined),
    setKey: SettingBoxKey.antiGoodsDyn,
    defaultVal: false,
    onChanged: (value) {
      DynamicsDataModel.antiGoodsDyn = value;
    },
  ),
  SwitchModel(
    title: '屏蔽无权查看的动态',
    subtitle: '过滤当前账号无权查看的受限动态,如充电专属(文章,图文等)动态',
    leading: const Icon(Icons.visibility_off_outlined),
    setKey: SettingBoxKey.removeBlockedDyn,
    defaultVal: false,
    onChanged: (value) {
      DynamicsDataModel.removeBlockedDyn = value;
    },
  ),
  SwitchModel(
    title: '屏蔽充电专属视频动态',
    subtitle: '过滤充电专属视频动态',
    leading: const Icon(Icons.video_library_outlined),
    setKey: SettingBoxKey.removeOnlyFansVideoDyn,
    defaultVal: false,
    onChanged: (value) {
      DynamicsDataModel.removeOnlyFansVideoDyn = value;
    },
  ),
  SwitchModel(
    title: '屏蔽动态视频',
    subtitle: '过滤动态流中的动态视频（信息密度较低，仅非 UP 页生效）',
    leading: const Icon(Icons.smart_display_outlined),
    setKey: SettingBoxKey.removeDynVideoDyn,
    defaultVal: false,
    onChanged: (value) {
      DynamicsDataModel.removeDynVideoDyn = value;
    },
  ),
];
