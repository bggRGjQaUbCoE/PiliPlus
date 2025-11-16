/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// created by bggRGjQaUbCoE on 2025/6/27
///

enum RichTextType { text, composing, at, emoji, vote, common }

class Emote {
  late String url;
  late double width;
  late double height;

  Emote({
    required this.url,
    required this.width,
    double? height,
  }) : height = height ?? width;
}

mixin RichTextTypeMixin {
  RichTextType get type;
  Emote? get emote;
  String? get id;
  String? get rawText;
}

extension TextEditingDeltaExt on TextEditingDelta {
  ({RichTextType type, String? rawText, Emote? emote, String? id}) get config {
    if (this case RichTextTypeMixin e) {
      return (type: e.type, rawText: e.rawText, emote: e.emote, id: e.id);
    }
    return (
      type: composing.isValid ? RichTextType.composing : RichTextType.text,
      rawText: null,
      emote: null,
      id: null,
    );
  }

  bool get isText {
    if (this case RichTextTypeMixin e) {
      return e.type == RichTextType.text;
    }
    return !composing.isValid;
  }

  bool get isComposing {
    return composing.isValid;
  }
}

class RichTextEditingDeltaInsertion extends TextEditingDeltaInsertion
    with RichTextTypeMixin {
  RichTextEditingDeltaInsertion({
    required super.oldText,
    required super.textInserted,
    required super.insertionOffset,
    required super.selection,
    required super.composing,
    RichTextType? type,
    this.emote,
    this.id,
    this.rawText,
  }) {
    this.type =
        type ??
        (composing.isValid ? RichTextType.composing : RichTextType.text);
  }

  @override
  late final RichTextType type;

  @override
  final Emote? emote;

  @override
  final String? id;

  @override
  final String? rawText;
}

class RichTextEditingDeltaReplacement extends TextEditingDeltaReplacement
    with RichTextTypeMixin {
  RichTextEditingDeltaReplacement({
    required super.oldText,
    required super.replacementText,
    required super.replacedRange,
    required super.selection,
    required super.composing,
    RichTextType? type,
    this.emote,
    this.id,
    this.rawText,
  }) {
    this.type =
        type ??
        (composing.isValid ? RichTextType.composing : RichTextType.text);
  }

  @override
  late final RichTextType type;

  @override
  final Emote? emote;

  @override
  final String? id;

  @override
  final String? rawText;
}

class RichTextItem {
  late RichTextType type;
  late String text;
  String? _rawText;
  late TextRange range;
  Emote? emote;
  String? id;

  String get rawText => _rawText ?? text;

  bool get isText => type == RichTextType.text;

  bool get isComposing => type == RichTextType.composing;

  bool get isRich => !isText && !isComposing;

  RichTextItem({
    this.type = RichTextType.text,
    required this.text,
    String? rawText,
    required this.range,
    this.emote,
    this.id,
  }) {
    _rawText = rawText;
  }

  RichTextItem.fromStart(
    this.text, {
    String? rawText,
    this.type = RichTextType.text,
    this.emote,
    this.id,
  }) {
    range = TextRange(start: 0, end: text.length);
    _rawText = rawText;
  }

  List<RichTextItem>? onInsert(
    TextEditingDeltaInsertion delta,
    RichTextEditingController controller,
  ) {
    final int insertionOffset = delta.insertionOffset;

    if (range.end < insertionOffset) {
      return null;
    }

    if (insertionOffset == 0 && range.start == 0) {
      final insertedLength = delta.textInserted.length;
      controller.newSelection = TextSelection.collapsed(offset: insertedLength);
      if (!isRich && delta.isText) {
        text = delta.textInserted + text;
        range = TextRange(start: range.start, end: range.start + text.length);
        return null;
      }
      range = TextRange(
        start: range.start + insertedLength,
        end: range.end + insertedLength,
      );
      final config = delta.config;
      final insertedItem = RichTextItem.fromStart(
        delta.textInserted,
        rawText: config.rawText,
        type: config.type,
        emote: config.emote,
        id: config.id,
      );
      return [insertedItem];
    }

    if (range.start >= insertionOffset) {
      final int insertedLength = delta.textInserted.length;
      range = TextRange(
        start: range.start + insertedLength,
        end: range.end + insertedLength,
      );
      return null;
    }

    if (range.end == insertionOffset) {
      final end = insertionOffset + delta.textInserted.length;
      controller.newSelection = TextSelection.collapsed(offset: end);
      if ((isText && delta.isText) || (isComposing && delta.isComposing)) {
        text += delta.textInserted;
        range = TextRange(start: range.start, end: end);
        return null;
      }
      final config = delta.config;
      final insertedItem = RichTextItem(
        type: config.type,
        emote: config.emote,
        id: config.id,
        text: delta.textInserted,
        rawText: config.rawText,
        range: TextRange(start: insertionOffset, end: end),
      );
      return [insertedItem];
    }

    if (!isRich &&
        range.start < insertionOffset &&
        range.end > insertionOffset) {
      final leadingText = text.substring(0, insertionOffset - range.start);
      final trailingString = text.substring(leadingText.length);
      final insertEnd = insertionOffset + delta.textInserted.length;
      controller.newSelection = TextSelection.collapsed(offset: insertEnd);
      if (delta.isText) {
        text = leadingText + delta.textInserted + trailingString;
        range = TextRange(
          start: range.start,
          end: range.start + text.length,
        );
        return null;
      }
      final config = delta.config;
      final insertedItem = RichTextItem(
        type: config.type,
        emote: config.emote,
        id: config.id,
        text: delta.textInserted,
        rawText: config.rawText,
        range: TextRange(start: insertionOffset, end: insertEnd),
      );
      final trailItem = RichTextItem(
        text: trailingString,
        range: TextRange(
          start: insertEnd,
          end: insertEnd + trailingString.length,
        ),
      );
      text = leadingText;
      range = TextRange(
        start: range.start,
        end: range.start + leadingText.length,
      );
      return [insertedItem, trailItem];
    }

    return null;
  }

  ({bool remove, bool cal})? onDelete(
    TextEditingDeltaDeletion delta,
    RichTextEditingController controller,
    int? delLength,
  ) {
    final deletedRange = delta.deletedRange;

    if (range.end <= deletedRange.start) {
      return null;
    }

    if (range.start >= deletedRange.end) {
      final length = delLength ?? delta.textDeleted.length;
      range = TextRange(
        start: range.start - length,
        end: range.end - length,
      );
      return null;
    }

    if (range.start < deletedRange.start && range.end > deletedRange.end) {
      if (isRich) {
        controller.newSelection = TextSelection.collapsed(offset: range.start);
        return (remove: true, cal: true);
      }
      text = text.replaceRange(
        deletedRange.start - range.start,
        deletedRange.end - range.start,
        '',
      );
      range = TextRange(start: range.start, end: range.start + text.length);
      controller.newSelection = TextSelection.collapsed(
        offset: deletedRange.start,
      );
      return null;
    }

    if (range.start >= deletedRange.start && range.end <= deletedRange.end) {
      if (range.start == deletedRange.start) {
        controller.newSelection = TextSelection.collapsed(offset: range.start);
      }
      return (remove: true, cal: false);
    }

    if (range.start < deletedRange.start && range.end <= deletedRange.end) {
      if (isRich) {
        controller.newSelection = TextSelection.collapsed(offset: range.start);
        return (remove: true, cal: true);
      }
      text = text.replaceRange(
        text.length - (range.end - deletedRange.start),
        null,
        '',
      );
      range = TextRange(
        start: range.start,
        end: deletedRange.start,
      );
      controller.newSelection = TextSelection.collapsed(
        offset: deletedRange.start,
      );
      return null;
    }

    if (range.start >= deletedRange.start && range.end > deletedRange.end) {
      final start = min(deletedRange.start, range.start);
      controller.newSelection = TextSelection.collapsed(offset: start);
      if (isRich) {
        return (remove: true, cal: true);
      }
      text = text.substring(deletedRange.end - range.start);
      range = TextRange(
        start: start,
        end: start + text.length,
      );
      return null;
    }

    return null;
  }

  ({bool remove, List<RichTextItem>? toAdd})? onReplace(
    TextEditingDeltaReplacement delta,
    RichTextEditingController controller,
  ) {
    final replacedRange = delta.replacedRange;

    if (range.end <= replacedRange.start) {
      return null;
    }

    if (range.start >= replacedRange.end) {
      final before = replacedRange.end - replacedRange.start;
      final after = delta.replacementText.length;
      final length = after - before;
      range = TextRange(
        start: range.start + length,
        end: range.end + length,
      );
      return null;
    }

    if (range.start < replacedRange.start && range.end > replacedRange.end) {
      if (!isRich) {
        if (delta.isText) {
          text = text.replaceRange(
            replacedRange.start - range.start,
            replacedRange.end - range.start,
            delta.replacementText,
          );
          final end = range.start + text.length;
          range = TextRange(start: range.start, end: end);
          controller.newSelection = TextSelection.collapsed(
            offset: replacedRange.start + delta.replacementText.length,
          );
          return null;
        } else {
          final leadingText = text.substring(
            0,
            replacedRange.start - range.start,
          );
          final trailString = text.substring(replacedRange.end - range.start);
          final insertEnd = replacedRange.start + delta.replacementText.length;
          controller.newSelection = TextSelection.collapsed(offset: insertEnd);
          final config = delta.config;
          final insertedItem = RichTextItem(
            type: config.type,
            emote: config.emote,
            id: config.id,
            text: delta.replacementText,
            rawText: config.rawText,
            range: TextRange(
              start: replacedRange.start,
              end: insertEnd,
            ),
          );
          final trailItem = RichTextItem(
            text: trailString,
            range: TextRange(
              start: insertEnd,
              end: insertEnd + trailString.length,
            ),
          );
          text = leadingText;
          range = TextRange(
            start: range.start,
            end: range.start + leadingText.length,
          );
          return (
            remove: false,
            toAdd: [insertedItem, trailItem],
          );
        }
      }
      final config = delta.config;
      text = delta.replacementText;
      type = config.type;
      emote = config.emote;
      id = config.id;
      final end = range.start + text.length;
      range = TextRange(start: range.start, end: end);
      controller.newSelection = TextSelection.collapsed(offset: end);
      return null;
    }

    if (range.start >= replacedRange.start && range.end <= replacedRange.end) {
      if (range.start == replacedRange.start) {
        text = delta.replacementText;
        final config = delta.config;
        _rawText = config.rawText;
        type = config.type;
        emote = config.emote;
        id = config.id;
        final end = range.start + text.length;
        range = TextRange(start: range.start, end: end);
        controller.newSelection = TextSelection.collapsed(offset: end);
        return (remove: false, toAdd: null);
      }
      return (remove: true, toAdd: null);
    }

    if (range.start < replacedRange.start && range.end <= replacedRange.end) {
      if (!isRich) {
        if (delta.isText) {
          text = text.replaceRange(
            text.length - (range.end - replacedRange.start),
            null,
            delta.replacementText,
          );
          final end = range.start + text.length;
          range = TextRange(start: range.start, end: end);
          controller.newSelection = TextSelection.collapsed(offset: end);
          return null;
        } else {
          text = text.replaceRange(
            text.length - (range.end - replacedRange.start),
            null,
            '',
          );
          range = TextRange(start: range.start, end: range.start + text.length);
          final end = replacedRange.start + delta.replacementText.length;
          final config = delta.config;
          final insertedItem = RichTextItem(
            text: delta.replacementText,
            rawText: config.rawText,
            type: config.type,
            emote: config.emote,
            id: config.id,
            range: TextRange(start: replacedRange.start, end: end),
          );
          controller.newSelection = TextSelection.collapsed(offset: end);
          return (remove: false, toAdd: [insertedItem]);
        }
      }
      text = delta.replacementText;
      final config = delta.config;
      type = config.type;
      emote = config.emote;
      id = config.id;
      final end = range.start + text.length;
      range = TextRange(start: range.start, end: end);
      controller.newSelection = TextSelection.collapsed(offset: end);
      return null;
    }

    if (range.start >= replacedRange.start && range.end > replacedRange.end) {
      if (range.start > replacedRange.start) {
        if (!isRich) {
          text = text.substring(replacedRange.end - range.start);
          final start = replacedRange.start + delta.replacementText.length;
          range = TextRange(start: start, end: start + text.length);
          return null;
        }
        return (remove: true, toAdd: null);
      }
      if (!isRich) {
        if (delta.isText) {
          text = text.replaceRange(
            0,
            replacedRange.end - range.start,
            delta.replacementText,
          );
          final end = range.start + text.length;
          range = TextRange(start: range.start, end: end);
          controller.newSelection = TextSelection.collapsed(offset: end);
          return null;
        } else {
          final end = range.start + delta.replacementText.length;
          final config = delta.config;
          final insertedItem = RichTextItem(
            text: delta.replacementText,
            rawText: config.rawText,
            type: config.type,
            emote: config.emote,
            id: config.id,
            range: TextRange(start: range.start, end: end),
          );
          controller.newSelection = TextSelection.collapsed(offset: end);
          text = text.substring(replacedRange.end - range.start);
          range = TextRange(start: end, end: end + text.length);
          return (remove: true, toAdd: [insertedItem]);
        }
      }
      text = delta.replacementText;
      final config = delta.config;
      type = config.type;
      emote = config.emote;
      id = config.id;
      final end = range.start + text.length;
      range = TextRange(start: range.start, end: end);
      controller.newSelection = TextSelection.collapsed(offset: end);
      return null;
    }

    return null;
  }

  @override
  String toString() {
    return '\ntype: [${type.name}],'
        'text: [$text],'
        'rawText: [$_rawText],'
        '\nrange: [TextRange(start: ${range.start}, end: ${range.end})]\n';
  }
}

class RichTextEditingController extends TextEditingController {
  RichTextEditingController({
    List<RichTextItem>? items,
    this.onMention,
  }) : super(
         text: items != null && items.isNotEmpty
             ? (StringBuffer()..writeAll(items.map((e) => e.text))).toString()
             : null,
       ) {
    if (items != null && items.isNotEmpty) {
      this.items.addAll(items);
    }
  }

  final VoidCallback? onMention;

  TextSelection newSelection = const TextSelection.collapsed(offset: 0);

  final List<RichTextItem> items = <RichTextItem>[];

  String get plainText {
    if (items.isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    for (var e in items) {
      buffer.write(e.text);
    }
    return buffer.toString();
  }

  String get rawText {
    if (items.isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    for (var e in items) {
      if (e.type == RichTextType.at) {
        buffer.write(e.text);
      } else {
        buffer.write(e.rawText);
      }
    }
    return buffer.toString();
  }

  void syncRichText(TextEditingDelta delta) {
    int? addIndex;
    List<RichTextItem>? toAdd;

    int? delLength;
    List<RichTextItem>? toDel;

    switch (delta) {
      case TextEditingDeltaInsertion e:
        if (e.textInserted == '@') {
          onMention?.call();
        }

        if (items.isEmpty) {
          final config = delta.config;
          items.add(
            RichTextItem.fromStart(
              delta.textInserted,
              rawText: config.rawText,
              type: config.type,
              emote: config.emote,
              id: config.id,
            ),
          );
          newSelection = TextSelection.collapsed(
            offset: delta.textInserted.length,
          );
          return;
        }
        for (int index = 0; index < items.length; index++) {
          List<RichTextItem>? newItems = items[index].onInsert(e, this);
          if (newItems != null) {
            addIndex = (e.insertionOffset == 0 && index == 0) ? 0 : index + 1;
            toAdd = newItems;
          }
        }

      case TextEditingDeltaDeletion e:
        for (int index = 0; index < items.length; index++) {
          final item = items[index];
          ({bool remove, bool cal})? res = item.onDelete(e, this, delLength);
          if (res != null) {
            if (res.remove) {
              (toDel ??= <RichTextItem>[]).add(item);
            }
            if (res.cal) {
              delLength ??= item.text.length;
            }
          }
        }

      case TextEditingDeltaReplacement e:
        for (int index = 0; index < items.length; index++) {
          final item = items[index];
          ({bool remove, List<RichTextItem>? toAdd})? res = item.onReplace(
            e,
            this,
          );
          if (res != null) {
            if (res.toAdd != null) {
              addIndex = res.remove
                  ? index
                  : (e.replacedRange.start == 0 && index == 0)
                  ? 0
                  : index + 1;
              (toAdd ??= <RichTextItem>[]).addAll(res.toAdd!);
            } else if (res.remove) {
              (toDel ??= <RichTextItem>[]).add(item);
            }
          }
        }

      case TextEditingDeltaNonTextUpdate e:
        newSelection = e.selection;
        if (newSelection.isCollapsed) {
          final newPos = dragOffset(newSelection.base);
          newSelection = newSelection.copyWith(
            baseOffset: newPos.offset,
            extentOffset: newPos.offset,
          );
        } else {
          final isNormalized =
              newSelection.baseOffset < newSelection.extentOffset;
          var startOffset = newSelection.start;
          var endOffset = newSelection.end;
          final newOffset = longPressOffset(startOffset, endOffset);
          startOffset = newOffset.startOffset;
          endOffset = newOffset.endOffset;
          newSelection = newSelection.copyWith(
            baseOffset: isNormalized ? startOffset : endOffset,
            extentOffset: isNormalized ? endOffset : startOffset,
          );
        }
    }

    if (addIndex != null && toAdd?.isNotEmpty == true) {
      items.insertAll(addIndex, toAdd!);
    }
    if (toDel?.isNotEmpty == true) {
      for (var item in toDel!) {
        items.remove(item);
      }
    }
  }

  TextStyle? composingStyle;
  TextStyle? richStyle;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );

    final bool composingRegionOutOfRange =
        !value.isComposingRangeValid || !withComposing;

    // if (composingRegionOutOfRange) {
    //   return TextSpan(style: style, text: text);
    // }

    // bool isValid = true;
    // int cursor = 0;
    // for (var e in items) {
    //   final range = e.range;
    //   if (range.start == cursor) {
    //     cursor = range.end;
    //   } else {
    //     isValid = false;
    //     break;
    //   }
    // }
    // debugPrint('isValid: $isValid,,${text.length},,${plainText.length}');
    // debugPrint('$items\n$selection');

    return TextSpan(
      style: style,
      children: items.map((e) {
        switch (e.type) {
          case RichTextType.text:
            return TextSpan(text: e.text);
          case RichTextType.composing:
            composingStyle ??=
                style?.merge(
                  const TextStyle(decoration: TextDecoration.underline),
                ) ??
                const TextStyle(decoration: TextDecoration.underline);
            if (composingRegionOutOfRange) {
              e.type = RichTextType.text;
            }
            return TextSpan(
              text: e.text,
              style: composingRegionOutOfRange ? null : composingStyle,
            );
          case RichTextType.at || RichTextType.common:
            richStyle ??= (style ?? const TextStyle()).copyWith(
              color: Theme.of(context).colorScheme.primary,
            );
            return TextSpan(
              text: e.text,
              style: richStyle,
            );
          case RichTextType.emoji:
            final emote = e.emote;
            if (emote != null) {
              return WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: NetworkImgLayer(
                    src: emote.url,
                    width: 22, // emote.width,
                    height: 22, // emote.height,
                    type: ImageType.emote,
                    boxFit: BoxFit.contain,
                  ),
                ),
              );
            }
            return TextSpan(text: e.text);
          case RichTextType.vote:
            richStyle ??= (style ?? const TextStyle()).copyWith(
              color: Theme.of(context).colorScheme.primary,
            );
            return TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    size: 22,
                    color: richStyle!.color,
                  ),
                ),
                TextSpan(
                  text: '${e.rawText} ',
                  style: richStyle,
                ),
              ],
            );
        }
      }).toList(),
    );

    // final TextStyle composingStyle =
    //     style?.merge(const TextStyle(decoration: TextDecoration.underline)) ??
    //         const TextStyle(decoration: TextDecoration.underline);
    // return TextSpan(
    //   style: style,
    //   children: <TextSpan>[
    //     TextSpan(text: value.composing.textBefore(value.text)),
    //     TextSpan(
    //         style: composingStyle,
    //         text: value.composing.textInside(value.text)),
    //     TextSpan(text: value.composing.textAfter(value.text)),
    //   ],
    // );
  }

  @override
  void clear() {
    items.clear();
    super.clear();
  }

  @override
  void dispose() {
    items.clear();
    super.dispose();
  }

  TextPosition dragOffset(TextPosition position) {
    final offset = position.offset;
    for (var e in items) {
      final range = e.range;
      if (offset >= range.end) {
        continue;
      }
      if (offset <= range.start) {
        break;
      }
      if (e.isRich) {
        if (offset * 2 > range.start + range.end) {
          return TextPosition(offset: range.end);
        } else {
          return TextPosition(offset: range.start);
        }
      }
    }
    return position;
  }

  int tapOffsetSimple(int offset) {
    for (var e in items) {
      final range = e.range;
      if (offset >= range.end) {
        continue;
      }
      if (offset <= range.start) {
        break;
      }
      if (e.isRich) {
        if (offset * 2 > range.start + range.end) {
          return range.end;
        } else {
          return range.start;
        }
      }
    }
    return offset;
  }

  int tapOffset(
    int offset, {
    required TextPainter textPainter,
    required Offset localPos,
    required Offset lastTapDownPosition,
  }) {
    for (var e in items) {
      final range = e.range;
      if (offset >= range.end) {
        continue;
      }
      if (offset < range.start) {
        break;
      }
      // emoji tap
      if (offset == range.start) {
        if (e.emote != null) {
          final cloestOffset = textPainter.getClosestGlyphForOffset(localPos);
          if (cloestOffset != null) {
            final offsetRect = cloestOffset.graphemeClusterLayoutBounds;
            final offsetRange = cloestOffset.graphemeClusterCodeUnitRange;
            if (lastTapDownPosition.dx > offsetRect.right) {
              return offsetRange.end;
            } else {
              return offsetRange.start;
            }
          }
        }
      } else {
        if (e.isRich) {
          if (offset * 2 > range.start + range.end) {
            return range.end;
          } else {
            return range.start;
          }
        }
      }
    }
    return offset;
  }

  ({int startOffset, int endOffset}) longPressOffset(
    int startOffset,
    int endOffset,
  ) {
    for (var e in items) {
      final range = e.range;
      if (startOffset >= range.end) {
        continue;
      }
      if (endOffset <= range.start) {
        break;
      }
      late final cal = range.start + range.end;
      if (startOffset > range.start && startOffset < range.end) {
        if (e.isRich) {
          if (startOffset * 2 > cal) {
            startOffset = range.end;
          } else {
            startOffset = range.start;
          }
        }
      }
      if (endOffset > range.start && endOffset < range.end) {
        if (e.isRich) {
          if (endOffset * 2 > cal) {
            endOffset = range.end;
          } else {
            endOffset = range.start;
          }
        }
      }
    }
    return (startOffset: startOffset, endOffset: endOffset);
  }

  TextSelection keyboardOffset(TextSelection newSelection) {
    final offset = newSelection.baseOffset;
    for (var e in items) {
      final range = e.range;
      if (offset >= range.end) {
        continue;
      }
      if (offset <= range.start) {
        break;
      }
      if (offset > range.start && offset < range.end) {
        if (e.isRich) {
          if (offset < selection.baseOffset) {
            return newSelection.copyWith(
              baseOffset: range.start,
              extentOffset: range.start,
            );
          } else {
            return newSelection.copyWith(
              baseOffset: range.end,
              extentOffset: range.end,
            );
          }
        }
      }
    }
    return newSelection;
  }

  TextSelection keyboardOffsets(TextSelection newSelection) {
    final startOffset = newSelection.start;
    final endOffset = newSelection.end;
    final isNormalized = newSelection.baseOffset < newSelection.extentOffset;
    for (var e in items) {
      final range = e.range;
      if (startOffset >= range.end) {
        continue;
      }
      if (endOffset <= range.start) {
        break;
      }
      if (isNormalized) {
        if (startOffset <= range.start &&
            endOffset > range.start &&
            endOffset < range.end) {
          if (e.isRich) {
            if (endOffset < selection.extentOffset) {
              return newSelection.copyWith(
                baseOffset: startOffset,
                extentOffset: range.start,
              );
            } else {
              return newSelection.copyWith(
                baseOffset: startOffset,
                extentOffset: range.end,
              );
            }
          }
        }
      } else {
        if (startOffset < range.end && startOffset > range.start) {
          if (e.isRich) {
            if (startOffset > selection.extentOffset) {
              return newSelection.copyWith(
                baseOffset: endOffset,
                extentOffset: range.end,
              );
            } else {
              return newSelection.copyWith(
                baseOffset: endOffset,
                extentOffset: range.start,
              );
            }
          }
        }
      }
    }
    return newSelection;
  }

  String? getSelectionText(TextSelection selection) {
    try {
      String text = '';
      final start = selection.start;
      final end = selection.end;
      for (var e in items) {
        final range = e.range;
        if (start >= range.end) {
          continue;
        }
        if (end <= range.start) {
          break;
        }
        if (e.isRich) {
          if (e.emote != null) {
            text += e.rawText;
          } else {
            text += e.text;
          }
        } else {
          text += e.text.substring(
            max(start, range.start) - range.start,
            min(end, range.end) - range.start,
          );
        }
      }
      return text;
    } catch (e) {
      if (kDebugMode) debugPrint('err getSelectionText: $e');
      return null;
    }
  }
}
