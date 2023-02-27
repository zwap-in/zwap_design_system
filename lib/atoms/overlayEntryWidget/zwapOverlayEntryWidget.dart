import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

extension _ZwapOverlayEntryChildExt on ZwapOverlayEntryChild {
  ZwapOverlayEntryChild _copyWithKey(GlobalKey<ZwapOverlayEntryChildState> key) => ZwapOverlayEntryChild(
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

  ZwapOverlayEntryChild({
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
      child: GestureDetector(behavior: HitTestBehavior.opaque, child: widget.child, onTap: () {}),
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

  @override
  void initState() {
    super.initState();
    PointerEventProvider.instance.addPointerDownListener(_pointerDownListener);
    PointerEventProvider.instance.addScrollListener(_scrollListener);

    /*  PointerEventProvider.instance.addScrollListener((s) {
      _close();
      /*  if (s is! ScrollUpdateNotification) return;
      late final Rect? _pos;

      switch (s.metrics.axis) {
        case Axis.horizontal:
          _pos = _widgetKey._move(Offset(s.scrollDelta ?? 0, 0));
          break;
        case Axis.vertical:
          _pos = _widgetKey._move(Offset(0, s.scrollDelta ?? 0));
          break;
      }

      Rect _safeArea = Rect.fromLTRB(30, 70, MediaQuery.of(context).size.width - 30, MediaQuery.of(context).size.height - 70);
      if (_pos == null) return;

      print('top: ${_pos.top <= _safeArea.top} -- bottom: ${_pos.bottom >= _safeArea.bottom}');
      //print('left: ${_pos.left <= _safeArea.left}');
      //print('right: ${_pos.right >= _safeArea.right}');

      bool _isInUnsafeArea() =>
          _pos!.top <= _safeArea.top || _pos.bottom >= _safeArea.bottom || _pos.left <= _safeArea.left || _pos.right >= _safeArea.right;

      return;
 */
      /*      switch (s.metrics.axis) {
        case Axis.horizontal:
          if (_intersection.left == 30) return _close();
          if (_intersection.right == 30) return _close();
          break;
        case Axis.vertical:
          print(_intersection);
          if (_intersection.top == 70) {
            print('top');
            return _close();
          }
          if (_intersection.bottom == 70) {
            print(_pos);
            print('bottom');
            return _close();
          }
          break;
      } */
    }); */
  }

  void _pointerDownListener(PointerDownEvent event) => _checkIfClose(event.position);
  void _scrollListener(ScrollNotification not) => _close();

  void _checkIfClose(Offset position) {
    Rect _widgetPos = _widgetKey.globalPaintBounds ?? Rect.zero;
    if (!_widgetPos.contains(position)) _close();
  }

  void _close() {
    PointerEventProvider.instance.removePointerListener(_pointerDownListener);
    PointerEventProvider.instance.removeScrollListener(_scrollListener);

    if (widget.entity?.mounted ?? false) widget.entity?.remove();
    if (widget.onAutoClose != null) widget.onAutoClose!();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.autoClose) return widget.child;

    return Stack(
      children: [
        widget.child._copyWithKey(_widgetKey),
      ],
    );
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

class _PointerEventProvider extends ChangeNotifier {
  final List<PointerListener<PointerUpEvent>> _pointerUpListeners;
  final List<PointerListener<PointerDownEvent>> _pointerDownListeners;
  final List<PointerListener<PointerCancelEvent>> _pointerCancelListeners;
  final List<PointerListener<PointerHoverEvent>> _pointerHoverListeners;
  final List<PointerListener<PointerMoveEvent>> _pointerMoveListeners;

  final List<ScrollListener> _scrollListener;

  _PointerEventProvider()
      : this._pointerUpListeners = [],
        this._pointerDownListeners = [],
        this._pointerCancelListeners = [],
        this._pointerHoverListeners = [],
        this._scrollListener = [],
        this._pointerMoveListeners = [];

  void addPointerUpListener(PointerListener<PointerUpEvent> listener) => _pointerUpListeners.add(listener);
  void addPointerDownListener(PointerListener<PointerDownEvent> listener) => _pointerDownListeners.add(listener);
  void addPointerCancelListener(PointerListener<PointerCancelEvent> listener) => _pointerCancelListeners.add(listener);
  void addPointerHoverListener(PointerListener<PointerHoverEvent> listener) => _pointerHoverListeners.add(listener);
  void addPointerMoveListener(PointerListener<PointerMoveEvent> listener) => _pointerMoveListeners.add(listener);

  void addScrollListener(ScrollListener listener) => _scrollListener.add(listener);

  void removePointerListener<T extends PointerEvent>(PointerListener<T> listener) {
    if (T is PointerUpEvent) _pointerUpListeners.remove(listener);
    if (T is PointerDownEvent) _pointerDownListeners.remove(listener);
    if (T is PointerCancelEvent) _pointerCancelListeners.remove(listener);
    if (T is PointerHoverEvent) _pointerHoverListeners.remove(listener);
    if (T is PointerMoveEvent) _pointerMoveListeners.remove(listener);
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
    for (ScrollListener l in _scrollListener) l(notification);
  }

  void _notifyAllIn<T extends PointerEvent>(List<PointerListener<T>> list, T e) {
    for (PointerListener<T> listener in list) listener(e);
  }
}
