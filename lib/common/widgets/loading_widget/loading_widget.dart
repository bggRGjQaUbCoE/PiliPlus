import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:flutter/material.dart';

Widget get loadingWidget => const Center(child: CircularProgressIndicator());

Widget get linearLoading =>
    const SliverToBoxAdapter(child: LinearProgressIndicator());

Widget errorWidget({String? errMsg, VoidCallback? onReload}) => HttpError(
  isSliver: false,
  errMsg: errMsg,
  onReload: onReload,
);

Widget scrollErrorWidget({
  String? errMsg,
  VoidCallback? onReload,
  ScrollController? controller,
}) => CustomScrollView(
  controller: controller,
  slivers: [
    HttpError(
      errMsg: errMsg,
      onReload: onReload,
    ),
  ],
);
