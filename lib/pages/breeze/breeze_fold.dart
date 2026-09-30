import 'dart:async';

import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:material_ui/material_ui.dart';

/// Classifies [source] with BiliBreeze and folds [child] into a one-line
/// hint when a selected category matches. Content stays visible until the
/// result arrives, and can always be expanded again.
class BreezeFold extends StatefulWidget {
  const BreezeFold({
    super.key,
    required this.kind,
    required this.source,
    required this.raw,
    required this.child,
  });

  final BreezeKind kind;

  /// The item being rendered; a different object means new content.
  final Object source;

  /// Built lazily, only while BiliBreeze is enabled for [kind].
  final BreezeRaw? Function() raw;
  final Widget child;

  @override
  State<BreezeFold> createState() => _BreezeFoldState();
}

class _BreezeFoldState extends State<BreezeFold> {
  StreamSubscription<BreezeEvent>? _sub;
  Timer? _timer;
  BreezeRaw? _raw;
  BreezeResult? _result;
  String? _error;
  bool _expanded = false;
  bool _policyChecking = false;
  int _epoch = 0;

  @override
  void initState() {
    super.initState();
    _sub = BreezeService.events.listen(_onEvent);
    _start();
  }

  @override
  void didUpdateWidget(BreezeFold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Compare the full input, not just the item: context such as a video's
    // title can arrive after the item itself.
    final raw = _buildRaw();
    // The list rebuilt the same content, e.g. after a refresh.
    if (raw?.identity == _raw?.identity) return;
    _reset();
    _raw = raw;
    _start();
  }

  @override
  void dispose() {
    _epoch++;
    _timer?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  BreezeRaw? _buildRaw() {
    final config = BreezeService.config;
    if (!config.kindEnabled(widget.kind) || !config.configured) return null;
    return widget.raw();
  }

  void _reset() {
    _epoch++;
    _timer?.cancel();
    _raw = null;
    _result = null;
    _error = null;
    _expanded = false;
  }

  void _start() {
    _timer?.cancel();
    final raw = _raw ??= _buildRaw();
    if (raw == null) return;
    // Usually prefetched while off screen, so render folded from the start.
    _result ??= BreezeService.peek(raw);
    _timer = Timer(Duration.zero, _run);
  }

  Future<void> _run() async {
    final raw = _raw;
    if (raw == null) return;
    final epoch = ++_epoch;
    bool stale() => !mounted || epoch != _epoch;
    try {
      final result = await BreezeService.detect(raw, cancelled: stale);
      if (stale()) return;
      setState(() {
        if (result.fold != _result?.fold) _expanded = false;
        _result = result;
        _error = null;
      });
    } on BreezeCancelled {
      return;
    } on BreezeException catch (e) {
      if (stale()) return;
      setState(() => _error = e.message);
      // Temporary failures (cooldown, network) are checked again later.
      if (e.retry) _timer = Timer(const Duration(minutes: 1), _run);
    } catch (e) {
      if (stale()) return;
      setState(() => _error = '检测失败');
    }
  }

  void _onEvent(BreezeEvent event) {
    if (!mounted) return;
    switch (event) {
      case BreezeSettingsChanged():
        setState(() {
          _reset();
          _start();
        });
      case BreezeAuthorChanged(:final uid):
        if (_raw?.authorId == uid && _result != null) _recheck();
    }
  }

  /// Applies a changed author policy; the classification comes from cache.
  Future<void> _recheck() async {
    final raw = _raw;
    if (raw == null || _policyChecking) return;
    _policyChecking = true;
    final epoch = _epoch;
    try {
      final result = await BreezeService.detect(raw);
      if (!mounted || epoch != _epoch) return;
      setState(() {
        if (result.fold != _result?.fold) _expanded = false;
        _result = result;
      });
    } catch (_) {
    } finally {
      _policyChecking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result != null && result.fold) {
      final bar = _Hint(
        label: foldLabel(_raw!, result),
        action: _expanded ? '收起' : '展开',
        expanded: _expanded,
        onTap: () => setState(() => _expanded = !_expanded),
      );
      // Folding itself is not animated; only the user's toggles are.
      return AnimatedSize(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 220),
        curve: const Cubic(.2, .7, .2, 1),
        alignment: Alignment.topCenter,
        child: _expanded
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [bar, widget.child],
              )
            : bar,
      );
    }
    if (_error case final error?) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.child,
          _Hint(
            label: error,
            action: '重试',
            onTap: () {
              setState(() => _error = null);
              _start();
            },
          ),
        ],
      );
    }
    return widget.child;
  }
}

class _Hint extends StatelessWidget {
  const _Hint({
    required this.label,
    required this.action,
    required this.onTap,
    this.expanded,
  });

  final String label;
  final String action;
  final VoidCallback onTap;
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final style = TextStyle(fontSize: 12, color: colorScheme.outline);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                Tooltip(
                  message: label,
                  child: Text(label, style: style),
                ),
                Semantics(
                  expanded: expanded,
                  child: TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.outline,
                      textStyle: const TextStyle(fontSize: 12),
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(action),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
