part of zwap.range_slider;

class ZwapRangeValues {
  final double min;
  final double max;

  double get extent => max - min;

  const ZwapRangeValues(this.min, this.max);

  ZwapRangeValues copyWith({
    double? min,
    double? max,
  }) =>
      ZwapRangeValues(
        min ?? this.min,
        max ?? this.max,
      );

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  ZwapRangeValues operator +(double value) {
    return ZwapRangeValues(min + value, max + value);
  }

  @override
  bool operator ==(Object other) {
    return other is ZwapRangeValues && other.min == min && other.max == max;
  }
}
