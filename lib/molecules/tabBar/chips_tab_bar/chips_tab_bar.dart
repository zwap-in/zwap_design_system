import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../atoms/atoms.dart';

enum ChipTabBarDecorationPosition { left, right }

typedef ChipTabBarDecoratorBuilder<T> = Widget? Function(BuildContext context, T item);

class ChipsTabBar<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) translateItem;

  final TextStyle? tabTextStyle;
  final TextStyle? selectedTabTextStyle;

  /// If provided and the returned widget is not null, the returned
  /// widget is used as decorator for the [item]
  final ChipTabBarDecoratorBuilder? decorationBuilder;

  /// The position of the decoration provided by [decorationBuilder]
  /// inside tab.
  ///
  ///  Default to [ChipTabBarDecorationPosition.right]
  final ChipTabBarDecorationPosition decorationPosition;

  final T? selectedTab;
  final void Function(T item)? onTabSelected;

  final EdgeInsets internalPadding;

  const ChipsTabBar({
    required this.items,
    required this.translateItem,
    this.selectedTab,
    this.onTabSelected,
    this.tabTextStyle,
    this.selectedTabTextStyle,
    this.decorationBuilder,
    this.decorationPosition = ChipTabBarDecorationPosition.right,
    this.internalPadding = const EdgeInsets.all(10),
    Key? key,
  }) : super(key: key);

  @override
  State<ChipsTabBar<T>> createState() => _ChipsTabBarState<T>();
}

class _ChipsTabBarState<T> extends State<ChipsTabBar<T>> {
  T? _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.selectedTab;
  }

  @override
  void didUpdateWidget(covariant ChipsTabBar<T> oldWidget) {
    if (_selectedTab != widget.selectedTab) setState(() => _selectedTab = widget.selectedTab);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length < 2) return Container();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.items
            .mapIndexed((i, t) => Padding(
                  padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 4),
                  child: _SingleTabWidget<T>(
                    item: t,
                    tranlateItem: widget.translateItem,
                    onTap: () => widget.onTabSelected != null ? widget.onTabSelected!(t) : null,
                    selected: _selectedTab == t,
                    tabTextStyle: widget.tabTextStyle,
                    selectedTabTextStyle: widget.selectedTabTextStyle,
                    decorationBuilder: widget.decorationBuilder,
                    decorationPosition: widget.decorationPosition,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _SingleTabWidget<T> extends StatefulWidget {
  final T item;
  final String Function(T item) tranlateItem;
  final bool selected;

  final TextStyle? tabTextStyle;
  final TextStyle? selectedTabTextStyle;

  final ChipTabBarDecoratorBuilder? decorationBuilder;

  final ChipTabBarDecorationPosition decorationPosition;

  final Function() onTap;

  const _SingleTabWidget({
    required this.tranlateItem,
    required this.item,
    required this.selected,
    required this.onTap,
    this.tabTextStyle,
    required this.decorationBuilder,
    required this.decorationPosition,
    this.selectedTabTextStyle,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleTabWidget<T>> createState() => _SingleTabWidgetState<T>();
}

class _SingleTabWidgetState<T> extends State<_SingleTabWidget<T>> {
  bool _hovered = false;
  late bool _selected;

  T get _item => widget.item;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant _SingleTabWidget<T> oldWidget) {
    if (_selected != widget.selected) setState(() => _selected = widget.selected);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    late final Widget? _decoration;

    if (widget.decorationBuilder != null)
      _decoration = widget.decorationBuilder!(context, widget.item);
    else
      _decoration = null;

    return InkWell(
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onHover: (hovered) => setState(() => _hovered = hovered),
      onTap: _selected ? () {} : widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _hovered
              ? ZwapColors.neutral200
              : _selected
                  ? ZwapColors.neutral100
                  : ZwapColors.whiteTransparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_decoration != null && widget.decorationPosition == ChipTabBarDecorationPosition.left) _decoration,
            ZwapText.customStyle(
              text: widget.tranlateItem(_item),
              customTextStyle: _selected
                  ? widget.selectedTabTextStyle ?? getTextStyle(ZwapTextType.bigBodySemibold).copyWith(color: ZwapColors.primary900Dark)
                  : widget.tabTextStyle ?? getTextStyle(ZwapTextType.bigBodyRegular).copyWith(color: ZwapColors.primary900Dark),
            ),
            if (_decoration != null && widget.decorationPosition == ChipTabBarDecorationPosition.right) _decoration,
          ],
        ),
      ),
    );
  }
}
