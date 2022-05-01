import 'package:example/stories/zwap_buttons_story.dart';
import 'package:example/stories/zwap_checkbox_story.dart';
import 'package:example/stories/zwap_input_story.dart';
import 'package:example/stories/zwap_modal_story.dart';
import 'package:example/stories/zwap_percent_story.dart';
import 'package:example/stories/zwap_scroll_items_story.dart';
import 'package:example/stories/zwap_select_story.dart';
import 'package:example/stories/zwap_tutorial_overlay_story.dart';
import 'package:example/stories/zwap_weekly_calendar_pickert_story.dart';
import 'package:flutter/material.dart';

enum ZwapStories {
  buttons,
  percent,
  weeklyCalendarPicker,
  checkbox,
  input,
  select,
  tutorialOverlay,
  modals,
  scrollItems,
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
    builder: (context) => const ZwapWeeklyCalendarPickerStory(),
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
  ),
  ZwapStory(
    name: "ZwapSelect",
    builder: (context) => const ZwapSelectStory(),
    story: ZwapStories.select,
  ),
  ZwapStory(
    name: "Tutorial Overlay",
    builder: (context) => ZwapTutorialOverlayStory(),
    story: ZwapStories.tutorialOverlay,
  ),
  ZwapStory(
    name: "Zwap Modal",
    builder: (context) => ZwapModalStory(),
    story: ZwapStories.modals,
  ),
  ZwapStory(
    name: "Zwap Scroll Items",
    builder: (context) => ZwapScrollItemsStory(),
    story: ZwapStories.scrollItems,
  )
];
