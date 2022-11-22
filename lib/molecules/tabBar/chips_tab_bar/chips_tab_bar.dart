import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../atoms/atoms.dart';

class ChipsTabBar<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) translateItem;

  final TextStyle? tabTextStyle;
  final TextStyle? selectedTabTextStyle;

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
                    text: widget.translateItem(t),
                    onTap: () => widget.onTabSelected != null ? widget.onTabSelected!(t) : null,
                    selected: _selectedTab == t,
                    tabTextStyle: widget.tabTextStyle,
                    selectedTabTextStyle: widget.selectedTabTextStyle,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _SingleTabWidget<T> extends StatefulWidget {
  final String text;
  final bool selected;

  final TextStyle? tabTextStyle;
  final TextStyle? selectedTabTextStyle;

  final Function() onTap;

  const _SingleTabWidget({
    required this.text,
    required this.selected,
    required this.onTap,
    this.tabTextStyle,
    this.selectedTabTextStyle,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleTabWidget<T>> createState() => _SingleTabWidgetState<T>();
}

class _SingleTabWidgetState<T> extends State<_SingleTabWidget<T>> {
  bool _hovered = false;
  late bool _selected;

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
        child: ZwapText.customStyle(
          text: widget.text,
          customTextStyle: _selected
              ? widget.selectedTabTextStyle ?? getTextStyle(ZwapTextType.bigBodySemibold).copyWith(color: ZwapColors.primary900Dark)
              : widget.tabTextStyle ?? getTextStyle(ZwapTextType.bigBodyRegular).copyWith(color: ZwapColors.primary900Dark),
        ),
      ),
    );
  }
}
