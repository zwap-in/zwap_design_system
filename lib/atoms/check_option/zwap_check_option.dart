import 'package:flutter/material.dart';

import '../atoms.dart';

//FEATURE: add decorations

/// ! This widget will try to expand. Provide a not-null-size
/// widget as [builder] result
class ZwapCheckOption extends StatefulWidget {
  /// Passed as param in the builder callback
  final bool selected;
  final Widget Function(BuildContext, bool) builder;

  final Function()? onTap;

  /// ! This widget will try to expand. Provide a not-null-size
  /// widget as [builder] result
  const ZwapCheckOption({
    required this.selected,
    required this.builder,
    this.onTap,
    super.key,
  });

  @override
  State<ZwapCheckOption> createState() => _ZwapCheckOptionState();
}

class _ZwapCheckOptionState extends State<ZwapCheckOption> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void didUpdateWidget(covariant ZwapCheckOption oldWidget) {
    if (_selected != widget.selected) setState(() => _selected = widget.selected);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selected ? ZwapColors.primary50 : ZwapColors.shades0,
          border: _selected
              ? const Border.fromBorderSide(const BorderSide(color: ZwapColors.primary700, width: 1.6))
              : const Border.fromBorderSide(const BorderSide(color: ZwapColors.neutral200)),
          boxShadow: [
            if (_selected)
              BoxShadow(
                offset: Offset(0, 4),
                color: ZwapColors.primary900Dark.withOpacity(0.1),
                blurRadius: 16,
                spreadRadius: 0,
              ),
          ],
        ),
        child: Stack(
          children: [
            widget.builder(context, _selected),
            Align(
              alignment: Alignment.topRight,
              child: AnimatedOpacity(
                opacity: _selected ? 1 : 0,
                curve: Curves.decelerate,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 31,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ZwapColors.primary700,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.elliptical(31, 24),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 7, bottom: 2),
                  child: Center(
                    child: Icon(Icons.check_rounded, color: ZwapColors.shades0, size: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
