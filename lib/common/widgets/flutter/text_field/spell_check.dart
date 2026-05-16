// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

/// @docImport 'editable_text.dart';
library;

import 'package:PiliPlus/common/widgets/flutter/text_field/editable_text.dart'
    show EditableTextContextMenuBuilder;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show SpellCheckService;

/// Controls how spell check is performed for text input.
///
/// This configuration determines the [SpellCheckService] used to fetch the
/// [List<SuggestionSpan>] spell check results and the [TextStyle] used to
/// mark misspelled words within text input.
@immutable
class SpellCheckConfiguration {
  /// Creates a configuration that specifies the service and suggestions handler
  /// for spell check.
  const SpellCheckConfiguration({
    this.spellCheckService,
    this.misspelledSelectionColor,
    this.misspelledTextStyle,
    this.spellCheckSuggestionsToolbarBuilder,
  }) : _spellCheckEnabled = true;

  /// Creates a configuration that disables spell check.
  const SpellCheckConfiguration.disabled()
    : _spellCheckEnabled = false,
      spellCheckService = null,
      spellCheckSuggestionsToolbarBuilder = null,
      misspelledTextStyle = null,
      misspelledSelectionColor = null;

  /// The service used to fetch spell check results for text input.
  final SpellCheckService? spellCheckService;

  /// The color the paint the selection highlight when spell check is showing
  /// suggestions for a misspelled word.
  ///
  /// For example, on iOS, the selection appears red while the spell check menu
  /// is showing.
  final Color? misspelledSelectionColor;

  /// Style used to indicate misspelled words.
  ///
  /// This is nullable to allow style-specific wrappers of [EditableText]
  /// to infer this, but this must be specified if this configuration is
  /// provided directly to [EditableText] or its construction will fail with an
  /// assertion error.
  final TextStyle? misspelledTextStyle;

  /// Builds the toolbar used to display spell check suggestions for misspelled
  /// words.
  final EditableTextContextMenuBuilder? spellCheckSuggestionsToolbarBuilder;

  final bool _spellCheckEnabled;

  /// Whether or not the configuration should enable or disable spell check.
  bool get spellCheckEnabled => _spellCheckEnabled;

  /// Returns a copy of the current [SpellCheckConfiguration] instance with
  /// specified overrides.
  SpellCheckConfiguration copyWith({
    SpellCheckService? spellCheckService,
    Color? misspelledSelectionColor,
    TextStyle? misspelledTextStyle,
    EditableTextContextMenuBuilder? spellCheckSuggestionsToolbarBuilder,
  }) {
    if (!_spellCheckEnabled) {
      // A new configuration should be constructed to enable spell check.
      return const SpellCheckConfiguration.disabled();
    }

    return SpellCheckConfiguration(
      spellCheckService: spellCheckService ?? this.spellCheckService,
      misspelledSelectionColor:
          misspelledSelectionColor ?? this.misspelledSelectionColor,
      misspelledTextStyle: misspelledTextStyle ?? this.misspelledTextStyle,
      spellCheckSuggestionsToolbarBuilder:
          spellCheckSuggestionsToolbarBuilder ??
          this.spellCheckSuggestionsToolbarBuilder,
    );
  }

  @override
  String toString() {
    return '${objectRuntimeType(this, 'SpellCheckConfiguration')}('
        '${_spellCheckEnabled ? 'enabled' : 'disabled'}, '
        'service: $spellCheckService, '
        'text style: $misspelledTextStyle, '
        'toolbar builder: $spellCheckSuggestionsToolbarBuilder'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SpellCheckConfiguration &&
        other.spellCheckService == spellCheckService &&
        other.misspelledTextStyle == misspelledTextStyle &&
        other.spellCheckSuggestionsToolbarBuilder ==
            spellCheckSuggestionsToolbarBuilder &&
        other._spellCheckEnabled == _spellCheckEnabled;
  }

  @override
  int get hashCode => Object.hash(
    spellCheckService,
    misspelledTextStyle,
    spellCheckSuggestionsToolbarBuilder,
    _spellCheckEnabled,
  );
}
