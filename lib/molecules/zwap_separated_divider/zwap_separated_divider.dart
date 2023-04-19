import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapSeparatedDivider extends StatelessWidget {
  /// Showed between two divider lines
  final Widget content;

  /// Color of the divider lines
  final Color dividerColor;

  /// Wrap [content] between two divider lines
  /// of [dividerColor] color
  const ZwapSeparatedDivider({
    required this.content,
    this.dividerColor = ZwapColors.shades100,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 1, child: Divider(thickness: 1, color: dividerColor, height: 1)),
        const SizedBox(width: 8),
        content,
        const SizedBox(width: 8),
        Flexible(flex: 1, child: Divider(thickness: 1, color: dividerColor, height: 1)),
      ],
    );
  }
}
