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
  final FocusNode _nameNode = FocusNode();
  final FocusNode _surnameNode = FocusNode();

  bool _errorState = false;

  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ZwapText(
                        text: "Error state",
                        zwapTextType: ZwapTextType.bodyRegular,
                        textColor: ZwapColors.neutral800,
                      ),
                    ),
                    ZwapSwitch(
                      value: _errorState,
                      onChange: (value) => setState(() => _errorState = value),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 550,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ZwapText(
                        text: 'Zwap Form',
                        zwapTextType: ZwapTextType.bigBodySemibold,
                        textColor: ZwapColors.primary900Dark,
                      ),
                      SizedBox(height: 24),
                      ZwapInput(
                        dynamicLabel: "Email",
                        keyCallBackFunction: (_) {
                          _nameNode.requestFocus();
                          _nameNode.hasFocus;
                        },
                        helperText: _errorState ? 'Ipsum in consequat aute aliquip' : null,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                              child: ZwapInput(
                            dynamicLabel: "Name",
                            keyCallBackFunction: (_) {
                              _surnameNode.requestFocus();
                              _surnameNode.hasFocus;
                            },
                            helperText: _errorState ? 'Ipsum in consequat' : null,
                          )),
                          SizedBox(width: 12),
                          Flexible(
                              child: ZwapInput(
                            dynamicLabel: "Surname",
                            focusNode: _surnameNode,
                            helperText: _errorState ? 'Ipsum in consequat' : null,
                          )),
                        ],
                      ),
                      SizedBox(height: 12),
                      ZwapSelect(
                        error: _errorState,
                        errorText: "Eu fugiat aliqua Lorem ea elit nisi ullamco sunt voluptate enim.",
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
                        helperText: _errorState ? 'Ipsum in consequat' : null,
                        translateKey: (k) => "ciao",
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: ZwapStars(
                          rating: _rating,
                          starSize: 38,
                          onStarClick: (value) => setState(() => _rating = value),
                        ),
                      ),
                      SizedBox(height: 12),
                      ZwapSelect.multiple(
                          error: _errorState,
                          errorText: "Eu fugiat aliqua Lorem ea elit nisi ullamco sunt voluptate enim.",
                          label: "Seleziona gli argomenti",
                          hintText: "Seleziona gli argomenti",
                          values: const {
                            'it': 'Italiano',
                            'us': 'Inglese',
                            'fr': 'Francese',
                          },
                          callBackFunction: (_, __) => {},
                          fetchMoreData: null,
                          translateText: (key) => {
                                'not_here': 'non c\'è?',
                                'add_here': 'Aggiungilo qui',
                              }[key]!,
                          itemBuilder: (context, key, value, header) => Transform.translate(
                                offset: Offset(0, -2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ZwapText(
                                      text: _emoji(key),
                                      zwapTextType: ZwapTextType.mediumBodyRegular,
                                      textColor: ZwapColors.primary900Dark,
                                    ),
                                    SizedBox(width: 8),
                                    ZwapText(
                                      text: 'value',
                                      zwapTextType: ZwapTextType.mediumBodyRegular,
                                      textColor: ZwapColors.primary900Dark,
                                    ),
                                  ],
                                ),
                              )),
                      SizedBox(height: 892),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _emoji(String countryCode) {
  String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
  return flag;
}
