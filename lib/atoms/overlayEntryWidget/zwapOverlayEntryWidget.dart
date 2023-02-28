import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

extension _ZwapOverlayEntryChildExt on ZwapOverlayEntryChild {
  ZwapOverlayEntryChild _copyWithWrapper(Widget Function(BuildContext, Widget) wrapper) => ZwapOverlayEntryChild._wrap(
        wrapper,
        key: key,
        height: height,
        width: width,
        top: top,
        left: left,
        bottom: bottom,
        right: right,
        child: child,
      );
}

extension ZwapOverlayEntryChildStateExt on GlobalKey<ZwapOverlayEntryChildState> {
  void updatePosition({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      currentState?._updatePosition(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
      );

  Rect? _move(Offset offset) {
    ZwapOverlayEntryChild? _child = this.currentWidget as ZwapOverlayEntryChild?;
    ZwapOverlayEntryChildState? _state = this.currentState;

    double? _left = _state?._left;
    double? _top = _state?._top;
    double? _right = _state?._right;
    double? _bottom = _state?._bottom;

    if (_left != null) _left -= offset.dx;
    if (_top != null) _top -= offset.dy;
    if (_right != null) _right += offset.dx;
    if (_bottom != null) _bottom += offset.dy;

    currentState?._updatePosition(
      left: _left,
      top: _top,
      right: _right,
      bottom: _bottom,
      width: _child?.width,
      height: _child?.height,
      duration: Duration.zero,
    );

    return globalPaintBounds;
  }
}

class ZwapOverlayEntryChild extends StatefulWidget {
  final Widget child;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  final Widget Function(BuildContext, Widget)? _wrapper;

  ZwapOverlayEntryChild({
    Key? key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  })  : this._wrapper = null,
        super(key: key);

  ZwapOverlayEntryChild._wrap(
    this._wrapper, {
    Key? key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  }) : super(key: key);

  @override
  State<ZwapOverlayEntryChild> createState() => ZwapOverlayEntryChildState();
}

class ZwapOverlayEntryChildState extends State<ZwapOverlayEntryChild> {
  Duration? _overrideDuration;

  late double? _left;
  late double? _top;
  late double? _right;
  late double? _bottom;
  late double? _width;
  late double? _height;

  @override
  void initState() {
    super.initState();

    _left = widget.left;
    _top = widget.top;
    _right = widget.right;
    _bottom = widget.bottom;
    _width = widget.width;
    _height = widget.height;
  }

  @override
  void didUpdateWidget(covariant ZwapOverlayEntryChild oldWidget) {
    if (mounted)
      setState(() {
        _left = widget.left;
        _top = widget.top;
        _right = widget.right;
        _bottom = widget.bottom;
        _width = widget.width;
        _height = widget.height;
      });

    super.didUpdateWidget(oldWidget);
  }

  void _updatePosition({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
    Duration? duration,
  }) {
    if (!mounted) return;
    setState(() {
      _overrideDuration = duration;
      if (left != null) _left = left;
      if (top != null) _top = top;
      if (right != null) _right = right;
      if (bottom != null) _bottom = bottom;
      if (width != null) _width = width;
      if (height != null) _height = height;
    });

    if (duration != null) {
      Future.delayed(duration, () {
        if (!mounted) return;
        setState(() => _overrideDuration = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _overrideDuration ?? const Duration(milliseconds: 75),
      curve: Curves.decelerate,
      left: _left,
      top: _top,
      right: _right,
      bottom: _bottom,
      width: _width,
      height: _height,
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: widget._wrapper == null
              ? widget.child
              : widget._wrapper!(
                  context,
                  widget.child,
                ),
          onTap: () {}),
    );
  }
}

class ZwapOverlayEntryWidget extends StatefulWidget {
  /// If true widget will close automatically
  /// on clicking outside child
  ///
  /// Default to true
  final bool autoClose;
  final ZwapOverlayEntryChild child;

  final OverlayEntry? entity;

  final Function()? onAutoClose;

  const ZwapOverlayEntryWidget({
    Key? key,
    this.autoClose = true,
    required this.child,
    required this.entity,
    this.onAutoClose,
  }) : super(key: key);

  @override
  State<ZwapOverlayEntryWidget> createState() => _ZwapOverlayEntryWidgetState();
}

class _ZwapOverlayEntryWidgetState extends State<ZwapOverlayEntryWidget> {
  final GlobalKey<ZwapOverlayEntryChildState> _widgetKey = GlobalKey<ZwapOverlayEntryChildState>();
  late OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entity;

    PointerEventProvider.instance.addPointerDownListener(_pointerDownListener, [_entry.hashCode.toString()]);
    PointerEventProvider.instance.addScrollListener(_scrollListener, [_entry.hashCode.toString()]);
  }

  void _pointerDownListener(PointerDownEvent event) {
    Rect _widgetRect = _widgetKey.globalPaintBounds ?? Rect.zero;

    if (_widgetRect.contains(event.position)) return;
    _close();
  }

  void _scrollListener(ScrollNotification not) => _close();

  void _close() {
    PointerEventProvider.instance.removePointerListener(_pointerDownListener);
    PointerEventProvider.instance.removeScrollListener(_scrollListener);

    if (widget.autoClose) {
      if (_entry?.mounted ?? false) {
        _entry?.remove();
        _entry = null;
      }

      if (widget.onAutoClose != null) widget.onAutoClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child._copyWithWrapper((_, child) => Container(
            key: _widgetKey,
            child: child,
          ))
    ]);
  }
}

class AppListenerWrapper extends StatefulWidget {
  final Widget child;
  const AppListenerWrapper({required this.child, super.key});

  @override
  State<AppListenerWrapper> createState() => _AppListenerWrapperState();
}

class _AppListenerWrapperState extends State<AppListenerWrapper> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (not) {
        PointerEventProvider.instance._notifyScroll(not);
        return false;
      },
      child: Listener(
        onPointerUp: (e) => PointerEventProvider.instance._notifyPointer(e),
        onPointerDown: (e) => PointerEventProvider.instance._notifyPointer(e),
        onPointerCancel: (e) => PointerEventProvider.instance._notifyPointer(e),
        onPointerHover: (e) => PointerEventProvider.instance._notifyPointer(e),
        onPointerMove: (e) => PointerEventProvider.instance._notifyPointer(e),
        child: widget.child,
      ),
    );
  }
}

typedef PointerListener<T extends PointerEvent> = FutureOr<void> Function(T);
typedef ScrollListener = FutureOr<void> Function(ScrollNotification);

class PointerEventProvider {
  static PointerEventProvider? __instance;
  static PointerEventProvider get _instance => __instance ??= PointerEventProvider._();

  final _PointerEventProvider _provider;

  PointerEventProvider._() : this._provider = _PointerEventProvider();

  static _PointerEventProvider get instance => _instance._provider;
}

class _PointerListenerDecorator<T extends PointerEvent> {
  PointerListener<T> listener;
  List<String> tags;

  _PointerListenerDecorator(this.listener, this.tags);
}

class _ScrollListenerDecorator {
  ScrollListener listener;
  List<String> tags;

  _ScrollListenerDecorator(this.listener, this.tags);
}

class _PointerEventProvider extends ChangeNotifier {
  final List<_PointerListenerDecorator<PointerUpEvent>> _pointerUpListeners;
  final List<_PointerListenerDecorator<PointerDownEvent>> _pointerDownListeners;
  final List<_PointerListenerDecorator<PointerCancelEvent>> _pointerCancelListeners;
  final List<_PointerListenerDecorator<PointerHoverEvent>> _pointerHoverListeners;
  final List<_PointerListenerDecorator<PointerMoveEvent>> _pointerMoveListeners;

  final List<_ScrollListenerDecorator> _scrollListener;

  _PointerEventProvider()
      : this._pointerUpListeners = [],
        this._pointerDownListeners = [],
        this._pointerCancelListeners = [],
        this._pointerHoverListeners = [],
        this._scrollListener = [],
        this._pointerMoveListeners = [];

  void addPointerUpListener(PointerListener<PointerUpEvent> listener, [List<String> tags = const []]) =>
      _pointerUpListeners.add(_PointerListenerDecorator(listener, tags));

  void addPointerDownListener(PointerListener<PointerDownEvent> listener, [List<String> tags = const []]) =>
      _pointerDownListeners.add(_PointerListenerDecorator(listener, tags));

  void addPointerCancelListener(PointerListener<PointerCancelEvent> listener, [List<String> tags = const []]) =>
      _pointerCancelListeners.add(_PointerListenerDecorator(listener, tags));

  void addPointerHoverListener(PointerListener<PointerHoverEvent> listener, [List<String> tags = const []]) =>
      _pointerHoverListeners.add(_PointerListenerDecorator(listener, tags));

  void addPointerMoveListener(PointerListener<PointerMoveEvent> listener, [List<String> tags = const []]) =>
      _pointerMoveListeners.add(_PointerListenerDecorator(listener, tags));

  void addScrollListener(ScrollListener listener, [List<String> tags = const []]) => _scrollListener.add(_ScrollListenerDecorator(listener, tags));

  void removePointerListener<T extends PointerEvent>(PointerListener<T> listener) {
    if (T == PointerUpEvent) _pointerUpListeners.removeWhere((d) => d.listener == listener);
    if (T == PointerDownEvent) _pointerDownListeners.removeWhere((d) => d.listener == listener);
    if (T == PointerCancelEvent) _pointerCancelListeners.removeWhere((d) => d.listener == listener);
    if (T == PointerHoverEvent) _pointerHoverListeners.removeWhere((d) => d.listener == listener);
    if (T == PointerMoveEvent) _pointerMoveListeners.removeWhere((d) => d.listener == listener);
  }

  void removeScrollListener(ScrollListener listener) => _scrollListener.remove(listener);

  void _notifyPointer(PointerEvent event) {
    if (event is PointerUpEvent) {
      _notifyAllIn(_pointerUpListeners, event);
    } else if (event is PointerDownEvent) {
      _notifyAllIn(_pointerDownListeners, event);
    } else if (event is PointerCancelEvent) {
      _notifyAllIn(_pointerCancelListeners, event);
    } else if (event is PointerHoverEvent) {
      _notifyAllIn(_pointerHoverListeners, event);
    } else if (event is PointerMoveEvent) {
      _notifyAllIn(_pointerMoveListeners, event);
    }
  }

  void _notifyScroll(ScrollNotification notification) {
    for (ScrollListener l in _scrollListener.map((d) => d.listener)) l(notification);
  }

  void _notifyAllIn<T extends PointerEvent>(List<_PointerListenerDecorator<T>> list, T e) {
    for (PointerListener<T> listener in list.map((d) => d.listener)) listener(e);
  }

  void removeAllRelatedToTag(String tag) {
    _pointerUpListeners.removeWhere((dec) => dec.tags.contains(tag));
    _pointerDownListeners.removeWhere((dec) => dec.tags.contains(tag));
    _pointerCancelListeners.removeWhere((dec) => dec.tags.contains(tag));
    _pointerHoverListeners.removeWhere((dec) => dec.tags.contains(tag));
    _pointerMoveListeners.removeWhere((dec) => dec.tags.contains(tag));
    _scrollListener.removeWhere((dec) => dec.tags.contains(tag));
  }
}

extension PointerEventProviderForEntry on _PointerEventProvider {
  void removeAllRelatedToEntry(OverlayEntry entry) => removeAllRelatedToTag(entry.hashCode.toString());
}
