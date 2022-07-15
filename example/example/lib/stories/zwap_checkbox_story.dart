import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/checkbox/zwapCheckbox.dart';
import 'package:zwap_design_system/atoms/text/base/zwapText.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

class ZwapCheckBoxStory extends StatefulWidget {
  const ZwapCheckBoxStory({Key? key}) : super(key: key);

  @override
  State<ZwapCheckBoxStory> createState() => _ZwapCheckBoxStoryState();
}

class _ZwapCheckBoxStoryState extends State<ZwapCheckBoxStory> {
  bool? _value = false;
  bool _disabled = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZwapText(text: 'Force value', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              SizedBox(width: 20),
              ZwapSwitch(
                value: _value ?? true,
                onValueChange: (v) => setState(() => _value = v),
              ),
              SizedBox(width: 20),
              ZwapText(text: 'Disabled State', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              SizedBox(width: 20),
              ZwapSwitch(
                value: _disabled,
                onValueChange: (v) => setState(() => _disabled = v),
              ),
              SizedBox(width: 20),
              ZwapText(text: 'Error State', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              SizedBox(width: 20),
              ZwapSwitch(
                value: _error,
                onValueChange: (v) => setState(() => _error = v),
              ),
              SizedBox(width: 20),
              ZwapButton(
                width: 170,
                height: 44,
                buttonChild: ZwapButtonChild.text(text: "Set indeterminate"),
                decorations: ZwapButtonDecorations.primaryLight(),
                onTap: () => setState(() => _value = null),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(width: 15),
          Column(
            children: [
              ZwapText(
                text: "Normal CheckBox",
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: ZwapColors.shades100,
              ),
              SizedBox(height: 15),
              ZwapCheckBox(
                value: _value,
                disabled: _disabled,
                error: _error,
                onCheckBoxClick: (value) => setState(() => _value = value),
              ),
              SizedBox(height: 40),
              ZwapText(
                text: "CheckBox Text",
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: ZwapColors.shades100,
              ),
              SizedBox(height: 15),
              //TODO: refactoring of ZwapCheckBoxText
              /* ZwapCheckBoxText(
                value: _value,
                disabled: _disabled,
                error: _error,
                onCheckBoxClick: (value) => setState(() => _value = value),
              ), */
            ],
          ),
        ],
      ),
    );
  }
}
