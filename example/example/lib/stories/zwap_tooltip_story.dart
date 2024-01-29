import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

class ZwapTooltipStory extends StatefulWidget {
  const ZwapTooltipStory({Key? key}) : super(key: key);

  @override
  State<ZwapTooltipStory> createState() => _ZwapTooltipStoryState();
}

class _ZwapTooltipStoryState extends State<ZwapTooltipStory> {
  bool _showTooltip = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _rowOf(Widget child) => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            child,
            child,
            child,
          ],
        );

    return Container(
      color: ZwapColors.primary900Dark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _rowOf(
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
          ),
          const SizedBox(height: 30),
          _rowOf(
            ZwapTooltip(
              message: "Proident aute ea id velit eu mollit.",
              transationOffset: Offset(100, 5),
              simple: true,
              position: TooltipPosition.rigth,
              borderColor: Colors.white.withOpacity(.3),
              child: _Box(),
            ),
          ),
          const SizedBox(height: 30),
          _rowOf(
            InkWell(
              onTap: () {},
              onHover: (h) {
                if (h) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() => _showTooltip = false);
                  });
                } else
                  setState(() => _showTooltip = true);
              },
              child: ZwapTooltip.builder(
                showTooltip: _showTooltip,
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
                child: _Box(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatefulWidget {
  const _Box({Key? key}) : super(key: key);

  @override
  State<_Box> createState() => _BoxState();
}

class _BoxState extends State<_Box> {
  final GlobalKey _key = GlobalKey();
  bool _showPos = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _showPos = true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      height: 70,
      width: 150,
      decoration: BoxDecoration(color: ZwapColors.primary400, borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Column(
          children: [
            ZwapText(
              text: "Simple tooltip",
              zwapTextType: ZwapTextType.bigBodyRegular,
              textColor: ZwapColors.primary900Dark,
            ),
            const SizedBox(height: 2),
            if (_showPos)
              ZwapText(
                text: "TL: ${_key.globalPaintBounds?.topLeft}",
                zwapTextType: ZwapTextType.smallBodyRegular,
                textColor: ZwapColors.primary900Dark,
              ),
          ],
        ),
      ),
    );
  }
}
