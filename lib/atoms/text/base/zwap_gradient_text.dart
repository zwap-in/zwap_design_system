part of zwap.text;

class ZwapGradientText extends StatefulWidget {
  final Pattern text;

  /// Copied from [Gradient], see [Gradient] for more details
  final List<Color> colors;

  /// Copied from [Gradient], see [Gradient] for more details
  final List<double>? stops;

  /// Copied from [Gradient], see [Gradient] for more details
  final Alignment? begin;

  /// Copied from [Gradient], see [Gradient] for more details
  final Alignment? end;

  final TextStyle? _customTextStyle;

  final ZwapTextType? _textType;

  final TextAlign? textAlign;

  final LinearGradient? _gradient;

  const ZwapGradientText({
    required this.text,
    required this.colors,
    required ZwapTextType textType,
    this.stops,
    this.begin,
    this.end,
    this.textAlign,
    Key? key,
  })  : this._textType = textType,
        this._customTextStyle = null,
        this._gradient = null,
        super(key: key);

  /// Same as ZwapGradientText() but you can provide a custom
  /// [TextStyle] instead of using the [ZwapTypography]
  const ZwapGradientText.custom({
    required this.text,
    required this.colors,
    required TextStyle style,
    this.stops,
    this.begin,
    this.end,
    this.textAlign,
    Key? key,
  })  : this._textType = null,
        this._customTextStyle = style,
        this._gradient = null,
        super(key: key);

  const ZwapGradientText.fromGradient({
    required this.text,
    required TextStyle style,
    required LinearGradient gradient,
    this.textAlign,
    Key? key,
  })  : this._gradient = gradient,
        this._textType = null,
        this._customTextStyle = style,
        this.end = null,
        this.begin = null,
        this.stops = null,
        this.colors = const [],
        super(key: key);

  @override
  State<ZwapGradientText> createState() => _ZwapGradientTextState();
}

class _ZwapGradientTextState extends State<ZwapGradientText> {
  String get actualText {
    if (widget.text is String) {
      return widget.text as String;
    } else if (widget.text is ZwapTranslation) {
      return (widget.text as ZwapTranslation).getTranslation();
    }

    return widget.text.toString();
  }

  @override
  void initState() {
    super.initState();

    if (widget.text is ZwapTranslation) {
      (widget.text as ZwapTranslation)._addNotifierMirror(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final LinearGradient _customGradient = widget._gradient ??
        LinearGradient(
          colors: widget.colors,
          stops: widget.stops,
          begin: widget.begin ?? Alignment.topLeft,
          end: widget.end ?? Alignment.bottomRight,
        );

    Widget _wrapWithEditable(Text child) {
      if (ZwapTranslation.enableEdits && widget.text is ZwapTranslation)
        return _WrapWithEditTextTooltip(
          text: widget.text as ZwapTranslation,
          builder: () => child,
        );
      return child;
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) => _customGradient.createShader(Offset.zero & bounds.size),
      blendMode: BlendMode.modulate,
      child: _wrapWithEditable(
        Text(
          actualText,
          style: (widget._customTextStyle ?? getTextStyle(widget._textType!).copyWith(color: Colors.white)).copyWith(),
          textAlign: widget.textAlign ?? TextAlign.center,
        ),
      ),
    );
  }
}
