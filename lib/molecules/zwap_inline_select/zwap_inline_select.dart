import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

class ZwapInlineSelect<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final Widget Function(BuildContext, T item, Key key) builder;

  final Function(T item)? onSelected;

  final double radius;
  final double selectedRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final double itemHeight;
  final double padding;

  const ZwapInlineSelect({
    required this.items,
    required this.selectedItem,
    required this.builder,
    this.onSelected,
    this.radius = 12,
    this.backgroundColor,
    this.selectedColor,
    this.selectedRadius = 12,
    this.itemHeight = 48,
    this.padding = 4,
    super.key,
  });

  @override
  State<ZwapInlineSelect<T>> createState() => _ZwapInlineSelectState<T>();
}

class _ZwapInlineSelectState<T> extends State<ZwapInlineSelect<T>> {
  T? __selectedItem;

  double _offset = 0;
  double _width = 0;

  bool _isDragging = false;

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

  @override
  void didUpdateWidget(covariant ZwapInlineSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedItem != widget.selectedItem && widget.selectedItem != __selectedItem) {
      __selectedItem = widget.selectedItem;
      _updatePositionsBySelected();
    }
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
    if (!mounted) return;
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
    if (!mounted) return;
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
    if (!mounted) return;
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

    if (widget.onSelected != null) widget.onSelected!(widget.items[_indexFromPosition]);
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
              borderRadius: BorderRadius.circular(widget.radius),
              color: widget.backgroundColor ?? ZwapColors.neutral100,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: _isDragging ? Duration.zero : const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          top: widget.padding,
          left: _offset,
          width: _currentWidth,
          height: widget.itemHeight,
          child: Container(
            decoration: BoxDecoration(
              color: widget.selectedColor ?? ZwapColors.shades0,
              borderRadius: BorderRadius.circular(widget.selectedRadius),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.padding),
          child: GestureDetector(
            onHorizontalDragStart: (_) => _isDragging = true,
            onHorizontalDragUpdate: (details) {
              if (!mounted) return;
              setState(() => _offset += details.delta.dx);
            },
            onHorizontalDragEnd: (_) {
              _isDragging = false;
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
      ],
    );
  }
}
