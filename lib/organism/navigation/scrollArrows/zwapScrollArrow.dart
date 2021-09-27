/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom scroll arrow
class ZwapScrollArrow extends StatelessWidget {
  /// Is a right arrow or left?
  final bool isRight;

  /// Is this arrow disabled or not?
  final bool isDisabled;

  /// Custom callBack function to handle the click on this icon
  final Function() onClickCallBack;

  ZwapScrollArrow(
      {Key? key,
      required this.onClickCallBack,
      this.isRight = true,
      this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget tmp = Container(
      decoration: BoxDecoration(
          color: ZwapColors.neutral50,
          shape: BoxShape.circle,
          border: Border.all(color: ZwapColors.neutral50)),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Icon(
            this.isRight
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            color:
                this.isDisabled ? ZwapColors.neutral200 : ZwapColors.neutral700,
            size: 16,
          )),
    );
    return this.isDisabled
        ? tmp
        : InkWell(
            onTap: () => this.onClickCallBack(),
            child: tmp,
          );
  }
}
