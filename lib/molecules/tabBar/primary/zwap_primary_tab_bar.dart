/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

//TODO (Marchetti): Let the user choose more decorations (such as hover tab style, min width and else)

/// Component to rendering the tab bar as menu
class ZwapPrimaryTabBar extends StatefulWidget {
  final List<String> tabs;
  final String selected;
  final Function(String tab)? onTabChanges;

  final ZwapTextType textType;
  final Color textColor;

  final ZwapTextType notSelectedTextType;
  final Color notSelectedTextColor;

  final TextStyle? _customStyle;
  final TextStyle? _customNotSelectedStyle;

  /// If true the tab bar will expand as much as possible in
  /// the horizontal direction
  final bool expand;

  /// Space berween each tab (adden even to
  /// the rigth of the last tab)
  final double tabSpace;

  /// A single tab width
  final double tabWidth;

  /// The selected line thickness
  final double selectedThickness;

  /// The not selected line thickness
  final double thickness;

  /// Used for tab decorations when tab is selected
  final Color selectedColor;

  /// Used for tab decorations when tab is not selected
  final Color secondaryColor;

  /// Used as padding for the primary tab line
  final double dividerHeight;

  /// If true the tab indicator will be rounded, will be a rectangle
  /// otherwise
  final bool roundTabIndicator;

  ZwapPrimaryTabBar({
    required this.tabs,
    required this.selected,
    this.onTabChanges,
    this.textColor = ZwapColors.shades100,
    this.textType = ZwapTextType.bigBodySemibold,
    this.notSelectedTextColor = ZwapColors.neutral700,
    this.notSelectedTextType = ZwapTextType.bigBodyRegular,
    this.expand = false,
    this.selectedThickness = 1.5,
    this.thickness = 1.5,
    this.secondaryColor = ZwapColors.neutral300,
    this.selectedColor = ZwapColors.primary700,
    this.tabWidth = 95,
    this.tabSpace = 0,
    this.dividerHeight = 20,
    this.roundTabIndicator = true,
    Key? key,
  })  : this._customStyle = null,
        this._customNotSelectedStyle = null,
        super(key: key);

  ZwapPrimaryTabBar.customTextStyle({
    required this.tabs,
    required this.selected,
    required TextStyle customStyle,
    required TextStyle notSelectedCustomStyle,
    this.expand = false,
    this.selectedThickness = 1.5,
    this.thickness = 1.5,
    this.secondaryColor = ZwapColors.neutral300,
    this.selectedColor = ZwapColors.primary700,
    this.tabWidth = 95,
    this.tabSpace = 0,
    this.onTabChanges,
    this.roundTabIndicator = true,
    this.dividerHeight = 20,
    Key? key,
  })  : this._customStyle = customStyle,
        this._customNotSelectedStyle = notSelectedCustomStyle,
        this.textColor = ZwapColors.shades100,
        this.textType = ZwapTextType.bigBodyRegular,
        this.notSelectedTextColor = ZwapColors.neutral700,
        this.notSelectedTextType = ZwapTextType.bigBodyRegular,
        super(key: key);

  @override
  State<ZwapPrimaryTabBar> createState() => _ZwapPrimaryTabBarState();
}

class _ZwapPrimaryTabBarState extends State<ZwapPrimaryTabBar> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant ZwapPrimaryTabBar oldWidget) {
    if (_selected != widget.selected) setState(() => _selected = widget.selected);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.expand)
          Padding(
            padding: EdgeInsets.only(
                top: (widget._customStyle == null
                        ? getTextSize("Any text", widget.textType)
                        : getTextSizeFromCustomStyle('Any Text', widget._customStyle!))
                    .height),
            child: Divider(
              height: widget.dividerHeight,
              thickness: widget.thickness,
              color: widget.secondaryColor,
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            children: widget.tabs
                .map(
                  (t) => _TabItemWidget(
                    name: t,
                    selected: _selected == t,
                    onTap: widget.onTabChanges == null ? null : () => widget.onTabChanges!(t),
                    textStyle: widget._customStyle ?? getTextStyle(widget.textType).copyWith(color: widget.textColor),
                    disabledStyle:
                        widget._customNotSelectedStyle ?? getTextStyle(widget.notSelectedTextType).copyWith(color: widget.notSelectedTextColor),
                    selectedThickness: widget.selectedThickness,
                    thickness: widget.thickness,
                    space: widget.tabSpace,
                    width: widget.tabWidth,
                    rounded: widget.roundTabIndicator,
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}

class _TabItemWidget extends StatefulWidget {
  final String name;
  final Function()? onTap;
  final bool selected;

  final TextStyle textStyle;
  final TextStyle disabledStyle;

  final double thickness;
  final double selectedThickness;
  final double width;

  final double space;
  final bool rounded;

  const _TabItemWidget({
    required this.name,
    required this.selected,
    required this.textStyle,
    required this.disabledStyle,
    required this.selectedThickness,
    required this.thickness,
    required this.width,
    required this.space,
    required this.rounded,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_TabItemWidget> createState() => __TabItemWidgetState();
}

class __TabItemWidgetState extends State<_TabItemWidget> {
  late bool _selected;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant _TabItemWidget oldWidget) {
    if (_selected != widget.selected) setState(() => _selected = widget.selected);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: widget.space),
      child: InkWell(
        onTap: widget.onTap ?? () {},
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        focusColor: ZwapColors.transparent,
        hoverColor: ZwapColors.transparent,
        splashColor: ZwapColors.transparent,
        highlightColor: ZwapColors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.decelerate.flipped,
              child: ZwapText.customStyle(
                key: ValueKey(_selected),
                text: widget.name,
                customTextStyle: _isHovered || _selected ? widget.textStyle : widget.disabledStyle,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              height: _selected ? max(0, 9.5 - widget.selectedThickness) : 9.5,
              color: ZwapColors.transparent,
            ),
            Container(
              height: max(widget.selectedThickness, widget.thickness),
              child: Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.decelerate,
                  height: _selected ? widget.selectedThickness : widget.thickness,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: _selected ? ZwapColors.primary800 : ZwapColors.neutral300,
                    borderRadius: widget.rounded ? BorderRadius.circular(5) : null,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              height: _selected ? max(0, widget.selectedThickness - widget.thickness) : 0,
              color: ZwapColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
