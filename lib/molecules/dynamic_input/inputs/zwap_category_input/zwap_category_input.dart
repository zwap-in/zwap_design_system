library zwap.dynamic_inputs.category_input;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_search_picker/zwap_search_picker.dart';

import '../../zwap_dynamic_input.dart';
import '../decorations/zwap_input_decorations.dart';

export '../decorations/zwap_input_decorations.dart';

part 'zwap_category_provider.dart';

typedef FilterCallback<T> = bool Function(T item, String filter);

class ZwapCategoryInput<T, S> extends StatefulWidget {
  ///  Use `==` operator to compare the values.
  ///
  /// If a value appears in multiple categories, all will
  /// be highlighted.
  final S? selectedValue;

  /// The keys are the categories and the values are the items in the category
  final Map<T, List<S>> values;

  final GetCopyOfItemCallback<T> getCopyOfCategory;
  final GetCopyOfItemCallback<S> getCopyOfItem;

  /// Will be called for each item for each category with
  /// [filter] as the user input.
  ///
  /// Only the values that satisfy the callback will be shown.
  ///
  /// Empty categories will be hidden.
  final FilterCallback<S> filterItems;

  final String? placeholder;

  /// Called when the user selects an item.
  ///
  /// The item can be null if the user clears the input selecting
  /// the current selected item.
  final FutureOr<void> Function(S? item) onSelected;

  /// Used to translate those keys:
  /// * no_results_found
  final String Function(String key) translateKey;

  /// If true and the [selectedItem] is not null, a clear button
  /// will be shown.
  final bool showClear;

  /// If provided called foreach element, if return a not null
  /// widget, this widget will be placed at the end of the element.
  final Widget? Function(S item)? addDecoratorTo;

  /// If provided, showed as the label of the input.
  ///
  /// If [placeholder] is null this value will be used instead.
  final String? label;

  final double borderRadius;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? activeBorderColor;
  final Color? textColor;

  final ZwapInputDecorations? decorations;

  ZwapCategoryInput({
    Key? key,
    required this.selectedValue,
    required this.values,
    required this.getCopyOfCategory,
    required this.getCopyOfItem,
    required this.filterItems,
    required this.onSelected,
    required this.translateKey,
    this.placeholder,
    this.showClear = true,
    this.addDecoratorTo,
    this.label,
    this.backgroundColor,
    this.borderColor,
    this.activeBorderColor,
    this.textColor,
    this.borderRadius = 8,
    this.decorations,
  }) : super(key: key);

  @override
  State<ZwapCategoryInput<T, S>> createState() => _ZwapCategoryInputState<T, S>();
}

class _ZwapCategoryInputState<T, S> extends State<ZwapCategoryInput<T, S>> {
  late final _ZwapCategoryProvider<T, S> _provider;

  final FocusNode _inputNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _provider = _ZwapCategoryProvider<T, S>(
      selectedValue: widget.selectedValue,
      allValues: widget.values,
      getCopyOfCategory: widget.getCopyOfCategory,
      getCopyOfItem: widget.getCopyOfItem,
      filterItems: widget.filterItems,
      onSelected: widget.onSelected,
      addDecoratorTo: widget.addDecoratorTo,
    );

    if (widget.selectedValue != null) _provider.inputController.text = _provider.getCopyOfItem(widget.selectedValue!);
    _inputNode.addListener(_focusListener);
  }

  void _focusListener() {
    setState(() => _hasFocus = _inputNode.hasFocus);
    if (_hasFocus) {
      _provider.inputController.text = '';
      _provider.inputKey.openIfClose();
    }

    if (!_hasFocus) {
      _provider.inputController.text = _provider.selectedValue == null ? '' : _provider.getCopyOfItem(_provider.selectedValue!);
    }
  }

  @override
  void didUpdateWidget(covariant ZwapCategoryInput<T, S> oldWidget) {
    if (widget.selectedValue != _provider.selectedValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _provider.selectedValue = widget.selectedValue;
        _provider.inputController.text = widget.selectedValue == null ? '' : _provider.getCopyOfItem(widget.selectedValue!);
        setState(() {});
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapCategoryProvider<T, S>>.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final S? _selectedItem = context.select<_ZwapCategoryProvider<T, S>, S?>((pro) => pro.selectedValue);

          return ZwapDynamicInput(
            borderRadius: widget.borderRadius,
            backgroundColor: widget.decorations?.backgroundColor ?? widget.backgroundColor,
            activeColor: widget.decorations?.hoveredBorderColor ?? widget.activeBorderColor,
            defaultColor: widget.decorations?.borderColor ?? widget.borderColor,
            dynamicLabel: widget.label,
            key: _provider.inputKey,
            builder: (context, child) => ChangeNotifierProvider<_ZwapCategoryProvider<T, S>>.value(
              value: _provider,
              child: child,
            ),
            content: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _provider.inputController,
                      focusNode: _inputNode,
                      style: getTextStyle(ZwapTextType.mediumBodyRegular)
                          .copyWith(color: widget.decorations?.textColor ?? widget.textColor ?? ZwapColors.primary900Dark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.placeholder ?? widget.label ?? '',
                        hintStyle: getTextStyle(ZwapTextType.mediumBodyRegular)
                            .copyWith(color: widget.decorations?.textColor ?? widget.textColor ?? ZwapColors.primary900Dark),
                      ),
                      cursorColor: widget.textColor ?? ZwapColors.primary900Dark,
                      onChanged: (value) => context.read<_ZwapCategoryProvider<T, S>>().filter = value,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  turns: _hasFocus ? 0.25 : 0.75,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: widget.decorations?.textColor ?? widget.textColor ?? ZwapColors.text65,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            overlay: _ZwapCategoryInputOverlay<T, S>(
              noResultsTranslated: (_) => widget.translateKey('no_results_found'),
              decorations: widget.decorations,
            ),
            showDeleteIcon: widget.showClear && _selectedItem != null,
            onDelete: () {
              context.read<_ZwapCategoryProvider<T, S>>().selectedValue = null;
              if (!_hasFocus) _provider.inputController.text = '';
            },
            focussed: _hasFocus,
            onOpen: () {
              if (_inputNode.hasFocus) return;
              _inputNode.requestFocus();
            },
            onClose: () {
              _provider.filter = '';

              if (!_inputNode.hasFocus) return;
              _inputNode.unfocus();
            },
          );
        },
      ),
    );
  }
}

class _ZwapCategoryInputOverlay<T, S> extends StatefulWidget {
  final String Function(String) noResultsTranslated;
  final ZwapInputDecorations? decorations;

  const _ZwapCategoryInputOverlay({
    required this.noResultsTranslated,
    this.decorations,
    super.key,
  });

  @override
  State<_ZwapCategoryInputOverlay<T, S>> createState() => _ZwapCategoryInputOverlayState<T, S>();
}

class _ZwapCategoryInputOverlayState<T, S> extends State<_ZwapCategoryInputOverlay<T, S>> {
  double _calculateHeight(Map<T, List<S>> values) {
    if (values.isEmpty) return 50;
    double _height = 0;

    _height = values.keys.length * 36 + values.values.map((l) => l.length).reduce((v, e) => v += e) * 32;

    final Rect? _inputRect = context.read<_ZwapCategoryProvider<T, S>>().inputKey.globalPaintBounds;
    double? _maxHeight = _inputRect == null ? null : MediaQuery.of(context).size.height - _inputRect.top - _inputRect.height - 32;

    if (MediaQuery.of(context).size.height - _inputRect!.top - _inputRect.height - 32 < 250) {
      _maxHeight = 420;
    }

    return max(50, min(_height, (_maxHeight ?? 420) - 32));
  }

  @override
  Widget build(BuildContext context) {
    final Map<T, List<S>> values = context.select<_ZwapCategoryProvider<T, S>, Map<T, List<S>>>((pro) => pro.values);
    final GetCopyOfItemCallback<T> getCopyOfCategory = context.read<_ZwapCategoryProvider<T, S>>().getCopyOfCategory;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
        height: _calculateHeight(values),
        color: widget.decorations?.overlayColor,
        child: values.isEmpty
            ? Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: ZwapText(
                  text: widget.noResultsTranslated(context.read<_ZwapCategoryProvider<T, S>>().filter),
                  zwapTextType: ZwapTextType.bigBodyRegular,
                  textColor: widget.decorations?.overlayTextColor ?? ZwapColors.primary900Dark,
                ),
              )
            : CustomScrollView(
                slivers: values.entries
                    .map(
                      (entry) => SliverStickyHeader(
                          header: Container(
                            height: 40,
                            width: double.infinity,
                            color: widget.decorations?.overlayColor ?? ZwapColors.shades0,
                            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                            alignment: Alignment.centerLeft,
                            child: ZwapText(
                              text: getCopyOfCategory(entry.key).toUpperCase(),
                              zwapTextType: ZwapTextType.mediumBodyBold,
                              textColor: widget.decorations?.overlaySecondaryTextColor ?? ZwapColors.text65,
                            ),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, index) => _SingleItemWidget<T, S>(item: entry.value[index], decorations: widget.decorations),
                              childCount: entry.value.length,
                            ),
                          )),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class _SingleItemWidget<T, S> extends StatefulWidget {
  final S item;
  final ZwapInputDecorations? decorations;

  const _SingleItemWidget({
    required this.item,
    this.decorations,
    super.key,
  });

  @override
  State<_SingleItemWidget<T, S>> createState() => _SingleItemWidgetState<T, S>();
}

class _SingleItemWidgetState<T, S> extends State<_SingleItemWidget<T, S>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool _selected = context.select<_ZwapCategoryProvider<T, S>, bool>((pro) => pro.selectedValue == widget.item);
    final GetCopyOfItemCallback<S> getCopyOfItem = context.read<_ZwapCategoryProvider<T, S>>().getCopyOfItem;

    final Widget? Function(S item)? _addDecorator = context.read<_ZwapCategoryProvider<T, S>>().addDecoratorTo;
    final Widget? _decoration = _addDecorator == null ? null : _addDecorator(widget.item);

    return InkWell(
      onTap: () => context.read<_ZwapCategoryProvider<T, S>>().selectedValue = widget.item,
      onHover: (hovered) => setState(() => _hovered = hovered),
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: _selected
              ? widget.decorations?.overlayHoverColor ?? ZwapColors.primary100
              : _hovered
                  ? widget.decorations?.overlayHoverColor ?? ZwapColors.primary50
                  : widget.decorations?.overlayColor ?? ZwapColors.shades0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: ZwapText(
                text: getCopyOfItem(widget.item),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: widget.decorations?.overlayTextColor ?? ZwapColors.primary900Dark,
              ),
            ),
            if (_decoration != null) ...[
              const SizedBox(width: 8),
              _decoration,
            ],
          ],
        ),
      ),
    );
  }
}
