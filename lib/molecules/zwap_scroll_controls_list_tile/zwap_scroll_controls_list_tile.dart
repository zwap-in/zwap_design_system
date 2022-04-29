import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';

import '../scroll_arrow/zwap_scroll_arrow.dart';

// TODO: add subtitle, leading, trailing and other properties

/// This widget consist in a title, an arrow icon near the title and if [showScrollContols] is true a left/rigth scroll comand icons, arranged horizontally.
class ZwapScrollControlsListTile extends StatefulWidget {
  final String title;

  final Function()? onLeftScrollControlTap;
  final Function()? onRigthScrollControlTap;

  final Function()? onShowAllTap;

  final bool leftEnabled;
  final bool rigthEnabled;

  final bool showScrollControls;

  final bool showViewAll;

  /// Used to translate (<key>: <english value>):
  /// * view_all: "View all"
  ///
  /// Required if [showViewAll] is true
  final String Function(String key)? translateKeyFunction;

  ZwapScrollControlsListTile({
    Key? key,
    required this.title,
    required this.translateKeyFunction,
    this.showScrollControls = true,
    this.leftEnabled = true,
    this.rigthEnabled = true,
    this.showViewAll = true,
    this.onLeftScrollControlTap,
    this.onRigthScrollControlTap,
    this.onShowAllTap,
  }) : super(key: key);

  @override
  State<ZwapScrollControlsListTile> createState() => _ZwapScrollControlsListTileState();
}

class _ZwapScrollControlsListTileState extends State<ZwapScrollControlsListTile> {
  late bool _showControls;
  late bool _showViewAll;
  late bool _rightEnabled;
  late bool _leftEnabled;

  @override
  void initState() {
    super.initState();

    _showControls = widget.showScrollControls;
    _rightEnabled = widget.rigthEnabled;
    _leftEnabled = widget.leftEnabled;
    _showViewAll = widget.showViewAll;
  }

  @override
  void didUpdateWidget(covariant ZwapScrollControlsListTile oldWidget) {
    if (_showControls != widget.showScrollControls) setState(() => _showControls = widget.showScrollControls);
    if (_rightEnabled != widget.rigthEnabled) setState(() => _rightEnabled = widget.rigthEnabled);
    if (_leftEnabled != widget.leftEnabled) setState(() => _leftEnabled = widget.leftEnabled);
    if (_showViewAll != widget.showViewAll) setState(() => _showViewAll = widget.showViewAll);

    super.didUpdateWidget(oldWidget);
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: getMultipleConditions(false, false, false, true, true)
                  ? BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45)
                  : BoxConstraints(),
              child: ZwapText(
                text: widget.title,
                textColor: ZwapColors.neutral800,
                zwapTextType: ZwapTextType.h2,
              ),
            ),
            SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.decelerate,
              child: ZwapButton(
                height: 30,
                width: 120,
                buttonChild: ZwapButtonChild.textWithIcon(
                  text: widget.translateKeyFunction!('view_all'),
                  icon: Icons.arrow_forward,
                  iconSize: 18,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  spaceBetween: 8,
                  iconPosition: ZwapButtonIconPosition.right,
                ),
                decorations: ZwapButtonDecorations.quaternary(internalPadding: EdgeInsets.zero),
                hide: !_showViewAll,
                onTap: widget.onShowAllTap,
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.decelerate,
          child: _showControls
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.left,
                        disabled: !_leftEnabled,
                        onTap: widget.onLeftScrollControlTap,
                      ),
                      flex: 0,
                      fit: FlexFit.tight,
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.right,
                        disabled: !_rightEnabled,
                        onTap: widget.onRigthScrollControlTap,
                      ),
                      flex: 0,
                    )
                  ],
                )
              : Container(),
        ),
      ],
    );
  }
}
