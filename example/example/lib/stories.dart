import 'package:example/stories/zwap_buttons_story.dart';
import 'package:example/stories/zwap_checkbox_story.dart';
import 'package:example/stories/zwap_input_story.dart';
import 'package:example/stories/zwap_percent.dart';
import 'package:example/stories/zwap_weekly_calendar_pickert.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

enum ZwapStories {
  buttons,
  percent,
  weeklyCalendarPicker,
  checkbox,
  input,
}

class ZwapStory {
  String name;
  ZwapStories story;
  Widget Function(BuildContext) builder;

  ZwapStory({
    required this.name,
    required this.builder,
    required this.story,
  });
}

List<ZwapStory> stories = [
  ZwapStory(
    name: "ZwapButton",
    builder: (context) => const ZwapButtonsStory(),
    story: ZwapStories.buttons,
  ),
  ZwapStory(
    name: "ZwapPercent",
    builder: (context) => const ZwapPercentStory(),
    story: ZwapStories.percent,
  ),
  ZwapStory(
    name: "ZwapWeeklyCalendarPicker",
    builder: (context) => const ZwapCalendarPickerStory(),
    story: ZwapStories.weeklyCalendarPicker,
  ),
  ZwapStory(
    name: "ZwapCheckBox",
    builder: (context) => const ZwapCheckBoxStory(),
    story: ZwapStories.checkbox,
  ),
  ZwapStory(
    name: "ZwapInput",
    builder: (context) => const ZwapInputStory(),
    story: ZwapStories.input,
  )
];
