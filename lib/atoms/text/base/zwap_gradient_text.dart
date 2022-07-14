import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapGradientText extends StatelessWidget {
  final String text;

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
  Widget build(BuildContext context) {
    final LinearGradient _customGradient = _gradient ??
        LinearGradient(
          colors: colors,
          stops: stops,
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomRight,
        );

    return ShaderMask(
      shaderCallback: (Rect bounds) => _customGradient.createShader(Offset.zero & bounds.size),
      blendMode: BlendMode.modulate,
      child: Text(
        text,
        style: (_customTextStyle ?? getTextStyle(_textType!).copyWith(color: Colors.white)).copyWith(
          height: 1.25,
        ),
        textAlign: textAlign ?? TextAlign.center,
      ),
    );
  }
}
