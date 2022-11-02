import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_input_with_tags.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_chips_input/zwap_chips_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_check_box_picker/zwap_check_box_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_floating_picker/zwap_floating_picker.dart';

enum MyEnum { a, b, c, v, d, f, g }

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

  final List<String> _secondSelected = [];

  @override
  Widget build(BuildContext context) {
    final bool _isApple = (html.window.navigator.platform?.startsWith('Mac') ?? false) || html.window.navigator.platform == 'iPhone';

    return Center(
      child: Container(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 600),
              ZwapDynamicInput(
                content: Container(
                  width: 40,
                  height: 40,
                  color: ZwapColors.secondary200,
                ),
                overlay: Container(
                  width: 40,
                  height: 40,
                  color: ZwapColors.error700,
                ),
              ),
              SizedBox(height: 20),
              ZwapChipsInput<String>(
                label: "Ciao",
                placeholder: "Laboris exercitation tempor ",
                items: [
                  'afdasdf',
                  'gerger',
                  'kmbaresf',
                  'sdeg4ergf',
                  'sdfasd',
                  'afkdasdf',
                  'gerkger',
                  'kmbkaresf',
                  'sdelkjskg4ergf',
                  'sdflkjskasd',
                  'afdlkjsasdf',
                  'gerlkjsger',
                  'kmblkjsaresf',
                  'sdelkjsg4ergf',
                  'sdflkjsasd',
                  'afklkjsdasdf',
                  'gerlkjskger',
                  'kmblkjskaresf',
                  'sdelkjskg4ergf',
                  'sdflkjskasd',
                ],
                itemBuilder: (context, i, status) => Padding(
                  padding: status.isHeader ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(([
                        Icons.abc_sharp,
                        Icons.access_time_filled_rounded,
                        Icons.access_time_filled_outlined,
                        Icons.accessibility,
                        Icons.accessibility_sharp,
                        Icons.accessibility_rounded,
                        Icons.accessibility_outlined,
                        Icons.accessibility_new,
                        Icons.accessibility_new_sharp,
                        Icons.accessibility_new_rounded,
                        Icons.accessibility_new_outlined,
                        Icons.accessible,
                        Icons.accessible_sharp,
                        Icons.accessible_rounded,
                        Icons.accessible_outlined,
                        Icons.accessible_forward,
                        Icons.accessible_forward_sharp,
                        Icons.accessible_forward_rounded,
                        Icons.accessible_forward_outlined,
                        Icons.account_balance,
                        Icons.account_balance_sharp,
                      ]..shuffle())
                          .first),
                      const SizedBox(width: 23),
                      ZwapText(
                        text: i,
                        zwapTextType: status.isHovered ? ZwapTextType.mediumBodyMedium : ZwapTextType.mediumBodyRegular,
                        textColor: (status.isSelected && !status.isHeader) ? ZwapColors.primary700 : ZwapColors.primary900Dark,
                      ),
                    ],
                  ),
                ),
                searchItem: (i, search) => i.toLowerCase().contains(search.toLowerCase().trim()),
                selectedItems: _secondSelected,
                onItemPicked: (i, _) {
                  if (_secondSelected.contains(i))
                    setState(() => _secondSelected.remove(i));
                  else
                    setState(() => _secondSelected.add(i));
                },
                translateKey: (key) => 'Nessun risultato, prova con qualcosa di diversoalkòd jadslkfj aòlskdjf aòksdj',
                noResultsWidget: Icon(
                  Icons.north_east,
                  color: ZwapColors.error700,
                ),
              ),
              SizedBox(height: 20),
              ZwapButton(
                decorations: ZwapButtonDecorations.primaryLight(),
                buttonChild: ZwapButtonChild.text(text: "Ciao"),
                onTap: () {
                  if (!_secondSelected.contains('sdelkjsg4ergf')) {
                    setState(() => _secondSelected.add('sdelkjsg4ergf'));
                  }
                },
              ),
              SizedBox(height: 20),
              ZwapFloatingPicker<MyEnum>(
                options: MyEnum.values,
                label: 'Label',
                placeholder: 'Laboris ipsum tempor consequat sunt',
                getItemString: (i)=> '$i$i$i',
              ),
              SizedBox(height: 20),
              ZwapCheckBoxPicker(
                initialSelectedItems: [
                  '21',
                  '121',
                ],
                label: "kdfjaskdlf",
                hintText: "sàdòlkfj asòdkfjasòdkfjasòdk fja òd",
                values: {
                  '25': 'afdasdf',
                  '42': 'gerger',
                  '32': 'kmbaresf',
                  '21': 'sdeg4ergf',
                  '112': 'sdfasd',
                  '125': 'afdasdf',
                  '142': 'gerger',
                  '132': 'kmbaresf',
                  '121': 'sdeg4ergf',
                  '1f12': 'sdfasd',
                  '1f25': 'afdasdf',
                  '1f42': 'gerger',
                  '1f32': 'kmbaresf',
                  '1f21': 'sdeg4ergf',
                  '1f12': 'sdfasd',
                },
              ),
              SizedBox(height: 20),
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
