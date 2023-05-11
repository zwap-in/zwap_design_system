library zwap.dynamic_inputs.search_picker;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../atoms/colors/zwapColors.dart';
import '../../../../atoms/text/base/zwapText.dart';
import '../../../../atoms/text_controller/masked_text_controller.dart';
import '../../../../atoms/typography/zwapTypography.dart';
import '../../zwap_dynamic_input.dart';

part 'zwap_time_picker_provider.dart';

/// Defines the gap between each time in the picker
/// in the suggested list inside dropdown.
///
/// Gap starts from 00:00
enum TimePickerGap {
  none,
  fifteenMinutes,
  thirtyMinutes,
  oneHour;

  int get inMinutes {
    switch (this) {
      case TimePickerGap.none:
        return 0;
      case TimePickerGap.fifteenMinutes:
        return 15;
      case TimePickerGap.thirtyMinutes:
        return 30;
      case TimePickerGap.oneHour:
        return 60;
    }
  }
}

class ZwapTimePicker extends StatefulWidget {
  /// The current selected time.
  final TimeOfDay? value;

  /// Called when the user selects a time.
  final Function(TimeOfDay?)? onChanged;

  /// Defines the gap between each time in the picker
  /// in the suggested list inside dropdown.
  final TimePickerGap gap;

  /// The placeholder text to show when the input is empty.
  final String placeholder;

  /// Whether to show the clear icon or not.
  ///
  /// Clear icon is always showed only if [value]
  /// is not null.
  final bool showClear;

  /// If true and the gap is not [TimePickerGap.none],
  /// the user will not be able to select a time that
  /// is not respecting the gap.
  ///
  /// If try to write a time that is not respecting the gap,
  /// the value will be the closest time respecting the gap.
  final bool mustRespectGap;

  final String title;

  const ZwapTimePicker({
    required this.title,
    this.value,
    this.onChanged,
    this.gap = TimePickerGap.thirtyMinutes,
    this.placeholder = '',
    this.mustRespectGap = true,
    this.showClear = true,
    super.key,
  });

  @override
  State<ZwapTimePicker> createState() => _ZwapTimePickerState();
}

class _ZwapTimePickerState extends State<ZwapTimePicker> {
  late final _ZwapTimePickerProvider _provider;
  final FocusNode _inputNode = FocusNode();

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _provider = _ZwapTimePickerProvider(
      widget.value,
      widget.onChanged,
      widget.gap,
      widget.mustRespectGap,
    );

    _inputNode.addListener(_focusNodeListener);
  }

  @override
  void didUpdateWidget(covariant ZwapTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _provider.updateValue(widget.value, callOnChanged: false);
    }

    if (oldWidget.gap != widget.gap) {
      _provider._gap = widget.gap;
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _provider.inputController.dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    setState(() => _hasFocus = _inputNode.hasFocus);

    if (_hasFocus) {
      _provider.inputController.text = '';
      _provider.inputKey.openIfClose();
    }

    if (!_hasFocus) {
      if (_provider.suspendFocusOutListener) return;
      _provider.validateInput();
      _provider.inputController.text = _provider.value == null ? '' : _provider.formatTime(_provider.value!);

      Future.delayed(const Duration(milliseconds: 30), () {
        _provider.inputKey.closeIfOpen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      child: ChangeNotifierProvider<_ZwapTimePickerProvider>.value(
        value: _provider,
        child: Builder(
          builder: (context) {
            final TimeOfDay? _selectedItem = context.select<_ZwapTimePickerProvider, TimeOfDay?>((pro) => pro.value);

            return ZwapDynamicInput(
              minOverlayWidth: 96,
              key: _provider.inputKey,
              activeColor: ZwapColors.primary700,
              builder: (context, child) => ChangeNotifierProvider<_ZwapTimePickerProvider>.value(
                value: _provider,
                child: child,
              ),
              content: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ZwapText.customStyle(
                            text: widget.title,
                            customTextStyle: ZwapTextType.smallBodySemibold.copyWith(
                              fontSize: 10,
                              color: ZwapColors.neutral400,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          TextField(
                            controller: _provider.inputController,
                            focusNode: _inputNode,
                            style: getTextStyle(ZwapTextType.bigBodyRegular).copyWith(color: ZwapColors.primary900Dark),
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: widget.placeholder,
                            ),
                            cursorColor: ZwapColors.primary900Dark,
                            onEditingComplete: () {
                              _provider.validateInput();
                              _provider.inputKey.closeIfOpen();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              overlay: _TimePickerOverlay(),
              showDeleteIcon: widget.showClear && _selectedItem != null,
              onDelete: () {
                context.read<_ZwapTimePickerProvider>().updateValue(null);
                if (!_hasFocus) _provider.inputController.text = '';
              },
              focussed: _hasFocus,
              onOpen: () {
                if (_inputNode.hasFocus) return;
                _inputNode.requestFocus();
              },
              onClose: () {
                if (!_inputNode.hasFocus) return;
                _inputNode.unfocus();
              },
            );
          },
        ),
      ),
    );
  }
}

class _TimePickerOverlay extends StatefulWidget {
  const _TimePickerOverlay({super.key});

  @override
  State<_TimePickerOverlay> createState() => _TimePickerOverlayState();
}

class _TimePickerOverlayState extends State<_TimePickerOverlay> {
  @override
  Widget build(BuildContext context) {
    final List<TimeOfDay> _suggestedTimes = context.select<_ZwapTimePickerProvider, List<TimeOfDay>>((pro) => pro.suggestion);

    if (_suggestedTimes.isEmpty) return Container();

    return Container(
      child: InkWell(
        onTap: () {},
        onHover: (hovered) {
          context.read<_ZwapTimePickerProvider>().suspendFocusOutListener = hovered;
        },
        child: Container(
          color: ZwapColors.shades0,
          constraints: BoxConstraints(maxHeight: 240),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _suggestedTimes.map((time) => _SingleTimeWidget(time: time)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleTimeWidget extends StatefulWidget {
  final TimeOfDay time;

  const _SingleTimeWidget({
    required this.time,
    super.key,
  });

  @override
  State<_SingleTimeWidget> createState() => _SingleTimeWidgetState();
}

class _SingleTimeWidgetState extends State<_SingleTimeWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<_ZwapTimePickerProvider>().value = widget.time;
      },
      onHover: (value) => setState(() => _hover = value),
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        color: _hover ? ZwapColors.primary50 : ZwapColors.shades0,
        child: ZwapText.customStyle(
          text: context.read<_ZwapTimePickerProvider>().formatTime(widget.time),
          customTextStyle: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark),
        ),
      ),
    );
  }
}
