/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The state provider for this primary tabBar
class ZwapPrimaryTabBarState extends ChangeNotifier {

  /// The items to list inside the tab bar
  final List<String> items;

  /// The current selected item
  late String currentSelected;

  ZwapPrimaryTabBarState(String? selectedItem, {required this.items}) {
    this.currentSelected = selectedItem ?? items.first;
  }

  /// It handles any change inside the tabBar
  void onChangeItem(String newItem) {
    this.currentSelected = newItem;
    notifyListeners();
  }
}

/// Component to rendering the tab bar as menu
class ZwapPrimaryTabBar extends StatelessWidget {

  /// It builds the item inside the tabBar menu
  Widget _getItemMenu(String key, ZwapPrimaryTabBarState provider) {
    return Flexible(
      flex: 0,
      fit: FlexFit.tight,
      child: Padding(
        padding: EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: () => provider.onChangeItem(key),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: ZwapText(
                  textColor: provider.currentSelected == key
                      ? ZwapColors.primary800
                      : ZwapColors.neutral500,
                  text: key,
                  zwapTextType: ZwapTextType.bodySemiBold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: SizedBox(
                  width: 100,
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: provider.currentSelected == key
                        ? ZwapColors.primary800
                        : ZwapColors.neutral300,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ZwapPrimaryTabBarState provider = context.read<ZwapPrimaryTabBarState>();
    List<String> keys = provider.items.toList();
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: getTextSize("Any text", ZwapTextType.bodySemiBold).height),
          child: Divider(
            height: 20,
            thickness: 2,
            color: ZwapColors.neutral300,
          ),
        ),
        ZwapHorizontalScroll(
          child: Row(
            children: List<Widget>.generate(keys.length, ((index) => this._getItemMenu(keys[index], provider))),
          ),
        )
      ],
    );
  }
}
