import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_input_with_tags.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_input.dart';

class ZwapInputStory extends StatefulWidget {
  const ZwapInputStory({Key? key}) : super(key: key);

  @override
  State<ZwapInputStory> createState() => _ZwapInputStoryState();
}

class _ZwapInputStoryState extends State<ZwapInputStory> {
  final Map<String, String> _items = {
    "1": "design",
    "2": "designer",
    "3": "developer",
    "4": "backend developer",
    "5": "frontend deleloper",
    "6": "human resources",
    "7": "policeman",
  };

  List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final bool _isApple = (html.window.navigator.platform?.startsWith('Mac') ?? false) || html.window.navigator.platform == 'iPhone';

    return Center(
      child: Container(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ZwapInput(
                label: "Input con label dinamica",
                dynamicLabel: "Label",
                dynamicLabelTextStyle: getTextStyle(ZwapTextType.bigBodyBold),
                keyCallBackFunction: (value) => print('key $value'),
              ),
              ZwapInput(label: "Input semplice"),
              SizedBox(height: 20),
              ZwapInput(
                label: "Input underlined",
                useOutlinedDecoration: false,
                fixedInitialText: "zwap.in/  ",
                fixedInitialTextStyle: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.text65),
                textStyle: getTextStyle(ZwapTextType.buttonText).copyWith(color: ZwapColors.primary900Dark),
                helperTextIsError: true,
                helperWidget: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 8),
                      ZwapIcons.icons('danger_circle', iconColor: ZwapColors.error500, iconSize: 15),
                      SizedBox(width: 6),
                      Expanded(
                        child: ZwapText(
                          text: "Questo url non può essere scelto, provane un altro",
                          zwapTextType: ZwapTextType.extraSmallBodyRegular,
                          textColor: ZwapColors.error500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                translateKey: (k) => "ciao",
              ),
              SizedBox(height: 20),
              ZwapInput.collapsed(
                label: "",
                placeholder: "No label",
                fixedInitialText: "Alessandro è ",
                fixedInitialTextStyle: ZwapTypography.mediumBodyMedium.copyWith(color: ZwapColors.neutral600),
                minLines: 4,
                maxLines: 8,
                minLenght: 50,
                borderRadius: 4,
                showClearAll: true,
                translateKey: (k) => "ciao",
              ),
              SizedBox(height: 40),
              ZwapInput.collapsed(
                label: "Nota per Ciccio",
                placeholder: "",
                minLines: 5,
                maxLines: 7,
                translateKey: (k) => "ciao",
                showClearAll: true,
                subtitle: "Shift + Enter for new line",
              ),
              SizedBox(height: 20),
              ZwapInput(
                label: "Input Beta",
                controller: TagsTextController(),
              ),
              SizedBox(height: 20),
              ZwapInputWithTags(),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ZwapHintInput(
                placeholder: "Digita qui...",
                onItemSelected: (k) => setState(() => _selectedItems.contains(k) ? null : _selectedItems.add(k)),
                minItems: 3,
                items: _items,
                selectedItems: _selectedItems,
                buildSelectedItem: (k) => Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  decoration: BoxDecoration(
                    color: ZwapColors.neutral100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedItems.remove(k)),
                        child: Icon(Icons.close, color: ZwapColors.success400, size: 18),
                      ),
                      SizedBox(width: 7),
                      ZwapText(
                        text: _items[k]!,
                        zwapTextType: ZwapTextType.mediumBodyRegular,
                        textColor: ZwapColors.text65,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
