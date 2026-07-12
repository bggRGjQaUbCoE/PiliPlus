import 'package:flutter/foundation.dart' show ValueGetter;

bool? safeToBool(dynamic value, [ValueGetter<String>? orString]) =>
    switch (value) {
      bool _ => value,
      int _ => value == 1,
      String _ => orString != null && value == orString(),
      _ => null,
    };
