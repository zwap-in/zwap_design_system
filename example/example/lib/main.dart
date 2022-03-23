import 'package:example/stories.dart';
import 'package:example/stories/zwap_buttons_story.dart';
import 'package:example/stories/zwap_percent.dart';
import 'package:example/story_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:taastrap/mediaQueries/components/generic/generic.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        Generic deviceType = Generic(maxWith: size.maxWidth.toInt());
        Utils.registerType<Generic>(deviceType);
        return OKToast(
          child: ChangeNotifierProvider<StoryProvider>(
            create: (_) => StoryProvider(),
            child: MaterialApp(
              title: 'Zwap ~ Storybook',
              theme: ThemeData(primaryColor: ZwapColors.primary700),
              home: const StoryBookWidget(),
            ),
          ),
        );
      },
    );
  }
}

class StoryProvider extends ChangeNotifier {
  late ZwapStories _currentStory;

  ZwapStories get currentStory => _currentStory;

  set currentStory(ZwapStories value) => value != _currentStory ? {_currentStory = value, notifyListeners()} : null;

  StoryProvider()
      : _currentStory = ZwapStories.input,
        super();
}
