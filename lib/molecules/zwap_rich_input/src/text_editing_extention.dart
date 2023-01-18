part of zwap.rich_input;

extension _TextEditingExt on TextEditingValue {
  /// Related only to the based offset
  ///
  // FEATURE: add _currentParagraph that return the current
  // paragraph, ie the line from the baseOffset to the line of the
  // extentOffset
  String get currentLine {
    if (text.isEmpty || selection.baseOffset <= 0) return '';

    int? _startIndex;
    int? _endIndex;

    _endIndex = text.indexOf('\n', selection.baseOffset);
    if (_endIndex == -1) _endIndex = text.length;

    for (int i = _endIndex - 1; i > 0; i--)
      if (text[i] == '\n') {
        _startIndex = i + 1;
        break;
      }
    if (_startIndex == null) _startIndex = 0;

    return text.substring(_startIndex, _endIndex);
  }

  /// Return the line #current + [offset], offset is default to 0
  ///
  /// Return an empty string if there is no line #current + [offset]
  ///
  // FEATURE: add _currentParagraph that return the current
  // paragraph, ie the line from the baseOffset to the line of the
  // extentOffset
  String getCurrentLine([int offset = 0]) {
    if (text.isEmpty || selection.baseOffset <= 0) return '';

    int? _startIndex;
    int? _endIndex;

    _endIndex = text.indexOf('\n', selection.baseOffset);
    if (_endIndex == -1) _endIndex = text.length;

    for (int i = offset < 0 ? _endIndex - 1 : selection.baseOffset; i > 0 && i < text.length; offset < 0 ? i++ : i--)
      if (text[i] == '\n') {
        if (offset == 0) {
          _startIndex = i + 1;
          break;
        }
        if (offset < 0)
          offset++;
        else
          offset--;
      }

    if (offset != 0) return '';

    if (_startIndex == null) _startIndex = 0;
    _endIndex = text.indexOf('\n', _startIndex);
    if (_endIndex == -1) _endIndex = text.length;

    return text.substring(_startIndex, _endIndex);
  }

  /// Related only to the based offset
  ///
  /// FEATURE: add _currentParagraph that edit the current
  /// paragraph, ie the line from the baseOffset to the line of the
  /// extentOffset
  TextEditingValue editCurrentLine(String newLine) {
    if (text.isEmpty || selection.baseOffset <= 0) {
      return copyWith(
        text: newLine,
        selection: TextSelection.collapsed(offset: newLine.length),
      );
    }

    int? _startIndex;
    int? _endIndex;

    _endIndex = text.indexOf('\n', selection.baseOffset);

    if (_endIndex == -1) {
      _endIndex = text.length;
    }

    for (int i = _endIndex - 1; i > 0; i--)
      if (text[i] == '\n') {
        _startIndex = i + 1;
        break;
      }

    if (_startIndex == null) _startIndex = 0;
    final int _offset = newLine.length - getCurrentLine().length;

    return copyWith(
      text: text.replaceRange(_startIndex, _endIndex, newLine),
      selection: TextSelection(
        baseOffset: selection.baseOffset + _offset,
        extentOffset: selection.extentOffset + _offset,
      ),
    );
  }
}
