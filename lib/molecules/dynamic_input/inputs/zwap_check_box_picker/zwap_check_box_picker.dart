library zwap.check_box_picker;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:collection/collection.dart';
part 'zwap_check_box_picker_provider.dart';

class ZwapCheckBoxPicker extends StatefulWidget {
  final String? label;
  final String? hintText;

  final List<String> initialSelectedItems;
  final Map<String, String> values;

  /// Called avery time an item is toggled
  ///
  /// The key item is provided as weel as a boolean value:
  /// if is true the item is selected
  final Function(String, bool)? onToggleItem;

  const ZwapCheckBoxPicker({
    required this.values,
    this.initialSelectedItems = const [],
    this.label,
    this.hintText,
    this.onToggleItem,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapCheckBoxPicker> createState() => _ZwapCheckBoxPickerState();
}

class _ZwapCheckBoxPickerState extends State<ZwapCheckBoxPicker> {
  late final _ZwapCheckBoxPickerProvider _provider;
  bool _focussed = false;

  @override
  void initState() {
    super.initState();
    _provider = _ZwapCheckBoxPickerProvider(
      values: widget.values,
      initialSelectedKeys: widget.initialSelectedItems,
      onToggleItem: widget.onToggleItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final List<String> _selectedKeys = context.select<_ZwapCheckBoxPickerProvider, List<String>>((state) => state.selectedKeys);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null) ...[
                ZwapText(
                  text: widget.label!,
                  zwapTextType: ZwapTextType.bigBodySemibold,
                  textColor: ZwapColors.primary900Dark,
                ),
                const SizedBox(height: 8),
                ZwapDynamicInput(
                  onOpen: () => setState(() => _focussed = true),
                  onClose: () => setState(() => _focussed = false),
                  focussed: _focussed,
                  builder: (context, child) => ChangeNotifierProvider.value(value: _provider, child: child),
                  content: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            key: ValueKey(_selectedKeys.isEmpty),
                            child: _selectedKeys.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: ZwapText(
                                      text: widget.hintText ?? '',
                                      zwapTextType: ZwapTextType.mediumBodyRegular,
                                      textColor: ZwapColors.neutral500,
                                    ),
                                  )
                                : _ChipsWidget(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.decelerate,
                        turns: _focussed ? -0.25 : 0.25,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: ZwapColors.text65,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  overlay: _OverlayContentWidget(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ChipsWidget extends StatelessWidget {
  const _ChipsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _selectedKeys = context.select<_ZwapCheckBoxPickerProvider, List<String>>((state) => state.selectedKeys);
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _selectedKeys
              .mapIndexed((i, k) => Padding(
                    padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 8),
                    child: _SingleChilpWidget(keyValue: k),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _SingleChilpWidget extends StatelessWidget {
  final String keyValue;

  const _SingleChilpWidget({required this.keyValue, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _text = context.select<_ZwapCheckBoxPickerProvider, String>((state) => state.values[keyValue] ?? '--');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: ZwapColors.neutral100,
      ),
      child: Row(
        children: [
          ZwapText(
            text: _text,
            zwapTextType: ZwapTextType.mediumBodyRegular,
            textColor: ZwapColors.primary900Dark,
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(keyValue),
            child: Container(width: 20, height: 20, child: Icon(Icons.close_rounded, size: 16, color: ZwapColors.text65)),
          )
        ],
      ),
    );
  }
}

class _OverlayContentWidget extends StatelessWidget {
  const _OverlayContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _values = context.select<_ZwapCheckBoxPickerProvider, Map<String, String>>((state) => state.values);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _values.entries.map((entry) => _CheckBoxListTileWidget(keyValue: entry.key)).toList(),
        ),
      ),
    );
  }
}

class _CheckBoxListTileWidget extends StatefulWidget {
  final String keyValue;

  const _CheckBoxListTileWidget({required this.keyValue, Key? key}) : super(key: key);

  @override
  State<_CheckBoxListTileWidget> createState() => _CheckBoxListTileWidgetState();
}

class _CheckBoxListTileWidgetState extends State<_CheckBoxListTileWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool _isSelected = context.select<_ZwapCheckBoxPickerProvider, bool>((state) => state.selectedKeys.contains(widget.keyValue));
    final String _text = context.select<_ZwapCheckBoxPickerProvider, String>((state) => state.values[widget.keyValue] ?? '--');

    return InkWell(
      onTap: () => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(widget.keyValue),
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
        width: double.infinity,
        height: 40,
        color: _hovered ? ZwapColors.neutral50 : ZwapColors.shades0,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZwapCheckBox(
              value: _isSelected,
              onCheckBoxClick: (_) => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(widget.keyValue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ZwapText(
                text: _text,
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: ZwapColors.primary900Dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
