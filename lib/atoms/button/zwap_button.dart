library zwap_button;

import 'dart:math';

import 'package:collection/collection.dart';

/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

part './zwap_button_decorations.dart';
part './zwap_button_options.dart';

extension ZwapButtonOpenOptionsCallback on void Function() {}

extension on Border {
  Border withStrokeAlign(double? align) => Border(
        top: top.copyWith(strokeAlign: align),
        bottom: bottom.copyWith(strokeAlign: align),
        left: left.copyWith(strokeAlign: align),
        right: right.copyWith(strokeAlign: align),
      );
}

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
  static void Function() openOptions = () {};

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

  /// If not null a tooltip will be showed on hover
  ///
  /// See [showTooltipOnlyOnDisabledState] for customizing where
  /// show the tooltip
  final String? tooltip;

  /// If true and [tooltip] is provided, [tooltip] is showed only
  /// if the button is in the disabled state
  final bool showTooltipOnlyOnDisabledState;

  final ZwapButtonOptions? rightOptions;

  const ZwapButton({
    required ZwapButtonChild buttonChild,
    this.decorations,
    this.focusNode,
    this.height,
    this.width,
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
    this.tooltip,
    this.showTooltipOnlyOnDisabledState = false,
    this.rightOptions,
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
    this.tooltip,
    this.showTooltipOnlyOnDisabledState = false,
    this.rightOptions,
    Key? key,
  })  : this.buttonChild = null,
        this.child = child,
        assert(completionValue >= 0 && completionValue <= 1),
        super(key: key);

  @override
  _ZwapButtonState createState() => _ZwapButtonState();
}

class _ZwapButtonState extends State<ZwapButton> {
  final GlobalKey<_ZwapButtonOptionsAppendiceState> _optionsKey = GlobalKey<_ZwapButtonOptionsAppendiceState>();
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _buttonContentKey = GlobalKey();

  late final FocusNode _focusNode;
  late final ZwapButtonDecorations _decorations;
  late final ZwapButtonDecorations _selectedDecorations;

  late final Map<Type, Action<Intent>>? _actions;
  late final Map<ShortcutActivator, Intent>? _shortcuts;

  double? _buttonHeight;

  double _completion = 0;

  bool _focussed = false;
  bool _hovered = false;
  bool __disabled = false;
  bool _pressed = false;
  bool _selected = false;

  bool _loading = false;

  bool get _disabled => __disabled || _completion != 1;

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _buttonHeight = _buttonKey.globalPaintBounds?.height);
    });
  }

  @override
  void didUpdateWidget(ZwapButton oldWidget) {
    if (widget.disabled != _disabled) setState(() => __disabled = widget.disabled);
    if (widget.loading != _loading) setState(() => _loading = widget.loading);
    if (widget.isSelected != _selected) setState(() => _selected = widget.isSelected);
    if (widget.completionValue != _completion) setState(() => _completion = widget.completionValue);

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

  Widget get _loader {
    return Container(
      height: max(16, (widget.height ?? _buttonHeight ?? 12) - _decorations.internalPadding.vertical),
      width: max(16, (widget.height ?? _buttonHeight ?? 12) - _decorations.internalPadding.vertical),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_contentColor ?? ZwapColors.shades0),
          strokeWidth: 1.2,
        ),
      ),
    );
  }

  BorderRadius get _borderRadius {
    BorderRadius _fixBorderRadius(BorderRadius? radius) {
      if (widget.rightOptions == null) return radius ?? BorderRadius.circular(0);
      return (radius ?? BorderRadius.circular(0)).copyWith(topRight: Radius.circular(0), bottomRight: Radius.circular(0));
    }

    return _fixBorderRadius(_selected ? _selectedDecorations.borderRadius : _decorations.borderRadius);
  }

  bool get _shrikWrap => widget.width == null;

  Widget _buildZwapButtonChild(BuildContext context) {
    ZwapButtonChild _child = widget.buttonChild!;

    if (_child.text != null && (_child.icon != null || _child._customIcon != null))
      return Row(
        mainAxisSize: _shrikWrap ? MainAxisSize.min : MainAxisSize.max,
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
          ZwapText.customStyle(
            text: _child.text!,
            parentKey: _buttonContentKey,
            customTextStyle: ZwapTypography.buttonText().copyWith(
              fontWeight: _child.fontWeight,
              fontSize: _child.fontSize.toDouble(),
              color: _contentColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            showTooltipIfOverflow: true,
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
        : ZwapText.customStyle(
            text: _child.text!,
            parentKey: _buttonContentKey,
            customTextStyle: ZwapTypography.buttonText().copyWith(
              fontWeight: _child.fontWeight,
              fontSize: _child.fontSize.toDouble(),
              color: _contentColor,
            ),
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            showTooltipIfOverflow: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    Widget _wrapWithRightOptions(Widget child) {
      final double? _height = widget.height ?? _buttonHeight;
      if (widget.rightOptions == null || _height == null) return child;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(width: 1),
          _ZwapButtonOptionsAppendice(
            key: _optionsKey,
            decorations: _decorations,
            height: _height,
            options: widget.rightOptions!,
          ),
        ],
      );
    }

    Widget _wrapWithRowColumn(Widget child) {
      if (widget.width != double.infinity) child = Row(mainAxisSize: MainAxisSize.min, children: [child]);
      if (widget.height != double.infinity) child = Column(mainAxisSize: MainAxisSize.min, children: [child]);
      return child;
    }

    EdgeInsets _fixPaddingIfNeeded(EdgeInsets padding) {
      if (padding.vertical == 0) return padding.copyWith(top: 4, bottom: 4);
      return padding;
    }

    final Widget _button = LayoutBuilder(builder: (context, size) {
      return _wrapWithRowColumn(
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
          margin: (widget.margin ?? EdgeInsets.zero).add(
            widget.hoverElevation != 0
                ? EdgeInsets.only(
                    top: _hovered ? 0 : widget.hoverElevation,
                    bottom: _hovered ? widget.hoverElevation : 0,
                  )
                : EdgeInsets.zero,
          ),
          child: _wrapWithRightOptions(
            AnimatedOpacity(
              key: _buttonKey,
              duration: const Duration(milliseconds: 200),
              opacity: widget.hide ? 0 : 1,
              child: GestureDetector(
                onTap: (_loading || _disabled)
                    ? null
                    : widget.onTap != ZwapButton.openOptions
                        ? widget.onTap
                        : () {
                            if (_optionsKey.currentContext?.mounted != true) return;
                            _optionsKey.currentState?.showOverlay();
                          },
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
                  mouseCursor: widget.hide ? SystemMouseCursors.basic : SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: _pressed ? Duration.zero : (_decorations.animationDuration ?? const Duration(milliseconds: 300)),
                    curve: Curves.easeInOut,
                    width: widget.width == double.infinity
                        ? size.maxWidth - (widget.margin?.horizontal ?? 0) - (widget.rightOptions != null ? 41 : 0)
                        : widget.width,
                    height: widget.height == double.infinity
                        ? size.maxHeight - (widget.margin?.vertical ?? 0) - (widget.rightOptions != null ? 41 : 0)
                        : widget.height,
                    decoration: BoxDecoration(
                      boxShadow: [if (_shadow != null) _shadow!],
                      color: _color,
                      gradient: _gradient,
                      borderRadius: _borderRadius,
                      border: _border?.withStrokeAlign(BorderSide.strokeAlignCenter),
                    ),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        _FadeAway(
                          show: _completion != 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) {
                                final double _width = _completion * (widget.width ?? 0);

                                Widget _wrapWithShaderMaskIfNeeded(Widget child) {
                                  if (_decorations.gradient == null) return child;

                                  return ShaderMask(
                                    shaderCallback: (b) => _decorations.gradient!.createShader(b),
                                    child: child,
                                  );
                                }

                                return _wrapWithShaderMaskIfNeeded(
                                  ClipRRect(
                                    borderRadius: _decorations.borderRadius ?? BorderRadius.zero,
                                    child: Container(
                                      width: widget.width,
                                      alignment: Alignment.centerLeft,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        curve: Curves.decelerate,
                                        height: widget.height ?? 0,
                                        width: _width,
                                        decoration: BoxDecoration(
                                          color: _decorations.gradient == null ? _decorations.backgroundColor : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: _decorations.borderRadius?.topRight ?? Radius.circular(0),
                                            bottomRight: _decorations.borderRadius?.bottomRight ?? Radius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: _decorations.internalPadding,
                          child: _loading
                              ? Padding(
                                  padding: _fixPaddingIfNeeded(_selected ? _selectedDecorations.internalPadding : _decorations.internalPadding),
                                  child: Center(
                                      child: widget.width == null && widget.height == null ? _loader : AspectRatio(aspectRatio: 1, child: _loader)),
                                )
                              : widget.buttonChild == null
                                  ? Center(
                                      key: _buttonContentKey,
                                      child: widget.child!(_currentStatus),
                                    )
                                  : Center(
                                      key: _buttonContentKey,
                                      child: _buildZwapButtonChild(context),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });

    if (widget.tooltip == null) return _button;
    if (widget.showTooltipOnlyOnDisabledState && !_disabled) return _button;

    return Tooltip(
      message: widget.tooltip!,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: _button,
    );
  }
}

class _FadeAway extends StatefulWidget {
  final Widget child;
  final bool show;

  const _FadeAway({
    required this.child,
    required this.show,
    super.key,
  });

  @override
  State<_FadeAway> createState() => _FadeAwayState();
}

class _FadeAwayState extends State<_FadeAway> {
  late bool _show;
  late bool _build;

  @override
  void initState() {
    super.initState();
    _show = widget.show;
    _build = widget.show;
  }

  void _makeAppear() async {
    _show = false;
    setState(() => _build = true);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _show = true);
  }

  void _makeDisappear() async {
    _build = true;
    setState(() => _show = false);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _build = false);
  }

  @override
  void didUpdateWidget(_FadeAway oldWidget) {
    if (widget.show != _show) {
      if (widget.show)
        _makeAppear();
      else
        _makeDisappear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_build) return const SizedBox();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _show ? 1 : 0,
      child: widget.child,
    );
  }
}
