library zwap.dynamic_inputs.simple_picker;

import 'package:collection/collection.dart';
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
  /// If is free input user can type anything and then
  /// click the "add" if no items are found
  ///
  /// When user type the [onCustomPicked] callback is called
  ///
  /// ! Marking an input as free input will disable the auto clear
  /// ! of the input when user close the overlay
  final bool isFreeInput;

  final List<T> items;

  /// Used to get the text to print for a single item
  final SimplePickerGetCopy<T>? getCopyOfItem;

  /// Used to build any item inside the overlay
  ///
  /// Is assumed that in the same way [disabled] is setted
  /// only from outside the widget, itemBuilder callback can
  /// interact with the "external disabled" var too.
  /// So there is no argument who sad if item is disabled in the
  /// [itemBuilder] callback
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

  /// If disabled is true no item can be picked
  final bool disabled;

  /// If true the showed items will not be all available
  /// items until the searched text length is less than
  /// [showLessItemUntilLength]
  final bool showLessItem;

  /// Number of characters needed before start showing all items
  final int showLessItemUntilLength;

  /// Items showed while search text length is less than
  /// [showLessItemUntilLength]
  final List<T>? lessItems;

  /// If true, when user unfocus this widget, the first item
  /// that is actually selected will be showed on the header
  final bool keepFirstItemOnHeader;

  final bool showChevron;

  /// The label showed above the widget
  final String? dynamicLabel;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoveredBorderColor;
  final Color? textColor;
  final Color? dynamicLabelColor;

  final void Function(String value)? onCustomPicked;

  const ZwapSimplePicker({
    required SimplePickerGetCopy<T> getCopyOfItem,
    required this.isItemIncludedIsSearch,
    required this.getIsSelected,
    required this.items,
    this.disabled = false,
    this.onItemPicked,
    this.label,
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    this.showLessItem = false,
    this.showLessItemUntilLength = 1,
    this.lessItems,
    this.keepFirstItemOnHeader = false,
    this.showChevron = false,
    this.dynamicLabel,
    this.backgroundColor,
    this.borderColor,
    this.hoveredBorderColor,
    this.textColor,
    this.dynamicLabelColor,
    this.isFreeInput = false,
    this.onCustomPicked,
    Key? key,
  })  : this.getCopyOfItem = getCopyOfItem,
        this.itemBuilder = null,
        assert(
          !showLessItem || lessItems != null,
          "You must provide a list of items to show when search text length is less than [showLessItemUntilLength] if [showLessItem] is true",
        ),
        super(key: key);

  const ZwapSimplePicker.builder({
    required SimplePickerItemBuilder<T> itemBuilder,
    required this.isItemIncludedIsSearch,
    required this.getIsSelected,
    required this.items,
    this.disabled = false,
    this.onItemPicked,
    this.label,
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    this.showLessItem = false,
    this.showLessItemUntilLength = 1,
    this.lessItems,
    this.keepFirstItemOnHeader = false,
    this.showChevron = false,
    this.dynamicLabel,
    this.backgroundColor,
    this.borderColor,
    this.hoveredBorderColor,
    this.textColor,
    this.dynamicLabelColor,
    this.isFreeInput = false,
    this.onCustomPicked,
    Key? key,
  })  : this.getCopyOfItem = null,
        this.itemBuilder = itemBuilder,
        assert(
          !showLessItem || lessItems != null,
          "You must provide a list of items to show when search text length is less than [showLessItemUntilLength] if [showLessItem] is true",
        ),
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

    _searchNode.addListener(_focusListener);

    _provider = _ZwapSimplePickerProvider<T>(
      getCopy: widget.getCopyOfItem,
      items: widget.items,
      itemBuilder: widget.itemBuilder,
      searchItem: widget.isItemIncludedIsSearch,
      getIsSelected: widget.getIsSelected,
      disabled: widget.disabled,
      onItemTap: _onItemTap,
      showLessItems: widget.showLessItem,
      showLessItemsUntil: widget.showLessItemUntilLength,
      lessItems: widget.lessItems,
    );

    _searchController.addListener(_controllerListener);
  }

  void _onItemTap(T item) {
    if (widget.onItemPicked != null) widget.onItemPicked!(item);
    _inputKey.closeIfOpen();
    _searchController.clear();
    _provider.search = '';

    if (widget.keepFirstItemOnHeader && _provider.getCopy != null && _provider.items.where((i) => _provider.getIsSelected(i)).isNotEmpty) {
      _searchController.text = _provider.getCopy!(_provider.items.firstWhere((element) => _provider.getIsSelected!(element)));
    }
  }

  void _controllerListener() {
    widget.onCustomPicked?.call(_searchController.text);

    if (!_focussed && _searchController.text.length > 1 && !widget.keepFirstItemOnHeader) {
      _inputKey.openIfClose();
    }
  }

  void _focusListener() {
    if (!_searchNode.hasFocus &&
        widget.keepFirstItemOnHeader &&
        _provider.getCopy != null &&
        _provider.items.where((i) => _provider.getIsSelected(i)).isNotEmpty) {
      _searchController.text = _provider.getCopy!(_provider.items.firstWhere((element) => _provider.getIsSelected(element)));
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ZwapSimplePicker<T> oldWidget) {
    _provider.disabled = widget.disabled;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    Widget _wrapWithChevron(Widget child) {
      if (widget.showChevron) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: child),
            const SizedBox(width: 12),
            Icon(
              Icons.keyboard_arrow_down,
              color: _focussed ? ZwapColors.transparent : (widget.dynamicLabelColor ?? ZwapColors.primary900Dark),
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
        );
      }

      return child;
    }

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
                textColor: widget.dynamicLabelColor ?? ZwapColors.primary900Dark,
              ),
              const SizedBox(height: 8),
            ],
            ZwapDynamicInput(
              dynamicLabel: widget.dynamicLabel,
              activeColor: widget.hoveredBorderColor,
              backgroundColor: widget.backgroundColor,
              defaultColor: widget.borderColor,
              key: _inputKey,
              onOpen: () => setState(() => _focussed = true),
              onClose: () => setState(() => _focussed = false),
              focussed: _focussed,
              builder: (context, child) => ChangeNotifierProvider<_ZwapSimplePickerProvider<T>>.value(
                value: _provider,
                child: child,
              ),
              content: _wrapWithChevron(
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.placeholder,
                      hintStyle: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: widget.textColor ?? ZwapColors.primary900Dark),
                    ),
                    cursorColor: widget.textColor ?? ZwapColors.primary900Dark,
                    onTap: _inputKey.toggleOverlay,
                    onChanged: (value) => context.read<_ZwapSimplePickerProvider<T>>().search = value,
                    style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: widget.textColor ?? ZwapColors.primary900Dark),
                  ),
                ),
              ),
              overlay: _OverlayContentWidget<T>(
                canAddItem: widget.isFreeInput,
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
  final bool canAddItem;

  const _OverlayContentWidget({
    required this.canAddItem,
    this.translateKey,
    this.noResultsWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<T> _items = context.select<_ZwapSimplePickerProvider<T>, List<T>>((pro) => pro._filteredItems);

    if (_items.isEmpty) {
      if (canAddItem) return Container();
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
          children: [
            ..._items.map((i) => _SingleItemWidget<T>(item: i)).toList(),
          ],
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
    final bool _disabled = context.select<_ZwapSimplePickerProvider<T>, bool>((pro) => pro.disabled);
    final SimplePickerGetCopy<T>? _getCopy = context.read<_ZwapSimplePickerProvider<T>>().getCopy;
    final SimplePickerItemBuilder<T>? _itemBuilder = context.read<_ZwapSimplePickerProvider<T>>().itemBuilder;

    final SimplePickerGetIsSelected<T> _getIsSelected =
        context.select<_ZwapSimplePickerProvider<T>, SimplePickerGetIsSelected<T>>((pro) => pro.getIsSelected);

    final bool _selected = _getIsSelected(widget.item);

    Color _getColor() {
      if (_disabled && _selected) return ZwapColors.primary50;
      if (_disabled) return ZwapColors.shades0;
      if (_hovered) return ZwapColors.neutral50;
      if (_selected) return ZwapColors.primary50;

      return ZwapColors.shades0;
    }

    Color _textColor() {
      if (_disabled && _selected) return ZwapColors.neutral700;
      if (_disabled) return ZwapColors.neutral500;
      if (_selected) return ZwapColors.text65;

      return ZwapColors.primary900Dark;
    }

    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: (_disabled) ? null : () => context.read<_ZwapSimplePickerProvider<T>>().onItemTap(widget.item),
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _getColor(),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _itemBuilder != null
            ? _itemBuilder(context, widget.item)
            : ZwapText(
                text: _getCopy!(widget.item),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: _textColor(),
              ),
      ),
    );
  }
}
