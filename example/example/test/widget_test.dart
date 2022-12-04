// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';
import 'package:oktoast/oktoast.dart';
import 'package:taastrap/mediaQueries/components/generic/generic.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils/utils.dart';

void main() {
  /* testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  }); */

  testWidgets("Test di test", (tester) async {
    final FocusNode _focus = FocusNode();

    await tester.pumpWidget(LayoutBuilder(
      builder: (context, size) {
        Generic deviceType = Generic(maxWith: size.maxWidth.toInt());
        Utils.registerType<Generic>(deviceType);
        return OKToast(
          child: ChangeNotifierProvider<StoryProvider>(
            create: (_) => StoryProvider(),
            child: MaterialApp(
              title: 'Zwap ~ Storybook',
              theme: ThemeData(primaryColor: ZwapColors.primary700),
              home: Material(
                  child: ZwapInput(
                focusNode: _focus,
                onEditingComplete: () => _focus.unfocus(),
              )),
            ),
          ),
        );
      },
    ));

    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ciao come va');
    expect(_focus.hasFocus, true);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text('ciao come va'), findsOneWidget);
  });
}
