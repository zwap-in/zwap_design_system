import 'package:example/stories/zwap_buttons.dart';
import 'package:example/stories/zwap_percent.dart';
import 'package:example/story_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Zwap ~ Storybook',
        theme: ThemeData(primaryColor: ZwapColors.primary700),
        home: const StoryBookWidget(),
      ),
    );
  }
}
