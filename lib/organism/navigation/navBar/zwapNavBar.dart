/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// It handles the state for this custom navBar
class ZwapNavBarState extends ChangeNotifier {

  /// Current selected item
  String selectedItem;

  /// Custom callBack function to handle the change screen on click on any item inside the navBar
  final Function(String newItem) changeScreenCallBack;

  /// Callback function to handle the opening menu
  final Function() openMenuCallBack;

  ZwapNavBarState({
    required this.selectedItem,
    required this.changeScreenCallBack,
    required this.openMenuCallBack
  });

  /// Flag to check if the menu is open
  bool isOpen = false;

  /// It opens or closes the menu
  void openCloseMenu(bool newValue) {
    this.openMenuCallBack();
    this.isOpen = newValue;
    notifyListeners();
  }

  /// It changes the current selected item
  void changeItem(String newValue) {
    this.selectedItem = newValue;
    notifyListeners();
    this.changeScreenCallBack(newValue);
  }
}

/// Component to rendering a navBar with a standard style
class ZwapNavBar extends StatelessWidget {

  /// The icons mapping with their related name inside the navbar menu
  final Map<String, IconData> iconsMenu;

  /// The current avatar image path
  final String currentAvatarPath;

  /// Is this avatar image an external asset?
  final bool isAvatarImageExternal;

  /// The background color for this navbar
  final Color backgroundColor;

  /// Bool flag to show or not the invite button inside the navBar
  final bool showInviteButton;

  ZwapNavBar({Key? key,
    required this.iconsMenu,
    required this.currentAvatarPath,
    required this.backgroundColor,
    this.isAvatarImageExternal = true,
    this.showInviteButton = false,
  }) : super(key: key);

  /// It retrieves the row to display the icon menu inside the navbar
  List<Widget> _getIconsRow(ZwapNavBarState provider) {
    List<Widget> iconsRow = [];
    this.iconsMenu.forEach((String key, IconData value) {
      Color tmpColor = provider.selectedItem == key
          ? ZwapColors.primary700
          : ZwapColors.neutral500;
      Widget tmp = Flexible(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 1.5),
                child: InkWell(
                  onTap: () => provider.changeItem(key),
                  child: Icon(
                    value,
                    color: tmpColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.5),
                child: InkWell(
                  onTap: () => provider.changeItem(key),
                  child: ZwapText(
                    text: key,
                    textColor: tmpColor,
                    zwapTextType: ZwapTextType.body1Regular,
                  ),
                ),
              )
            ],
          ),
        ),
        flex: 0,
        fit: FlexFit.tight,
      );
      iconsRow.add(tmp);
    });
    return iconsRow;
  }

  /// It retrieves the avatar icon with a button to show a dropdown menu
  Widget _getAvatarIcon(ZwapNavBarState provider) {
    return InkWell(
      onTap: () => {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: ZwapAvatar(
              imagePath: this.currentAvatarPath,
              size: 20,
              isExternal: this.isAvatarImageExternal,
            ),
            flex: 0,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: Icon(
              provider.isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            flex: 0,
            fit: FlexFit.tight,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapNavBarState>(builder: (context, provider, child) {
      List<Widget> rightIcons = this._getIconsRow(provider);
      List<Widget> leftWidgets = [
        Padding(
          padding: EdgeInsets.only(left: 30),
          child: Image.asset(
            "assets/images/brand/icon.png",
            package: "zwap_design_system",
            width: 45,
            height: 45,
          ),
        )
      ];
      if (this.showInviteButton) {
        leftWidgets.add(
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: ZwapButton(
                onPressedCallBack: () {},
                zwapButtonContentType: ZwapButtonContentType.withIcon,
                zwapButtonStatus: ZwapButtonStatus.defaultStatus,
                zwapButtonType: ZwapButtonType.flat,
                text: "Get invite Codes",
                icon: Icons.sticky_note_2,
              ),
            )
        );
      }
      List<Widget> rightWidgets = [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(rightIcons.length, ((index) => rightIcons[index])),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: this._getAvatarIcon(provider),
        )
      ];
      return Container(
        color: this.backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ZwapSeparatedRow(
          leftWidgets: leftWidgets,
          rightWidgets: rightWidgets,
        ),
      );
    });
  }
}
