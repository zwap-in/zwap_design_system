import 'package:flutter/material.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

class PlusIcon extends StatelessWidget{

  final Function() onTapCallBack;

  final Function(bool isHovered) onHoverCallBack;

  final String totalCount;

  final bool decorationCheck;

  PlusIcon({Key? key,
    required this.onTapCallBack,
    required this.onHoverCallBack,
    required this.totalCount,
    required this.decorationCheck
  }): super(key: key);

  Widget build(BuildContext context){
    return InkWell(
      onTap: onTapCallBack,
      onHover: onHoverCallBack,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: decorationCheck ? ZwapColors.neutral100 : Colors.transparent,
          border: Border.all(color: ZwapColors.neutral200, width: 0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Plus square icon
            SizedBox(width: 10),
            Flexible(
              child: ZwapText(
                text: this.totalCount,
                textColor: ZwapColors.neutral700,
                zwapTextType: ZwapTextType.bodyRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}