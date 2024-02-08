import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }

  Offset? get globalOffset {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) return Offset(translation.x, translation.y);
    return null;
  }

  /// Return the global offset (top left) that the widget
  /// related to this key should assume to be positioned
  /// related to the target widget.
  Offset? positionRelatedTo(
    GlobalKey targetKey, {
    Alignment position = Alignment.topCenter,
    Offset translate = Offset.zero,
    Offset padding = const Offset(4, 4),
  }) {
    final Rect? _targetRect = targetKey.globalPaintBounds;
    final Rect? _rect = globalPaintBounds;

    Offset _position = Offset.zero;

    if (_targetRect != null && _rect != null) {
      final Offset _delta = Offset((_targetRect.width - _rect.width) / 2, (_targetRect.height - _rect.height) / 2);
      final Offset _d = _rect.size.offset + _delta + padding;

      _position = _targetRect.center - (_rect.size / 2).offset + _d.withAl(position) + translate;
    }

    return _position;
  }

  /// Same as calling [positionRelatedTo], but the returned offset
  /// will never let the widget be positioned outside the screen.
  ///
  /// [screenCorrection] should be used to adapt the device screen size
  /// to the actual Overlay.of(context) "available area". For example,
  /// if the MaterialApp is wrapped inside a builder that provide widget outside
  /// the app, the screenCorrection should be used to correct the screen size.
  Offset? safePositionRelatedTo(
    GlobalKey targetKey, {
    Alignment position = Alignment.topCenter,
    Offset translate = Offset.zero,
    Offset padding = const Offset(4, 4),
    BuildContext? context,
    Offset screenCorrection = Offset.zero,
  }) {
    final Offset? _position = positionRelatedTo(targetKey, position: position, translate: translate, padding: padding);
    if (_position == null) return null;
    if (currentContext == null && context == null) return _position;

    Size _screenSize = MediaQuery.of(currentContext ?? context!).size;
    _screenSize = Size(_screenSize.width - screenCorrection.dx, _screenSize.height - screenCorrection.dy);

    final Rect _updatedTooltipRect = globalPaintBounds!.translate(_position.dx - screenCorrection.dx, _position.dy - screenCorrection.dy);

    double _dx = 0;
    double _dy = 0;

    if (_updatedTooltipRect.left + _updatedTooltipRect.width > _screenSize.width) {
      _dx = _screenSize.width - (_updatedTooltipRect.left + _updatedTooltipRect.width + 16);
    } else if (_updatedTooltipRect.left < 0) {
      _dx = -_updatedTooltipRect.left + 16;
    }

    if (_updatedTooltipRect.top + _updatedTooltipRect.height > _screenSize.height) {
      _dy = _screenSize.height - (_updatedTooltipRect.top + _updatedTooltipRect.height + 16);
    } else if (_updatedTooltipRect.top < 0) {
      _dy = -_updatedTooltipRect.top + 16;
    }

    return _position + Offset(_dx, _dy) - screenCorrection;
  }
}

extension on Size {
  Offset get offset => Offset(width, height);
}

extension on Offset {
  Offset withAl(Alignment alignment) {
    return Offset(dx * alignment.x, dy * alignment.y);
  }
}
