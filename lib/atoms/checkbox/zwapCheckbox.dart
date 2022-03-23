/// IMPORTING THIRD PARTY PACKAGES
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapCheckBoxStateDecoration {
  final Color? color;
  final Color? hoverColor;
  final Color? disabledColor;
  final Color? errorColor;

  final Border? border;
  final Border? hoverBorder;
  final Border? disabledBorder;
  final Border? errorBorder;

  final Radius? borderRadius;

  final Color? iconColor;
  final Color? iconHoverColor;
  final Color? iconDisabledColor;
  final Color? iconErrorColor;

  const ZwapCheckBoxStateDecoration({
    this.color,
    this.hoverColor,
    this.disabledColor,
    this.errorColor,
    this.border,
    this.hoverBorder,
    this.disabledBorder,
    this.errorBorder,
    this.iconColor,
    this.iconHoverColor,
    this.iconDisabledColor,
    this.iconErrorColor,
    this.borderRadius,
  });

  const ZwapCheckBoxStateDecoration.selected({
    this.color = ZwapColors.primary700,
    this.hoverColor = ZwapColors.primary800,
    this.disabledColor = ZwapColors.primary200,
    this.errorColor = ZwapColors.error100,
    this.border,
    this.hoverBorder,
    this.disabledBorder,
    this.errorBorder,
    this.iconColor = ZwapColors.shades0,
    this.iconHoverColor = ZwapColors.shades0,
    this.iconDisabledColor = ZwapColors.shades0,
    this.iconErrorColor = ZwapColors.shades0,
    this.borderRadius = const Radius.circular(4),
  });

  const ZwapCheckBoxStateDecoration.unselected({
    this.color = ZwapColors.whiteTransparent,
    this.hoverColor = ZwapColors.neutral50,
    this.disabledColor = ZwapColors.whiteTransparent,
    this.errorColor = ZwapColors.error100,
    this.border = const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral300)),
    this.hoverBorder = const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral300)),
    this.disabledBorder = const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral100)),
    this.errorBorder,
    this.iconColor = ZwapColors.shades0,
    this.iconHoverColor = ZwapColors.shades0,
    this.iconDisabledColor = ZwapColors.shades0,
    this.iconErrorColor = ZwapColors.shades0,
    this.borderRadius = const Radius.circular(4),
  });

  const ZwapCheckBoxStateDecoration.indeterminate({
    this.color = ZwapColors.primary200,
    this.hoverColor = ZwapColors.primary300,
    this.disabledColor = ZwapColors.primary200,
    this.errorColor = ZwapColors.error100,
    this.border,
    this.hoverBorder,
    this.disabledBorder,
    this.errorBorder,
    this.iconColor = ZwapColors.shades0,
    this.iconHoverColor = ZwapColors.shades0,
    this.iconDisabledColor = ZwapColors.shades0,
    this.iconErrorColor = ZwapColors.shades0,
    this.borderRadius = const Radius.circular(4),
  });

  ZwapCheckBoxStateDecoration copyWith({
    Color? color,
    Color? hoverColor,
    Color? disabledColor,
    Color? errorColor,
  }) {
    return ZwapCheckBoxStateDecoration(
      color: color ?? this.color,
      hoverColor: hoverColor ?? this.hoverColor,
      disabledColor: disabledColor ?? this.disabledColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }
}

class ZwapCheckBoxDecorations {
  final ZwapCheckBoxStateDecoration selected;
  final ZwapCheckBoxStateDecoration unselected;
  final ZwapCheckBoxStateDecoration indeterminate;

  const ZwapCheckBoxDecorations({
    this.selected = const ZwapCheckBoxStateDecoration.selected(),
    this.unselected = const ZwapCheckBoxStateDecoration.unselected(),
    this.indeterminate = const ZwapCheckBoxStateDecoration.indeterminate(),
  });
}

/// CheckBox component from Zwap Design System
///
/// See details in single properties
class ZwapCheckBox extends StatefulWidget {
  /// [isSelected] is the new current value
  ///
  /// ! Obviously indeterminate value cannot be reached, but only setted with initial value
  final Function(bool isSelected)? onCheckBoxClick;

  /// * `value == true` -> checkbox is selected
  /// * `value == false` -> checkbox is not selected
  /// * `value == null` -> checkbox indeterminate
  ///
  /// ! Changing this value at runtime will change the internal value, BUT the actual internal value can be different
  /// In fact, this widget is autonomus and can be used even providing only the inial value
  ///
  /// Default to `false`
  final bool? value;

  /// If true the checkbox will be disabled and callback will not be called on click
  final bool disabled;

  final bool error;

  final ZwapCheckBoxDecorations decorations;

  ZwapCheckBox({
    Key? key,
    this.value,
    this.disabled = false,
    this.error = false,
    this.onCheckBoxClick,
    this.decorations = const ZwapCheckBoxDecorations(),
  }) : super(key: key);

  _ZwapCheckBoxState createState() => _ZwapCheckBoxState();
}

/// Standard component to render a checkbox with Zwap standard style
class _ZwapCheckBoxState extends State<ZwapCheckBox> {
  late bool? _value;
  late bool _disabled;
  late bool _error;

  bool _isHovered = false;

  ZwapCheckBoxDecorations get _decorations => widget.decorations;

  @override
  void initState() {
    super.initState();

    _value = widget.value;
    _disabled = widget.disabled;
    _error = widget.error;
  }

  @override
  void didUpdateWidget(covariant ZwapCheckBox oldWidget) {
    if (widget.value != _value) setState(() => _value = widget.value);
    if (widget.disabled != _disabled) setState(() => _disabled = widget.disabled);
    if (widget.error != _error) setState(() => _error = widget.error);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        onTap: _disabled
            ? null
            : () {
                setState(() => _value = !(_value ?? false));
                if (widget.onCheckBoxClick != null) widget.onCheckBoxClick!(_value ?? false);
              },
        mouseCursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Padding(
          padding: EdgeInsets.only(right: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _value == null
                  ? _disabled
                      ? _decorations.indeterminate.disabledColor
                      : _error
                          ? _decorations.indeterminate.errorColor
                          : _isHovered
                              ? _decorations.indeterminate.hoverColor
                              : _decorations.indeterminate.color
                  : _value!
                      ? _disabled
                          ? _decorations.selected.disabledColor
                          : _error
                              ? _decorations.selected.errorColor
                              : _isHovered
                                  ? _decorations.selected.hoverColor
                                  : _decorations.selected.color
                      : _disabled
                          ? _decorations.unselected.disabledColor
                          : _error
                              ? _decorations.unselected.errorColor
                              : _isHovered
                                  ? _decorations.unselected.hoverColor
                                  : _decorations.unselected.color,
              border: _value == null
                  ? _disabled
                      ? _decorations.indeterminate.disabledBorder
                      : _error
                          ? _decorations.indeterminate.errorBorder
                          : _isHovered
                              ? _decorations.indeterminate.hoverBorder
                              : _decorations.indeterminate.border
                  : _value!
                      ? _disabled
                          ? _decorations.selected.disabledBorder
                          : _error
                              ? _decorations.selected.errorBorder
                              : _isHovered
                                  ? _decorations.selected.hoverBorder
                                  : _decorations.selected.border
                      : _disabled
                          ? _decorations.unselected.disabledBorder
                          : _error
                              ? _decorations.unselected.errorBorder
                              : _isHovered
                                  ? _decorations.unselected.hoverBorder
                                  : _decorations.unselected.border,
              borderRadius: BorderRadius.all(
                (_value == null
                        ? _decorations.indeterminate.borderRadius
                        : _value!
                            ? _decorations.selected.borderRadius
                            : _decorations.unselected.borderRadius) ??
                    Radius.circular(4),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Container(
                height: getMultipleConditions<double>(17, 17, 16, 15, 15) + 4,
                width: getMultipleConditions<double>(17, 17, 16, 15, 15) + 4,
                key: ValueKey(_value),
                child: _value == null
                    ? Icon(
                        Icons.remove_rounded,
                        color: ZwapColors.shades0,
                        size: getMultipleConditions<double>(17, 17, 16, 15, 15),
                      )
                    : _value!
                        ? Icon(
                            Icons.check_rounded,
                            color: ZwapColors.shades0,
                            size: getMultipleConditions<double>(17, 17, 16, 15, 15),
                          )
                        : Container(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
