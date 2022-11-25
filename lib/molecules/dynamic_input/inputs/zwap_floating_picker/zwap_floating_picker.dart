import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_floating_picker/zwap_floating_picker_provider.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';

import '../../../../atoms/atoms.dart';

class ZwapFloatingPicker<T> extends StatefulWidget {
  final List<T> options;
  final T? selectedOption;

  final void Function(T?)? onSelected;

  final String? label;
  final String? placeholder;

  final String Function(T) getItemString;

  const ZwapFloatingPicker({
    required this.options,
    required this.getItemString,
    this.selectedOption,
    this.onSelected,
    this.label,
    this.placeholder,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapFloatingPicker<T>> createState() => _ZwapFloatingPickerState<T>();
}

class _ZwapFloatingPickerState<T> extends State<ZwapFloatingPicker<T>> {
  final GlobalKey<ZwapDynamicInputState> _inputKey = GlobalKey();
  late final ZwapFloatingPickerProvider<T> _provider;
  bool _focussed = false;

  @override
  void initState() {
    super.initState();

    _provider = ZwapFloatingPickerProvider<T>(
      inputKey: _inputKey,
      values: widget.options,
      onSelected: widget.onSelected,
      selectedValue: widget.selectedOption,
      getCopy: widget.getItemString,
    );
  }

  @override
  void didUpdateWidget(covariant ZwapFloatingPicker<T> oldWidget) {
    if (widget.selectedOption != _provider.selectedValue) _provider.selectedValue = widget.selectedOption;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
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
        ],
        ZwapDynamicInput(
          key: _inputKey,
          content: ChangeNotifierProvider<ZwapFloatingPickerProvider<T>>.value(
            value: _provider,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _ContentWidget<T>(
                      placeholder: widget.placeholder ?? '',
                      focussed: _focussed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.decelerate,
                    turns: _focussed ? 0.25 : 0.75,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: ZwapColors.text65,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          overlay: _OverlayWidget<T>(),
          onOpen: () => setState(() => _focussed = true),
          onClose: () => setState(() => _focussed = false),
          builder: (_, child) => ChangeNotifierProvider<ZwapFloatingPickerProvider<T>>.value(
            value: _provider,
            child: child,
          ),
          focussed: _focussed,
        ),
      ],
    );
  }
}

class _ContentWidget<T> extends StatefulWidget {
  final String placeholder;
  final bool focussed;

  const _ContentWidget({required this.focussed, this.placeholder = '', Key? key}) : super(key: key);

  @override
  State<_ContentWidget<T>> createState() => _ContentWidgetState<T>();
}

class _ContentWidgetState<T> extends State<_ContentWidget<T>> {
  late bool _focussed;

  @override
  void initState() {
    super.initState();
    _focussed = widget.focussed;
  }

  @override
  void didUpdateWidget(covariant _ContentWidget<T> oldWidget) {
    if (_focussed != widget.focussed) setState(() => _focussed = widget.focussed);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final T? _selectedItem = context.select<ZwapFloatingPickerProvider<T>, T?>((pro) => pro.selectedValue);
    final String Function(T) _getCopy = context.select<ZwapFloatingPickerProvider<T>, String Function(T)>((pro) => pro.getCopy);

    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (_selectedItem == null || _focussed)
            ? ZwapText(
                text: widget.placeholder,
                zwapTextType: ZwapTextType.mediumBodyRegular,
                textColor: ZwapColors.neutral500,
              )
            : ZwapText(
                text: _getCopy(_selectedItem),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: ZwapColors.primary900Dark,
              ),
      ),
    );
  }
}

class _OverlayWidget<T> extends StatelessWidget {
  const _OverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<T> _values = context.select<ZwapFloatingPickerProvider<T>, List<T>>((pro) => pro.values);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _values.map((i) => _SingleItemWidget<T>(item: i)).toList(),
        ),
      ),
    );
  }
}

class _SingleItemWidget<T> extends StatefulWidget {
  final T item;

  const _SingleItemWidget({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleItemWidget<T>> createState() => _SingleItemWidgetState<T>();
}

class _SingleItemWidgetState<T> extends State<_SingleItemWidget<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final String Function(T) _getCopy = context.select<ZwapFloatingPickerProvider<T>, String Function(T)>((pro) => pro.getCopy);
    final bool _isSelected = context.select<ZwapFloatingPickerProvider<T>, bool>((pro) => pro.selectedValue.hashCode == widget.item.hashCode);

    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: () {
        context.read<ZwapFloatingPickerProvider<T>>().selectedValue = widget.item;
        context.read<ZwapFloatingPickerProvider<T>>().inputKey.toggleOverlay();
      },
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _hovered
            ? ZwapColors.neutral50
            : _isSelected
                ? ZwapColors.primary50
                : ZwapColors.shades0,
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ZwapText(
          text: _getCopy(widget.item),
          zwapTextType: ZwapTextType.bigBodyRegular,
          textColor: ZwapColors.primary900Dark,
        ),
      ),
    );
  }
}
