import 'package:PiliPlus/pages/follow_type/followed/controller.dart';
import 'package:PiliPlus/pages/follow_type/view.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();

  static void toFollowedPage({dynamic mid, String? name}) {
    if (mid == null) return;
    Get.toNamed(
      '/followed',
      arguments: {
        'mid': Utils.safeToInt(mid),
        'name': name,
      },
    );
  }
}

class _FollowedPageState extends FollowTypePageState<FollowedPage> {
  @override
  final controller = Get.putOrFind(
    FollowedController.new,
    tag: Get.arguments?['mid']?.toString() ?? Utils.generateRandomString(8),
  );

  @override
  PreferredSizeWidget get appBar => AppBar(
    title: Obx(
      () => Text(
        '我关注的${controller.total.value}人也关注了${controller.name.value ?? 'TA'}',
      ),
    ),
  );
}
