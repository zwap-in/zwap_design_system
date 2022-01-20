/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import 'picker/zwapDatePicker.dart';

/// The provider state to handle this component
class ZwapDateInput extends StatefulWidget {
  /// The placeholder text inside this input widget
  final String hintText;

  /// The text editing controller
  final TextEditingController? inputController;

  /// The title text for this input date picker widget
  final String? label;

  final int? selectedYear;

  final int? minYear;

  final int? maxYear;

  ZwapDateInput({
    Key? key,
    required this.hintText,
    this.inputController,
    this.label,
    this.maxYear,
    this.minYear,
    this.selectedYear,
  }) : super(key: key);

  _ZwapDateInputState createState() => _ZwapDateInputState();
}

/// Component to handle the input date picker
class _ZwapDateInputState extends State<ZwapDateInput> {
  final GlobalKey _yearInputKey = GlobalKey();

  /// The focus node for the input field
  late final FocusNode _inputFocus;

  late final TextEditingController _inputController;

  /// The overlay on the input field
  OverlayEntry? _pickerOverlay;

  bool get _isOverlayOpened => _pickerOverlay?.mounted ?? false;

  late bool _isHovered;

  @override
  void initState() {
    _isHovered = false;
    _inputController = widget.inputController ?? TextEditingController();
    _inputFocus = FocusNode(onKeyEvent: (node, event) {
      if (_isOverlayOpened) {}

      return KeyEventResult.ignored;
    });

    super.initState();
  }

  void _toggleOverlay() {
    if (_pickerOverlay?.mounted ?? false) {
      try {
        _pickerOverlay!.remove();
      } catch (e) {}
      _pickerOverlay = null;
    } else {
      Overlay.of(context)?.insert(_pickerOverlay = _createOverlay());
      if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
    }

    setState(() {});
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(builder: (context) {
      return ZwapOverlayEntryWidget(
        entity: _pickerOverlay,
        onAutoClose: () => _inputFocus.hasFocus ? _inputFocus.unfocus() : null,
        child: ZwapOverlayEntryChild(
          top: (_yearInputKey.globalOffset?.dy ?? 0) + 45,
          left: _yearInputKey.globalOffset?.dx ?? 0,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 350),
            curve: Curves.decelerate,
            tween: Tween(begin: 0, end: 1),
            builder: (context, animation, child) => Opacity(
              opacity: animation,
              child: Container(height: 200),
            ),
          ),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          ZwapText(
            text: widget.label!,
            zwapTextType: ZwapTextType.bodySemiBold,
            textColor: ZwapColors.neutral600,
          ),
          SizedBox(height: 5),
        ],
        InkWell(
          onHover: (bool value) => setState(() => _isHovered = value),
          onTap: () {
            if (!_inputFocus.hasFocus) _inputFocus.requestFocus();

            _toggleOverlay();
          },
          child: Container(
            key: _yearInputKey,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: this._isHovered ? ZwapColors.primary300 : ZwapColors.neutral300),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocus,
                    decoration: InputDecoration.collapsed(hintText: widget.hintText),
                    cursorColor: ZwapColors.shades100,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                SizedBox(width: 5),
                AnimatedRotation(
                  turns: _isOverlayOpened ? 0.5 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(_isOverlayOpened)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
