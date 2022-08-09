library zwap_button;

import 'dart:math';

/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

import '../constants/zwapConstants.dart';
import '../typography/zwapTypography.dart';

part './zwap_button_decorations.dart';

//FEATURE: In line buttons (2 bottoni uno affiano all'altro -> su schemi piccoli uno sotto l'altro)

/// Used as argument of the callback when custom childs are builded.
///
/// Usually used to make the custom child of the button dynamic in base
/// of the current ZwapButton status
class ZwapButtonStatusDescription {
  /// Is true if the button is hovered
  final bool isHovered;

  /// Is true if the button is focussed
  final bool isFocussed;

  /// Is true if the button is disabled
  final bool isDisabled;

  /// Is true if the button is hidden
  final bool isHidden;

  /// Is true if the button is selected
  final bool isSelected;

  /// The current ZwapButton decorations
  final ZwapButtonDecorations? decorations;

  /// The decoration used when [isSelected] is true
  final ZwapButtonDecorations? selectedDecorations;

  ZwapButtonStatusDescription._({
    required this.isDisabled,
    required this.isFocussed,
    required this.isHovered,
    required this.isHidden,
    required this.isSelected,
    required this.decorations,
    required this.selectedDecorations,
  });
}

enum ZwapButtonIconPosition { left, right }

/// To set colors see [ZwapButtonDecorations]
class ZwapButtonChild {
  final String? text;
  final int fontSize;
  final FontWeight fontWeight;

  final IconData? icon;
  final int iconSize;

  final ZwapButtonIconPosition iconPosition;

  final Widget Function(ZwapButtonStatusDescription)? _customIcon;

  final double spaceBetween;

  ZwapButtonChild.text({
    required String text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
  })  : this.text = text,
        this.icon = null,
        this.iconSize = 24,
        this.spaceBetween = 0,
        this.iconPosition = ZwapButtonIconPosition.left,
        this._customIcon = null;

  ZwapButtonChild.textWithIcon({
    required String text,
    required IconData icon,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.spaceBetween = 5,
    this.iconSize = 24,
    this.iconPosition = ZwapButtonIconPosition.left,
  })  : this.text = text,
        this._customIcon = null,
        this.icon = icon;

  ZwapButtonChild.textWithCustomIcon({
    required String text,
    required Widget Function(ZwapButtonStatusDescription) icon,
    this.spaceBetween = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.iconPosition = ZwapButtonIconPosition.left,
  })  : this.text = text,
        this._customIcon = icon,
        this.iconSize = 24,
        this.icon = null;

  ZwapButtonChild.icon({
    required IconData icon,
    this.iconSize = 24,
  })  : this.text = null,
        this.icon = icon,
        this._customIcon = null,
        this.spaceBetween = 0,
        this.iconPosition = ZwapButtonIconPosition.left,
        this.fontSize = 14,
        this.fontWeight = FontWeight.w400;

  ZwapButtonChild.customIcon({
    required Widget Function(ZwapButtonStatusDescription) icon,
    this.iconSize = 24,
  })  : this.text = null,
        this.icon = null,
        this.fontWeight = FontWeight.w400,
        this.iconPosition = ZwapButtonIconPosition.left,
        this.spaceBetween = 0,
        this._customIcon = icon,
        this.fontSize = 14;
}

class ZwapButton extends StatefulWidget {
  /// Content of button
  final Widget Function(ZwapButtonStatusDescription)? child;

  final ZwapButtonChild? buttonChild;

  /// If [true] button will be disabled
  final bool disabled;

  /// Il true a loading indicator will be shown instead of button child
  final bool loading;

  /// Opacity of this button: hide ? 0 : 1
  final bool hide;

  final FocusNode? focusNode;

  final double? width;
  final double? height;
  final ZwapButtonDecorations? decorations;
  final EdgeInsets? margin;

  final Function()? onTap;
  final Function()? onLongTap;
  final Function(bool)? onHover;

  /// A map of [Intent] keys to [Action] objects that defines which actions this widget knows about.
  ///
  /// If [null] -> the "click on enter" is added by default
  final Map<Type, Action<Intent>>? actions;

  /// The map of shortcuts that the [ShortcutManager] will be given to manage.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Some buttons can be use as "triggers" and have a selected state.
  ///
  /// Simply, when [isSelected] is true, [selectedDecorations] are
  /// used instead of [decorations].
  final bool isSelected;

  /// Used when [isSelected] is true
  final ZwapButtonDecorations? selectedDecorations;

  /// If different from 0 is used to animate button from bottom
  ///
  /// The provided value will be the "heigth" of the empty space
  /// under the button
  final double hoverElevation;

  /// This value must be between 0 and 1.
  ///
  /// If not equal to 1, the button will use [disabled] state decoration.
  ///
  /// If not equal to 0 the button will fill horizontally only the [completationValue]
  /// percent of the width. Fill color will always be [decorations.backgroundColor]
  ///
  /// ! Works even in loading state !
  ///
  /// Default to 1 (no changes to "normal" button)
  final double completionValue;

  const ZwapButton({
    required ZwapButtonChild buttonChild,
    this.decorations,
    this.focusNode,
    this.height = 44,
    this.width = 116,
    this.hide = false,
    this.disabled = false,
    this.onHover,
    this.margin,
    this.onLongTap,
    this.onTap,
    this.actions,
    this.shortcuts,
    this.loading = false,
    this.isSelected = false,
    this.selectedDecorations,
    this.hoverElevation = 0,
    this.completionValue = 1,
    Key? key,
  })  : this.child = null,
        this.buttonChild = buttonChild,
        assert(completionValue >= 0 && completionValue <= 1),
        super(key: key);

  const ZwapButton.customChild({
    required Widget Function(ZwapButtonStatusDescription) child,
    this.decorations,
    this.focusNode,
    this.height = 44,
    this.width = 116,
    this.hide = false,
    this.disabled = false,
    this.margin,
    this.onHover,
    this.onLongTap,
    this.onTap,
    this.actions,
    this.shortcuts,
    this.loading = false,
    this.isSelected = false,
    this.selectedDecorations,
    this.hoverElevation = 0,
    this.completionValue = 1,
    Key? key,
  })  : this.buttonChild = null,
        this.child = child,
        assert(completionValue >= 0 && completionValue <= 1),
        super(key: key);

  @override
  _ZwapButtonState createState() => _ZwapButtonState();
}

class _ZwapButtonState extends State<ZwapButton> {
  late final FocusNode _focusNode;
  late final ZwapButtonDecorations _decorations;
  late final ZwapButtonDecorations _selectedDecorations;

  late final Map<Type, Action<Intent>>? _actions;
  late final Map<ShortcutActivator, Intent>? _shortcuts;

  double _completion = 0;

  bool _focussed = false;
  bool _hovered = false;
  bool __disabled = false;
  bool _pressed = false;
  bool _selected = false;

  bool _loading = false;

  bool get _disabled => __disabled || _completion != 1;

  /// If true the animation duration of the button will be
  /// [Duration.zero]
  bool _jumpAnimation = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _decorations = widget.decorations ?? ZwapButtonDecorations.primaryLight();
    _selectedDecorations = widget.selectedDecorations ?? ZwapButtonDecorations.primaryLight();

    _completion = widget.completionValue;

    _focussed = _focusNode.hasFocus;
    __disabled = widget.disabled;
    _selected = widget.isSelected;

    _loading = widget.loading;

    _actions = widget.actions ??
        {
          if (kIsWeb)
            ButtonActivateIntent: CallbackAction<Intent>(onInvoke: (intent) => widget.onTap != null ? widget.onTap!() : null)
          else
            ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) => widget.onTap != null ? widget.onTap!() : null),
        };
    _shortcuts = widget.shortcuts;

    super.initState();
  }

  @override
  void didUpdateWidget(ZwapButton oldWidget) {
    if (widget.disabled != _disabled) setState(() => __disabled = widget.disabled);
    if (widget.loading != _loading) setState(() => _loading = widget.loading);
    if (widget.isSelected != _selected) setState(() => _selected = widget.isSelected);
    if (widget.completionValue != _completion) {
      _jumpAnimation = true;
      setState(() => _completion = widget.completionValue);
      Future.delayed(const Duration(milliseconds: 300), () => _jumpAnimation = false);
    }

    super.didUpdateWidget(oldWidget);
  }

  T? _getCurrentValueByStatus<T>({
    required T? normal,
    required T? hover,
    required T? disabled,
    required T? focussed,
    required T? pressed,
    required T? selectedNormal,
    required T? selectedHover,
    required T? selectedDisabled,
    required T? selectedFocussed,
    required T? selectedPressed,
  }) {
    if (_selected) {
      if (_loading) return selectedNormal;

      if (_disabled) return selectedDisabled;
      if (_pressed) return selectedPressed;
      if (_hovered) return selectedHover;
      if (_focussed) return selectedFocussed;
      return selectedNormal;
    }

    if (_loading) return normal;

    if (_disabled) return disabled;
    if (_pressed) return pressed;
    if (_hovered) return hover;
    if (_focussed) return focussed;
    return normal;
  }

  Color? get _color => _getCurrentValueByStatus<Color>(
        normal: _decorations.gradient == null ? _decorations.backgroundColor : null,
        disabled: _decorations.disabledGradient == null ? _decorations.disabledColor : null,
        focussed: _decorations.focussedGradient == null ? _decorations.focussedColor : null,
        pressed: _decorations.pressedGradient == null ? _decorations.pressedColor : null,
        hover: _decorations.hoverGradient == null ? _decorations.hoverColor : null,
        selectedNormal: _selectedDecorations.gradient == null ? _selectedDecorations.backgroundColor : null,
        selectedDisabled: _selectedDecorations.disabledGradient == null ? _selectedDecorations.disabledColor : null,
        selectedFocussed: _selectedDecorations.focussedGradient == null ? _selectedDecorations.focussedColor : null,
        selectedPressed: _selectedDecorations.pressedGradient == null ? _selectedDecorations.pressedColor : null,
        selectedHover: _selectedDecorations.hoverGradient == null ? _selectedDecorations.hoverColor : null,
      );

  Gradient? get _gradient => _getCurrentValueByStatus<Gradient>(
        normal: _decorations.gradient,
        disabled: _decorations.disabledGradient,
        focussed: _decorations.focussedGradient,
        pressed: _decorations.pressedGradient,
        hover: _decorations.hoverGradient,
        selectedNormal: _selectedDecorations.gradient,
        selectedDisabled: _selectedDecorations.disabledGradient,
        selectedFocussed: _selectedDecorations.focussedGradient,
        selectedPressed: _selectedDecorations.pressedGradient,
        selectedHover: _selectedDecorations.hoverGradient,
      );

  Border? get _border => _getCurrentValueByStatus(
        normal: _decorations.border,
        hover: _decorations.hoverBorder,
        disabled: _decorations.disabledBorder,
        pressed: _decorations.pressedBorder,
        focussed: _decorations.focussedBorder,
        selectedNormal: _selectedDecorations.border,
        selectedHover: _selectedDecorations.hoverBorder,
        selectedDisabled: _selectedDecorations.disabledBorder,
        selectedPressed: _selectedDecorations.pressedBorder,
        selectedFocussed: _selectedDecorations.focussedBorder,
      );

  BoxShadow? get _shadow => _getCurrentValueByStatus(
        normal: _decorations.shadow,
        hover: _decorations.hoverShadow,
        disabled: _decorations.disabledShadow,
        pressed: _decorations.pressedShadow,
        focussed: _decorations.focussedShadow,
        selectedNormal: _selectedDecorations.shadow,
        selectedHover: _selectedDecorations.hoverShadow,
        selectedDisabled: _selectedDecorations.disabledShadow,
        selectedPressed: _selectedDecorations.pressedShadow,
        selectedFocussed: _selectedDecorations.focussedShadow,
      );

  Color? get _contentColor => _getCurrentValueByStatus(
        normal: _decorations.contentColor,
        hover: _decorations.hoverContentColor,
        disabled: _decorations.disabledContentColor,
        pressed: _decorations.pressedContentColor,
        focussed: _decorations.focussedContentColor,
        selectedNormal: _selectedDecorations.contentColor,
        selectedHover: _selectedDecorations.hoverContentColor,
        selectedDisabled: _selectedDecorations.disabledContentColor,
        selectedPressed: _selectedDecorations.pressedContentColor,
        selectedFocussed: _selectedDecorations.focussedContentColor,
      );

  ZwapButtonStatusDescription get _currentStatus => ZwapButtonStatusDescription._(
        isDisabled: _disabled,
        isFocussed: _focussed,
        isHovered: _hovered,
        isHidden: widget.hide,
        isSelected: _selected,
        decorations: _decorations,
        selectedDecorations: _selectedDecorations,
      );

  Widget _buildZwapButtonChild(BuildContext context) {
    ZwapButtonChild _child = widget.buttonChild!;

    if (_child.text != null && (_child.icon != null || _child._customIcon != null))
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_child.iconPosition == ZwapButtonIconPosition.left) ...[
            _child.icon == null
                ? _child._customIcon!(_currentStatus)
                : Icon(
                    _child.icon!,
                    size: _child.iconSize.toDouble(),
                    color: _contentColor,
                  ),
            SizedBox(width: _child.spaceBetween),
          ],
          Text(
            _child.text!,
            style: ZwapTypography.buttonText().copyWith(
              fontWeight: _child.fontWeight,
              fontSize: _child.fontSize.toDouble(),
              color: _contentColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (_child.iconPosition == ZwapButtonIconPosition.right) ...[
            SizedBox(width: _child.spaceBetween),
            _child.icon == null
                ? _child._customIcon!(_currentStatus)
                : Icon(
                    _child.icon!,
                    size: _child.iconSize.toDouble(),
                    color: _contentColor,
                  ),
          ],
        ],
      );

    return _child.text == null
        ? _child.icon == null
            ? _child._customIcon!(_currentStatus)
            : Icon(
                _child.icon!,
                size: _child.iconSize.toDouble(),
                color: _contentColor,
              )
        : Text(
            _child.text!,
            style: ZwapTypography.buttonText().copyWith(
              fontWeight: _child.fontWeight,
              fontSize: _child.fontSize.toDouble(),
              color: _contentColor,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.decelerate,
      margin: (widget.margin ?? EdgeInsets.zero).add(widget.hoverElevation != 0
          ? EdgeInsets.only(
              top: _hovered ? 0 : widget.hoverElevation,
              bottom: _hovered ? widget.hoverElevation : 0,
            )
          : EdgeInsets.zero),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.hide ? 0 : 1,
        child: GestureDetector(
          onTap: (_loading || _disabled) ? null : widget.onTap,
          onLongPress: () {
            if (_pressed) setState(() => _pressed = false);
            if (widget.onLongTap != null) widget.onLongTap!();
          },
          onTapDown: (_) => !_pressed ? setState(() => _pressed = true) : null,
          onTapUp: (_) => _pressed ? setState(() => _pressed = false) : null,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            enabled: !widget.disabled,
            onShowFocusHighlight: (hasFocus) => setState(() => _focussed = hasFocus),
            onShowHoverHighlight: (hasHover) {
              if (!hasHover && _pressed) setState(() => _pressed = false);
              setState(() => _hovered = hasHover);
              if (widget.onHover != null) widget.onHover!(hasHover);
            },
            actions: _actions,
            shortcuts: _shortcuts,
            mouseCursor: widget.hide
                ? SystemMouseCursors.basic
                : _disabled
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: _pressed ? Duration.zero : (_decorations.animationDuration ?? const Duration(milliseconds: 200)),
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [if (_shadow != null) _shadow!],
                color: _color,
                gradient: _gradient,
                borderRadius: _decorations.borderRadius,
                border: _border,
              ),
              child: Stack(
                children: [
                  if (_completion != 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Builder(builder: (context) {
                        final double _width = _completion * (widget.width ?? 0);

                        double _height = widget.height ?? 0;

                        double? _topPadding;
                        double? _bottomPadding;

                        if (_width < (_decorations.borderRadius?.topLeft.x ?? 0)) {
                          final double _topEmptySpace = (_decorations.borderRadius?.topLeft.y ?? 0) *
                              (((_decorations.borderRadius?.topLeft.x ?? 0) - _width) / (_decorations.borderRadius?.topLeft.x ?? 1));
                          ;
                          _height -= _topEmptySpace;
                          _topPadding = _topEmptySpace;
                        }
                        if (_width < (_decorations.borderRadius?.bottomLeft.x ?? 0)) {
                          final double _bottomEmptySpace = (_decorations.borderRadius?.bottomLeft.y ?? 0) *
                              (((_decorations.borderRadius?.bottomLeft.x ?? 0) - _width) / (_decorations.borderRadius?.bottomLeft.x ?? 1));
                          _height -= _bottomEmptySpace;
                          _bottomPadding = _bottomEmptySpace;
                        }

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.decelerate,
                          height: _height,
                          width: _width,
                          margin: EdgeInsets.only(top: _topPadding ?? 0, bottom: _bottomPadding ?? 0),
                          decoration: BoxDecoration(
                            color: _decorations.backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: _decorations.borderRadius?.topLeft ?? Radius.circular(0),
                              bottomLeft: _decorations.borderRadius?.bottomLeft ?? Radius.circular(0),
                              topRight: _width > (widget.width ?? 0) - (_decorations.borderRadius?.topRight.x ?? 0)
                                  ? _decorations.borderRadius?.topRight ?? Radius.circular(0)
                                  : Radius.circular(0),
                              bottomRight: _width > (widget.width ?? 0) - (_decorations.borderRadius?.bottomRight.x ?? 0)
                                  ? _decorations.borderRadius?.topRight ?? Radius.circular(0)
                                  : Radius.circular(0),
                            ),
                          ),
                        );
                      }),
                    ),
                  Padding(
                    padding: _decorations.internalPadding,
                    child: _loading
                        ? Center(
                            child: Container(
                                height: min(24, widget.height ?? 0 - 4),
                                width: min(24, widget.width ?? 0 - 4),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(_contentColor ?? ZwapColors.shades0),
                                  strokeWidth: 1.2,
                                )),
                          )
                        : widget.buttonChild == null
                            ? widget.child!(_currentStatus)
                            : Center(child: _buildZwapButtonChild(context)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
