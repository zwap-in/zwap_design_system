library zwap.rich_input;

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/blurComponent/zwapBlurComponent.dart';

part 'zwap_rich_controller.dart';
part 'zwap_rich_input_provider.dart';
part 'style_descriptor.dart';
part 'src/text_editing_extention.dart';
part 'rich_style_overlay.dart';

class ZwapRichInput extends StatefulWidget {
  final RichInputValue? initialValue;
  final void Function(RichInputValue)? onValueChange;

  final bool canEditFontSize;

  const ZwapRichInput({
    this.initialValue,
    this.onValueChange,
    this.canEditFontSize = false,
    super.key,
  });

  @override
  State<ZwapRichInput> createState() => _ZwapRichInputState();
}

class _ZwapRichInputState extends State<ZwapRichInput> {
  late final FocusNode _node;
  late final _ZwapRichInputProvider _provider;

  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _provider = _ZwapRichInputProvider(focusNode: _node, canEditFontSize: widget.canEditFontSize);

    _provider.addListener(_updateStyleOverlay);
  }

  void _updateStyleOverlay() {
    final bool _showOverlay = _provider._showOverlay;

    _entry?.remove();
    _entry = null;
    if (!_showOverlay) return;

    //? Calculate the position of the cursor, see here: https://stackoverflow.com/questions/59243627/flutter-how-to-get-the-coordinates-of-the-cursor-in-a-textfield
    final TextPainter _painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: _provider._richInputController.buildTextSpan(context: context, withComposing: false),
    );
    _painter.layout(maxWidth: _node.rect.width - 20);

    Rect caretPrototype = Rect.fromLTWH(0.0, 0.0, 1, 14);

    final Offset _cursorOffset = _provider._node.offset +
        _painter.getOffsetForCaret(TextPosition(offset: _provider._richInputController.value.selection.baseOffset), caretPrototype);

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (context) {
          return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _cursorOffset.dy + 35,
              left: _cursorOffset.dx - 120,
              child: ChangeNotifierProvider.value(value: _provider, child: RichStyleOverlay()));
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ZwapRichInput oldWidget) {
    if (widget.initialValue != null && widget.initialValue != _provider.value) {
      _provider.value = widget.initialValue!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapRichInputProvider>.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final double _maxFontSize = context.select<_ZwapRichInputProvider, double>((pro) => pro.maxFontSize);

          return TextField(
            focusNode: _node,
            controller: _provider.controller,
            style: ZwapTextType.mediumBodyRegular.copyWith(fontSize: _maxFontSize),
            decoration: InputDecoration.collapsed(
              hintText: 'Inserisci qui il testo',
            ),
            cursorColor: ZwapColors.primary900Dark,
            minLines: 1,
            maxLines: 500,
          );
        },
      ),
    );
  }
}
