import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_input.dart';
import 'package:zwap_design_system/atoms/check_option/zwap_check_option.dart';
import 'package:zwap_design_system/atoms/input/zwap_input_with_tags.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';
import 'package:zwap_design_system/molecules/calendar_input/zwap_calendar_input.dart';
import 'package:zwap_design_system/molecules/date_picker/zwap_date_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_category_input/zwap_category_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_check_box_picker/zwap_check_box_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_chips_input/zwap_chips_input.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_floating_picker/zwap_floating_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_search_picker/zwap_search_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_simple_picker/zwap_simple_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_time_picker/zwap_time_picker.dart';
import 'package:zwap_design_system/molecules/dynamic_input/zwap_dynamic_input.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/molecules/rangeSlider/zwap_range_slider.dart';
import 'package:zwap_design_system/molecules/slider/zwap_slider.dart';
import 'package:zwap_design_system/molecules/zwap_inline_select/zwap_inline_select.dart';
import 'package:zwap_design_system/molecules/zwap_rich_input/zwap_rich_input.dart';
import 'package:zwap_design_system/utils/streamed_text_controller.dart';

String _alphabet = "abcdefghijklmnopqrstuvwxyz    ";

Stream<String> _getStream() async* {
  await Future.delayed(const Duration(milliseconds: 800));
  for (int i = 0; i < 300; i++) {
    await Future.delayed(Duration(milliseconds: Random().nextInt(90)));
    final int _count = Random().nextInt(3) + 1;
    final String _text = List.generate(_count, (_) => _alphabet[Random().nextInt(_alphabet.length)]).join();

    yield _text;
  }

  yield "<done>";
}

enum MyEnum { a, b, c, v, d, f, g }

class ZwapInputStory extends StatefulWidget {
  const ZwapInputStory({Key? key}) : super(key: key);

  @override
  State<ZwapInputStory> createState() => _ZwapInputStoryState();
}

class _ZwapInputStoryState extends State<ZwapInputStory> {
  final Map<String, List<String>> _categories = {
    "Design": [
      "Design case",
      "Design grafico",
      "Design web",
      "Design mobile",
      "Design UX",
    ],
    "Sviluppo software": [
      "Sviluppo web",
      "Sviluppo mobile",
      "Sviluppo backend",
      "Sviluppo frontend",
      "Sviluppo fullstack",
    ],
    "Marketing": [
      "Marketing online",
      "Marketing offline",
      "Marketing digitale",
      "Marketing strategico",
      "Marketing operativo",
    ],
    "Gestione": [
      "Gestione aziendale",
      "Gestione progetti",
      "Gestione risorse umane",
      "Gestione risorse finanziarie",
      "Gestione risorse tecniche",
    ],
  };

  String? _selectedIntValue;

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
  List<int> _thirdSelected = [];

  bool _disableSimplePicker = false;

  final int _year = 2020;

  double min = 70;
  double max = 250;
  int _valueInline = 1;

  List<String> _selectedLanguages = [];

  bool _gapOfHalf = true;

  final List<String> values = [
    'asdkfjaskdlfjaskdlf',
    'asdkfjaskfjaskdlf',
    'asdfsasdkfjdlf',
    'sdfasdkfjdlf',
    'asdkfsdfasjdlf',
    'asdkfjdlsfsdaf',
    'asdkdsfafjdlf',
    'asdaskffsjdlf',
    'asdassdkfjdlf',
    'asdaskfjdfdddlf',
  ];

  String? _selectedSearchItem = 'asdkfjaskdlfjaskdlf';

  String _richValue = '';

  bool _isFirstCheckOptionSelected = true;

  double _value = 0.7;

  DateTime? _date;

  TimeOfDay? time;

  late StreamedTextController _textController;

  @override
  void initState() {
    super.initState();
    _textController = StreamedTextController();

    /* _getStream().listen((e) {
      if (e == '<done>') {
        _textController.loadingDone();
        return;
      }

      _textController.updateLoadingData(_textController.text + e);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    final bool _isApple = (html.window.navigator.platform?.startsWith('Mac') ?? false) || html.window.navigator.platform == 'iPhone';

    /* return Container(
      width: 400,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: ZwapColors.neutral600)),
            child: ZwapRangeSlider(
              value: ZwapRangeValues(min, max),
              minValue: 5,
              maxValue: 300,
              thumbSize: 32,
              lineWidth: 12,
              lineBorderRadius: 100,
              maxExtent: 100,
              minExtent: 30,
              onChange: (value) => setState(() {
                min = double.parse(value.min.toStringAsFixed(5));
                max = double.parse(value.max.toStringAsFixed(5));
              }),
            ),
          ),
          //? Add text of current range slider
          SizedBox(height: 15),
          ZwapText(
            text: '$min -- $max',
            zwapTextType: ZwapTextType.bigBodyBold,
            textColor: Colors.black,
          ),
        ],
      ),
    ); */

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ZwapText(
              text: 'Rich input',
              zwapTextType: ZwapTextType.mediumBodyRegular,
              textColor: ZwapColors.shades0,
            ),
            SizedBox(height: 5),
            ZwapRichInput(
              initialValue: RichInputValue.fromHtml(_richValue, ZwapTextType.mediumBodyRegular.copyWith()),
              onValueChange: (value) => setState(() => _richValue = value.htmlText),
            ),
            SizedBox(height: 24),
            Container(
              width: 500,
              padding: const EdgeInsets.all(32),
              color: const Color(0xff0C0C2F),
              child: Column(
                children: [
                  ZwapText(
                    text: '$_value',
                    zwapTextType: ZwapTextType.bigBodyExtraBold,
                    textColor: ZwapColors.shades0,
                  ),
                  const SizedBox(height: 70),
                  Container(
                    width: double.infinity,
                    child: ZwapSlider(
                      value: _value,
                      onChange: (value) => setState(() => _value = value),
                      thumbChild: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: ZwapColors.primary700,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.menu_rounded,
                              color: ZwapColors.shades0,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                      thumbSize: 32,
                      decoration: ZwapSliderDecoration(
                        backgroundColor: ZwapColors.shades0.withOpacity(.2),
                        fillColor: ZwapColors.primary700,
                        thumbColor: ZwapColors.shades0.withOpacity(.15),
                        borderRadius: BorderRadius.circular(100),
                        fillHeight: 16,
                        backgroundHeight: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Container(
                    height: 550,
                    decoration: BoxDecoration(
                      color: const Color(0xff0C0C2F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ZwapColors.shades0.withOpacity(.3), width: 1),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: ZwapInput.collapsed(
                        internalPadding: EdgeInsets.zero,
                        cursorColor: ZwapColors.shades0.withOpacity(.8),
                        placeholder: 'Incolla o digita qui la tua job description',
                        placeholderStyle: ZwapTextType.bigBodyRegular.copyWith(color: ZwapColors.shades0.withOpacity(.6)),
                        textStyle: ZwapTextType.bigBodyRegular.copyWith(color: ZwapColors.shades0),
                        backgroundColor: const Color(0xff0C0C2F),
                        forceNoBorders: true,
                        minLines: 7,
                        maxLines: 500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: ZwapDatePicker(
                          value: _date,
                          onChange: (v) => setState(() => _date = v),
                          decoratorBuilder: (_) => Icon(Icons.calendar_month),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: ZwapDatePicker(
                          value: _date,
                          onChange: (v) => setState(() => _date = v),
                          dateFormatter: 'yyyy-MM-ddTHH:mm:ss.mmmuuu',
                          enableWhere: (d) => d.isAfter(DateTime.now()),
                        ),
                      ),
                    ],
                  ),
                  ZwapText(
                    text: 'Zwap Inputs with style: ',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(25),
                    color: Color(0xff000013).withOpacity(.9),
                    child: ZwapInput(
                      dynamicLabel: "Label",
                      dynamicLabelTextStyle: getTextStyle(ZwapTextType.mediumBodySemibold),
                      dynamicLabelColor: ZwapColors.shades0,
                      keyCallBackFunction: (value) => print('key $value'),
                      backgroundColor: Color(0xffD9D9D9).withOpacity(.1),
                      textStyle: ZwapTextType.bigBodyRegular.copyWith(color: ZwapColors.shades0),
                      cursorColor: ZwapColors.neutral200,
                      enabledBorderColor: ZwapColors.shades0,
                      hoveredBorderColor: ZwapColors.shades0,
                      disabledBorderColor: ZwapColors.shades0,
                      focussedBorderColor: ZwapColors.primary700,
                    ),
                  ),
                  ZwapText(
                    text: 'Zwap Search picker with decorations: ',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),

                  Container(
                    padding: const EdgeInsets.all(25),
                    color: Color(0xff000013).withOpacity(.9),
                    child: ZwapSearchPicker<String>(
                      decorations: ZwapInputDecorations(
                        backgroundColor: ZwapColors.primary900Dark,
                        borderColor: ZwapColors.shades0,
                        hintColor: ZwapColors.shades0,
                        hoveredBorderColor: ZwapColors.shades0,
                        overlayColor: Color(0xff262646),
                        overlayHoverColor: ZwapColors.primary700Dark,
                        textColor: ZwapColors.shades0,
                        overlaySecondaryTextColor: ZwapColors.shades0.withOpacity(.7),
                        overlayTextColor: ZwapColors.shades0,
                        secondaryTextColor: ZwapColors.shades0.withOpacity(.7),
                        labelColor: ZwapColors.shades0,
                        overlaySelectedColor: ZwapColors.primary900Dark,
                        overlaySelectedTextColor: ZwapColors.shades0,
                      ),
                      canAddItem: false,
                      showChevron: false,
                      onAddItem: (v) {
                        return v;
                      },
                      selectedItem: _selectedSearchItem,
                      performSearch: (search, page) async {
                        await Future.delayed(const Duration(seconds: 1));
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
                      initialValues: [],
                      translateKey: (_) => 'Nessun risultato',
                      placeholder: "Ciao ciao ciao ciao",
                      onItemSelected: (s) {
                        print(s);
                        _selectedSearchItem = s;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(25),
                    color: Color(0xff000013).withOpacity(.9),
                    child: ZwapInput.collapsed(
                      controller: _textController,
                      dynamicLabel: "Label",
                      minLines: 2,
                      maxLines: 3,
                      dynamicLabelTextStyle: getTextStyle(ZwapTextType.mediumBodySemibold),
                      placeholder: "Veniam ullamco adipisicing esse sit irure elit ad culpa pariatur aliqua.",
                      dynamicLabelColor: ZwapColors.shades0,
                      keyCallBackFunction: (value) => print('key $value'),
                      backgroundColor: Color(0xffD9D9D9).withOpacity(.1),
                      textStyle: ZwapTextType.bigBodyRegular.copyWith(color: ZwapColors.shades0),
                      cursorColor: ZwapColors.neutral200,
                      enabledBorderColor: ZwapColors.shades0,
                      hoveredBorderColor: ZwapColors.shades0,
                      disabledBorderColor: ZwapColors.shades0,
                      focussedBorderColor: ZwapColors.primary700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Color(0xff000013).withOpacity(.9),
                    padding: const EdgeInsets.all(20),
                    child: ZwapSimplePicker<int>(
                      onCustomPicked: (s) => print(s),
                      // dynamicLabel: "Ciaociaocicoaciaocai",
                      showChevron: true,
                      textColor: ZwapColors.shades0,
                      backgroundColor: Color(0xffD9D9D9).withOpacity(.1),
                      dynamicLabelColor: ZwapColors.shades0,
                      hoveredBorderColor: ZwapColors.primary700,
                      borderColor: ZwapColors.shades0,
                      disabled: _disableSimplePicker,
                      items: List.generate(1000, (i) => i),
                      getCopyOfItem: (i) => '$i~$i•$i',
                      getIsSelected: (i) => _thirdSelected.contains(i),
                      isItemIncludedIsSearch: (i, s) => i % s.length == 0,
                      placeholder: "Ex incididunt occaecat ",
                      translateKey: (_) => 'Nessun risultato',
                      onItemPicked: (i) => setState(() => _thirdSelected = [i]),
                      showLessItem: true,
                      showLessItemUntilLength: 3,
                      lessItems: List.generate(40, (i) => i * 2),
                      keepFirstItemOnHeader: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    color: Color(0xff000013).withOpacity(.9),
                    padding: const EdgeInsets.all(20),
                    child: ZwapCategoryInput<String, String>(
                      activeBorderColor: ZwapColors.primary700,
                      backgroundColor: Color(0xffD9D9D9).withOpacity(.1),
                      textColor: ZwapColors.shades0,
                      borderColor: ZwapColors.shades0,
                      selectedValue: _selectedIntValue,
                      showClear: false,
                      values: _categories,
                      getCopyOfCategory: (s) => s,
                      getCopyOfItem: (integer) => '$integer',
                      filterItems: (integer, f) {
                        print('$integer <-> ${integer.contains(f.toLowerCase().trim())}');
                        return integer.contains(f.toLowerCase().trim());
                      },
                      onSelected: (i) => setState(() => _selectedIntValue = i),
                      translateKey: (k) => 'Nessun risultato per sadf',
                      placeholder: 'Seleziona un elemento',
                    ),
                  ),
                  SizedBox(height: 55),
                  ZwapText(
                    text: 'Category input',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                  SizedBox(height: 5),
                  ZwapCategoryInput<String, String>(
                    label: "Category",
                    selectedValue: _selectedIntValue,
                    values: _categories,
                    getCopyOfCategory: (s) => s,
                    getCopyOfItem: (integer) => '$integer',
                    filterItems: (integer, f) {
                      print('$integer <-> ${integer.contains(f.toLowerCase().trim())}');
                      return integer.contains(f.toLowerCase().trim());
                    },
                    onSelected: (i) => setState(() => _selectedIntValue = i),
                    translateKey: (k) => 'Nessun risultato per sadf',
                    placeholder: 'Seleziona un elemento',
                  ),
                  SizedBox(height: 25),
                  ZwapText(
                    text: 'Time picker',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ZwapSwitch(
                        value: _gapOfHalf,
                        onChange: (v) {
                          final bool _shouldFail = Random().nextBool();
                          if (_shouldFail) {
                            print('failed');
                            return false;
                          }

                          setState(() => _gapOfHalf = v);
                        },
                      ),
                      const SizedBox(width: 12),
                      Container(
                        child: ZwapTimePicker(
                          value: time,
                          placeholder: "XX:XX",
                          showClear: false,
                          gap: _gapOfHalf ? TimePickerGap.thirtyMinutes : TimePickerGap.fifteenMinutes,
                          onChanged: (v) {
                            setState(() => time = v);
                          },
                          title: "DALLE",
                          translateOffset: const Offset(-64, 0),
                          backgroundColor: Colors.transparent,
                          borderActiveColor: ZwapColors.primary400,
                          borderDefaultColor: const Color(0xff808092),
                          overlayColor: ZwapColors.primary900Dark,
                          titleColor: ZwapColors.shades0,
                          valueColor: ZwapColors.shades0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        child: ZwapTimePicker(
                          value: time,
                          placeholder: "XX:XX",
                          showClear: false,
                          onChanged: (v) => setState(() => time = v),
                          title: "ALLE",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  SizedBox(height: 25),
                  ZwapText(
                    text: 'Inline select',
                    zwapTextType: ZwapTextType.mediumBodyRegular,
                    textColor: ZwapColors.primary900Dark,
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 56,
                    child: ZwapInlineSelect<int>(
                      selectedItem: _valueInline,
                      onSelected: (i) {
                        setState(() => _valueInline = i);
                      },
                      items: [1, 2, 3],
                      builder: (_, i, k) => Container(
                        key: k,
                        width: i == 1 ? 148 : 130,
                        height: 48,
                        child: Center(
                          child: ZwapRichText.safeText(
                            textSpans: [
                              ZwapTextSpan.fromZwapTypography(
                                text: i == 1 ? '⚡️' : '🛸',
                                textType: ZwapTextType.mediumBodyRegular,
                                textColor: ZwapColors.primary900Dark,
                              ),
                              ZwapTextSpan(
                                text: i == 1 ? ' Sintetico' : ' Esteso',
                                textStyle: ZwapTextType.bigBodySemibold.copyWith(
                                  fontSize: 17,
                                  color: ZwapColors.primary900Dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      String flag = key
                          .toUpperCase()
                          .replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

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
                      'jp': 'sdeg4ergf',
                      'gr': 'sdfasd',
                      'ua': 'afdasdf',
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Container(
                    width: 400,
                    child: ZwapRangeSlider(
                      value: ZwapRangeValues(min, max),
                      minValue: 5,
                      maxValue: 300,
                      thumbSize: 32,
                      lineWidth: 12,
                      lineBorderRadius: 100,
                      onChange: (value) => setState(() {
                        min = value.min.floorToDouble();
                        max = value.max.floorToDouble();
                      }),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: ZwapSlider(
                      value: _value,
                      onChange: (value) => setState(() {
                        _value = value;
                      }),
                    ),
                    width: 200,
                  ),
                  SizedBox(height: 5),
                  Text('$min -- $max', style: ZwapTextType.bigBodyBold.copyWith(color: Colors.white)),
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
                    canAddItem: false,
                    showChevron: false,
                    onAddItem: (v) {
                      return v;
                    },
                    selectedItem: _selectedSearchItem,
                    performSearch: (search, page) async {
                      await Future.delayed(const Duration(seconds: 1));
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
                    initialValues: [],
                    translateKey: (_) => 'Nessun risultato',
                    placeholder: "Ciao ciao ciao ciao",
                    onItemSelected: (s) {
                      print(s);
                      _selectedSearchItem = s;
                    },
                  ),
                  SizedBox(height: 20),
                  ZwapSearchPicker<String>(
                    activeColor: ZwapColors.primary700,
                    canAddItem: false,
                    showChevron: false,
                    label: "Llkdafjhsjkd ga",
                    onAddItem: (v) {
                      print(v);
                      return v;
                    },
                    selectedItem: _selectedSearchItem,
                    performSearch: (search, page) async {
                      await Future.delayed(const Duration(seconds: 1));
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
                    initialValues: [],
                    translateKey: (_) => 'Nessun risultato',
                    placeholder: "Ciao ciao ciao ciao",
                    onItemSelected: (s) {
                      print(s);
                      _selectedSearchItem = s;
                    },
                  ),
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
                    placeholder: 'sàlkafjsdfkljasd',
                    placeholderStyle: ZwapTextType.bigBodyExtraBold.copyWith(color: ZwapColors.error500),
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
                    showChevron: true,
                    disabled: _disableSimplePicker,
                    items: List.generate(1000, (i) => i),
                    getCopyOfItem: (i) => '$i~$i•$i',
                    getIsSelected: (i) => _thirdSelected.contains(i),
                    isItemIncludedIsSearch: (i, s) => i % s.length == 0,
                    label: "Simple picker (int)",
                    placeholder: "Ex incididunt occaecat ",
                    translateKey: (_) => 'Nessun risultato',
                    onItemPicked: (i) => setState(() => _thirdSelected = [i]),
                    showLessItem: true,
                    showLessItemUntilLength: 3,
                    lessItems: List.generate(40, (i) => i * 2),
                    keepFirstItemOnHeader: true,
                  ),
                  SizedBox(height: 20),

                  ZwapText(
                    text: 'Chips Input',
                    zwapTextType: ZwapTextType.bigBodySemibold,
                    textColor: ZwapColors.primary900Dark,
                  ),
                  ZwapChipsInput<String>(
                    errorMessage: _error ? 'djfò aksdjf òas' : null,
                    itemHeigth: 22,
                    showMaxSelectedItemsString: false,
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
                          Icon(Icons.face),
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
                    placeholder: 'DFKLASJDKLFJASDKFJ',
                    placeholderStyle: getTextStyle(ZwapTextType.buttonText).copyWith(fontWeight: FontWeight.w800, color: ZwapColors.warning700),
                    useOutlinedDecoration: false,
                    //fixedInitialText: "zwap.in/  ",
                    //fixedInitialTextStyle: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.text65),
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
                  //ZwapInputWithTags(),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  ZwapHintInput(
                    placeholder: "Digita qui...",
                    onItemSelected: (k) => setState(() => _selectedItems.contains(k) ? null : _selectedItems = (List.from(_selectedItems)..add(k))),
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
                  SizedBox(height: 420),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
