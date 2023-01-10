import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_input.dart';
import 'package:zwap_design_system/atoms/check_option/zwap_check_option.dart';
import 'package:zwap_design_system/atoms/input/zwap_input_with_tags.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';
import 'package:zwap_design_system/molecules/calendar_input/zwap_calendar_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_check_box_picker/zwap_check_box_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_chips_input/zwap_chips_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_floating_picker/zwap_floating_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_search_picker/zwap_search_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_simple_picker/zwap_simple_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/molecules/rangeSlider/zwap_range_slider.dart';
import 'package:zwap_design_system/molecules/slider/zwap_slider.dart';

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

  bool get _error => _disableSimplePicker;

  List<String> _selectedItems = [];

  final List<String> _secondSelected = [];
  final List<int> _thirdSelected = [];

  bool _disableSimplePicker = false;

  final int _year = 2020;

  double min = 5;
  double max = 300;

  List<String> _selectedLanguages = [];

  final List<String> values = [
    'asdkfjaskdlfjaskdlf',
    'asdkfjaskdlfjaskdlf',
    'asdfsasdkfjdlf',
    'sdfasdkfjdlf',
    'asdkfsdfasjdlf',
    'asdkfjdlsfsdaf',
    'asdkdsfafjdlf',
    'asdaskffsjdlf',
    'asdassdkfjdlf',
    'asdaskfjdfdddlf',
  ];

  String? _selectedSearchItem;

  bool _isFirstCheckOptionSelected = true;

  double _value = 0;

  @override
  Widget build(BuildContext context) {
    final bool _isApple = (html.window.navigator.platform?.startsWith('Mac') ?? false) || html.window.navigator.platform == 'iPhone';

    return Center(
      child: Container(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ZwapText(
                text: 'ZwapCheckOptions',
                zwapTextType: ZwapTextType.mediumBodyRegular,
                textColor: ZwapColors.primary900Dark,
              ),
              SizedBox(height: 5),
              ZwapCheckOption(
                selected: _isFirstCheckOptionSelected,
                onTap: () => setState(() => _isFirstCheckOptionSelected = true),
                builder: (_, __) => Container(
                  margin: const EdgeInsets.all(15),
                  width: 200,
                  height: 30,
                  child: ZwapText(
                    text: 'Option 1',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ZwapCheckOption(
                selected: !_isFirstCheckOptionSelected,
                onTap: () => setState(() => _isFirstCheckOptionSelected = false),
                builder: (_, __) => Container(
                  width: 200,
                  margin: const EdgeInsets.all(15),
                  height: 60,
                  child: ZwapText(
                    text: 'Option 2',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ZwapButton(
                buttonChild: ZwapButtonChild.text(text: "resetta"),
                decorations: ZwapButtonDecorations.primaryLight(),
                onTap: () => setState(() {
                  min = 105;
                  max = 205;
                  _selectedLanguages = [];
                  _selectedSearchItem = null;
                }),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ZwapCheckBoxPicker(
                error: _error,
                errorText: "Magna minim pariatur dolore ",
                showClearButton: true,
                selectedItems: _selectedLanguages,
                onClearAll: () => _selectedLanguages = [],
                onToggleItem: (item, selected) {
                  if (selected)
                    setState(() => _selectedLanguages..add(item));
                  else
                    setState(() => _selectedLanguages..remove(item));
                },
                label: "CheckBoxPicker",
                itemBuilder: (_, key, value) {
                  String flag =
                      key.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

                  return Transform.translate(
                    offset: Offset(0, -2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ZwapText(
                          text: flag,
                          zwapTextType: ZwapTextType.mediumBodyRegular,
                          textColor: ZwapColors.primary900Dark,
                        ),
                        SizedBox(width: 8),
                        ZwapText(
                          text: value,
                          zwapTextType: ZwapTextType.mediumBodyRegular,
                          textColor: ZwapColors.primary900Dark,
                        ),
                      ],
                    ),
                  );
                },
                hintText: "sàdòlkfj asòdkfjasòdkfjasòdk fja òd",
                dynamicLabel: "Labelll",
                values: {
                  'it': 'afdasdf',
                  'dk': 'gerger',
                  'bg': 'kmbaresf',
                  'uk': 'sdeg4ergf',
                  'pl': 'sdfasd',
                  'cn': 'afdasdf',
                  'cz': 'gerger',
                  'dk': 'kmbaresf',
                  'jp': 'sdeg4ergf',
                  'gr': 'sdfasd',
                  'ua': 'afdasdf',
                },
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              SizedBox(height: 20),
              Container(
                child: ZwapRangeSlider(
                  value: ZwapRangeValues(min, max),
                  minValue: 5,
                  maxValue: 300,
                  onChange: (value) => setState(() {
                    min = value.min.floorToDouble();
                    max = value.max.floorToDouble();
                  }),
                ),
                width: 200,
              ),
              SizedBox(height: 15),
              Container(
                child: ZwapSlider(
                  value: _value,
                  onChange: (value) => setState(() {
                    _value = value;
                  }),
                  disabled: true,
                ),
                width: 200,
              ),
              SizedBox(height: 5),
              Text('$min -- $max'),
              SizedBox(height: 15),
              Text('$_value'),
              SizedBox(height: 20),
              ZwapText(
                text: "ZwapSearchPicker",
                zwapTextType: ZwapTextType.bigBodySemibold,
                textColor: ZwapColors.primary900Dark,
              ),
              const SizedBox(height: 8),
              ZwapSearchPicker<String>(
                selectedItem: _selectedSearchItem,
                performSearch: (search, page) async {
                  if (search.isEmpty && page == 2)
                    return [
                      'lkjfrtyuhjnmkh',
                      'lkhgrtyuhjnmkh',
                      'ljhgftyuhjnmkh',
                      'lkjhgfryuhjnmkh',
                      'kjhgfrtuhjnmkh',
                      'lkjhgfrtymkh',
                    ];

                  return search.isEmpty ? values : values.where((e) => e.contains(search)).toList();
                },
                getItemCopy: (s) => s,
                initialValues: values,
                translateKey: (_) => 'Nessun risultato',
                placeholder: "Ciao ciao ciao ciao",
                onItemSelected: (s) => _selectedSearchItem = s,
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ZwapSwitch(
                value: _disableSimplePicker,
                onChange: (value) => setState(() => _disableSimplePicker = value),
              ),
              SizedBox(height: 20),
              ZwapInput(
                showCheckboxOnSuccessState: false,
                showSuccess: true,
              ),
              SizedBox(height: 20),
              ZwapYearPicker(
                selectedYear: _year,
                hintText: 'Seleziona l\'anno di nascita',
              ),
              SizedBox(height: 20),
              ZwapCalendarInput(
                selectedDate: DateTime(2022, 11, 12),
                onlyFutureDates: true,
              ),
              SizedBox(height: 20),
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
              ZwapSimplePicker<int>(
                disabled: _disableSimplePicker,
                items: List.generate(1000, (i) => i),
                getCopyOfItem: (i) => '$i~$i•$i',
                getIsSelected: (i) => _thirdSelected.contains(i),
                isItemIncludedIsSearch: (i, s) => i % s.length == 0,
                label: "Simple picker (int)",
                placeholder: "Ex incididunt occaecat ",
                translateKey: (_) => 'Nessun risultato',
                onItemPicked: (i) => _thirdSelected.contains(i) ? setState(() => _thirdSelected.remove(i)) : setState(() => _thirdSelected.add(i)),
                showLessItem: true,
                showLessItemUntilLength: 3,
                lessItems: List.generate(40, (i) => i * 2),
              ),
              SizedBox(height: 20),
              ZwapChipsInput<String>(
                itemHeigth: 22,
                label: "Ciao",
                placeholder: "Laboris exercitation tempor ",
                maxSelectedItems: 10,
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
                      const SizedBox(width: 12),
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
                translateKey: (key) => {
                  'no_results_found': 'Nessun risultato, prova con qualcosa di diverso',
                  'max_elements': 'Tool selezionati',
                  'continue_typing_for_more_results': 'Continua a scrivere per visualizzare altri tool',
                }[key]!,
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
                getItemString: (i) => '$i$i$i',
              ),
              SizedBox(height: 20),
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
                minLenght: 4,
                borderRadius: 4,
                showClearAll: true,
                translateKey: (k) =>
                    {
                      'zwap_input_write_at_least': 'Scrivi almeno altri',
                      'zwap_input_characters': 'caratteri',
                    }[k] ??
                    "ciao",
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
