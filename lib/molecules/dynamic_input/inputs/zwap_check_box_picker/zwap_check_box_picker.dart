library zwap.check_box_picker;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:collection/collection.dart';

part 'zwap_check_box_picker_provider.dart';
part 'zwap_check_box_picker_chip.dart';

typedef ZwapCheckBoxPickerItemBuilder = Widget Function(BuildContext context, String key, String value);

class ZwapCheckBoxPicker extends StatefulWidget {
  final String? label;
  final String? hintText;

  /// List of keys in [values] that are selected
  final List<String> selectedItems;
  final Map<String, String> values;

  /// If provided used to build elements in the header and
  /// inside the overlay
  final ZwapCheckBoxPickerItemBuilder? itemBuilder;

  /// Called avery time an item is toggled
  ///
  /// The key item is provided as weel as a boolean value:
  /// if is true the item is selected
  final Function(String, bool)? onToggleItem;

  /// This color will be used in the hovered and the selected statee
  final Color? activeColor;

  /// If true the active color will be red and, is not null,
  /// [errorText] is showed under the input
  final bool error;

  final String? errorText;

  final String? dynamicLabel;

  final bool showClearButton;
  final Function()? onClearAll;

  /// If true the widget width will be the max available,
  /// otherwise it will be the min available
  final bool expand;

  /// In provided, used to sort the selected items showed in the header
  final int Function(String keyA, String keyB)? sortItems;

  /// If greater than 0, the minimum number of items that must be selected
  final int minSelectedItems;

  /// If not empty will be showed as the overlay label
  final String overlayLabel;

  final ZwapCheckBoxPickerChipDecoration chipDecorations;

  const ZwapCheckBoxPicker({
    required this.values,
    this.selectedItems = const [],
    this.label,
    this.hintText,
    this.onToggleItem,
    this.itemBuilder,
    this.activeColor,
    this.error = false,
    this.errorText,
    this.dynamicLabel,
    this.showClearButton = false,
    this.onClearAll,
    this.expand = true,
    this.sortItems,
    this.minSelectedItems = 0,
    this.overlayLabel = '',
    this.chipDecorations = const ZwapCheckBoxPickerChipDecoration(),
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapCheckBoxPicker> createState() => _ZwapCheckBoxPickerState();
}

class _ZwapCheckBoxPickerState extends State<ZwapCheckBoxPicker> {
  late final _ZwapCheckBoxPickerProvider _provider;

  late bool _error;
  bool _focussed = false;

  @override
  void initState() {
    super.initState();
    _error = widget.error;
    _provider = _ZwapCheckBoxPickerProvider(
      values: widget.values,
      initialSelectedKeys: widget.selectedItems,
      onToggleItem: widget.onToggleItem,
      onClearAll: widget.onClearAll,
      minSelectedItems: widget.minSelectedItems,
    );
  }

  @override
  void didUpdateWidget(covariant ZwapCheckBoxPicker oldWidget) {
    if (_error != widget.error && mounted) setState(() => _error = widget.error);
    if (!listEquals(_provider.selectedKeys, widget.selectedItems)) {
      _provider.selectedKeys = widget.selectedItems;
      if (mounted) setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final List<String> _selectedKeys = context.select<_ZwapCheckBoxPickerProvider, List<String>>((state) => state.selectedKeys);

          Widget _wrapWithExpanded(Widget child) {
            if (widget.expand) return Expanded(child: child);
            return child;
          }

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
                expanded: widget.expand,
                showDeleteIcon: widget.showClearButton && _selectedKeys.isNotEmpty,
                onDelete: _provider.clear,
                dynamicLabel: _provider.selectedKeys.isEmpty ? null : widget.dynamicLabel,
                activeColor: _error ? ZwapColors.error400 : widget.activeColor,
                defaultColor: _error ? ZwapColors.error400 : null,
                onOpen: mounted ? () => setState(() => _focussed = true) : null,
                onClose: mounted ? () => setState(() => _focussed = false) : null,
                focussed: _focussed,
                builder: (context, child) => ChangeNotifierProvider.value(value: _provider, child: child),
                content: Row(
                  mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    _wrapWithExpanded(
                      AnimatedSwitcher(
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
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : _ChipsWidget(
                                  builder: widget.itemBuilder,
                                  expand: widget.expand,
                                  sort: widget.sortItems,
                                  chipDecorations: widget.chipDecorations,
                                ),
                        ),
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
                overlay: _OverlayContentWidget(
                  builder: widget.itemBuilder,
                  sort: widget.sortItems,
                  title: widget.overlayLabel,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  alignment: Alignment.centerLeft,
                  child: _error && widget.errorText != null
                      ? Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: ZwapText(
                            text: widget.errorText!,
                            zwapTextType: ZwapTextType.bodyRegular,
                            textColor: ZwapColors.error400,
                          ),
                        )
                      : Container(key: UniqueKey()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChipsWidget extends StatelessWidget {
  final ZwapCheckBoxPickerItemBuilder? builder;
  final bool expand;
  final int Function(String a, String b)? sort;
  final ZwapCheckBoxPickerChipDecoration chipDecorations;

  const _ChipsWidget({
    required this.builder,
    required this.expand,
    required this.sort,
    required this.chipDecorations,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _keys = List.from(context.select<_ZwapCheckBoxPickerProvider, List<String>>((state) => state.selectedKeys));
    if (sort != null) _keys.sort(sort!);

    return Container(
      width: expand ? double.infinity : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _keys
              .mapIndexed((i, k) => Padding(
                    padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 8),
                    child: _SingleChipWidget(
                      builder: builder,
                      keyValue: k,
                      chipDecorations: chipDecorations,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _OverlayContentWidget extends StatelessWidget {
  final ZwapCheckBoxPickerItemBuilder? builder;
  final int Function(String, String)? sort;
  final String title;

  const _OverlayContentWidget({
    required this.builder,
    required this.sort,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _values = context.select<_ZwapCheckBoxPickerProvider, Map<String, String>>((state) => state.values);
    final List<String> _keys = List.from(_values.keys);
    if (sort != null) _keys.sort(sort!);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Container(
                height: 40,
                width: double.infinity,
                child: ZwapText(
                  text: title,
                  zwapTextType: ZwapTextType.mediumBodyBold,
                  textColor: ZwapColors.text65,
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
              ),
            ..._keys
                .map(
                  (k) => _CheckBoxListTileWidget(builder: builder, keyValue: k),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxListTileWidget extends StatefulWidget {
  final String keyValue;
  final ZwapCheckBoxPickerItemBuilder? builder;

  const _CheckBoxListTileWidget({
    required this.builder,
    required this.keyValue,
    Key? key,
  }) : super(key: key);

  @override
  State<_CheckBoxListTileWidget> createState() => _CheckBoxListTileWidgetState();
}

class _CheckBoxListTileWidgetState extends State<_CheckBoxListTileWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool _isSelected = context.select<_ZwapCheckBoxPickerProvider, bool>((state) => state.selectedKeys.contains(widget.keyValue));
    final String _text = context.select<_ZwapCheckBoxPickerProvider, String>((state) => state.values[widget.keyValue] ?? '--');

    final bool _disable = context.select<_ZwapCheckBoxPickerProvider, bool>(
      (pro) => pro.minSelectedItems > 0 && pro.selectedKeys.length == pro.minSelectedItems,
    );

    return InkWell(
      onTap: () => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(widget.keyValue),
      onHover: (isHovered) => mounted ? setState(() => _hovered = isHovered) : null,
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
              disabled: _disable,
              onCheckBoxClick: (_) => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(widget.keyValue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.builder == null
                  ? ZwapText(
                      text: _text,
                      zwapTextType: ZwapTextType.bigBodyRegular,
                      textColor: ZwapColors.primary900Dark,
                    )
                  : widget.builder!(context, widget.keyValue, _text),
            ),
          ],
        ),
      ),
    );
  }
}
