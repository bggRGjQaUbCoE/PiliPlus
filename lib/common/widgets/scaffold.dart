import 'package:flutter/material.dart';

Widget scaffold({
  Widget? appBar,
  required Widget body,
}) {
  if (appBar != null) {
    body = Column(
      children: [
        appBar,
        Expanded(child: body),
      ],
    );
  }
  return Material(
    child: body,
  );
}
