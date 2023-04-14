library zwap.dynamic_inputs.category_input;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_search_picker/zwap_search_picker.dart';

import '../../zwap_dynamic_input.dart';

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
                      style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.placeholder ?? '',
                      ),
                      cursorColor: ZwapColors.primary900Dark,
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
                    color: ZwapColors.text65,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            overlay: _ZwapCategoryInputOverlay<T, S>(
              noResultsTranslated: (_) => widget.translateKey('no_results_found'),
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

class _ZwapCategoryInputOverlay<T, S> extends StatelessWidget {
  final String Function(String) noResultsTranslated;

  const _ZwapCategoryInputOverlay({
    super.key,
    required this.noResultsTranslated,
  });

  double _calculateHeight(Map<T, List<S>> values) {
    if (values.isEmpty) return 50;
    return values.keys.length * 36 + values.values.map((l) => l.length).reduce((v, e) => v += e) * 32;
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
        height: max(50, min(_calculateHeight(values), 420)),
        child: values.isEmpty
            ? Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: ZwapText(
                  text: noResultsTranslated(context.read<_ZwapCategoryProvider<T, S>>().filter),
                  zwapTextType: ZwapTextType.bigBodyRegular,
                  textColor: ZwapColors.primary900Dark,
                ),
              )
            : CustomScrollView(
                slivers: values.entries
                    .map(
                      (entry) => SliverStickyHeader(
                          header: Container(
                            height: 40,
                            width: double.infinity,
                            color: ZwapColors.shades0,
                            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                            alignment: Alignment.centerLeft,
                            child: ZwapText(
                              text: getCopyOfCategory(entry.key).toUpperCase(),
                              zwapTextType: ZwapTextType.mediumBodyBold,
                              textColor: ZwapColors.text65,
                            ),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, index) => _SingleItemWidget<T, S>(item: entry.value[index]),
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

  const _SingleItemWidget({
    required this.item,
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
              ? ZwapColors.primary100
              : _hovered
                  ? ZwapColors.primary50
                  : ZwapColors.shades0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: ZwapText(
                text: getCopyOfItem(widget.item),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: ZwapColors.primary900Dark,
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
