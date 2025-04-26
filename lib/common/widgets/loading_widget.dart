import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:flutter/material.dart';

Widget get loadingWidget => Center(child: CircularProgressIndicator());

Widget errorWidget({errMsg, onReload}) => HttpError(
      isSliver: false,
      errMsg: errMsg,
      onReload: onReload,
    );

Widget scrollErrorWidget({errMsg, onReload, controller}) => CustomScrollView(
      controller: controller,
      slivers: [
        HttpError(
          errMsg: errMsg,
          onReload: onReload,
        )
      ],
    );
