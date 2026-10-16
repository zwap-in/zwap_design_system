import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

Color? _buttonColor(WidgetTester tester) {
  final Iterable<AnimatedContainer> containers = tester.widgetList<AnimatedContainer>(
    find.descendant(of: find.byType(ZwapButton), matching: find.byType(AnimatedContainer)),
  );
  for (final AnimatedContainer container in containers) {
    final Decoration? decoration = container.decoration;
    if (decoration is BoxDecoration && decoration.color != null) return decoration.color;
  }
  return null;
}

Widget _child(ZwapButtonStatusDescription _) => const SizedBox();

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('ZwapButton applies new decorations without being remounted', (tester) async {
    const Key key = Key('button');

    await tester.pumpWidget(_wrap(ZwapButton.customChild(
      key: key,
      child: _child,
      decorations: ZwapButtonDecorations(backgroundColor: Colors.red),
    )));
    await tester.pumpAndSettle();
    expect(_buttonColor(tester), Colors.red);

    await tester.pumpWidget(_wrap(ZwapButton.customChild(
      key: key,
      child: _child,
      decorations: ZwapButtonDecorations(backgroundColor: Colors.blue),
    )));
    await tester.pumpAndSettle();
    expect(_buttonColor(tester), Colors.blue);
  });

  testWidgets('ZwapButton default decorations follow ZwapButtonDecorations.primaryColor', (tester) async {
    const Key key = Key('button');
    final Color? previous = ZwapButtonDecorations.primaryColor;
    addTearDown(() => ZwapButtonDecorations.primaryColor = previous);

    ZwapButtonDecorations.primaryColor = Colors.green;
    await tester.pumpWidget(_wrap(ZwapButton.customChild(key: key, child: _child)));
    await tester.pumpAndSettle();
    expect(_buttonColor(tester), Colors.green);

    ZwapButtonDecorations.primaryColor = Colors.orange;
    await tester.pumpWidget(_wrap(ZwapButton.customChild(key: key, child: _child)));
    await tester.pumpAndSettle();
    expect(_buttonColor(tester), Colors.orange);
  });
}
