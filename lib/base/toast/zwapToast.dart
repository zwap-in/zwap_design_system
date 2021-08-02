/// IMPORTING THIRD PARTY PACKAGES
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zwap_utils/zwap_utils/utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// Custom component to show a toast element inside the screen
class ZwapToast{

  static Future<bool?> show(String text) async{
    return Fluttertoast.showToast(
        msg: text,
        webPosition: "center",
        webBgColor: Utils.colorString(DesignColors.greyPrimary),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: DesignColors.greyPrimary,
        textColor: DesignColors.blackPrimary,
        timeInSecForIosWeb: 2
    );
  }

  static Future<bool?> cancel() async{
    return Fluttertoast.cancel();
  }

}

