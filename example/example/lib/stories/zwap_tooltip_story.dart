import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapTooltipStory extends StatelessWidget {
  const ZwapTooltipStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZwapColors.primary900Dark,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZwapTooltip(
              message: "Proident aute ea id velit eu mollit.",
              transationOffset: Offset(100, 5),
              simple: true,
              position: TooltipPosition.top,
              borderColor: Colors.white.withOpacity(.3),
              child: Container(
                height: 70,
                width: 120,
                decoration: BoxDecoration(color: ZwapColors.primary400, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: ZwapText(
                    text: "Simple tooltip",
                    zwapTextType: ZwapTextType.bigBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ZwapTooltip.builder(
              transationOffset: Offset(-70, 5),
              radius: 5,
              borderColor: Colors.white.withOpacity(.3),
              builder: (_) => Container(
                width: 130,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ZwapText(
                      text: "Ea duis elit occaecat",
                      zwapTextType: ZwapTextType.bigBodySemibold,
                      textColor: ZwapColors.shades0,
                    ),
                    const SizedBox(height: 2),
                    ZwapText(
                      text: "Duis elit eu id mollit. Elit anim labore excepteur non. Ad cupidatat aute ex ad deserunt tempor proident amet.",
                      zwapTextType: ZwapTextType.smallBodyRegular,
                      textColor: ZwapColors.shades0,
                    ),
                  ],
                ),
              ),
              child: Container(
                height: 70,
                width: 120,
                decoration: BoxDecoration(color: ZwapColors.primary400, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: ZwapText(
                    text: "Simple tooltip",
                    zwapTextType: ZwapTextType.bigBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
