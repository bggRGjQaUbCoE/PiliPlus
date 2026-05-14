import 'package:flutter/material.dart';

Widget scaffold({
  required Widget appBar,
  required Widget body,
}) {
  return Material(
    child: Column(
      children: [
        appBar,
        Expanded(child: body),
      ],
    ),
  );
}

Widget scaffold_({
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
