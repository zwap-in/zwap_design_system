library zwap.dynamic_inputs.chips_input;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:provider/provider.dart';

part 'zwap_chips_input_provider.dart';

class PickItemStatus {
  final bool isSelected;
  final bool isHeader;
  final bool isHovered;

  PickItemStatus._({
    this.isHeader = false,
    this.isSelected = false,
    this.isHovered = false,
  });
}

typedef ChipsInputItemBuilder<T> = Widget Function(BuildContext context, T item, PickItemStatus status);
typedef ChipsInputItemSearch<T> = bool Function(T item, String search);

class ZwapChipsInput<T> extends StatefulWidget {
  final List<T> items;

  /// Called for build the items inside the picker overlay
  ///
  /// Inside the provided [PickItemStatus] you can find info
  /// such as if time is selected, hovered or if the returned widget
  /// will be used to build an header child
  ///
  /// ! **Important**: isHovered will be always false if isHeader is true
  final ChipsInputItemBuilder<T> itemBuilder;

  /// If not provided the text input may not be aligned
  final double? itemHeigth;

  /// Called to detect if an item should be hidden after
  /// user typed
  ///
  /// Should return true if items should appar in search results
  final ChipsInputItemSearch<T> searchItem;

  /// [isSelected] is true if item has just been selected
  final void Function(T item, bool isSelected)? onItemPicked;

  final String? label;
  final String? placeholder;

  /// If not provided [translateKey] must be not null
  final Widget? noResultsWidget;

  /// If not provided [noResultsWidget] must be not null
  ///
  /// Used to translate keys:
  /// * no_results_found
  /// * max_elements
  /// * continue_typing_for_more_results
  final String Function(String)? translateKey;

  /// Items must be the same objects from items list
  final List<T> selectedItems;

  /// If true the showed items will not be all available
  /// items until the searched text length is less than
  /// [showLessItemUntilLength]
  final bool showLessItem;

  /// Number of characters needed before start showing all items
  final int showLessItemUntilLength;

  /// Items showed while search text length is less than
  /// [showLessItemUntilLength]
  final List<T>? lessItems;

  /// Must be positive (0 included)
  ///
  /// If 0 there will be no maximum, otherwise the provided int
  /// will be the max selected items count and a text is showed under the picker
  ///
  /// Default to 0
  final int maxSelectedItems;

  const ZwapChipsInput({
    required this.items,
    required this.itemBuilder,
    required this.searchItem,
    this.selectedItems = const [],
    this.onItemPicked,
    this.label,
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    this.itemHeigth,
    this.showLessItem = false,
    this.showLessItemUntilLength = 1,
    this.lessItems,
    this.maxSelectedItems = 0,
    Key? key,
  })  : assert(
          noResultsWidget != null || translateKey != null,
          "One of [noResultsWidget] and [translateKey] must be not null to provide an empty results message to final user",
        ),
        assert(
          !showLessItem || lessItems != null,
          "You must provide a list of items to show when search text length is less than [showLessItemUntilLength] if [showLessItem] is true",
        ),
        assert(
          maxSelectedItems >= 0,
          "[maxSelectedItems] must be a positive integer",
        ),
        super(key: key);

  @override
  State<ZwapChipsInput<T>> createState() => _ZwapChipsInputState<T>();
}

class _ZwapChipsInputState<T> extends State<ZwapChipsInput<T>> {
  final GlobalKey<ZwapDynamicInputState> _inputKey = GlobalKey();
  late final _ZwapChipsInputProvider<T> _provider;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

  bool _focussed = false;

  @override
  void initState() {
    super.initState();

    _searchNode.addListener(() => setState(() {}));

    _provider = _ZwapChipsInputProvider<T>(
      builderCallback: widget.itemBuilder,
      searchCallback: widget.searchItem,
      onItemPicked: (item, selected) {
        if (widget.onItemPicked != null) widget.onItemPicked!(item, selected);
        _inputKey.updateOverlayPosition();
      },
      values: widget.items,
      initialSelectedItems: widget.selectedItems.map((i) => i.hashCode).toList(),
      lessItems: widget.lessItems,
      showLessItems: widget.showLessItem,
      showLessItemsUntil: widget.showLessItemUntilLength,
      maxItems: widget.maxSelectedItems,
    );
  }

  @override
  void didUpdateWidget(covariant ZwapChipsInput<T> oldWidget) {
    if (widget.selectedItems.length != _provider.selectedItems.length || !listEquals(widget.selectedItems, _provider.selectedItems))
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _provider.updateSelected(widget.selectedItems.map((i) => i.hashCode).toList()),
      );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapChipsInputProvider<T>>.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final List<T> _selectedKeys = context.select<_ZwapChipsInputProvider<T>, List<T>>((pro) => pro.selectedItems);

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
              ZwapDynamicInput.customSizeContent(
                key: _inputKey,
                content: AnimatedSize(
                  duration: _selectedKeys.isEmpty ? const Duration(milliseconds: 200) : Duration.zero,
                  child: LayoutBuilder(
                    builder: (_, bounds) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: bounds.maxWidth - 54,
                            padding: EdgeInsets.only(
                              left: 12,
                              top: _selectedKeys.isEmpty ? 0 : 12,
                              bottom: _selectedKeys.isEmpty ? 0 : 12,
                            ),
                            child: Wrap(
                              runSpacing: 8,
                              spacing: 8,
                              children: [
                                ..._selectedKeys.map((k) => _SingleChipWidget<T>(item: k)).toList(),
                                _InputWrapper<T>(
                                  controller: _searchController,
                                  placeHolder: widget.placeholder ?? '',
                                  dynamicInputKey: _inputKey,
                                  child: SizedBox(
                                    height: _selectedKeys.isEmpty ? null : widget.itemHeigth,
                                    child: TextField(
                                      controller: _searchController,
                                      focusNode: _searchNode,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: _selectedKeys.isEmpty ? widget.placeholder : null,
                                      ),
                                      cursorColor: ZwapColors.primary900Dark,
                                      onTap: _inputKey.toggleOverlay,
                                      onChanged: (value) => context.read<_ZwapChipsInputProvider<T>>().search = value,
                                      style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 24,
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 125),
                                child: _searchNode.hasFocus
                                    ? Container(width: 17, key: UniqueKey())
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        child: Transform.rotate(
                                          angle: 3 * pi / 2,
                                          child: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: ZwapColors.text65),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      );
                    },
                  ),
                ),
                overlay: _ZwapPickInputOverlay<T>(
                  translateKey: widget.translateKey,
                  noResultsWidget: widget.noResultsWidget,
                ),
                focussed: _focussed,
                onOpen: () {
                  setState(() => _focussed = true);
                  _searchNode.requestFocus();
                },
                onClose: () {
                  setState(() => _focussed = false);
                  _provider.search = '';
                  _searchController.clear();
                  _searchNode.unfocus();
                },
                builder: (context, child) => ChangeNotifierProvider<_ZwapChipsInputProvider<T>>.value(
                  value: _provider,
                  child: child,
                ),
              ),
              if (widget.maxSelectedItems != 0) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: ZwapRichText.safeText(
                    textSpans: [
                      ZwapTextSpan.fromZwapTypography(text: "${widget.translateKey!('max_elements')}: ", textType: ZwapTextType.smallBodyRegular),
                      ZwapTextSpan.fromZwapTypography(text: "${_selectedKeys.length}", textType: ZwapTextType.smallBodyBold),
                      ZwapTextSpan.fromZwapTypography(text: "/${widget.maxSelectedItems}", textType: ZwapTextType.smallBodyRegular),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ZwapPickInputOverlay<T> extends StatelessWidget {
  final Function(String)? translateKey;
  final Widget? noResultsWidget;

  const _ZwapPickInputOverlay({
    this.translateKey,
    this.noResultsWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<T> _items = context.select<_ZwapChipsInputProvider<T>, List<T>>((pro) => pro.activeItems);
    final bool _isShowingLessItem =
        context.select<_ZwapChipsInputProvider<T>, bool>((pro) => pro.showLessItems && pro.search.length <= pro.showLessItemsUntil);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._items.map((i) => _SingleItemWidget<T>(item: i)).toList(),
            if (_isShowingLessItem) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ZwapText(
                  text: translateKey!('continue_typing_for_more_results'),
                  zwapTextType: ZwapTextType.mediumBodyRegular,
                  textColor: ZwapColors.primary900Dark,
                ),
              ),
            ],
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
    final ChipsInputItemBuilder<T> _builder = context.read<_ZwapChipsInputProvider<T>>().builderCallback;
    final bool _isSelected = context.select<_ZwapChipsInputProvider<T>, bool>((pro) => pro.isItemSelected(widget.item));

    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: () => context.read<_ZwapChipsInputProvider<T>>().toggleItem(widget.item),
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
        child: _builder(context, widget.item, PickItemStatus._(isHeader: false, isHovered: _hovered, isSelected: _isSelected)),
      ),
    );
  }
}

class _SingleChipWidget<T> extends StatelessWidget {
  final T item;

  const _SingleChipWidget({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChipsInputItemBuilder<T> _builder = context.read<_ZwapChipsInputProvider<T>>().builderCallback;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: ZwapColors.neutral100,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 0,
            child: _builder(context, item, PickItemStatus._(isHeader: true, isHovered: false, isSelected: true)),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => context.read<_ZwapChipsInputProvider<T>>().toggleItem(item),
            child: Container(width: 20, height: 20, child: Icon(Icons.close_rounded, size: 16, color: ZwapColors.text65)),
          )
        ],
      ),
    );
  }
}

class _InputWrapper<T> extends StatefulWidget {
  final Widget child;
  final String placeHolder;
  final TextEditingController controller;
  final GlobalKey<ZwapDynamicInputState> dynamicInputKey;

  const _InputWrapper({
    required this.child,
    required this.controller,
    required this.placeHolder,
    required this.dynamicInputKey,
    Key? key,
  }) : super(key: key);

  @override
  State<_InputWrapper<T>> createState() => _InputWrapperState<T>();
}

class _InputWrapperState<T> extends State<_InputWrapper<T>> {
  final TextStyle _style = getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark);

  double get _textWidth {
    final bool _isInputEmpty = context.read<_ZwapChipsInputProvider<T>>().selectedItems.isEmpty;

    final double _minWidth = _isInputEmpty ? textWidth(widget.placeHolder, _style) : 0;
    final double _width = textWidth(widget.controller.text, _style);
    return max(_minWidth, _width) + 40;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {});
    widget.dynamicInputKey.updateOverlayPosition();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 3),
      width: _textWidth,
      child: widget.child,
    );
  }
}
