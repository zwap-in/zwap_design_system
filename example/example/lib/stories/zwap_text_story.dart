import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/text/base/zwap_gradient_text.dart';
import 'package:zwap_design_system/molecules/moleculesText/zwap_expandable_text.dart';
import 'package:zwap_design_system/zwap_design_system.dart';

class ZwapTextStory extends StatefulWidget {
  const ZwapTextStory({Key? key}) : super(key: key);

  @override
  State<ZwapTextStory> createState() => _ZwapTextStoryState();
}

class _ZwapTextStoryState extends State<ZwapTextStory> {
  ZwapTextType _firstTextType = ZwapTextType.bigBodyBold;
  ZwapTextType _secondTextType = ZwapTextType.h3;

  Color _firstColor = ZwapColors.neutral800;
  Color _secondColor = ZwapColors.shades100;

  //TODO (Marchetti): Add dropdowns for pick colors and text types

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 120),
            ZwapRichText.safeText(
              textSpans: [
                ZwapTextSpan(
                  text: "Con Zwap espandi\n",
                  textStyle: getTextStyle(ZwapTextType.bigBodyBold).copyWith(
                    color: ZwapColors.primary900Dark,
                    fontSize: 48,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w400,
                    height: 1.10,
                  ),
                ),
                ZwapGradientTextSpan.fromGradient(
                  forcedHeight: 54,
                  forcedTranslation: Offset(0, 7),
                  text: "del 500%gggg",
                  gradient: LinearGradient(colors: [Color(0xff3E4FF7), Color(0xffDD0783)]),
                  textStyle: getTextStyle(ZwapTextType.bigBodyBold).copyWith(
                    color: ZwapColors.primary900Dark,
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                ZwapTextSpan(
                  text: " la tua rete",
                  textStyle: getTextStyle(ZwapTextType.bigBodyBold).copyWith(
                    color: ZwapColors.primary900Dark,
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                    height: 1.5,
                  ),
                ),
              ],
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: Center(child: ZwapText(text: "Test one", textColor: _firstColor, zwapTextType: _firstTextType)),
                  ),
                  Expanded(
                    child: Center(child: ZwapText(text: "Test two", textColor: _firstColor, zwapTextType: _firstTextType)),
                  ),
                ],
              ),
            ),
            ZwapExpandableText(
              text:
                  "Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt. Consectetur ex amet elit nulla adipisicing labore et aliqua consequat. Laboris eiusmod eiusmod cillum sunt.",
              maxClosedLines: 3,
              textType: ZwapTextType.bigBodyRegular,
              textColor: ZwapColors.neutral900,
              translateKey: (key) => {
                'see_less': 'Vedi meno',
                'see_more': 'Vedi tutto',
              }[key]!,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 22),
            ZwapRichText.safeText(
              textSpans: [
                ZwapTextSpan.fromZwapTypography(
                  text: "Ullamco elit proident duis laboris sint labore aliquip laborum voluptate tempor eu laborum.",
                  textType: ZwapTextType.bigBodyBold,
                  textColor: ZwapColors.warning400,
                  children: [
                    ZwapTextSpan(text: "  <Proident dolore quis culpa anim laborum.>  "),
                    ZwapTextSpan.fromZwapTypography(
                      text: "  <in bb>  ",
                    ),
                    ZwapTextSpan.fromZwapTypography(text: "  <in verde>  ", textColor: ZwapColors.success400),
                    ZwapTextSpan(text: "  <ciao>  ", textStyle: TextStyle(fontWeight: FontWeight.w200, decoration: TextDecoration.lineThrough)),
                    ZwapTextSpan(text: "...."),
                  ],
                ),
                ZwapGradientTextSpan.fromZwapTypography(
                  text: "Mollit  veniam sunt magna.",
                  textType: ZwapTextType.bigBodySemibold,
                  colors: [Colors.amber, Colors.red, Colors.blue],
                  stops: [0, 0.9, 1],
                ),
                ZwapTextSpan.fromZwapTypography(
                  text: "Mollit incididunt sunt deserunt qui veniam sunt magna.",
                  textType: ZwapTextType.smallBodyRegular,
                  textColor: ZwapColors.success400,
                ),
              ],
            ),
            SizedBox(height: 20),
            ZwapRichText.safeText(
              textSpans: [
                ZwapTextSpan.fromZwapTypography(
                  text: "dàaòj gnaòrgaeri gag a ga ",
                  textType: ZwapTextType.bigBodyRegular,
                  textColor: ZwapColors.shades100,
                ),
                ZwapGradientTextSpan.fromZwapTypography(
                  text: "mollit",
                  textType: ZwapTextType.bigBodyRegular,
                  colors: [Colors.amber, Colors.red, Colors.blue],
                  stops: [0, 0.9, 1],
                ),
                ZwapTextSpan.fromZwapTypography(
                  text: " Mollit incididunt sunt deserunt qui veniam sunt magna.",
                  textType: ZwapTextType.bigBodyRegular,
                  textColor: ZwapColors.shades100,
                  gestureRecognizer: TapGestureRecognizer()..onTap = () => print('ciao'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ZwapGradientText(
              textType: ZwapTextType.bigBodyBold,
              text: "Text text teasdfasdfaxt",
              colors: [Colors.amber, Colors.red, Colors.blue],
              stops: [0, 0.9, 1],
            ),
          ],
        ),
      ),
    );
  }
}
