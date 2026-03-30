import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/models/common/member/archive_order_type_web.dart';
import 'package:PiliPlus/models_new/member/search_archive/data.dart';
import 'package:PiliPlus/models_new/member/search_archive/vlist.dart';
import 'package:PiliPlus/pages/member_video_web/archive/controller.dart';
import 'package:PiliPlus/pages/member_video_web/base/view.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberVideoWeb extends StatefulWidget {
  const MemberVideoWeb({super.key});

  @override
  State<MemberVideoWeb> createState() => _MemberVideoWebState();

  static Future<void>? toMemberVideoWeb({
    required Object mid,
    required String name,
  }) {
    return Get.toNamed(
      '/videoWeb',
      arguments: {
        'mid': mid,
        'name': name,
      },
    );
  }
}

class _MemberVideoWebState
    extends
        BaseVideoWebState<
          MemberVideoWeb,
          SearchArchiveData,
          VListItemModel,
          ArchiveOrderTypeWeb
        > {
  @override
  late final MemberVideoWebCtr controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MemberVideoWebCtr(), tag: name);
  }

  @override
  List<ArchiveOrderTypeWeb> get values => ArchiveOrderTypeWeb.values;

  @override
  Widget? buildTags(ColorScheme colorScheme) {
    if (controller.tags case final tags?) {
      return SliverPinnedHeader(
        backgroundColor: colorScheme.surface,
        child: SelfSizedHorizontalList(
          itemCount: tags.length,
          padding: const .fromLTRB(10, 0, 10, 8),
          itemBuilder: (context, index) {
            final item = tags[index];
            final isCurr = controller.specialType != null
                ? item.specialType == controller.specialType
                : item.tid == controller.tid;
            return SearchText(
              padding: const .symmetric(horizontal: 8, vertical: 4),
              text: '${item.name!} ${item.count}',
              bgColor: isCurr ? colorScheme.secondaryContainer : null,
              textColor: isCurr ? colorScheme.onSecondaryContainer : null,
              onTap: (_) {
                if (isCurr) return;
                controller
                  ..tid = item.tid ?? 0
                  ..specialType = item.specialType
                  ..onReload();
              },
            );
          },
          separatorBuilder: (_, _) => const SizedBox(width: 10),
        ),
      );
    }
    return null;
  }
}
