/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/organism/navigation/dropDownMenu/zwapDropDownMenu.dart';

/// It handles the state for this custom navBar
class ZwapNavBarState extends ChangeNotifier {

  /// Current selected item
  String selectedItem;

  /// Custom callBack function to handle the change screen on click on any item inside the navBar
  final Function(String newItem) changeScreenCallBack;

  ZwapNavBarState({
    required this.selectedItem,
    required this.changeScreenCallBack,
  });

  /// Flag to check if the menu is open
  bool isOpen = false;

  /// It opens or closes the menu
  void openCloseMenu() {
    this.isOpen = !this.isOpen;
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
  final Map<String, String> iconsMenu;

  /// The current avatar image path
  final String currentAvatarPath;

  /// Is this avatar image an external asset?
  final bool isAvatarImageExternal;

  /// Function to handle the click on invite button inside the navBar
  final Function() onInviteButtonClick;

  /// The background color for this navbar
  final Color backgroundColor;

  /// Bool flag to show or not the invite button inside the navBar
  final bool showInviteButton;

  /// On logo click
  final Function() onLogoClick;

  /// The menu items inside the navBar menu for the desktop view
  final Map<String, TupleType<String, Function()>> menuItems;

  ZwapNavBar({Key? key,
    required this.iconsMenu,
    required this.currentAvatarPath,
    required this.backgroundColor,
    required this.onInviteButtonClick,
    required this.onLogoClick,
    this.isAvatarImageExternal = true,
    this.showInviteButton = false,
    this.menuItems = const {}
  }) : super(key: key);

  /// It retrieves the row to display the icon menu inside the navbar
  Widget _getIconsRow() {
    return Consumer<ZwapNavBarState>(
        builder: (context, provider, child){
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(this.iconsMenu.keys.toList().length, ((item) => Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.5),
                      child: InkWell(
                        onTap: () => provider.changeItem(this.iconsMenu.keys.toList()[item]),
                        child: ZwapIcons.icons(this.iconsMenu[this.iconsMenu.keys.toList()[item]]!, iconColor: provider.selectedItem == this.iconsMenu.keys.toList()[item]
                            ? ZwapColors.primary700
                            : ZwapColors.neutral500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.5),
                      child: InkWell(
                        onTap: () => provider.changeItem(this.iconsMenu.keys.toList()[item]),
                        child: ZwapText(
                          text: this.iconsMenu.keys.toList()[item].capitalize(),
                          textColor: provider.selectedItem == this.iconsMenu.keys.toList()[item]
                              ? ZwapColors.primary700
                              : ZwapColors.neutral500,
                          zwapTextType: ZwapTextType.body3Regular,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ))),
          );
        }
    );
  }

  /// It retrieves the avatar icon with a button to show a dropdown menu
  Widget _getAvatarIcon() {
    return Consumer<ZwapNavBarState>(
        builder: (context, provider, child){
          return InkWell(
            onTap: () => provider.openCloseMenu(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: ZwapAvatar(
                      imagePath: this.currentAvatarPath,
                      size: 20,
                      isExternal: this.isAvatarImageExternal,
                    ),
                  ),
                  flex: 0,
                  fit: FlexFit.tight,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: provider.isOpen ? ZwapIcons.icons("arrow_up_2") : ZwapIcons.icons("arrow_down_2"),
                  ),
                  flex: 0,
                  fit: FlexFit.tight,
                )
              ],
            ),
          );
        }
    );
  }

  Widget get _logoWidget => InkWell(
    onTap: () => this.onLogoClick(),
    child: Image.asset(
      "assets/images/brand/icon.png",
      package: "zwap_design_system",
      width: 36,
      height: 36,
    ),
  );

  Widget get _inviteButton => ZwapButton(
    iconColor: ZwapColors.error400,
    onPressedCallBack: () => this.onInviteButtonClick(),
    zwapButtonContentType: ZwapButtonContentType.withIcon,
    zwapButtonStatus: ZwapButtonStatus.hoverStatus,
    textColor: ZwapColors.neutral600,
    zwapButtonType: ZwapButtonType.flat,
    text: Utils.translatedText("button_invite_navbar"),
    icon: "ticket_star",
    verticalPadding: 10,
  );

  Widget _getDesktopNavBar(){
    List<Widget> leftWidgets = [
      Padding(
        padding: EdgeInsets.only(right: 25),
        child: this._logoWidget,
      )
    ];
    if (this.showInviteButton) {
      leftWidgets.add(
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: this._inviteButton,
          )
      );
    }
    return Column(
      children: [
        ZwapSeparatedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          leftWidgets: leftWidgets,
          rightWidgets: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: this._getIconsRow(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: this._getAvatarIcon(),
            )
          ],
        ),
        Consumer<ZwapNavBarState>(
            builder: (context, provider, child){
              return Align(
                alignment: Alignment.bottomRight,
                child: provider.isOpen ? ZwapPopupMenu(
                  menuItems: this.menuItems,
                ) : Container(),
              );
            }
        )
      ],
    );
  }

  Widget _getMobileNavBar(){
    return ZwapSeparatedRow(
        leftWidgets: [
          _logoWidget
        ],
        rightWidgets: [
          _inviteButton
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return getMultipleConditions(this._getDesktopNavBar(), this._getDesktopNavBar(), this._getDesktopNavBar(), this._getMobileNavBar(), this._getMobileNavBar());
  }
}
