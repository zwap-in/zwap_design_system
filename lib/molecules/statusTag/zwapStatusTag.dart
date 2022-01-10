/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Define the zwap status tag type
enum ZwapStatusTagType { defaultStatus, hoverStatus, selectedStatus }

/// The provider state for this Widget
class ZwapStatusTagProviderState extends ChangeNotifier {

  /// The status tag type
  ZwapStatusTagType zwapStatusTagType = ZwapStatusTagType.defaultStatus;

  /// It handles the hoovering on this status widget
  void onHover(bool isHover) {
    if (isHover && this.zwapStatusTagType == ZwapStatusTagType.defaultStatus) {
      this.zwapStatusTagType = ZwapStatusTagType.hoverStatus;
    } else if (!isHover &&
        this.zwapStatusTagType == ZwapStatusTagType.hoverStatus) {
      this.zwapStatusTagType = ZwapStatusTagType.defaultStatus;
    }
    notifyListeners();
  }

  /// Selecting or deselecting the status tag widget
  void selectDeselectLayer() {
    if (this.zwapStatusTagType != ZwapStatusTagType.selectedStatus) {
      this.zwapStatusTagType = ZwapStatusTagType.selectedStatus;
    } else {
      this.zwapStatusTagType = ZwapStatusTagType.defaultStatus;
    }
    notifyListeners();
  }
}


/// Widget for status tag
class ZwapStatusTagContainer extends StatelessWidget {

  /// The status icon
  final IconData iconStatus;

  /// The status text
  final String statusText;

  /// The callBack click function
  final Function() callBackClick;

  ZwapStatusTagContainer({Key? key,
      required this.iconStatus,
      required this.statusText,
      required this.callBackClick
  }) : super(key: key);

  /// It gets the border color for this status tag widget
  Color _getBorderColor(ZwapStatusTagProviderState provider) {
    switch (provider.zwapStatusTagType) {
      case ZwapStatusTagType.defaultStatus:
        return ZwapColors.neutral200;
      case ZwapStatusTagType.hoverStatus:
        return ZwapColors.neutral50;
      case ZwapStatusTagType.selectedStatus:
        return ZwapColors.error400;
    }
  }

  /// It gets the background color for this status tag widget
  Color _getBackGroundColor(ZwapStatusTagProviderState provider) {
    switch (provider.zwapStatusTagType) {
      case ZwapStatusTagType.defaultStatus:
        return ZwapColors.shades0;
      case ZwapStatusTagType.hoverStatus:
        return ZwapColors.shades0;
      case ZwapStatusTagType.selectedStatus:
        return ZwapColors.error400;
    }
  }

  /// It gets the color for the children elements
  Color _getChildrenColor(ZwapStatusTagProviderState provider) {
    switch (provider.zwapStatusTagType) {
      case ZwapStatusTagType.defaultStatus:
        return ZwapColors.error400;
      case ZwapStatusTagType.hoverStatus:
        return ZwapColors.error400;
      case ZwapStatusTagType.selectedStatus:
        return ZwapColors.shades0;
    }
  }

  /// It gets the elements to rendering inside the column inside the widget
  List<Widget> _getChildrenComponent(ZwapStatusTagProviderState provider) {
    Widget finalComponent = Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Icon(
            this.iconStatus,
            color: this._getChildrenColor(provider),
            size: 36,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: ZwapText(
            text: this.statusText,
            textColor: this._getChildrenColor(provider),
            zwapTextType: ZwapTextType.buttonText,
          ),
        )
      ],
    );
    List<Widget> children = [];
    if (provider.zwapStatusTagType == ZwapStatusTagType.selectedStatus) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.verified,
            color: this._getChildrenColor(provider),
            size: 18,
          )
        ],
      ));
    }
    children.add(finalComponent);
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapStatusTagProviderState>(builder: (context, provider, child) {
      List<Widget> childrenWidgets = this._getChildrenComponent(provider);
      return InkWell(
        hoverColor: Colors.transparent,
        onHover: (bool isHover) => provider.onHover(isHover),
        onTap: () => this.callBackClick(),
        child: Container(
          decoration: BoxDecoration(
              color: this._getBackGroundColor(provider),
              borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.defaultRadius)),
              border: Border.all(color: this._getBorderColor(provider))
          ),
          child: Column(
            children: List<Widget>.generate(childrenWidgets.length, ((index) => childrenWidgets[index])),
          ),
        ),
      );
    });
  }
}
