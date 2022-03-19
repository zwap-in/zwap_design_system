import 'package:flutter/material.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/objects/objects.dart';

class SingleStatus extends StatelessWidget{

  final int currentIndex;

  final int? hoveredIndex;

  final StatusModel status;

  final Function(StatusModel status) onStatusTap;

  final Function(int? index) changeIndex;

  SingleStatus({Key? key,
    required this.currentIndex,
    required this.hoveredIndex,
    required this.status,
    required this.onStatusTap,
    required this.changeIndex
  }): super(key: key);

  Widget build(BuildContext context){
    return InkWell(
      onTap: () => onStatusTap(status),
      onHover: (isHovered) => changeIndex(isHovered ? currentIndex : null),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: hoveredIndex == currentIndex ? ZwapColors.neutral100 : Colors.transparent,
          border: Border.all(color: ZwapColors.neutral200, width: 0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.iconData, color: status.statusColor, size: 16),
            SizedBox(width: 10),
            Flexible(
              child: ZwapText.customStyle(
                text: status.statusName,
                customTextStyle: TextStyle(
                  color: ZwapColors.shades100,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SFUIText',
                  package: 'zwap_design_system',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}