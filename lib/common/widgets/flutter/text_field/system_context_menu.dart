// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: prefer_initializing_formals

/// @docImport 'package:flutter/material.dart';
library;

import 'package:PiliPlus/common/widgets/flutter/text_field/editable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide EditableText, EditableTextState, SystemContextMenu;
import 'package:flutter/services.dart';

/// Displays the system context menu on top of the Flutter view.
///
/// Currently, only supports iOS 16.0 and above and displays nothing on other
/// platforms.
///
/// The context menu is the menu that appears, for example, when doing text
/// selection. Flutter typically draws this menu itself, but this class deals
/// with the platform-rendered context menu instead.
///
/// There can only be one system context menu visible at a time. Building this
/// widget when the system context menu is already visible will hide the old one
/// and display this one. A system context menu that is hidden is informed via
/// [onSystemHide].
///
/// Pass [items] to specify the buttons that will appear in the menu. Any items
/// without a title will be given a default title from [WidgetsLocalizations].
///
/// By default, [items] will be set to the result of [getDefaultItems]. This
/// method considers the state of the [EditableTextState] so that, for example,
/// it will only include [IOSSystemContextMenuItemCopy] if there is currently a
/// selection to copy.
///
/// To check if the current device supports showing the system context menu,
/// call [isSupported].
///
/// {@tool dartpad}
/// This example shows how to create a [TextField] that uses the system context
/// menu where supported and does not show a system notification when the user
/// presses the "Paste" button.
///
/// ** See code in examples/api/lib/widgets/system_context_menu/system_context_menu.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [SystemContextMenuController], which directly controls the hiding and
///    showing of the system context menu.
class SystemContextMenu extends StatefulWidget {
  /// Creates an instance of [SystemContextMenu] that points to the given
  /// [anchor].
  const SystemContextMenu._({
    super.key,
    required this.anchor,
    required this.items,
    this.onSystemHide,
  });

  /// Creates an instance of [SystemContextMenu] for the field indicated by the
  /// given [EditableTextState].
  factory SystemContextMenu.editableText({
    Key? key,
    required EditableTextState editableTextState,
    List<IOSSystemContextMenuItem>? items,
  }) {
    final (
      startGlyphHeight: double startGlyphHeight,
      endGlyphHeight: double endGlyphHeight,
    ) = editableTextState
        .getGlyphHeights();

    return SystemContextMenu._(
      key: key,
      anchor: TextSelectionToolbarAnchors.getSelectionRect(
        editableTextState.renderEditable,
        startGlyphHeight,
        endGlyphHeight,
        editableTextState.renderEditable.getEndpointsForSelection(
          editableTextState.textEditingValue.selection,
        ),
      ),
      items: items ?? getDefaultItems(editableTextState),
      onSystemHide: () => editableTextState.hideToolbar(false),
    );
  }

  /// The [Rect] that the context menu should point to.
  final Rect anchor;

  /// A list of the items to be displayed in the system context menu.
  ///
  /// When passed, items will be shown regardless of the state of text input.
  /// For example, [IOSSystemContextMenuItemCopy] will produce a copy button
  /// even when there is no selection to copy. Use [EditableTextState] and/or
  /// the result of [getDefaultItems] to add and remove items based on the state
  /// of the input.
  ///
  /// Defaults to the result of [getDefaultItems].
  ///
  /// To add custom menu items, pass [IOSSystemContextMenuItemCustom] instances
  /// in the [items] list. Each custom item requires a title and an onPressed callback.
  ///
  /// See also:
  ///
  ///  * [IOSSystemContextMenuItemCustom], which creates custom menu items.
  final List<IOSSystemContextMenuItem> items;

  /// Called when the system hides this context menu.
  ///
  /// For example, tapping outside of the context menu typically causes the
  /// system to hide the menu.
  ///
  /// This is not called when showing a new system context menu causes another
  /// to be hidden.
  final VoidCallback? onSystemHide;

  /// Whether the current device supports showing the system context menu.
  ///
  /// Currently, this is only supported on newer versions of iOS.
  ///
  /// See also:
  ///
  ///  * [isSupportedByField], which uses this method and determines whether an
  ///    individual [EditableTextState] supports the system context menu.
  static bool isSupported(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS &&
        (MediaQuery.maybeSupportsShowingSystemContextMenu(context) ?? false);
  }

  /// Whether the given field supports showing the system context menu.
  ///
  /// Currently [SystemContextMenu] is only supported with an active
  /// [TextInputConnection]. In cases where this isn't possible, such as in a
  /// read-only field, fall back to using a Flutter-rendered context menu like
  /// [AdaptiveTextSelectionToolbar].
  ///
  /// See also:
  ///
  ///  * [isSupported], which is used by this method and determines whether the
  ///    platform in general supports showing the system context menu.
  static bool isSupportedByField(EditableTextState editableTextState) {
    return !editableTextState.widget.readOnly &&
        isSupported(editableTextState.context);
  }

  /// The default [items] for the given [EditableTextState].
  ///
  /// For example, [IOSSystemContextMenuItemCopy] will only be included when the
  /// field represented by the [EditableTextState] has a selection.
  ///
  /// See also:
  ///
  ///  * [EditableTextState.contextMenuButtonItems], which provides the default
  ///    [ContextMenuButtonItem]s for the Flutter-rendered context menu.
  static List<IOSSystemContextMenuItem> getDefaultItems(
    EditableTextState editableTextState,
  ) {
    final items = <IOSSystemContextMenuItem>[];

    // Use the generic Flutter-rendered context menu model as the single source of truth.
    for (final ContextMenuButtonItem button
        in editableTextState.contextMenuButtonItems) {
      switch (button.type) {
        case ContextMenuButtonType.copy:
          items.add(const IOSSystemContextMenuItemCopy());
        case ContextMenuButtonType.cut:
          items.add(const IOSSystemContextMenuItemCut());
        case ContextMenuButtonType.paste:
          items.add(const IOSSystemContextMenuItemPaste());
        case ContextMenuButtonType.selectAll:
          items.add(const IOSSystemContextMenuItemSelectAll());
        case ContextMenuButtonType.lookUp:
          items.add(const IOSSystemContextMenuItemLookUp());
        case ContextMenuButtonType.searchWeb:
          items.add(const IOSSystemContextMenuItemSearchWeb());
        case ContextMenuButtonType.share:
          items.add(const IOSSystemContextMenuItemShare());
        case ContextMenuButtonType.liveTextInput:
          items.add(const IOSSystemContextMenuItemLiveText());
        case ContextMenuButtonType.delete:
        // No native iOS system menu button for Delete — intentionally ignored.
        case ContextMenuButtonType.custom:
        // Custom items are provided explicitly via SystemContextMenu.items,
        // not via defaults. Intentionally ignore in default mapping.
      }
    }

    return items;
  }

  @override
  State<SystemContextMenu> createState() => _SystemContextMenuState();
}

class _SystemContextMenuState extends State<SystemContextMenu> {
  late final SystemContextMenuController _systemContextMenuController;

  @override
  void initState() {
    super.initState();
    _systemContextMenuController = SystemContextMenuController(
      onSystemHide: widget.onSystemHide,
    );
  }

  @override
  void dispose() {
    _systemContextMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(SystemContextMenu.isSupported(context));

    if (widget.items.isNotEmpty) {
      final WidgetsLocalizations localizations = WidgetsLocalizations.of(
        context,
      );
      final List<IOSSystemContextMenuItemData> itemDatas = widget.items
          .map((IOSSystemContextMenuItem item) => item.getData(localizations))
          .toList();
      _systemContextMenuController.showWithItems(widget.anchor, itemDatas);
    }

    return const SizedBox.shrink();
  }
}
