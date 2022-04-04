import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_input_with_tags.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';

class ZwapInputStory extends StatelessWidget {
  const ZwapInputStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        child: Column(
          children: [
            ZwapInput(label: "Input semplice"),
            SizedBox(height: 20),
            ZwapInput.collapsed(
              label: "Collapsed Input with FixedInitialText, Min and Max lines, Min lenght and clean all",
              placeholder: "Write something here...",
              fixedInitialText: "Alessandro è ",
              fixedInitialTextStyle: ZwapTypography.mediumBodyMedium.copyWith(color: ZwapColors.neutral600),
              minLines: 4,
              maxLines: 8,
              minLenght: 50,
              borderRadius: 4,
              showClearAll: true,
            ),
            SizedBox(height: 40),
            ZwapInput(
              label: "Input Beta",
              controller: TagsTextController(),
            ),
            SizedBox(height: 20),
            ZwapInputWithTags(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
