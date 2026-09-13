import 'package:PiliPlus/common/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({
    super.key,
    required this.selected,
    required this.color,
  });

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      selected ? Assets.coinPaid : Assets.coinUnpaid,
      width: 22.5,
      height: 22.5,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: '投币',
    );
  }
}
