/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';


/// The interface to define any popup widget
abstract class AbstractBasePopup extends Widget{

  /// The close popup callBack
  final Function() onCloseCallBack;

  AbstractBasePopup({Key? key,
    required this.onCloseCallBack
  }) : super(key: key);

  /// The save callBack to retrieve to save the data
  void onSaveCallBack(Map<String, dynamic> json){
    this.onCloseCallBack();
  }

}


/// The Base popup class to show any widget as a dialog
class BasePopup {

  /// The context to use to build the dialog
  final BuildContext context;

  /// The function to retrieve the child widget to display inside the dialog
  final AbstractBasePopup Function(Function(BuildContext context))
      getWidgetChild;

  BasePopup({required this.context, required this.getWidgetChild});

  /// The function to close the dialog
  void _closePopup(context) {
    Navigator.pop(context);
  }

  /// The function to show the dialog
  void openPopup() {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "BasePopup",
      barrierColor: Colors.black.withOpacity(0.5),
      context: this.context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.only(
              left: getMultipleConditions(500.0, 485.0, 0.0, 0.0, 0.0),
              right: getMultipleConditions(500.0, 485.0, 0.0, 0.0, 0.0),
              top: getMultipleConditions(90.0, 90.0, 0.0, 0.0, 0.0),
            ),
            child: this.getWidgetChild(this._closePopup),
          ),
        );
      },
    );
  }
}
