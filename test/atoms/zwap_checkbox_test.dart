import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

void main() {
  test('ZwapCheckBoxStateDecoration.copyWith keeps borders, radius and icon colors', () {
    const Border border = Border.fromBorderSide(BorderSide(color: Colors.red));
    const ZwapCheckBoxStateDecoration original = ZwapCheckBoxStateDecoration(
      color: Colors.blue,
      border: border,
      borderRadius: Radius.circular(6),
      iconColor: Colors.black,
      iconHoverColor: Colors.grey,
    );

    final ZwapCheckBoxStateDecoration copy = original.copyWith(color: Colors.green);

    expect(copy.color, Colors.green);
    expect(copy.border, border);
    expect(copy.borderRadius, const Radius.circular(6));
    expect(copy.iconColor, Colors.black);
    expect(copy.iconHoverColor, Colors.grey);
  });
}
