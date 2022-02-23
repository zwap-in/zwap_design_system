library zwap_button;

/// IMPORTING THIRD PARTY PACKAGES

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

import '../constants/zwapConstants.dart';
import '../typography/zwapTypography.dart';

part './zwap_button_decorations.dart';

class ZwapButtonStatusDescription {
  final bool isHovered;
  final bool isFocussed;
  final bool isDisabled;
  final bool isHidden;

  ZwapButtonStatusDescription._({
    required this.isDisabled,
    required this.isFocussed,
    required this.isHovered,
    required this.isHidden,
  });
}

/// To set colors see [ZwapButtonDecorations]
class ZwapButtonChild {
  final String? text;
  final int fontSize;
  final FontWeight fontWeight;

  final IconData? icon;
  final int iconSize;

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
        this._customIcon = null;

  ZwapButtonChild.textWithIcon({
    required String text,
    required IconData icon,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.spaceBetween = 5,
    this.iconSize = 24,
  })  : this.text = text,
        this._customIcon = null,
        this.icon = icon;

  ZwapButtonChild.textWithCustomIcon({
    required String text,
    required Widget Function(ZwapButtonStatusDescription) icon,
    this.spaceBetween = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
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
        this.fontSize = 14,
        this.fontWeight = FontWeight.w400;

  ZwapButtonChild.customIcon({
    required Widget Function(ZwapButtonStatusDescription) icon,
    this.iconSize = 24,
  })  : this.text = null,
        this.icon = null,
        this.fontWeight = FontWeight.w400,
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

  /// Opacity of this button: hide ? 0 : 1
  final bool hide;

  final FocusNode? focusNode;

  final double width;
  final double height;
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
    Key? key,
  })  : this.child = null,
        this.buttonChild = buttonChild,
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
    Key? key,
  })  : this.buttonChild = null,
        this.child = child,
        super(key: key);

  @override
  _ZwapButtonState createState() => _ZwapButtonState();
}

class _ZwapButtonState extends State<ZwapButton> {
  late final FocusNode _focusNode;
  late final ZwapButtonDecorations _decorations;

  late final Map<Type, Action<Intent>>? _actions;
  late final Map<ShortcutActivator, Intent>? _shortcuts;

  bool _focussed = false;
  bool _hovered = false;
  bool _disabled = false;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _decorations = widget.decorations ?? ZwapButtonDecorations();

    _focussed = _focusNode.hasFocus;
    _disabled = widget.disabled;

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
    if (widget.disabled != _disabled) setState(() => _disabled = widget.disabled);
    super.didUpdateWidget(oldWidget);
  }

  T? _getCurrentValueByStatus<T>({
    required T? normal,
    required T? hover,
    required T? disabled,
    required T? focussed,
  }) {
    if (_disabled) return disabled;
    if (_hovered) return hover;
    if (_focussed) return focussed;
    return normal;
  }

  Color? get _color => _getCurrentValueByStatus<Color>(
      normal: _decorations.gradient == null ? _decorations.backgroundColor : null,
      disabled: _decorations.disabledGradient == null ? _decorations.disabledColor : null,
      focussed: _decorations.focussedGradient == null ? _decorations.focussedColor : null,
      hover: _decorations.hoverGradient == null ? _decorations.hoverColor : null);

  Gradient? get _gradient => _getCurrentValueByStatus<Gradient>(
        normal: _decorations.gradient,
        disabled: _decorations.disabledGradient,
        focussed: _decorations.focussedGradient,
        hover: _decorations.hoverGradient,
      );

  Border? get _border => _getCurrentValueByStatus(
        normal: _decorations.border,
        hover: _decorations.hoverBorder,
        disabled: _decorations.disabledBorder,
        focussed: _decorations.focussedBorder,
      );

  BoxShadow? get _shadow => _getCurrentValueByStatus(
        normal: _decorations.shadow,
        hover: _decorations.hoverShadow,
        disabled: _decorations.disabledShadow,
        focussed: _decorations.focussedShadow,
      );

  Color? get _contentColor => _getCurrentValueByStatus(
        normal: _decorations.contentColor,
        hover: _decorations.hoverContentColor,
        disabled: _decorations.disabledContentColor,
        focussed: _decorations.focussedContentColor,
      );

  ZwapButtonStatusDescription get _currentStatus => ZwapButtonStatusDescription._(
        isDisabled: _disabled,
        isFocussed: _focussed,
        isHovered: _hovered,
        isHidden: widget.hide,
      );

  Widget _buildZwapButtonChild(BuildContext context) {
    ZwapButtonChild _child = widget.buttonChild!;

    if (_child.text != null && (_child.icon != null || _child._customIcon != null))
      return Row(
        children: [
          _child.icon == null
              ? _child._customIcon!(_currentStatus)
              : Icon(
                  _child.icon!,
                  size: _child.iconSize.toDouble(),
                  color: _contentColor,
                ),
          SizedBox(width: _child.spaceBetween),
          Text(
            _child.text!,
            style: ZwapTypography.buttonText().copyWith(
              fontWeight: _child.fontWeight,
              fontSize: _child.fontSize.toDouble(),
              color: _contentColor,
            ),
          ),
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
    return Container(
      margin: widget.margin,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.hide ? 0 : 1,
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongTap,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            enabled: !widget.disabled,
            onShowFocusHighlight: (hasFocus) => setState(() => _focussed = hasFocus),
            onShowHoverHighlight: (hasHover) => setState(() => _hovered = hasHover),
            actions: _actions,
            shortcuts: _shortcuts,
            mouseCursor: _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: _decorations.internalPadding,
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
              child: widget.buttonChild == null ? widget.child!(_currentStatus) : _buildZwapButtonChild(context),
            ),
          ),
        ),
      ),
    );
  }
}
