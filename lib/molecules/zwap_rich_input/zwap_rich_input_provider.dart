part of zwap.rich_input;

class RichInputValue {
  final String text;
  final Map<int, TextStyle> styles;
  final TextStyle defaultTextStyle;

  const RichInputValue({
    required this.text,
    required this.styles,
    required this.defaultTextStyle,
  });

  String get htmlText {
    String html = '';

    for (int i = 0; i < this.text.length; i++) {
      TextStyle _previous = i - 1 >= 0 ? (styles[i - 1] ?? this.defaultTextStyle) : defaultTextStyle;
      TextStyle _current = styles[i] ?? defaultTextStyle;

      if (_previous.fontWeight != _current.fontWeight) {
        if (_previous.fontWeight == FontWeight.w400)
          html += '<b>';
        else
          html += '</b>';
      }

      if (_previous.fontStyle != _current.fontStyle) {
        if (_previous.fontStyle == FontStyle.normal)
          html += '<i>';
        else
          html += '</i>';
      }

      if (_previous.decoration != _current.decoration) {
        if (_previous.decoration == TextDecoration.none)
          html += '<u>';
        else
          html += '</u>';
      }

      html += this.text[i];
    }

    TextStyle _lastOne = this.styles[this.text.length - 1] ?? defaultTextStyle;

    if (_lastOne.fontWeight == FontWeight.w700) html += '</b>';
    if (_lastOne.fontStyle == FontStyle.italic) html += '</i>';
    if (_lastOne.decoration == TextDecoration.underline) html += '</u>';

    return html.replaceAll('\n', '<br>');
  }

  ///Supported tag <b>, <i>, <u>, <br>.
  factory RichInputValue.fromHtml(String html, TextStyle defaultTextStyle) {
    Map<int, TextStyle> styles = {};
    String text = '';

    TextStyle currentTextStyle = defaultTextStyle;

    for (int i = 0; i < html.length; i++) {
      if (html[i] == '<') {
        bool toggleOn = true;
        int offset = 0;

        if (html[i + 1] == '/') {
          toggleOn = false;
          offset = 1;
        }

        switch (html[i + 1 + offset]) {
          case 'b':
            if (html[i + 2 + offset] == '>') {
              currentTextStyle = currentTextStyle.copyWith(fontWeight: toggleOn ? FontWeight.w700 : defaultTextStyle.fontWeight);
              i += 3 + offset;
            } else if (html[i + 2 + offset] == 'r' && html[i + 3 + offset] == '>') {
              text = text + '\n';
              i += 3 + offset;
              continue;
            }
            break;
          case 'i':
            currentTextStyle = currentTextStyle.copyWith(fontStyle: toggleOn ? FontStyle.italic : defaultTextStyle.fontStyle);
            i += 3 + offset;
            break;
          case 'u':
            currentTextStyle = currentTextStyle.copyWith(decoration: toggleOn ? TextDecoration.underline : defaultTextStyle.decoration);
            i += 3 + offset;
            break;
        }
      }

      if (i >= html.length) break;
      if (html[i] == '<') {
        i--;
        continue;
      }

      text += html[i];
      styles[text.length - 1] = currentTextStyle;
    }

    return RichInputValue(
      text: text,
      styles: styles,
      defaultTextStyle: defaultTextStyle,
    );
  }
}

class _ZwapRichInputProvider extends ChangeNotifier {
  late final _HandleMetaKeyboardActions _keyboardActionHandler;
  late ZwapRichController _richInputController;
  late _StyleDescriptor __descriptor;
  final FocusNode _node;

  final bool canEditFontSize;

  Timer? _showOverlayTimer;
  bool _showOverlay = false;

  RichInputValue get value => _richInputController.richInputValue;

  set value(RichInputValue value) => _richInputController = ZwapRichController(
        text: value.text,
        initialStyles: value.styles,
        defaultTextStyle: value.defaultTextStyle,
        onSelectionChange: _onSelectionChangeHandler,
        initialTextStyle: _richInputController.currentTextStyle,
      );

  set _descriptor(_StyleDescriptor value) {
    __descriptor = value;
    notifyListeners();
  }

  _ZwapRichInputProvider({
    required FocusNode focusNode,
    required this.canEditFontSize,
    ZwapRichController? controller,
  })  : _node = focusNode,
        super() {
    _richInputController = controller ??
        ZwapRichController(
          defaultTextStyle: ZwapTextType.mediumBodyRegular.copyWith(),
          onSelectionChange: _onSelectionChangeHandler,
          initialStyles: {},
        );

    _richInputController.addListener(() {
      _showOverlay = false;
      _showOverlayTimer?.cancel();
      _showOverlayTimer = Timer(const Duration(milliseconds: 500), () {
        _showOverlay = true;
        notifyListeners();
      });

      notifyListeners();
    });

    _keyboardActionHandler = _HandleMetaKeyboardActions(shortcuts: {
      LogicalKeyboardKey.keyB: toggleBold,
      LogicalKeyboardKey.keyI: toggleItalic,
      LogicalKeyboardKey.keyU: toggleUnderlined,
      if (canEditFontSize) ...{
        LogicalKeyboardKey.add: incrementFontSize,
        LogicalKeyboardKey.minus: decrementFontSize,
      },
    });

    __descriptor = _StyleDescriptor.standard();
    _node.addListener(_focusNodeListener);
  }

  double get maxFontSize => _richInputController.maxTextStyle;

  void _focusNodeListener() {
    if (_node.hasFocus) {
      _keyboardActionHandler.enable();
    } else {
      _showOverlay = false;
      _keyboardActionHandler.disable();
    }
  }

  void _onSelectionChangeHandler(int from, int? to, Map<int, TextStyle> dic) {
    if ((to ?? 0) - from <= 1)
      setStyle(_StyleDescriptor.fromTextStyle(dic[from]));
    else {
      final Map<int, TextStyle> _subDic = {};

      dic.forEach((key, value) {
        if (key > from && key < (to ?? dic.length)) _subDic[key] = value;
      });
      _descriptor = _StyleDescriptor.fromSubDict(_subDic);
      setStyle(_StyleDescriptor.fromSubDict(_subDic));
    }
  }

  ZwapRichController get controller => _richInputController;

  bool get _hasToHandleSelection => (_richInputController.selection.extentOffset - _richInputController.selection.baseOffset).abs() >= 1;

  RichInputValue? get result => _richInputController.value.text.isEmpty
      ? null
      : RichInputValue(
          text: _richInputController.text,
          styles: _richInputController.styles,
          defaultTextStyle: _richInputController.defaultTextStyle,
        );

  void toggleBold() {
    ///se non tutti della selezione bold => bold quelli mancanti
    ///se tutti bold nella selezione => no bold
    ///
    ///se no selezione : normale

    if (_hasToHandleSelection) {
      if (__descriptor.bold) //se bold è settato a true significa che gia tutti nella selezione sono bold
      {
        _richInputController.setStyleOnSelection(bold: false);
      } else
        _richInputController.setStyleOnSelection(bold: true);
    } else {
      if (_richInputController.currentTextStyle.fontWeight == FontWeight.w700) {
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(fontWeight: FontWeight.w400));
      } else {
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(fontWeight: FontWeight.w700));
      }

      _descriptor = __descriptor.copyWith(
        bold: _richInputController.currentTextStyle.fontWeight == FontWeight.w700,
      );
    }
    notifyListeners();
  }

  void toggleItalic() {
    if (_hasToHandleSelection) {
      if (__descriptor.italic) {
        _richInputController.setStyleOnSelection(italic: false);
      } else {
        _richInputController.setStyleOnSelection(italic: true);
      }
    } else {
      if (_richInputController.currentTextStyle.fontStyle == FontStyle.italic)
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(fontStyle: FontStyle.normal));
      else
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(fontStyle: FontStyle.italic));

      _descriptor = __descriptor.copyWith(
        italic: _richInputController.currentTextStyle.fontStyle == FontStyle.italic,
      );
    }
    notifyListeners();
  }

  void toggleUnderlined() {
    if (_hasToHandleSelection) {
      if (__descriptor.underline)
        _richInputController.setStyleOnSelection(underlined: false);
      else
        _richInputController.setStyleOnSelection(underlined: true);
    } else {
      if (_richInputController.currentTextStyle.decoration == TextDecoration.underline)
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(decoration: TextDecoration.none));
      else
        _richInputController.setTextStyle(_richInputController.currentTextStyle.copyWith(decoration: TextDecoration.underline));

      _descriptor = __descriptor.copyWith(
        underline: _richInputController.currentTextStyle.decoration == TextDecoration.underline,
      );
    }
    notifyListeners();
  }

  void setStyle(_StyleDescriptor descriptor) {
    _richInputController.setTextStyle(_richInputController.defaultTextStyle.copyWith(
      fontWeight: descriptor.bold ? FontWeight.w700 : FontWeight.w400,
      fontStyle: descriptor.italic ? FontStyle.italic : FontStyle.normal,
      decoration: descriptor.underline ? TextDecoration.underline : TextDecoration.none,
      fontSize: descriptor.fontSize,
    ));
  }

  void incrementFontSize() {
    final double _fontSize =
        ((_richInputController.currentTextStyle.fontSize ?? _richInputController.defaultTextStyle.fontSize ?? 14) + 1).floorToDouble();

    if (_hasToHandleSelection) {
      _richInputController.setStyleOnSelection(fontSize: _fontSize);
    } else {
      setStyle(__descriptor.copyWith(fontSize: _fontSize));
    }
    _descriptor = __descriptor.copyWith(fontSize: _fontSize);
  }

  void decrementFontSize() {
    final double _fontSize =
        ((_richInputController.currentTextStyle.fontSize ?? _richInputController.defaultTextStyle.fontSize ?? 14) - 1).floorToDouble();

    if (_hasToHandleSelection) {
      _richInputController.setStyleOnSelection(fontSize: _fontSize);
    } else {
      setStyle(__descriptor.copyWith(fontSize: _fontSize));
    }
    _descriptor = __descriptor.copyWith(fontSize: _fontSize);
  }
}
