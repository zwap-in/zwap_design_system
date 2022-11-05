library zwap.dynamic_inputs.simple_picker;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:provider/provider.dart';

import '../../../../atoms/atoms.dart';

part 'zwap_simple_picker_provider.dart';

typedef SimplePickerGetCopy<T> = String Function(T item);
typedef SimplePickerGetIsSelected<T> = bool Function(T item);
typedef SimplePickerSearchItem<T> = bool Function(T item, String searchValue);
typedef SimplePickerItemBuilder<T> = Widget Function(BuildContext context, T item);

class ZwapSimplePicker<T> extends StatefulWidget {
  final List<T> items;

  /// Used to get the text to print for a single item
  final SimplePickerGetCopy<T>? getCopyOfItem;

  /// Used to build any item inside the overlay
  final SimplePickerItemBuilder<T>? itemBuilder;

  /// Selected items will be **disabled** (ie:
  /// lighter color and not clickable)
  ///
  /// Should return true if the item is selected
  final SimplePickerGetIsSelected<T> getIsSelected;

  /// Called foreach element when user type something: should
  /// return true of the item should apper in the overlay
  final SimplePickerSearchItem<T> isItemIncludedIsSearch;

  /// Called when user pick an item
  final Function(T item)? onItemPicked;

  final String? label;
  final String? placeholder;

  /// If not provided [translateKey] must be not null
  final Widget? noResultsWidget;

  /// If not provided [noResultsWidget] must be not null
  ///
  /// Used to translate keys:
  /// * no_results_found
  final String Function(String)? translateKey;

  const ZwapSimplePicker({
    required SimplePickerGetCopy<T> getCopyOfItem,
    required this.isItemIncludedIsSearch,
    required this.getIsSelected,
    required this.items,
    this.onItemPicked,
    this.label,
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    Key? key,
  })  : this.getCopyOfItem = getCopyOfItem,
        this.itemBuilder = null,
        super(key: key);

  const ZwapSimplePicker.builder({
    required SimplePickerItemBuilder<T> itemBuilder,
    required this.isItemIncludedIsSearch,
    required this.getIsSelected,
    required this.items,
    this.onItemPicked,
    this.label,
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    Key? key,
  })  : this.getCopyOfItem = null,
        this.itemBuilder = itemBuilder,
        super(key: key);

  @override
  State<ZwapSimplePicker<T>> createState() => _ZwapSimplePickerState<T>();
}

class _ZwapSimplePickerState<T> extends State<ZwapSimplePicker<T>> {
  final GlobalKey<ZwapDynamicInputState> _inputKey = GlobalKey();
  late final _ZwapSimplePickerProvider<T> _provider;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  bool _focussed = false;

  @override
  void initState() {
    super.initState();

    _searchNode.addListener(() => setState(() {}));

    _provider = _ZwapSimplePickerProvider<T>(
      getCopy: widget.getCopyOfItem,
      items: widget.items,
      itemBuilder: widget.itemBuilder,
      searchItem: widget.isItemIncludedIsSearch,
      getIsSelected: widget.getIsSelected,
      onItemTap: (item) {
        if (widget.onItemPicked != null) widget.onItemPicked!(item);
        _inputKey.closeIfOpen();
        _searchController.clear();
      },
    );

    _searchController.addListener(_controllerListener);
  }

  void _controllerListener() {
    if (!_focussed && _searchController.text.length > 1) _inputKey.openOfClose();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapSimplePickerProvider<T>>.value(
      value: _provider,
      child: Builder(
        builder: (context) => Column(
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
              onOpen: () => setState(() => _focussed = true),
              onClose: () => setState(() => _focussed = false),
              focussed: _focussed,
              builder: (context, child) => ChangeNotifierProvider<_ZwapSimplePickerProvider<T>>.value(
                value: _provider,
                child: child,
              ),
              content: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchNode,
                  decoration: InputDecoration(border: InputBorder.none, hintText: widget.placeholder),
                  cursorColor: ZwapColors.primary900Dark,
                  onTap: _inputKey.toggleOverlay,
                  onChanged: (value) => context.read<_ZwapSimplePickerProvider<T>>().search = value,
                  style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark),
                ),
              ),
              overlay: _OverlayContentWidget<T>(
                noResultsWidget: widget.noResultsWidget,
                translateKey: widget.translateKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayContentWidget<T> extends StatelessWidget {
  final Function(String)? translateKey;
  final Widget? noResultsWidget;

  const _OverlayContentWidget({
    this.translateKey,
    this.noResultsWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<T> _items = context.select<_ZwapSimplePickerProvider<T>, List<T>>((pro) => pro._filteredItems);

    if (_items.isEmpty) {
      if (noResultsWidget != null) return noResultsWidget!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: ZwapText(
          text: translateKey!('no_results_found'),
          zwapTextType: ZwapTextType.mediumBodyRegular,
          textColor: ZwapColors.primary900Dark,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _items.map((i) => _SingleItemWidget<T>(item: i)).toList(),
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
    final SimplePickerGetCopy<T>? _getCopy = context.read<_ZwapSimplePickerProvider<T>>().getCopy;
    final SimplePickerItemBuilder<T>? _itemBuilder = context.read<_ZwapSimplePickerProvider<T>>().itemBuilder;

    final SimplePickerGetIsSelected<T> _getIsSelected =
        context.select<_ZwapSimplePickerProvider<T>, SimplePickerGetIsSelected<T>>((pro) => pro.getIsSelected);

    final bool _selected = _getIsSelected(widget.item);

    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: _selected ? null : () => context.read<_ZwapSimplePickerProvider<T>>().onItemTap(widget.item),
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _hovered
            ? ZwapColors.neutral50
            : _selected
                ? ZwapColors.primary50
                : ZwapColors.shades0,
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _itemBuilder != null
            ? _itemBuilder(context, widget.item)
            : ZwapText(
                text: _getCopy!(widget.item),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: _selected ? ZwapColors.text65 : ZwapColors.primary900Dark,
              ),
      ),
    );
  }
}
