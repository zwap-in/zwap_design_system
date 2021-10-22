/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/selectTag/multiSelectField/multiSelectField.dart';

/// The multi select field list
class ZwapMultiSelectFieldListItem extends StatelessWidget {

  /// The multi select form field item
  final ZwapMultiSelectFormFieldItem zwapMultiSelectFormFieldItem;

  /// The on selected callBack function
  final VoidCallback onSelected;

  ZwapMultiSelectFieldListItem({Key? key,
    required this.zwapMultiSelectFormFieldItem,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: <Widget>[
          if(this.zwapMultiSelectFormFieldItem.leading != null) CircleAvatar(),
          SizedBox(width: 10),
          ZwapText(
            text: this.zwapMultiSelectFormFieldItem.label,
            textColor: ZwapColors.neutral700,
            zwapTextType: this.zwapMultiSelectFormFieldItem.labelStyle,
          )
        ],
      ),
    );
  }
}