import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/objects/objects.dart';

class InviterInfo extends StatelessWidget {
  final InvitedByUser? invitedBy;

  InviterInfo({Key? key, required this.invitedBy}) : super(key: key);

  Widget build(BuildContext context) {
    return this.invitedBy != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5),
            child: ZwapTextMultiStyle(
              texts: {
                Utils.translatedText("invited_by"): TupleType(a: null, b: TupleType(a: ZwapTextType.bodyRegular, b: ZwapColors.neutral500)),
                " ${this.invitedBy!.name} ${this.invitedBy!.surname}": TupleType(
                    a: new TapGestureRecognizer()..onTap = () => Utils.currentState.openScreen(invitedBy!.url),
                    b: TupleType(a: ZwapTextType.bodyRegular, b: ZwapColors.primary700))
              },
            ),
          )
        : Container();
  }
}
