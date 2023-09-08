part of zwap.rich_input;

enum _ListType {
  unordered,
  numeric,
  alphabetic;
}

const kEnableList = false;

extension _StringExt on String {
  String get reversed => split('').reversed.reduce((v, e) => '$v$e');

  /// Remove the char at index [index], if present, and add at
  /// the same index [newValue]
  String replace(int index, String newValue) => ((split('')..remove(index))..insert(index, newValue)).reduce((v, e) => '$v$e');
}

/// If enabled listen for meta key pressed and then dispatch
/// all the provided [PhysicalKeyboardKey] to the given action
class _HandleMetaKeyboardActions {
  late final Map<LogicalKeyboardKey, Function()?> shortcuts;

  bool _enabled = false;
  void enable() {
    if (!_enabled) {
      RawKeyboard.instance.addListener(_handleEvent);
    }
    _enabled = true;
  }

  void disable() {
    if (_enabled) {
      RawKeyboard.instance.removeListener(_handleEvent);
    }
    _enabled = false;
  }

  _HandleMetaKeyboardActions({this.shortcuts = const {}});

  bool _isMetaKeyPressed = false;

  void _handleEvent(RawKeyEvent event) {
    bool _isMetaKey() => event.logicalKey == LogicalKeyboardKey.metaLeft || event.logicalKey == LogicalKeyboardKey.metaRight;

    if (event is RawKeyDownEvent) {
      if (_isMetaKey()) {
        _isMetaKeyPressed = true;
      }

      if (_isMetaKeyPressed && shortcuts[event.logicalKey] != null) {
        shortcuts[event.logicalKey]!();
      }
    } else if (event is RawKeyUpEvent) {
      if (_isMetaKey()) {
        _isMetaKeyPressed = false;
      }
    }
  }
}

/// Expanded from TextEditingController,add insertBlock,insertText method and data property.
class ZwapRichController extends TextEditingController {
  Map<int, TextStyle> _dictionary = {};

  TextEditingValue? _focusValue;

  ///(baseOffset, extentOffset, dictionary)
  ///
  ///Dictionary-> index: style
  final Function(int, int?, Map<int, TextStyle>)? onSelectionChange;

  TextStyle defaultTextStyle;
  TextStyle currentTextStyle = TextStyle();

  Map<int, TextStyle> get styles => _dictionary;

  RichInputValue get richInputValue => RichInputValue(text: text, styles: styles, defaultTextStyle: defaultTextStyle);

  double get maxTextStyle {
    if (_dictionary.isEmpty || _dictionary.values.every((v) => v.fontSize == null)) return defaultTextStyle.fontSize ?? 14;

    return _dictionary.values.map((s) => s.fontSize).reduce((v, e) {
          if (v == null) return e;
          if (e == null) return v;
          if (v > e) return v;
          return e;
        }) ??
        defaultTextStyle.fontSize ??
        14;
  }

  ZwapRichController({
    required this.defaultTextStyle,
    String text = '',
    TextStyle initialTextStyle = const TextStyle(),
    this.onSelectionChange,
    Map<int, TextStyle> initialStyles = const {},
  })  : this.currentTextStyle = initialTextStyle,
        this._dictionary = initialStyles.isEmpty ? {} : initialStyles,
        super(text: text.replaceAll('\\n', ''));

  @override
  void clear() {
    currentTextStyle = defaultTextStyle;
    super.clear();
  }

  void setTextStyle(TextStyle newStyle) => currentTextStyle = newStyle;

  void setStyleOnSelection({
    bool? bold,
    bool? italic,
    bool? underlined,
    double? fontSize,
  }) {
    final int _from = min(value.selection.baseOffset, value.selection.extentOffset);
    final int _to = max(value.selection.baseOffset, value.selection.extentOffset);

    for (int i = _from; i < _to; i++) {
      TextStyle _style = _dictionary[i] ?? defaultTextStyle;

      _dictionary[i] = (_dictionary[i] ?? defaultTextStyle).copyWith(
        fontWeight: bold == null
            ? _style.fontWeight
            : bold
                ? FontWeight.w700
                : FontWeight.w400,
        fontStyle: italic == null
            ? _style.fontStyle
            : italic
                ? FontStyle.italic
                : FontStyle.normal,
        decoration: underlined == null
            ? _style.decoration
            : underlined
                ? TextDecoration.underline
                : TextDecoration.none,
        fontSize: fontSize == null ? _style.fontSize : fontSize,
      );
    }

    super.notifyListeners();
    onSelectionChange!(_from - 1, _to, _dictionary);
  }

  bool _detectEnterPressed(TextEditingValue newValue) {
    final List<String> _newCharacters = newValue.text.split('');
    final List<String> _oldCharacters = value.text.split('');

    _newCharacters.retainWhere((e) {
      return !_oldCharacters.remove(e);
    });

    return _newCharacters.contains('\n');
  }

  @override
  set value(TextEditingValue newValue) {
    if (kEnableList) newValue = _checkForList(newValue);
    _manageDictionary(newValue);

    if (onSelectionChange != null && newValue.text.length == value.text.length)
      onSelectionChange!(newValue.selection.baseOffset - 1, newValue.selection.extentOffset, _dictionary);

    super.value = _formatValue(value, newValue);
    if (newValue.selection.baseOffset != -1) {
      _focusValue = newValue;
    } else if (_focusValue != null && _focusValue!.selection.baseOffset > newValue.text.length) {
      _focusValue = null;
    }
  }

  TextEditingValue _formatValue(TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue == newValue || newValue.text.length >= oldValue.text.length || newValue.selection.baseOffset == -1) return newValue;
    return newValue;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (!value.composing.isValid || !withComposing) {
      return _getTextSpan(text, style);
    }

    final TextStyle composingStyle = (style ?? TextStyle()).merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return TextSpan(
      style: style,
      children: <TextSpan>[
        _getTextSpan(value.composing.textBefore(value.text), style),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(value.text),
        ),
        _getTextSpan(value.composing.textAfter(value.text), style),
      ],
    );
  }

  TextSpan _getTextSpan(String text, TextStyle? style) {
    if (_dictionary.isEmpty || text.isEmpty) {
      return TextSpan(style: style, text: text);
    }

    final List<TextSpan> children = [];

    for (int i = 0; i < text.length; i++) {
      children.add(
        TextSpan(
          text: text[i],
          style: (_dictionary[i] ?? defaultTextStyle).copyWith(
            height: text[i] == 'a' ? 1.5 : 4,
          ) /* min(
            1.2,
            (_dictionary[i]?.fontSize ?? 0) / (defaultTextStyle.fontSize ?? 1),
          )) */
          ,
        ),
      );
    }

    return TextSpan(
      style: defaultTextStyle,
      children: children,
    );
  }

  void _manageDictionary(TextEditingValue newValue) {
    if (newValue.selection.baseOffset == newValue.text.length && value.selection.baseOffset >= 0) {
      if (value.selection.isCollapsed) {
        _dictionary[value.selection.baseOffset] = currentTextStyle;
      }
    } else {
      if (newValue.text.length != value.text.length) {
        _slideDictionary(value.selection.baseOffset, newValue.text.length - value.text.length, newValue.text.length);
      }
      if (newValue.text.length > value.text.length) {
        for (int i = value.selection.baseOffset; i < (value.selection.baseOffset + (newValue.text.length - value.text.length)); i++) {
          _dictionary[i] = currentTextStyle;
        }
      } else {
        for (int i = value.selection.baseOffset; i < (newValue.text.length); i++) {
          _dictionary[i] = _dictionary[i + value.text.length - newValue.text.length - 1] ?? defaultTextStyle;
        }
      }
    }
  }

  void _slideDictionary(int from, int of, int newLenght) {
    Map<int, TextStyle> original = Map<int, TextStyle>.from(_dictionary);
    for (int i = 0; i < original.keys.length; i++) {
      if (i + of < from) continue;

      if (i >= newLenght)
        _dictionary.remove(i);
      else
        _dictionary[i + of] = original[i] ?? defaultTextStyle;
    }
  }

  //? ----- LISTS ----
  static const String _kUnorderedListHeader = '   • ';
  static const String _kNumericListHeader = '   N. ';
  static const String _kAlphabeticHeader = '   A. ';

  static Map<_ListType, String> _kListHeaders = {
    _ListType.unordered: _kUnorderedListHeader,
    _ListType.numeric: _kNumericListHeader,
    _ListType.alphabetic: _kAlphabeticHeader,
  };

  static Map<_ListType, List<Pattern>> _kTriggerChars = {
    _ListType.unordered: ['- ', '• '],
    _ListType.numeric: [RegExp('[0-9]+\. ')],
    _ListType.alphabetic: [RegExp('[a-zA-Z]{1}\. ')],
  };

  /// Return the line before the current one (related
  /// to the current baseOffset)
  String get _previousLine {
    int? _startIndex;
    int? _endIndex;

    _endIndex = value.text.substring(0, value.selection.baseOffset).reversed.indexOf('\n');
    for (int i = _endIndex - 1; i > 0; i--)
      if (value.text[i] == '\n') {
        _startIndex = i + 1;
        break;
      }
    if (_startIndex == null) _startIndex = 0;

    return value.text.substring(_startIndex, _endIndex);
  }

  /// Return not null if a list should start, the result
  /// if the [_ListType] related to the start character
  /// or the start character of the lines before
  ///
  /// If no [line] is provided, the [_currentLine] will
  /// be used
  _ListType? _isLineAList({String? line}) {
    final String _line = line ?? value.getCurrentLine();
    final String _trimmed = _line.trimLeft();

    for (_ListType t in _ListType.values)
      if (_kTriggerChars[t] != null && _kTriggerChars[t]!.any((t) => _trimmed.startsWith(t))) {
        return t;
      }

    return null;
  }

  ///  Return null if current line shouldn't
  /// be listed, the header otherwise
  String? get _getCurrentListHeader {
    if (_isLineAList() == null) return null;

    switch (_isLineAList()!) {
      case _ListType.unordered:
        return _kUnorderedListHeader;
      case _ListType.numeric:
        int? _previousNum;
        if (_previousLine.trimLeft().startsWith(RegExp('[0-9]*\. '))) {
          _previousNum = int.tryParse(_previousLine.substring(0, _previousLine.indexOf('.')).trim());
        }

        return _kNumericListHeader.replaceAll('N', '${(_previousNum ?? 0) + 1}');
      case _ListType.alphabetic:
        return _kAlphabeticHeader.replaceAll('A', _getNextChar());
    }
  }

  String _alphabetOrder = 'abcdefghijklmnopkrstuvwxyzABCDEFGHIJKLMNOPQRSTUVQXYZ';

  String _getNextChar() {
    String? _currentChar;
    if (_previousLine.trimLeft().startsWith(RegExp('[0-9]*. '))) {
      _currentChar = _previousLine.substring(0, _previousLine.indexOf('.')).trim();
    }
    if (_currentChar == null || _currentChar.isEmpty || !_currentChar.split('').every((c) => _alphabetOrder.contains(c))) {
      return 'a';
    }

    for (int i = _currentChar.length; i > 0; i--) {
      if (_currentChar![i] == 'Z') {
        _currentChar = _currentChar.replace(i, 'a');
        continue;
      }

      _currentChar = _currentChar.replace(i, _alphabetOrder[_alphabetOrder.indexOf(_currentChar[i]) + 1]);
      return _currentChar;
    }

    return 'a$_currentChar';
  }

  TextEditingValue _checkForList(TextEditingValue value) {
    if (_detectEnterPressed(value) && _isLineAList(line: value.getCurrentLine(-1)) != null) {
      value = _transformLineInListElement(value, _isLineAList(line: value.getCurrentLine(-1))!);
    }

    bool _alreadyFormatted() => value.getCurrentLine().startsWith(_kListHeaders[_isLineAList(line: value.getCurrentLine())!]!);

    if (_isLineAList(line: value.getCurrentLine()) == null) return value;
    if (_alreadyFormatted()) return value;

    value = _formatLineForList(value);
    return value;
  }

  /// Return the number of spaces added (if spaces should be removed
  /// return a negative number)
  TextEditingValue _formatLineForList(TextEditingValue value) {
    final String _header = _kListHeaders[_isLineAList(line: value.getCurrentLine())!]!;
    final String _currentLine = value.getCurrentLine();

    if (_currentLine.startsWith(_header)) {
      return value;
    }

    final _needingSpaces = (_header.length - _header.trimLeft().length) - (_currentLine.length - _currentLine.trimLeft().length);

    if (_needingSpaces >= 0)
      value = value.editCurrentLine('${' ' * _needingSpaces}${value.getCurrentLine()}');
    else
      value = value.editCurrentLine(value.getCurrentLine().substring(-_needingSpaces));

    return value;
  }

  /// Used to force the current line to be a element of a list,
  /// base offset of [value] is used to determine the current line
  TextEditingValue _transformLineInListElement(TextEditingValue value, _ListType listType) {
    final String _header = _kListHeaders[listType]!;
    final String _currentLine = value.getCurrentLine();

    if (_currentLine.startsWith(_header)) {
      return value;
    }
    return value.editCurrentLine('$_header');
  }
}
