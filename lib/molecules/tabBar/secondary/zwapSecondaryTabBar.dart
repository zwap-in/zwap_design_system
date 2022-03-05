/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// It handles the state this for this tabBar
class ZwapSecondaryTabBar extends StatefulWidget {
  /// The items inside the tabBar menu
  final List<String> items;

  final Function(String key) callBackClick;

  ZwapSecondaryTabBar({Key? key, required this.items, required this.callBackClick}) : super(key: key) {
    assert(this.items.length == 2, "This type of tab bar must have a max of 2 items");
  }

  _ZwapSecondaryTabBarState createState() => _ZwapSecondaryTabBarState(currentSelected: this.items.first);
}

/// Widget to display a secondary tab bar
class _ZwapSecondaryTabBarState extends State<ZwapSecondaryTabBar> {
  /// The current selected item
  String currentSelected;

  _ZwapSecondaryTabBarState({required this.currentSelected});

  /// The hoovered item
  String hooveredItem = "";

  /// Handle change inside this tabBar items
  void _onChange(String newKey) {
    widget.callBackClick(newKey);
    setState(() {
      this.currentSelected = newKey;
    });
  }

  /// It handles the hoovering on item inside the horizontal tabBar
  void _onHover(String? newItem) {
    setState(() {
      if (newItem != null) {
        this.hooveredItem = newItem;
      } else {
        this.hooveredItem = "";
      }
    });
  }

  /// It builds the button widget inside this horizontal tabBar
  Widget _getButtonWidget(int index) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: MouseRegion(
          onExit: (_) => this._onHover(null),
          onEnter: (_) => this._onHover(widget.items[index]),
          child: ZwapButton(
            margin: const EdgeInsets.symmetric(horizontal: 37),
            decorations: ZwapButtonDecorations.secondaryLight(
              backgroundColor: this.currentSelected == widget.items[index] ? ZwapColors.shades0 : ZwapColors.neutral200,
              contentColor: this.currentSelected == widget.items[index]
                  ? ZwapColors.neutral700
                  : this.hooveredItem == widget.items[index]
                      ? ZwapColors.neutral500
                      : ZwapColors.neutral400,
            ),
            buttonChild: ZwapButtonChild.text(text: widget.items[index]),
            onTap: () => this._onChange(widget.items[index]),
          ),
        ),
      ),
      flex: 0,
      fit: FlexFit.tight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: ZwapColors.neutral200, borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.tabBarRadius))),
      child: Padding(
        padding: EdgeInsets.all(ZwapRadius.defaultRadius),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            this._getButtonWidget(0),
            this._getButtonWidget(1),
          ],
        ),
      ),
    );
  }
}
