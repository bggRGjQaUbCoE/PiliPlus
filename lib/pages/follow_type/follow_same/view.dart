import 'package:PiliPlus/pages/follow_type/follow_same/controller.dart';
import 'package:PiliPlus/pages/follow_type/view.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowSamePage extends StatefulWidget {
  const FollowSamePage({super.key});

  @override
  State<FollowSamePage> createState() => _FollowSamePageState();
}

class _FollowSamePageState extends FollowTypePageState<FollowSamePage> {
  @override
  final controller = Get.put(
    FollowSameController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  PreferredSizeWidget get appBar => AppBar(
    title: Obx(
      () {
        final name = controller.name.value;
        return Text('${name == null ? '' : '我与$name的'}共同关注');
      },
    ),
  );
}
