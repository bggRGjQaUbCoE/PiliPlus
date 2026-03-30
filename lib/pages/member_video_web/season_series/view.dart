import 'package:PiliPlus/models/common/member/archive_sort_type_app.dart';
import 'package:PiliPlus/models/common/member/web_ss_type.dart';
import 'package:PiliPlus/models_new/member/season_web/archive.dart';
import 'package:PiliPlus/models_new/member/season_web/data.dart';
import 'package:PiliPlus/pages/member_video_web/base/view.dart';
import 'package:PiliPlus/pages/member_video_web/season_series/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSSWeb extends StatefulWidget {
  const MemberSSWeb({super.key});

  @override
  State<MemberSSWeb> createState() => _MemberSSWebState();

  static Future<void>? toMemberSSWeb({
    required WebSsType type,
    required Object id,
    required Object mid,
    required String name,
  }) {
    return Get.toNamed(
      '/ssWeb',
      arguments: {
        'type': type,
        'id': id,
        'mid': mid,
        'name': name,
      },
    );
  }
}

class _MemberSSWebState
    extends
        BaseVideoWebState<
          MemberSSWeb,
          SeasonWebData,
          SeasonArchive,
          ArchiveSortTypeApp
        > {
  @override
  late final MemberSSWebCtr controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MemberSSWebCtr(), tag: name);
  }

  @override
  List<ArchiveSortTypeApp> get values => ArchiveSortTypeApp.values;
}
