/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/text_controller/initial_text_controller.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

/// Custom component for a standard input with a predefined Zwap style
class ZwapInput extends StatefulWidget {
  /// Text controller for handling the value from external of this component
  final TextEditingController? controller;

  /// The input type for this custom component
  final TextInputType textInputType;

  final int? minLines;

  /// The max lines to rendering in the input text multi lines
  final int maxLines;

  /// If [true] input will be disabled
  final bool disabled;

  /// The input name as a label text
  final String? label;

  /// The placeholder for this input
  final String? placeholder;

  /// It handles the changes inside this input text field
  final Function(String newValue)? onChanged;

  /// Custom internal padding for this input
  final EdgeInsets internalPadding;

  /// Optionally prefix icon
  final IconData? prefixIcon;

  /// Optionally suffix icon
  final IconData? suffixIcon;

  /// The on key callBack function
  final Function(String value)? keyCallBackFunction;

  /// Autofill hints inside the input text
  final List<String> autofillHints;

  final FocusNode? focusNode;

  final String? prefixText;

  ///The text showed under the input
  final String? helperText;

  ///If [true] helperText will be shown as error, else as regular text
  final bool helperTextIsError;

  final bool showSuccess;

  /// If true input will de disabled but without the disabled decorations
  final bool readOnly;

  final Function()? onTap;

  final bool _isCollapsed;

  final String? fixedInitialText;

  /// Ignored if [fixedInitialText] is null
  final TextStyle? fixedInitialTextStyle;

  /// If you don't wont or can't provide a controller but need to provide some initial values use this field.
  ///
  /// If [controller] is not null this field is ignored
  final String? initialValue;

  final TextCapitalization? textCapitalization;

  final List<TextInputFormatter>? inputFormatters;

  final Widget? prefixWidget;
  final Widget? suffixWidget;

  final double? borderRadius;

  final void Function()? onEditingComplete;

  /// Is true text will be obscured
  final bool obscure;

  /// If `textInputType == TextInputType.visiblePassword` text will be obscure automatically
  ///
  /// Real reason: Lots of components may use version before 0.504
  /// In those versions text was oscured only if `textInputType == TextInputType.visiblePassword`.
  ///
  /// Default `true`
  final bool autoObscureIfPassword;

  /// If <= 0 nothing change
  ///
  /// If > 0:
  /// * A min lenght string will be shown under the input on le left: "characters: lenght/minLenght"
  /// * If `showMinLenghtIndicator == true` a dynamic bar will be shown on bottom (inside the input container)
  ///
  /// Default `0`
  final int minLenght;

  /// Works only if [minLenght] > 0. Tipically used with collapsed input
  ///
  /// See [minLenght] property for details
  ///
  /// Default `true`
  final bool showMinLenghtIndicator;

  /// If true a clear all button will be showd under the input on the right
  ///
  /// Default `false`
  final bool showClearAll;

  /// This will be used to translate 'zwap_input_characters' and 'zwap_input_clear_all' keys
  ///
  /// It must be not null if [minLenght] != 0 or [showClearAll] is true
  final String Function(String key)? translateKey;

  /// The value text style
  final TextStyle? textStyle;

  /// The value text style when [disabled] is true
  final TextStyle? disabledTextStyle;

  /// The input cursor color
  final Color? cursorColor;

  /// If provided a "floating" label will be showed:
  /// * inside the input as placeholder if empty
  /// * on the border if is not empty
  ///
  /// See [dynamicLabelTextStyle] for style
  final String? dynamicLabel;

  /// Color will be overwritten in base of the current state
  /// (focussed or not)
  final TextStyle? dynamicLabelTextStyle;

  /// Showed under the input, usually used for something
  /// like "Shift + Enter for new line"
  ///
  /// Only for collesped ZwapInput
  final String? subtitle;

  ZwapInput({
    Key? key,
    this.controller,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.disabled = false,
    this.internalPadding = const EdgeInsets.all(15),
    this.onChanged,
    this.label,
    this.placeholder,
    this.prefixIcon,
    this.suffixIcon,
    this.keyCallBackFunction,
    this.helperText,
    this.helperTextIsError = true,
    this.autofillHints = const [],
    this.focusNode,
    this.prefixText,
    this.showSuccess = false,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.fixedInitialText,
    this.fixedInitialTextStyle,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
    this.suffixWidget,
    this.prefixWidget,
    this.borderRadius,
    this.onEditingComplete,
    this.obscure = false,
    this.autoObscureIfPassword = true,
    this.minLenght = 0,
    this.showMinLenghtIndicator = true,
    this.showClearAll = false,
    this.translateKey,
    this.textStyle,
    this.disabledTextStyle,
    this.cursorColor,
    this.dynamicLabel,
    this.dynamicLabelTextStyle,
    this.subtitle,
  })  : assert(fixedInitialText == null || controller == null),
        assert(((minLenght != 0 || showClearAll) && translateKey != null) || (minLenght == 0 && !showClearAll)),
        this._isCollapsed = false,
        super(key: key);

  ZwapInput.collapsed({
    Key? key,
    this.controller,
    this.textInputType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.disabled = false,
    this.internalPadding = const EdgeInsets.all(15),
    this.onChanged,
    this.label,
    required this.placeholder,
    this.prefixIcon,
    this.suffixIcon,
    this.keyCallBackFunction,
    this.helperText,
    this.helperTextIsError = true,
    this.autofillHints = const [],
    this.focusNode,
    this.prefixText,
    this.fixedInitialText,
    this.fixedInitialTextStyle,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
    this.suffixWidget,
    this.prefixWidget,
    this.borderRadius,
    this.onEditingComplete,
    this.obscure = false,
    this.autoObscureIfPassword = true,
    this.minLenght = 0,
    this.showMinLenghtIndicator = true,
    this.showClearAll = false,
    this.translateKey,
    this.textStyle,
    this.disabledTextStyle,
    this.cursorColor,
    this.dynamicLabel,
    this.dynamicLabelTextStyle,
    this.subtitle,
  })  : assert(fixedInitialText == null || controller == null),
        assert(((minLenght != 0 || showClearAll) && translateKey != null) || (minLenght == 0 && !showClearAll)),
        this._isCollapsed = true,
        this.showSuccess = false,
        super(key: key);

  _ZwapInputState createState() => _ZwapInputState();
}

/// It handles the input state
class _ZwapInputState extends State<ZwapInput> {
  final GlobalKey _containerKey = GlobalKey();

  /// The input value controller
  late TextEditingController _controller;

  late FocusNode _focusNode;

  late bool _hasFocus;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ??
        (widget.fixedInitialText != null
            ? InitialTextController(
                text: widget.initialValue, fixedInitialString: widget.fixedInitialText!, fixedInitialStringStyle: widget.fixedInitialTextStyle)
            : TextEditingController(text: widget.initialValue));
    _focusNode = widget.focusNode ?? FocusNode();

    _hasFocus = _focusNode.hasFocus;

    _controller.addListener(_controllerListener);
    _focusNode.addListener(_focusListener);

    //? Min lenght indicator requires the _containerKey to be mounted in order to wolrk properly, so add a post frame setState callback solve this needing
    if (_showMinLenghtIndicator) WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));
  }

  void _focusListener() {
    if (_hasFocus != _focusNode.hasFocus) setState(() => _hasFocus = _focusNode.hasFocus);
  }

  void _controllerListener() {
    if (_showMinLenghtIndicator) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  bool get _showMinLenghtIndicator => widget.minLenght > 0 && widget.showMinLenghtIndicator;
  int get _realTextLenght =>
      widget.fixedInitialText != null ? max(0, _controller.text.length - widget.fixedInitialText!.length) : _controller.text.length;

  Color _getBorderColor(Color defaultColor, {Color? successColor, Color? errorColor}) {
    if (widget.helperText != null && widget.helperTextIsError) return errorColor ?? ZwapColors.error300;
    if (widget.showSuccess) return successColor ?? ZwapColors.success800;

    return defaultColor;
  }

  InputBorder _getZwapInputBorder(Color borderColor) => OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? ZwapRadius.buttonRadius)),
        borderSide: BorderSide(color: borderColor, width: 1, style: BorderStyle.solid),
      );

  /// The field decoration for any text field
  InputDecoration _getTextFieldDecoration() {
    return new InputDecoration(
      enabledBorder: _getZwapInputBorder(_getBorderColor(_focusNode.hasFocus ? ZwapColors.primary300 : ZwapColors.neutral300)),
      focusedBorder: _getZwapInputBorder(_getBorderColor(ZwapColors.primary300)),
      disabledBorder:
          _getZwapInputBorder(_getBorderColor(ZwapColors.neutral200, errorColor: ZwapColors.error50, successColor: ZwapColors.success200)),
      contentPadding: widget.internalPadding,
      prefixText: widget.prefixText,
      hoverColor: ZwapColors.primary300,
      labelText: widget.dynamicLabel,
      // getTextStyle(ZwapTextType.smallBodyRegular).copyWith(color: ZwapColors.primary700),
      labelStyle: MaterialStateTextStyle.resolveWith(
        (states) {
          final Map<MaterialState, TextStyle> styles = {
            MaterialState.focused:
                (widget.dynamicLabelTextStyle ?? getTextStyle(ZwapTextType.smallBodyRegular)).copyWith(color: ZwapColors.primary400),
          };
          for (var s in states)
            if (styles.keys.contains(s)) {
              return styles[s]!;
            }
          return (widget.dynamicLabelTextStyle ?? getTextStyle(ZwapTextType.smallBodyRegular)).copyWith(color: ZwapColors.neutral500);
        },
      ),
      hintText: widget.placeholder,
      hintStyle: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral400),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: ZwapColors.neutral400,
              size: 24,
            )
          : widget.prefixWidget,
      suffixIcon: widget.showSuccess || widget.suffixIcon != null
          ? Icon(
              widget.showSuccess ? Icons.check : widget.suffixIcon,
              color: widget.showSuccess ? ZwapColors.success800 : ZwapColors.neutral700,
              size: 24,
            )
          : widget.suffixWidget,
    );
  }

  /// It gets the input field
  Widget _getInputWidget({required InputDecoration decorations}) {
    String _getOnChangedValue(String value) {
      if (widget.fixedInitialText != null) return value.substring(widget.fixedInitialText!.length);
      return value;
    }

    return Theme(
      data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: ZwapColors.primary400)),
      child: TextField(
        controller: this._controller,
        scrollPadding: EdgeInsets.zero,
        enabled: !widget.disabled,
        keyboardType: widget._isCollapsed ? TextInputType.multiline : widget.textInputType,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged != null ? (String newValue) => widget.onChanged!(_getOnChangedValue(newValue)) : null,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
        cursorColor: widget.cursorColor ?? ZwapColors.shades100,
        obscureText: (widget.autoObscureIfPassword && widget.textInputType == TextInputType.visiblePassword) || widget.obscure,
        textAlign: TextAlign.start,
        focusNode: widget.readOnly ? FocusNode() : _focusNode,
        style: widget.disabled
            ? widget.disabledTextStyle ?? getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral300)
            : widget.textStyle ?? getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral700),
        decoration: decorations,
        onSubmitted: widget.keyCallBackFunction,
        readOnly: widget.readOnly,
        enableInteractiveSelection: !widget.readOnly,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        onEditingComplete: widget.onEditingComplete,
      ),
    );
  }

  /// It gets the label for this input
  Widget _getLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: ZwapText(
            text: widget.label!,
            zwapTextType: ZwapTextType.bodySemiBold,
            textColor: widget.disabled ? ZwapColors.neutral300 : ZwapColors.neutral600,
          ),
        ),
      ],
    );
  }

  Widget _minLenghtIndicatorWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: _realTextLenght >= widget.minLenght ? ZwapColors.success300 : ZwapColors.neutral300),
        height: 2,
        width: _realTextLenght >= widget.minLenght
            ? _containerKey.globalPaintBounds?.width ?? 0
            : (_containerKey.globalPaintBounds?.width ?? 0) * (_realTextLenght / widget.minLenght),
      ),
    );
  }

  Widget _bottomContent() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_showMinLenghtIndicator)
          ZwapRichText.safeText(
            textSpans: [
              //TODO: traduci
              ZwapTextSpan.fromZwapTypography(text: "${widget.translateKey!('zwap_input_characters')}: ", textType: ZwapTextType.smallBodyRegular),
              ZwapTextSpan.fromZwapTypography(text: "$_realTextLenght", textType: ZwapTextType.smallBodyBold),
              ZwapTextSpan.fromZwapTypography(text: "/${widget.minLenght}", textType: ZwapTextType.smallBodyRegular),
            ],
          ),
        if (widget.showClearAll)
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _controller.text = '',
            child: ZwapText(
              text: widget.translateKey!('zwap_input_clear_all'),
              zwapTextType: ZwapTextType.smallBodyRegular,
              textColor: ZwapColors.primary700,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isCollapsed)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) this._getLabel(),
          InkWell(
            onHover: (hover) => setState(() => _isHovered = hover),
            onTap: () => _focusNode.requestFocus(),
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.text,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? ZwapRadius.buttonRadius)),
              child: Container(
                key: _containerKey,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? ZwapRadius.buttonRadius)),
                  border: Border.all(
                    color: widget.disabled
                        ? _getBorderColor(ZwapColors.neutral200, errorColor: ZwapColors.error50, successColor: ZwapColors.success200)
                        : (_focusNode.hasFocus || _isHovered)
                            ? _getBorderColor(ZwapColors.primary300)
                            : _getBorderColor(ZwapColors.neutral300),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                padding: _showMinLenghtIndicator
                    ? widget.internalPadding.copyWith(
                        bottom: 0,
                        right: (widget.borderRadius ?? ZwapRadius.buttonRadius) / 2,
                        left: (widget.borderRadius ?? ZwapRadius.buttonRadius) / 2,
                      )
                    : widget.internalPadding,
                child: Column(
                  children: [
                    Padding(
                      padding: _showMinLenghtIndicator
                          ? EdgeInsets.only(
                              left: max(0, widget.internalPadding.left - (widget.borderRadius ?? ZwapRadius.buttonRadius) / 2),
                              right: max(0, widget.internalPadding.right - (widget.borderRadius ?? ZwapRadius.buttonRadius) / 2),
                            )
                          : EdgeInsets.zero,
                      child: _getInputWidget(
                        decorations: InputDecoration.collapsed(
                          hintText: widget.placeholder!,
                          hintStyle: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral400),
                          enabled: !widget.disabled,
                          hoverColor: ZwapColors.primary300,
                        ),
                      ),
                    ),
                    if (_showMinLenghtIndicator) ...[
                      SizedBox(height: widget.internalPadding.bottom),
                      _minLenghtIndicatorWidget(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (widget.subtitle != null) ...[
            SizedBox(height: 3),
            ZwapText(
              text: widget.subtitle!,
              zwapTextType: ZwapTextType.smallBodyRegular,
              textColor: ZwapColors.neutral400,
            ),
          ],
          if (widget.minLenght > 0 || widget.showClearAll) ...[
            SizedBox(height: widget.subtitle  == null ? 6 : 3),
            _bottomContent(),
          ],
          Container(
            width: double.infinity,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: widget.helperText != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: ZwapText(
                        textColor: widget.helperTextIsError ? ZwapColors.error400 : ZwapColors.success400,
                        zwapTextType: ZwapTextType.bodyRegular,
                        text: widget.helperText!,
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) this._getLabel(),
        this._getInputWidget(decorations: this._getTextFieldDecoration()),
        if (widget.minLenght > 0 || widget.showClearAll) _bottomContent(),
        Container(
          width: double.infinity,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: widget.helperText != null
                ? Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: ZwapText(
                      textColor: widget.helperTextIsError ? ZwapColors.error400 : ZwapColors.success400,
                      zwapTextType: ZwapTextType.bodyRegular,
                      text: widget.helperText!,
                    ),
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
