part of weekly_calendar_picker;

///? Weekly Calendar Picker Day Slot Widget Decoration Multi State Collection
class WCPDSWDMultiStateColletion<T> {
  final T? standard;
  final T? hovered;
  final T? diasabled;

  const WCPDSWDMultiStateColletion({this.standard, this.hovered, this.diasabled});
}

class WCPDateSlotWidgetDecorations {
  final EdgeInsets internalPadding;
  final BorderRadius? borderRadius;

  final WCPDSWDMultiStateColletion<Border> selectedBorder;
  final WCPDSWDMultiStateColletion<Border> notSelectedBorder;
  final WCPDSWDMultiStateColletion<Color> selectedBackgroundColor;
  final WCPDSWDMultiStateColletion<Color> notSelectedBackgroundColor;
  final WCPDSWDMultiStateColletion<Color> selectedTextColor;
  final WCPDSWDMultiStateColletion<Color> notSelectedTextColor;
  final WCPDSWDMultiStateColletion<ZwapTextType> selectedTextType;
  final WCPDSWDMultiStateColletion<ZwapTextType> notSelectedTextType;
  final WCPDSWDMultiStateColletion<TextStyle> selectedTextStyle;
  final WCPDSWDMultiStateColletion<TextStyle> notSelectedTextStyle;

  const WCPDateSlotWidgetDecorations({
    this.internalPadding = EdgeInsets.zero,
    this.borderRadius,
    this.selectedBorder = const WCPDSWDMultiStateColletion(),
    this.notSelectedBorder = const WCPDSWDMultiStateColletion(),
    this.selectedBackgroundColor = const WCPDSWDMultiStateColletion(),
    this.notSelectedBackgroundColor = const WCPDSWDMultiStateColletion(),
    this.selectedTextColor = const WCPDSWDMultiStateColletion(),
    this.notSelectedTextColor = const WCPDSWDMultiStateColletion(),
    this.selectedTextType = const WCPDSWDMultiStateColletion(),
    this.notSelectedTextType = const WCPDSWDMultiStateColletion(),
  })  : this.selectedTextStyle = const WCPDSWDMultiStateColletion(),
        this.notSelectedTextStyle = const WCPDSWDMultiStateColletion();

  const WCPDateSlotWidgetDecorations.customTextStyle({
    this.internalPadding = EdgeInsets.zero,
    this.borderRadius,
    this.selectedBorder = const WCPDSWDMultiStateColletion(),
    this.notSelectedBorder = const WCPDSWDMultiStateColletion(),
    this.selectedBackgroundColor = const WCPDSWDMultiStateColletion(),
    this.notSelectedBackgroundColor = const WCPDSWDMultiStateColletion(),
    this.selectedTextStyle = const WCPDSWDMultiStateColletion(),
    this.notSelectedTextStyle = const WCPDSWDMultiStateColletion(),
  })  : this.selectedTextColor = const WCPDSWDMultiStateColletion(),
        this.notSelectedTextColor = const WCPDSWDMultiStateColletion(),
        this.selectedTextType = const WCPDSWDMultiStateColletion(),
        this.notSelectedTextType = const WCPDSWDMultiStateColletion();

  const WCPDateSlotWidgetDecorations.standard({
    this.internalPadding = const EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.selectedBorder = const WCPDSWDMultiStateColletion(
      standard: const Border.fromBorderSide(BorderSide(color: ZwapColors.primary100)),
      diasabled: const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral100)),
      hovered: const Border.fromBorderSide(BorderSide(color: ZwapColors.primary200)),
    ),
    this.notSelectedBorder = const WCPDSWDMultiStateColletion(
      diasabled: const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral100)),
      hovered: const Border.fromBorderSide(BorderSide(color: ZwapColors.neutral300)),
    ),
    this.selectedBackgroundColor = const WCPDSWDMultiStateColletion(
      diasabled: ZwapColors.whiteTransparent,
      hovered: ZwapColors.primary50,
      standard: ZwapColors.primary100,
    ),
    this.notSelectedBackgroundColor = const WCPDSWDMultiStateColletion(
      diasabled: ZwapColors.whiteTransparent,
      hovered: ZwapColors.neutral100,
      standard: ZwapColors.whiteTransparent,
    ),
    this.selectedTextColor = const WCPDSWDMultiStateColletion(
      diasabled: ZwapColors.primary800,
      hovered: ZwapColors.primary400,
      standard: ZwapColors.primary400,
    ),
    this.notSelectedTextColor = const WCPDSWDMultiStateColletion(
      diasabled: ZwapColors.neutral300,
      hovered: ZwapColors.neutral800,
      standard: ZwapColors.neutral800,
    ),
    this.selectedTextType = const WCPDSWDMultiStateColletion(
      diasabled: ZwapTextType.bodySemiBold,
      hovered: ZwapTextType.bodySemiBold,
      standard: ZwapTextType.bodySemiBold,
    ),
    this.notSelectedTextType = const WCPDSWDMultiStateColletion(
      diasabled: ZwapTextType.bodyRegular,
      hovered: ZwapTextType.bodyRegular,
      standard: ZwapTextType.bodyRegular,
    ),
  })  : this.selectedTextStyle = const WCPDSWDMultiStateColletion(),
        this.notSelectedTextStyle = const WCPDSWDMultiStateColletion();

  /// If [hasCustomTextStyle] is true [selectedTextColor], [notSelectedTextColor], [selectedTextType], [notSelectedTextType] will be null and only [selectedTextStyle] and [notSelectedTextStyle] will be copied
  ///
  /// The expact dual case is [hasCustomTextStyle] is false
  WCPDateSlotWidgetDecorations copyWith({
    EdgeInsets? internalPadding,
    BorderRadius? borderRadius,
    WCPDSWDMultiStateColletion<Border>? selectedBorder,
    WCPDSWDMultiStateColletion<Border>? notSelectedBorder,
    WCPDSWDMultiStateColletion<Color>? selectedBackgroundColor,
    WCPDSWDMultiStateColletion<Color>? notSelectedBackgroundColor,
    WCPDSWDMultiStateColletion<Color>? selectedTextColor,
    WCPDSWDMultiStateColletion<Color>? notSelectedTextColor,
    WCPDSWDMultiStateColletion<ZwapTextType>? selectedTextType,
    WCPDSWDMultiStateColletion<ZwapTextType>? notSelectedTextType,
    WCPDSWDMultiStateColletion<TextStyle>? selectedTextStyle,
    WCPDSWDMultiStateColletion<TextStyle>? notSelectedTextStyle,
    required bool hasCustomTextStyle,
  }) {
    if (hasCustomTextStyle)
      return WCPDateSlotWidgetDecorations.customTextStyle(
        internalPadding: internalPadding ?? this.internalPadding,
        borderRadius: borderRadius ?? this.borderRadius,
        selectedBorder: selectedBorder ?? this.selectedBorder,
        notSelectedBorder: notSelectedBorder ?? this.notSelectedBorder,
        selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
        notSelectedBackgroundColor: notSelectedBackgroundColor ?? this.notSelectedBackgroundColor,
        selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
        notSelectedTextStyle: notSelectedTextStyle ?? this.notSelectedTextStyle,
      );
    else
      return WCPDateSlotWidgetDecorations(
        internalPadding: internalPadding ?? this.internalPadding,
        borderRadius: borderRadius ?? this.borderRadius,
        selectedBorder: selectedBorder ?? this.selectedBorder,
        notSelectedBorder: notSelectedBorder ?? this.notSelectedBorder,
        selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
        notSelectedBackgroundColor: notSelectedBackgroundColor ?? this.notSelectedBackgroundColor,
        selectedTextColor: selectedTextColor ?? this.selectedTextColor,
        notSelectedTextColor: notSelectedTextColor ?? this.notSelectedTextColor,
        selectedTextType: selectedTextType ?? this.selectedTextType,
        notSelectedTextType: notSelectedTextType ?? this.notSelectedTextType,
      );
  }
}
