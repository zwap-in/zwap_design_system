import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/radio_overlay_picker/radio_overlay_picker.dart';

class DecoratedRadioOverlay<T extends Enum> extends StatefulWidget {
  final String title;
  final List<T> values;
  final String Function(T) getValueLabel;
  final String Function(T)? headerValueLabel;
  final void Function(T) onSelectedValue;
  final T? selected;

  const DecoratedRadioOverlay({
    required this.title,
    required this.values,
    required this.getValueLabel,
    required this.onSelectedValue,
    required this.selected,
    this.headerValueLabel,
    super.key,
  });

  @override
  State<DecoratedRadioOverlay<T>> createState() => _DecoratedRadioOverlayState<T>();
}

class _DecoratedRadioOverlayState<T extends Enum> extends State<DecoratedRadioOverlay<T>> {
  final GlobalKey<RadioOverlayPickerState> _key = GlobalKey<RadioOverlayPickerState>();
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: () => _key.currentState?.toggleOverlay(),
      onHover: (hover) => setState(() => _hovered = hover),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: ZwapColors.shades0,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _hovered ? ZwapColors.text65 : ZwapColors.neutral300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(flex: 2),
            ZwapText.customStyle(
              text: widget.title,
              customTextStyle: ZwapTextType.bigBodySemibold.copyWith(
                fontSize: 10,
                color: _hovered ? ZwapColors.text65 : ZwapColors.neutral400,
              ),
            ),
            Spacer(),
            RadioOverlayPicker<T>(
              key: _key,
              values: widget.values,
              getValueLabel: widget.getValueLabel,
              onSelectedValue: widget.onSelectedValue,
              selected: widget.selected,
              headerValueLabel: widget.headerValueLabel,
              chevronSize: 16,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              overlayOffset: const Offset(-16, 32),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
