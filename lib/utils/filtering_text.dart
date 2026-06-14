import 'package:flutter/services.dart';

abstract final class FilteringText {
  static final decimal = [
    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
  ];
}
