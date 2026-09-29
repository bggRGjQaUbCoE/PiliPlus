// =============================================================
// PiliPlus Windows 桌面化 · 内容限宽通用助手（纯 UI）
// 信息流/网格类页面共用：可用宽度超过 maxWidth 时内容居中排布，
// 不再横向铺满超宽屏；窄窗与非桌面端原样返回（无副作用）。
// =============================================================
import 'package:PiliPlus/common/widgets/desktop/hover_card.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_constrained_cross_axis.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:material_ui/material_ui.dart';

/// 桌面端把 [sliver] 限宽至 [maxWidth] 并居中；非桌面原样返回。
Widget desktopLimitSliver(Widget sliver, {double maxWidth = 1280}) =>
    PlatformUtils.isDesktop
    ? CenteredSliverConstrainedCrossAxis(maxExtent: maxWidth, sliver: sliver)
    : sliver;

/// 桌面端为卡片加 hover 反馈（视觉 + 可选悬停预取详情）；非桌面原样返回。
/// [prefetchBvid] 非空时，鼠标在卡片上停留约 400ms 后预取该视频详情。
Widget desktopCard(Widget card, {String? prefetchBvid}) =>
    PlatformUtils.isDesktop
    ? HoverCard(
        onHoverDelay: prefetchBvid == null
            ? null
            : () => PageUtils.prefetchVideoDetail(prefetchBvid),
        child: card,
      )
    : card;
