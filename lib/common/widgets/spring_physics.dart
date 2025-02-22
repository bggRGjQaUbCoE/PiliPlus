import 'package:flutter/cupertino.dart';
import 'package:PiliPlus/utils/storage.dart';

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  CustomTabBarViewScrollPhysics({super.parent});

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription spring = SpringDescription(
    mass: GStorage.springDescription[0],
    stiffness: GStorage.springDescription[1],
    damping: GStorage.springDescription[2]
  );
}

final customTabBarViewScrollPhysics = CustomTabBarViewScrollPhysics();