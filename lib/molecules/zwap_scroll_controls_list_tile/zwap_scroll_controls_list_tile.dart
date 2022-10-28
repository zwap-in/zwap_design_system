import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';

import '../scroll_arrow/zwap_scroll_arrow.dart';

// FEATURE: add subtitle, leading, trailing and other properties

// BUG: On small devices overlflor

/// This widget consist in a title, an arrow icon near the title and if [showScrollContols] is true a left/rigth scroll comand icons, arranged horizontally.
///
/// When device is small (ie: type1 or type0) button and scroll controllers are showed under the text, insetead of in line
class ZwapScrollControlsListTile extends StatefulWidget {
  final String title;

  final Function()? onLeftScrollControlTap;
  final Function()? onRigthScrollControlTap;

  final Function()? onViewAllTap;

  final bool leftEnabled;
  final bool rigthEnabled;

  final bool showScrollControls;

  final bool showViewAll;

  /// If provided this widget will be displaed in the left of the scroll controls, or oa the end of the row if the scroll controls are hidden
  final Widget? trailing;

  /// The rigth margin of trailing widget
  final double? trailingPadding;

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
    this.onViewAllTap,
    this.trailing,
    this.trailingPadding,
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
    final bool _isSmall = getMultipleConditions(false, false, false, true, true);

    final Widget _controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.trailing != null) ...[
          widget.trailing!,
          SizedBox(width: widget.trailingPadding ?? 25),
        ],
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

    if (_isSmall)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ZwapText(
            text: widget.title,
            textColor: ZwapColors.neutral800,
            zwapTextType: ZwapTextType.h2,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ZwapScrollControlsListTileButtons(
                onViewAllTap: widget.onViewAllTap,
                showViewAll: _showViewAll,
                translateKeyFunction: widget.translateKeyFunction,
              ),
              _controls,
            ],
          ),
        ],
      );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZwapText(
              text: widget.title,
              textColor: ZwapColors.neutral800,
              zwapTextType: ZwapTextType.h2,
            ),
            SizedBox(width: 10),
            _ZwapScrollControlsListTileButtons(
              onViewAllTap: widget.onViewAllTap,
              showViewAll: _showViewAll,
              translateKeyFunction: widget.translateKeyFunction,
            ),
          ],
        ),
        _controls,
      ],
    );
  }
}

class _ZwapScrollControlsListTileButtons extends StatefulWidget {
  final bool showViewAll;

  final Function()? onViewAllTap;
  final String Function(String key)? translateKeyFunction;

  const _ZwapScrollControlsListTileButtons({
    required this.onViewAllTap,
    required this.showViewAll,
    required this.translateKeyFunction,
    Key? key,
  }) : super(key: key);

  @override
  State<_ZwapScrollControlsListTileButtons> createState() => __ZwapScrollControlsListTileButtonsState();
}

class __ZwapScrollControlsListTileButtonsState extends State<_ZwapScrollControlsListTileButtons> {
  late bool _showViewAll;

  @override
  void initState() {
    super.initState();

    _showViewAll = widget.showViewAll;
  }

  @override
  void didUpdateWidget(covariant _ZwapScrollControlsListTileButtons oldWidget) {
    if (_showViewAll != widget.showViewAll) setState(() => _showViewAll = widget.showViewAll);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.decelerate,
      child: ZwapButton(
        height: 30,
        width: 110,
        buttonChild: ZwapButtonChild.textWithIcon(
          text: widget.translateKeyFunction!('view_all'),
          icon: Icons.arrow_forward,
          iconSize: 18,
          fontSize: 15,
          fontWeight: FontWeight.w300,
          spaceBetween: 8,
          iconPosition: ZwapButtonIconPosition.right,
        ),
        decorations: ZwapButtonDecorations.quaternary(
          internalPadding: EdgeInsets.zero,
          backgroundColor: ZwapColors.whiteTransparent,
        ),
        hide: !_showViewAll,
        onTap: widget.onViewAllTap,
      ),
    );
  }
}
