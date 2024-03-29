import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/percent_widget/percent_widget.dart';
import 'package:zwap_design_system/zwap_design_system.dart';
import 'package:zwap_design_system/atoms/progress_line/zwap_progress_line.dart';

class ZwapPercentStory extends StatefulWidget {
  const ZwapPercentStory({Key? key}) : super(key: key);

  @override
  State<ZwapPercentStory> createState() => _ZwapPercentStoryState();
}

class _ZwapPercentStoryState extends State<ZwapPercentStory> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            onChanged: (v) => setState(() => _value = v),
            value: _value,
          ),
          SizedBox(height: 15),
          ZwapText(text: "Zwap Progress Line", zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.neutral800),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: LayoutBuilder(
                builder: (_, size) => ZwapProgressLine(
                  value: _value,
                  width: size.maxWidth,
                  backgroundColor: ZwapColors.neutral200,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          ZwapText(text: "Simple ZwapPercent", zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.neutral800),
          SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZwapSimplePercent(value: _value),
              SizedBox(width: 20),
              ZwapSimplePercent(
                radius: 40,
                value: _value,
                decorations: ZwapPercentIndicatorDecorations.success(lineWidth: 7, backgoundLineWidth: 3),
              ),
            ],
          ),
          SizedBox(height: 20),
          ZwapText(text: "Normal ZwapPercent", zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.neutral800),
          SizedBox(height: 8),
          ZwapPercentWidget(
            percentValue: _value,
            title: "Pro day left",
            subtitle: "Your account will be downgraded to our free plan in 6 days",
            insidePercentContent: ZwapPercentWidgetPercentContent.custom(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZwapText.customStyle(
                    text: "6",
                    customTextStyle: ZwapTypography.bigBodyBold.copyWith(height: 0.85, color: ZwapColors.neutral600),
                    textAlign: TextAlign.center,
                  ),
                  ZwapText.customStyle(
                    text: "days",
                    customTextStyle: ZwapTypography.extraSmallBodyRegular.copyWith(height: 0.85, color: ZwapColors.neutral400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            button: ZwapButton(
              height: 35,
              width: 93,
              buttonChild: ZwapButtonChild.text(text: "✨ Upgrade"),
              decorations: ZwapButtonDecorations(
                  gradient: ZwapColors.buttonGrad,
                  hoverGradient: ZwapColors.buttonGradHover,
                  disabledGradient: ZwapColors.buttonGrad,
                  focussedGradient: ZwapColors.buttonGrad,
                  pressedGradient: ZwapColors.buttonGrad,
                  contentColor: ZwapColors.shades0,
                  hoverContentColor: ZwapColors.shades0,
                  disabledContentColor: ZwapColors.shades0,
                  focussedContentColor: ZwapColors.shades0,
                  pressedContentColor: ZwapColors.shades0,
                  borderRadius: BorderRadius.circular(8),
                  internalPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
              onTap: () => {},
            ),
          ),
          SizedBox(height: 20),
          ZwapPercentWidget(
            percentValue: _value,
            title: "Pro day left",
            subtitle: "Your account will be downgraded to our free plan in 6 days",
            button: ZwapButton(
              height: 35,
              width: 93,
              buttonChild: ZwapButtonChild.text(text: "✨ Upgrade"),
              decorations: ZwapButtonDecorations(
                  gradient: LinearGradient(colors: [Color(0xffF8606B), Color(0xffF32478)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  hoverGradient: LinearGradient(
                      colors: [Color.fromARGB(255, 243, 76, 87), Color.fromARGB(255, 236, 22, 108)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter),
                  disabledGradient:
                      LinearGradient(colors: [Color(0xffF8606B), Color(0xffF32478)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  focussedGradient:
                      LinearGradient(colors: [Color(0xffF8606B), Color(0xffF32478)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  pressedGradient:
                      LinearGradient(colors: [Color(0xffF8606B), Color(0xffF32478)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  contentColor: ZwapColors.shades0,
                  hoverContentColor: ZwapColors.shades0,
                  disabledContentColor: ZwapColors.shades0,
                  focussedContentColor: ZwapColors.shades0,
                  pressedContentColor: ZwapColors.shades0,
                  borderRadius: BorderRadius.circular(8),
                  internalPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8)),
              onTap: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
