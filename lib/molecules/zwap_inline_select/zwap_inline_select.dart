import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:collection/collection.dart';

class ZwapInlineSelect<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final Widget Function(BuildContext, T item, Key key) builder;

  final Function(T item)? onSelected;

  const ZwapInlineSelect({
    required this.items,
    required this.selectedItem,
    required this.builder,
    this.onSelected,
    super.key,
  });

  @override
  State<ZwapInlineSelect<T>> createState() => _ZwapInlineSelectState<T>();
}

class _ZwapInlineSelectState<T> extends State<ZwapInlineSelect<T>> {
  bool _isGrabbing = false;
  T? __selectedItem;

  double _offset = 0;
  double _width = 0;

  GlobalKey _selectKey = GlobalKey();
  List<GlobalKey> _keys = [];

  bool _initialized = false;

  set _selectedItem(T? item) {
    __selectedItem = item;
    if (widget.onSelected != null && item != null) widget.onSelected!(item);

    _updatePositionsBySelected();
  }

  @override
  void initState() {
    super.initState();
    __selectedItem = widget.selectedItem;

    _keys = List.generate(widget.items.length, (i) => GlobalKey());
  }

  double _getOffsetOf(int x) {
    if (x < 0) return 0;
    if (x >= widget.items.length) return _keys[_keys.length - 1].globalOffset?.dx ?? 0 - (_selectKey.globalOffset?.dx ?? 0);
    return (_keys[x].globalOffset?.dx ?? 0) - (_selectKey.globalOffset?.dx ?? 0);
  }

  double _getWidthOf(int x) {
    if (x < 0 || x >= widget.items.length) return 0;
    return _keys[x].globalPaintBounds?.width ?? 0;
  }

  double get _currentWidth {
    if (_offset == -1) return 0;

    double _sum = 0;
    for (int i = 0; i < widget.items.length; i++) {
      final double _w = (_keys[i].globalPaintBounds?.width ?? 0);
      if (_offset < (_sum += _w)) {
        return _getWidthOf(i);
      }
    }

    return _getWidthOf(widget.items.length - 1);
  }

  int get _indexFromPosition {
    final double _centerPosition = _offset + _currentWidth / 2;

    double _sum = 0;
    for (int i = 0; i < widget.items.length; i++) {
      if (_centerPosition < (_sum += (_keys[i].globalPaintBounds?.width ?? 0))) return i;
    }
    return widget.items.length - 1;
  }

  double _clearPosition(double pos) => min(max(0, pos), _selectKey.globalPaintBounds?.width ?? 100);

  void _initializeOffset() {
    if (!_keys.every((k) => k.globalPaintBounds != null)) {
      Future.delayed(const Duration(milliseconds: 200), () => setState(() {}));
      return;
    }
    _initialized = true;

    if (__selectedItem == null) {
      setState(() => _offset = -1);
      return;
    }

    final GlobalKey _tmp = _keys[widget.items.indexOf(__selectedItem!)];
    if (_tmp.globalOffset != null) {
      setState(
        () {
          _offset = _getOffsetOf(widget.items.indexOf(__selectedItem!));
          _width = _getWidthOf(widget.items.indexOf(__selectedItem!));
        },
      );
    }
  }

  void _updatePositionsBySelected() {
    if (__selectedItem == null) {
      setState(() => _offset = -1);
      return;
    }

    final GlobalKey _tmp = _keys[widget.items.indexOf(__selectedItem!)];
    if (_tmp.globalOffset != null) {
      setState(
        () {
          _offset = _getOffsetOf(widget.items.indexOf(__selectedItem!));
          _width = _getWidthOf(widget.items.indexOf(__selectedItem!));
        },
      );
    }
  }

  void _updatePositions() {
    if (__selectedItem == null) {
      setState(() => _offset = -1);
      return;
    }

    final GlobalKey _tmp = _keys[_indexFromPosition];
    if (_tmp.globalOffset != null) {
      setState(
        () {
          _offset = _getOffsetOf(_indexFromPosition);
          _width = _getWidthOf(_indexFromPosition);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) _initializeOffset();

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            key: _selectKey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ZwapColors.neutral100,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastLinearToSlowEaseIn,
          top: 4,
          left: _offset,
          width: _currentWidth,
          height: 48,
          child: Container(
            decoration: BoxDecoration(
              color: ZwapColors.shades0,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: InkWell(
            mouseCursor: _isGrabbing ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
            child: GestureDetector(
              onHorizontalDragStart: (_) {
                _isGrabbing = true;
                setState(() {});
              },
              onHorizontalDragUpdate: (details) {
                setState(() => _offset += details.delta.dx);
              },
              onHorizontalDragEnd: (_) {
                _isGrabbing = false;
                setState(() {});
                _updatePositions();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.items
                    .mapIndexed(
                      (i, e) => InkWell(
                        onTap: () => _selectedItem = e,
                        child: widget.builder(context, e, _keys[i]),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
