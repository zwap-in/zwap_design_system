part of zwap.rich_input;

class _StyleDescriptor {
  final bool bold;
  final bool italic;
  final bool underline;
  final double? fontSize;

  _StyleDescriptor.fromSubDict(Map<int, TextStyle> dict)
      : this.bold = dict.isEmpty ? false : dict.keys.every((k) => dict[k]?.fontWeight == FontWeight.w700),
        this.italic = dict.isEmpty ? false : dict.keys.every((k) => dict[k]?.fontStyle == FontStyle.italic),
        this.underline = dict.isEmpty ? false : dict.keys.every((k) => dict[k]?.decoration == TextDecoration.underline),
        this.fontSize = dict.isEmpty ? null : dict.entries.first.value.fontSize;

  _StyleDescriptor.fromTextStyle(TextStyle? style)
      : this.bold = style?.fontWeight == FontWeight.w700,
        this.italic = style?.fontStyle == FontStyle.italic,
        this.underline = style?.decoration == TextDecoration.underline,
        this.fontSize = style?.fontSize;

  const _StyleDescriptor.standard({
    this.fontSize,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });

  const _StyleDescriptor({
    required this.fontSize,
    required this.bold,
    required this.italic,
    required this.underline,
  });

  _StyleDescriptor copyWith({
    bool? bold,
    bool? italic,
    bool? underline,
    double? fontSize,
  }) =>
      _StyleDescriptor(
        bold: bold ?? this.bold,
        italic: italic ?? this.italic,
        underline: underline ?? this.underline,
        fontSize: fontSize ?? this.fontSize,
      );

  @override
  String toString() {
    return '_StyleDescriptor#$hashCode('
        '\tbold: $bold'
        '\titalic: $italic'
        '\tunderline: $underline'
        '\tfontSize: $fontSize'
        ')';
  }
}
