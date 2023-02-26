import './stories.dart';
import './story_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:taastrap/mediaQueries/components/generic/generic.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        return ChangeNotifierProvider<StoryProvider>(
          create: (_) => StoryProvider(),
          child: MaterialApp(
            title: 'Zwap ~ Storybook',
            theme: ThemeData(primaryColor: ZwapColors.primary700),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('it', 'IT'),
            ],
            home: Builder(
              builder: (context) {
                final bool _loading = context.select<StoryProvider, bool>((pro) => pro.loading);
                if (_loading)
                  return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(ZwapColors.primary700), strokeWidth: 1.8));

                return AppListenerWrapper(child: OKToast(child: const StoryBookWidget()));
              },
            ),
          ),
        );
      },
    );
  }
}

class StoryProvider extends ChangeNotifier {
  bool _loading = true;
  late ZwapStories _currentStory;

  ZwapStories get currentStory => _currentStory;
  bool get loading => _loading;

  set currentStory(ZwapStories value) {
    if (value != _currentStory) {
      _currentStory = value;
      notifyListeners();

      _saveStory(value);
    }
  }

  StoryProvider() : super() {
    _initialize();
  }

  Future _initialize() async {
    final int _firstIndex = (await SharedPreferences.getInstance()).getInt('story') ?? 0;
    _currentStory = ZwapStories.values[_firstIndex];
    _loading = false;
    notifyListeners();
  }

  Future _saveStory(ZwapStories story) async {
    (await SharedPreferences.getInstance()).setInt('story', story.index);
  }
}
