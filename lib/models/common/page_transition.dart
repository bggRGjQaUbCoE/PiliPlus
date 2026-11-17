import 'package:get/get.dart';

extension PageTransitionLabel on Transition {
  String get label => switch (this) {
    .fade => '上移淡入',
    .fadeIn => '淡入淡出',
    .rightToLeft => '从右滑入',
    .leftToRight => '从左滑入',
    .upToDown => '从上滑入',
    .downToUp => '从下滑入',
    .rightToLeftWithFade => '右入淡化',
    .leftToRightWithFade => '左入淡化',
    .zoom => '缩放',
    .topLevel => '顶层缩放',
    .noTransition => '无动画',
    .cupertino => 'iOS 风格滑动',
    .cupertinoDialog => 'iOS 风格对话框',
    .size => '尺寸展开',
    .circularReveal => '圆形展开',
    .native => '系统默认',
    .sharedAxis => '共享轴滑动',
  };
}
