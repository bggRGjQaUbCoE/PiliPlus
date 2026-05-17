import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TabModel {
  TabModel({
    required this.id,
    required this.initialRoute,
    this.initialArguments,
    this.pinned = false,
    String? title,
    this.icon,
  })  : title = (title ?? '').obs,
        navigatorKey = GlobalKey<NavigatorState>();

  final String id;
  final String initialRoute;
  final dynamic initialArguments;
  final GlobalKey<NavigatorState> navigatorKey;
  final RxString title;
  final IconData? icon;
  final bool pinned;
}
