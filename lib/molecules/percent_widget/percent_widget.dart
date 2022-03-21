import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapPercentIndicatorDecorations {
  final double radius;
  final double lineWidth;
  final Color backgroundColor;
  final Color valueColor;

  const ZwapPercentIndicatorDecorations({
    required this.radius,
    required this.lineWidth,
    required this.backgroundColor,
    required this.valueColor,
  });

  const ZwapPercentIndicatorDecorations.descrutive({
    this.radius = 30,
    this.lineWidth = 6,
    this.backgroundColor = ZwapColors.error200,
    this.valueColor = ZwapColors.error400,
  });

  ZwapPercentIndicatorDecorations copyWith({
    double? radius,
    double? lineWidth,
    Color? backgroundColor,
    Color? valueColor,
  }) {
    return ZwapPercentIndicatorDecorations(
      radius: radius ?? this.radius,
      lineWidth: lineWidth ?? this.lineWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      valueColor: valueColor ?? this.valueColor,
    );
  }
}

class ZwapPercentWidgetDecorations {
  //? Container decorations
  final Color backgroundColor;
  final List<BoxShadow> shadows;
  final BorderRadius borderRadius;
  final Border? border;
  final EdgeInsets contentPadding;

  //? Percent indicator decorations

  final ZwapPercentIndicatorDecorations percentIndicatorDecorations;

  //? Content indicator decorations
  /// Prefer use styles from `ZwapTypography`
  final TextStyle titleStyle;

  /// Prefer use styles from `ZwapTypography`
  final TextStyle subtitleStyle;

  const ZwapPercentWidgetDecorations({
    required this.backgroundColor,
    required this.shadows,
    required this.contentPadding,
    required this.borderRadius,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.percentIndicatorDecorations,
    this.border,
  });

  const ZwapPercentWidgetDecorations.defaultDecorations({
    this.backgroundColor = ZwapColors.shades0,
    this.shadows = const [ZwapShadow.levelOne],
    this.borderRadius = const BorderRadius.all(const Radius.circular(30)),
    this.titleStyle: ZwapTypography.bigBodyBold,
    this.subtitleStyle: ZwapTypography.extraSmallBodyRegular,
    this.border,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.percentIndicatorDecorations = const ZwapPercentIndicatorDecorations.descrutive(),
  });

  const ZwapPercentWidgetDecorations.flat({
    this.backgroundColor = ZwapColors.shades0,
    this.shadows = const [],
    this.borderRadius = const BorderRadius.all(const Radius.circular(30)),
    this.titleStyle: ZwapTypography.bigBodyBold,
    this.subtitleStyle: ZwapTypography.extraSmallBodyRegular,
    this.border,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.percentIndicatorDecorations = const ZwapPercentIndicatorDecorations.descrutive(),
  });

  ZwapPercentWidgetDecorations copyWith({
    Color? backgroundColor,
    List<BoxShadow>? shadows,
    BorderRadius? borderRadius,
    Border? border,
    EdgeInsets? contentPadding,
    ZwapPercentIndicatorDecorations? percentIndicatorDecorations,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) {
    return ZwapPercentWidgetDecorations(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shadows: shadows ?? this.shadows,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      contentPadding: contentPadding ?? this.contentPadding,
      percentIndicatorDecorations: percentIndicatorDecorations ?? this.percentIndicatorDecorations,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    );
  }
}

class ZwapPercentWidgetPercentContent {
  /// If true show 'XX%' inside the percent indicator.
  ///
  /// Show [customWidget] otherwise
  final bool _showPercent;
  final Widget? _customWidget;

  const ZwapPercentWidgetPercentContent.percent()
      : this._showPercent = true,
        this._customWidget = null;

  const ZwapPercentWidgetPercentContent.custom({required Widget content})
      : this._customWidget = content,
        this._showPercent = false;
}

class ZwapPercentWidget extends StatefulWidget {
  final double width;
  final double height;

  /// The value to show in the percent indicator
  ///
  /// The widget automatically response to this variable changes with animations
  ///
  /// Between 0 and 1
  final double percentValue;

  /// The widget to show inside the percent indicator
  ///
  /// Default to `ZwapPercentWidgetPercentContent.percent()`
  final ZwapPercentWidgetPercentContent insidePercentContent;

  /// The text in top center.
  final String title;

  /// The text in bottom center.
  ///
  /// In null this textx will not be shown and title will be vertically centered
  final String? subtitle;

  /// The button to show inside this widget
  final ZwapButton? button;

  /// See `ZwapPercentWidgetDecorations` for details
  final ZwapPercentWidgetDecorations decorations;

  final int titleMaxLines;
  final int subtitleMaxLines;

  const ZwapPercentWidget({
    this.width = 390,
    this.height = 96,
    required this.percentValue,
    required this.title,
    this.insidePercentContent = const ZwapPercentWidgetPercentContent.percent(),
    this.subtitle,
    this.button,
    this.decorations = const ZwapPercentWidgetDecorations.defaultDecorations(),
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 2,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapPercentWidget> createState() => _ZwapPercentWidgetState();
}

class _ZwapPercentWidgetState extends State<ZwapPercentWidget> {
  late double _percentValue;

  @override
  void initState() {
    _percentValue = widget.percentValue;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ZwapPercentWidget oldWidget) {
    if (_percentValue != widget.percentValue) setState(() => _percentValue = widget.percentValue);

    super.didUpdateWidget(oldWidget);
  }

  ZwapPercentWidgetDecorations get decorations => widget.decorations;
  ZwapPercentIndicatorDecorations get indicatorDecorations => widget.decorations.percentIndicatorDecorations;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: decorations.backgroundColor,
        borderRadius: decorations.borderRadius,
        border: decorations.border,
        boxShadow: decorations.shadows,
      ),
      padding: decorations.contentPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 0,
            child: CircularPercentIndicator(
              percent: widget.percentValue,
              radius: indicatorDecorations.radius,
              animation: true,
              lineWidth: indicatorDecorations.lineWidth,
              backgroundColor: indicatorDecorations.backgroundColor,
              fillColor: Colors.transparent,
              progressColor: indicatorDecorations.valueColor,
              circularStrokeCap: CircularStrokeCap.round,
              center: Center(
                child: widget.insidePercentContent._showPercent
                    ? ZwapText(
                        text: "${_percentValue * 100}%",
                        zwapTextType: ZwapTextType.mediumBodyBold,
                        textColor: ZwapColors.neutral600,
                        textAlign: TextAlign.center,
                      )
                    : widget.insidePercentContent._customWidget!,
              ),
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 0,
                  child: ZwapText.customStyle(
                    text: widget.title,
                    customTextStyle: decorations.titleStyle,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: widget.titleMaxLines,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  SizedBox(height: 1),
                  Expanded(
                    flex: 0,
                    child: ZwapText.customStyle(
                      text: widget.subtitle!,
                      customTextStyle: decorations.subtitleStyle,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: widget.subtitleMaxLines,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 7),
          if (widget.button != null) widget.button!,
        ],
      ),
    );
  }
}
