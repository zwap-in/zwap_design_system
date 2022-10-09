import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';

List<IconData> _icons = [
  Icons.apple_sharp,
  Icons.airline_seat_flat,
  Icons.h_mobiledata,
  Icons.apple_sharp,
  Icons.baby_changing_station,
  Icons.e_mobiledata,
  Icons.aspect_ratio,
  Icons.branding_watermark,
  Icons.dnd_forwardslash,
  Icons.lte_mobiledata,
  Icons.mail,
];

class ZwapFormStory extends StatefulWidget {
  const ZwapFormStory({Key? key}) : super(key: key);

  @override
  State<ZwapFormStory> createState() => _ZwapFormStoryState();
}

class _ZwapFormStoryState extends State<ZwapFormStory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 550,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZwapText(
              text: 'Zwap Form',
              zwapTextType: ZwapTextType.bigBodySemibold,
              textColor: ZwapColors.primary900Dark,
            ),
            SizedBox(height: 24),
            ZwapInput(dynamicLabel: "Email"),
            SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(child: ZwapInput(dynamicLabel: "Name")),
                SizedBox(width: 12),
                Flexible(child: ZwapInput(dynamicLabel: "Surname")),
              ],
            ),
            SizedBox(height: 12),
            ZwapSelect(
              label: "Seleziona l'argomento",
              hintText: "Seleziona l'argomento",
              values: {
                for (int i in List.generate(10, (i) => i)) '$i': '$i',
              },
              callBackFunction: (_, __) => {},
              fetchMoreData: null,
              translateText: (key) => {
                'not_here': 'non c\'è?',
                'add_here': 'Aggiungilo qui',
              }[key]!,
              itemBuilder: (context, key, valus, header) => header
                  ? Row(
                      children: [
                        Icon(
                          _icons[int.parse(key)],
                          color: ZwapColors.getRandomColor(is200: true),
                          size: 16,
                        ),
                        SizedBox(width: 12),
                        ZwapText(
                          text: 'Item $key',
                          zwapTextType: ZwapTextType.mediumBodyRegular,
                          textColor: ZwapColors.primary900Dark,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _icons[int.parse(key)],
                          color: ZwapColors.getRandomColor(is200: true),
                          size: 16,
                        ),
                        SizedBox(height: 12),
                        ZwapText(
                          text: 'Item $key',
                          zwapTextType: ZwapTextType.mediumBodyRegular,
                          textColor: ZwapColors.primary900Dark,
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 12),
            ZwapInput.collapsed(
              label: "Collapsed Input",
              placeholder: "Write s omething here...",
              minLines: 4,
              maxLines: 8,
              minLenght: 50,
              showClearAll: true,
              translateKey: (k) => "ciao",
            ),
          ],
        ),
      ),
    );
  }
}
