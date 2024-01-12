part of zwap.range_slider;

class ZwapRangeValues {
  final double min;
  final double max;

  double get extent => max - min;

  const ZwapRangeValues(this.min, this.max);

  ZwapRangeValues copyWith({
    double? min,
    double? max,
  }) {
    return ZwapRangeValues(
      min ?? this.min,
      max ?? this.max,
    );
  }

  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  ZwapRangeValues operator +(double value) {
    return ZwapRangeValues(min + value, max + value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ZwapRangeValues && other.min == min && other.max == max;
  }

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
    };
  }

  factory ZwapRangeValues.fromMap(Map<String, dynamic> map) {
    return ZwapRangeValues(
      map['min']?.toDouble() ?? 0.0,
      map['max']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZwapRangeValues.fromJson(String source) => ZwapRangeValues.fromMap(json.decode(source));

  @override
  String toString() => 'ZwapRangeValues(min: $min, max: $max)';
}

class ZwapRangeValuesDescription {
  final ZwapRangeValues values;
  final bool isExtentAtMin;
  final bool isExtentAtMax;

  const ZwapRangeValuesDescription({
    required this.values,
    required this.isExtentAtMin,
    required this.isExtentAtMax,
  });

  ZwapRangeValuesDescription copyWith({
    ZwapRangeValues? values,
    bool? isExtentAtMin,
    bool? isExtentAtMax,
  }) {
    return ZwapRangeValuesDescription(
      values: values ?? this.values,
      isExtentAtMin: isExtentAtMin ?? this.isExtentAtMin,
      isExtentAtMax: isExtentAtMax ?? this.isExtentAtMax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'values': values.toMap(),
      'isExtentAtMin': isExtentAtMin,
      'isExtentAtMax': isExtentAtMax,
    };
  }

  factory ZwapRangeValuesDescription.fromMap(Map<String, dynamic> map) {
    return ZwapRangeValuesDescription(
      values: ZwapRangeValues.fromMap(map['values']),
      isExtentAtMin: map['isExtentAtMin'] ?? false,
      isExtentAtMax: map['isExtentAtMax'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZwapRangeValuesDescription.fromJson(String source) => ZwapRangeValuesDescription.fromMap(json.decode(source));

  @override
  String toString() => 'ZwapRangeValuesDescription(values: $values, isExtentAtMin: $isExtentAtMin, isExtentAtMax: $isExtentAtMax)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ZwapRangeValuesDescription &&
        other.values == values &&
        other.isExtentAtMin == isExtentAtMin &&
        other.isExtentAtMax == isExtentAtMax;
  }

  @override
  int get hashCode => values.hashCode ^ isExtentAtMin.hashCode ^ isExtentAtMax.hashCode;
}
