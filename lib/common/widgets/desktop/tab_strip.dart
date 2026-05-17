import 'package:PiliPlus/common/widgets/desktop/tab_manager.dart';
import 'package:PiliPlus/common/widgets/desktop/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabStrip extends StatelessWidget {
  const TabStrip({super.key, required this.tabManager});

  final TabManager tabManager;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = tabManager.tabs;
      final active = tabManager.activeIndex.value;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < tabs.length; i++)
            _TabItem(
              tab: tabs[i],
              isActive: i == active,
              onTap: () => tabManager.switchTo(i),
              onClose: tabs[i].pinned ? null : () => tabManager.closeTab(i),
            ),
          _NewTabButton(onTap: () => tabManager.openTab('/home')),
        ],
      );
    });
  }
}

class _TabItem extends StatefulWidget {
  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    this.onClose,
  });

  final TabModel tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPinned = widget.tab.pinned;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: isPinned ? 36 : 160,
          height: 32,
          margin: const EdgeInsets.only(top: 4, right: 1),
          padding: EdgeInsets.symmetric(horizontal: isPinned ? 0 : 8),
          decoration: BoxDecoration(
            color: widget.isActive
                ? colorScheme.surface
                : (_hovering
                    ? colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5)
                    : Colors.transparent),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: isPinned
              ? Center(
                  child: Icon(
                    widget.tab.icon,
                    size: 16,
                    color: widget.isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ClipRect(
                        child: Obx(() => _MarqueeText(
                              text: widget.tab.title.value,
                              hovering: _hovering,
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.isActive
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: AnimatedOpacity(
                        opacity: _hovering || widget.isActive ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MarqueeText extends StatefulWidget {
  const _MarqueeText({
    required this.text,
    required this.hovering,
    required this.style,
  });

  final String text;
  final bool hovering;
  final TextStyle style;

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _scrollController = ScrollController();
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MarqueeText old) {
    super.didUpdateWidget(old);
    if (widget.text != old.text) {
      _controller.stop();
      _controller.reset();
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checkOverflow();
      });
    }
    if (widget.hovering != old.hovering) {
      if (widget.hovering && _isOverflowing) {
        _startMarquee();
      } else {
        _stopMarquee();
      }
    }
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;
    _isOverflowing = _scrollController.position.maxScrollExtent > 0;
  }

  void _startMarquee() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return;
    final duration = Duration(milliseconds: (max * 30).toInt().clamp(1500, 8000));
    _controller.duration = duration;
    _controller.repeat();
  }

  void _stopMarquee() {
    _controller.stop();
    _controller.reset();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(max * _controller.value);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkOverflow();
    });
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        maxLines: 1,
        softWrap: false,
        style: widget.style,
      ),
    );
  }
}

class _NewTabButton extends StatefulWidget {
  const _NewTabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_NewTabButton> createState() => _NewTabButtonState();
}

class _NewTabButtonState extends State<_NewTabButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(left: 4, top: 4),
          decoration: BoxDecoration(
            color: _hovering
                ? colorScheme.surfaceContainerHighest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
