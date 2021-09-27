/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Widget banner to show advice info about user connections
class ZwapConnectionsAdvice extends StatelessWidget{

  /// The icon data to rendering at the left of this banner
  final IconData iconData;

  /// The text info about the advice for this user connections
  final String adviceText;

  /// The callBack function on clicking on the clear icon on the right side for this banner component
  final Function() callBackClear;

  ZwapConnectionsAdvice({Key? key,
    required this.iconData,
    required this.adviceText,
    required this.callBackClear
  }): super(key: key);

  Widget build(BuildContext context){
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Flexible(
              child: Icon(
                this.iconData,
                size: 10,
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: ZwapText(
                text: this.adviceText,
                zwapTextType: ZwapTextType.body1SemiBold,
                textColor: ZwapColors.shades0,
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: InkWell(
                onTap: () => this.callBackClear(),
                child: Icon(
                  Icons.close,
                  size: 10,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: ZwapColors.primary400,
        borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius))
      ),
    );
  }

}