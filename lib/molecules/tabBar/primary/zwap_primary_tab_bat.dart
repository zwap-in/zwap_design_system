/// IMPORTING THIRD PARTY PACKAGES
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

  final TextStyle? _customStyle;

  ZwapPrimaryTabBar({
    required this.tabs,
    required this.selected,
    this.onTabChanges,
    this.textColor = ZwapColors.shades100,
    this.textType = ZwapTextType.bigBodyRegular,
    Key? key,
  })  : this._customStyle = null,
        super(key: key);

  ZwapPrimaryTabBar.customTextStyle({
    required this.tabs,
    required this.selected,
    required TextStyle customStyle,
    this.onTabChanges,
    Key? key,
  })  : this._customStyle = customStyle,
        this.textColor = ZwapColors.shades100,
        this.textType = ZwapTextType.bigBodyRegular,
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
        Padding(
          padding: EdgeInsets.only(
              top: (widget._customStyle == null
                      ? getTextSize("Any text", widget.textType)
                      : getTextSizeFromCustomStyle('Any Text', widget._customStyle!))
                  .height),
          child: Divider(
            height: 20,
            thickness: 2,
            color: ZwapColors.neutral300,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.tabs
                .map((t) => widget._customStyle == null
                    ? _TabItemWidget(
                        name: t,
                        selected: _selected == t,
                        onTap: widget.onTabChanges == null ? null : () => widget.onTabChanges!(t),
                        textColor: widget.textColor,
                        textType: widget.textType,
                      )
                    : _TabItemWidget.customStyle(
                        name: t,
                        selected: _selected == t,
                        onTap: widget.onTabChanges == null ? null : () => widget.onTabChanges!(t),
                        style: widget._customStyle!,
                      ))
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

  final ZwapTextType textType;
  final Color textColor;

  final TextStyle? _customStyle;

  const _TabItemWidget({
    required this.name,
    required this.selected,
    required this.textType,
    required this.textColor,
    this.onTap,
    Key? key,
  })  : this._customStyle = null,
        super(key: key);

  const _TabItemWidget.customStyle({
    required this.name,
    required this.selected,
    required TextStyle style,
    this.onTap,
    Key? key,
  })  : this._customStyle = style,
        this.textType = ZwapTextType.bigBodyRegular,
        this.textColor = ZwapColors.shades100,
        super(key: key);

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
      padding: EdgeInsets.only(right: 20),
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
              child: widget._customStyle == null
                  ? ZwapText(
                      key: ValueKey(_selected),
                      text: widget.name,
                      textColor: _selected
                          ? widget.textColor
                          : _isHovered
                              ? ZwapColors.neutral800
                              : ZwapColors.neutral500,
                      zwapTextType: widget.textType,
                    )
                  : ZwapText.customStyle(
                      key: ValueKey(_selected),
                      text: widget.name,
                      customTextStyle: _isHovered && !_selected ? widget._customStyle!.copyWith(color: ZwapColors.neutral800) : widget._customStyle!,
                    ),
            ),
            SizedBox(height: 9.5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              height: 1.5,
              width: 95,
              decoration: BoxDecoration(
                color: _selected ? ZwapColors.primary800 : ZwapColors.neutral300,
                borderRadius: BorderRadius.circular(5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
