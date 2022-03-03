/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwap_design_system/atoms/text_controller/initial_text_controller.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/constants/zwapConstants.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

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

  /// The optional autofill hints inside the input text
  final String? autofillHints;

  final FocusNode? focusNode;

  final String? prefixText;

  ///The text showed under the input
  final String? helperText;

  ///If [true] helperText will be showed as error, else as regular text
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
    this.autofillHints,
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
  })  : assert(fixedInitialText == null || controller == null),
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
    this.autofillHints,
    this.focusNode,
    this.prefixText,
    this.fixedInitialText,
    this.fixedInitialTextStyle,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
  })  : assert(fixedInitialText == null || controller == null),
        this._isCollapsed = true,
        this.showSuccess = false,
        super(key: key);

  _ZwapInputState createState() => _ZwapInputState();
}

/// It handles the input state
class _ZwapInputState extends State<ZwapInput> {
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

    _focusNode.addListener(_focusListener);
  }

  void _focusListener() {
    if (_hasFocus != _focusNode.hasFocus) setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  Color _getBorderColor(Color defaultColor, {Color? successColor, Color? errorColor}) {
    if (widget.helperText != null && widget.helperTextIsError) return errorColor ?? ZwapColors.error300;
    if (widget.showSuccess) return successColor ?? ZwapColors.success800;

    return defaultColor;
  }

  InputBorder _getZwapInputBorder(Color borderColor) => OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
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
      hintText: widget.placeholder,
      hintStyle: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral400),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: ZwapColors.neutral400,
              size: 24,
            )
          : null,
      suffixIcon: widget.showSuccess || widget.suffixIcon != null
          ? Icon(
              widget.showSuccess ? Icons.check : widget.suffixIcon,
              color: widget.showSuccess ? ZwapColors.success800 : ZwapColors.neutral700,
              size: 24,
            )
          : null,
    );
  }

  /// It gets the input field
  TextField _getInputWidget({required InputDecoration decorations}) {
    String _getOnChangedValue(String value) {
      if (widget.fixedInitialText != null) return value.substring(widget.fixedInitialText!.length + 1);
      return value;
    }

    return TextField(
      controller: this._controller,
      scrollPadding: EdgeInsets.zero,
      enabled: !widget.disabled,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autofillHints: widget.autofillHints != null ? [widget.autofillHints!] : null,
      onChanged: widget.onChanged != null ? (String newValue) => widget.onChanged!(_getOnChangedValue(newValue)) : null,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
      cursorColor: ZwapColors.shades100,
      obscureText: widget.textInputType == TextInputType.visiblePassword,
      textAlign: TextAlign.start,
      focusNode: widget.readOnly ? FocusNode() : _focusNode,
      style: getTextStyle(ZwapTextType.bodyRegular).apply(color: widget.disabled ? ZwapColors.neutral300 : ZwapColors.neutral700),
      decoration: decorations,
      onSubmitted: widget.keyCallBackFunction,
      readOnly: widget.readOnly,
      enableInteractiveSelection: !widget.readOnly,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
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

  @override
  Widget build(BuildContext context) {
    if (widget._isCollapsed)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) this._getLabel(),
          InkWell(
            onHover: (hover) => setState(() => _isHovered = hover),
            onTap: () {},
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
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
              padding: widget.internalPadding,
              child: _getInputWidget(
                decorations: InputDecoration.collapsed(
                  hintText: widget.placeholder!,
                  hintStyle: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral400),
                  enabled: !widget.disabled,
                  hoverColor: ZwapColors.primary300,
                ),
              ),
            ),
          ),
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
