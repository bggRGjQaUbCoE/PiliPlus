import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:material_ui/material_ui.dart';

enum TeamInfoType { home, status, away }

class TeamInfoLayout
    extends SlottedMultiChildRenderObjectWidget<TeamInfoType, RenderBox> {
  const TeamInfoLayout({
    super.key,
    required this.homeTeam,
    required this.status,
    required this.awayTeam,
  });

  final Widget homeTeam;
  final Widget status;
  final Widget awayTeam;

  @override
  Widget childForSlot(TeamInfoType slot) => switch (slot) {
    .home => homeTeam,
    .status => status,
    .away => awayTeam,
  };

  @override
  RenderTeamInfoLayout createRenderObject(BuildContext context) {
    return RenderTeamInfoLayout();
  }

  @override
  Iterable<TeamInfoType> get slots => TeamInfoType.values;
}

const _spacing = 30.0;

class RenderTeamInfoLayout extends RenderBox
    with
        SlottedContainerRenderObjectMixin<TeamInfoType, RenderBox>,
        SlottedLayoutMixin {
  RenderBox get home => childForSlot(.home)!;
  RenderBox get status => childForSlot(.status)!;
  RenderBox get away => childForSlot(.away)!;

  @override
  Iterable<TeamInfoType> get slots => TeamInfoType.values;

  @override
  void performLayout() {
    final constraints = this.constraints;
    final c = constraints..loosen();

    final home = this.home;
    final homeSize = (home..layout(c, parentUsesSize: true)).size;

    final status = this.status;
    final statusSize = (status..layout(c, parentUsesSize: true)).size;

    final away = this.away;
    final awaySize = (away..layout(c, parentUsesSize: true)).size;

    final height = math.max(
      awaySize.height,
      math.max(homeSize.height, statusSize.height),
    );
    final maxTeamWidth = math.max(homeSize.width, awaySize.width);
    final width = (maxTeamWidth + _spacing) * 2 + statusSize.width;

    final maxWidth = constraints.maxWidth;
    double dx = maxWidth > width ? 0 : (maxWidth - width) / 2;
    setOffset(
      home,
      Offset(dx, (height - homeSize.height) / 2),
    );
    dx += maxTeamWidth + _spacing;
    setOffset(
      status,
      Offset(
        dx,
        (height - statusSize.height) / 2,
      ),
    );
    dx += maxTeamWidth + _spacing;
    setOffset(
      away,
      Offset(
        dx,
        (height - awaySize.height) / 2,
      ),
    );

    size = constraints.constrainDimensions(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      context.paintChild(child, getOffset(child) + offset);
    }
  }
}
