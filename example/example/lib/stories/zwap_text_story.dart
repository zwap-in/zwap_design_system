import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/moleculesText/zwap_expandable_text.dart';
import 'package:zwap_design_system/molecules/percent_widget/percent_widget.dart';
import 'package:zwap_design_system/molecules/zwap_modal/zwap_modal.dart';
import 'package:zwap_design_system/zwap_design_system.dart';
import 'package:provider/provider.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                "Duis nostrud do sit Lorem ex aliqua ea ea laborum labore anim. Dolor labore amet cillum velit id qui magna culpa ad ad nisi. Occaecat Lorem mollit ut enim et labore cillum ut cillum nulla laboris. Est est consectetur velit incididunt ea quis. Elit anim nulla aliquip exercitation fugiat id et eu. Mollit eu et consectetur aliqua non officia ullamco aute sit incididunt.Aute sint deserunt aliquip pariatur sunt aliqua eu aliqua aliquip exercitation commodo dolor mollit elit. Elit in sint nisi non incididunt. Cupidatat reprehenderit consectetur consequat aliquip duis est. Eiusmod quis aute amet labore sit aliqua nostrud. Incididunt fugiat enim proident qui qui. Exercitation tempor labore do exercitation exercitation eiusmod cillum incididunt ex.",
            maxClosedLines: 3,
            textType: ZwapTextType.bigBodyRegular,
            textColor: ZwapColors.neutral900,
            translateKey: (key) => {
              'see_less': 'Vedi meno',
              'see_more': 'Vedi tutto',
            }[key]!,
          ),
        ],
      ),
    );
  }
}
