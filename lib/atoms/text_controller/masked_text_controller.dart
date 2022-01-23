import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef BeforeChangeCallback = bool Function(String previous, String next);
typedef AfterChangeCallback = void Function(String previous, String next);

enum CursorBehaviour {
  unlocked,
  start,
  end,
}

/// A [TextEditingController] extended to provide custom masks to flutter
class MaskedTextController extends TextEditingController {
  MaskedTextController({
    required this.mask,
    this.beforeChange,
    this.afterChange,
    this.cursorBehavior = CursorBehaviour.unlocked,
    String? text,
    Map<String, RegExp>? translator,
  }) : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    // Initialize the beforeChange and afterChange callbacks if they are null
    beforeChange ??= (previous, next) => true;
    afterChange ??= (previous, next) {};

    addListener(_listener);
    _lastCursor = this.text.length;
    updateText(this.text);
  }

  /// The current applied mask
  String mask;

  /// Translator from mask characters to [RegExp]
  late Map<String, RegExp> translator;

  /// A function called before the text is updated.
  /// Returns a boolean informing whether the text should be updated.
  ///
  /// Defaults to a function returning true
  BeforeChangeCallback? beforeChange;

  /// A function called after the text is updated
  ///
  /// Defaults to an empty function
  AfterChangeCallback? afterChange;

  /// Configure if the cursor should be forced
  CursorBehaviour cursorBehavior;

  /// Indicates what was the last text inputted by the user with mask
  String _lastUpdatedText = '';

  /// Indicates where the last cursor position was
  int _lastCursor = 0;

  /// This flag indicates if the curosr update is pending after a [updateText]
  bool _cursorUpdatePending = false;

  /// Cursor calculated in [updateText] call
  int _cursorCalculatedPosition = 0;

  /// Save previous mask used to check for update
  String? _previousMask;

  /// Default [RegExp] for each character available for the mask
  ///
  /// 'A' represents a letter of the alphabet
  /// '0' represents a numeric character
  /// '@' represents a alphanumeric character
  /// '*' represents any character
  static Map<String, RegExp> getDefaultTranslator() => {'A': RegExp(r'[A-Za-z]'), '0': RegExp(r'[0-9]'), '@': RegExp(r'[A-Za-z0-9]'), '*': RegExp(r'.*')};

  /// Corresponding to [TextEditingController.text]
  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
    }
  }

  /// Lock to prevent multiple calls, since it needs some shared variables
  bool _lockProcess = false;

  /// Check for user updates in the TextField
  void _listener() {
    if (!_lockProcess) {
      try {
        _lockProcess = true;

        // only changing the text
        if (text != _lastUpdatedText) {
          final previous = _lastUpdatedText;
          if (beforeChange!(previous, text)) {
            updateText(text);
            afterChange!(previous, text);
          } else {
            updateText(_lastUpdatedText);
          }
        }

        // this is called in next iteration, after updateText is called
        if (_cursorUpdatePending && selection.baseOffset != _cursorCalculatedPosition) {
          _moveCursor(_cursorCalculatedPosition);
          _cursorUpdatePending = false;
        }

        if (cursorBehavior != CursorBehaviour.unlocked) {
          cursorBehavior == CursorBehaviour.start ? _moveCursor(0, true) : _moveCursor(_lastUpdatedText.length, true);
        }

        // only changing cursor position
        if (_lastCursor != selection.baseOffset && selection.baseOffset > -1) {
          _lastCursor = selection.baseOffset;
        }
      } finally {
        _lockProcess = false;
      }
    }
  }

  /// Replaces [mask] with a [newMask] and moves cursor to the end if
  /// [shouldMoveCursorToEnd] is true
  /// [shouldUpdateValue] Set to true to request a following update in the text.
  ///   If this method is being called in [beforeChange] this MUST be false,
  ///   since it will call [updateText] as next step automatically.
  void updateMask(
    String newMask, {
    bool shouldMoveCursorToEnd = true,
    bool shouldUpdateValue = false,
  }) {
    if (mask != newMask) {
      _previousMask = mask;
      mask = newMask;

      if (shouldUpdateValue) {
        updateText(text);
      }

      if (shouldMoveCursorToEnd) {
        moveCursorToEnd();
      }
    }
  }

  /// Updates the current [text] with a new one applying the [mask]
  void updateText(String newText) {
    // save values for possible concurrent updates
    final _oldMask = _previousMask ?? mask;
    final _mask = mask;
    final oldText = _lastUpdatedText;
    final previousCursor = _lastCursor;

    _lastUpdatedText = _applyMask(_mask, newText);
    final newCursor = _calculateCursorPosition(
      previousCursor,
      _oldMask,
      _mask,
      oldText,
      _lastUpdatedText,
    );

    _previousMask = mask;
    text = _lastUpdatedText;

    // Mark to update in next listner iteration
    _cursorUpdatePending = true;
    _cursorCalculatedPosition = newCursor;
    _moveCursor(_cursorCalculatedPosition);
  }

  /// Moves cursor to the end of the text
  void moveCursorToEnd() => _moveCursor(_lastUpdatedText.length, true);

  /// Retrieve current value without mask
  String get unmasked => _removeMask(mask, text);

  /// Unmask the [text] given a [mask]
  String unmask(String mask, String text) => _removeMask(mask, text);

  /// Moves cursor to specific position
  void _moveCursor(int index, [bool force = false]) {
    // only moves the cursor if it is not defined or text is not selected
    if (force || selection.baseOffset == selection.extentOffset) {
      final value = min(max(index, 0), text.length);
      selection = TextSelection.collapsed(offset: value);
      _lastCursor = value;
    }
  }

  /// Applies the [mask] to the [value]
  String _applyMask(String mask, String value) {
    final result = StringBuffer('');
    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (maskCharIndex != mask.length && valueCharIndex != value.length) {
      final maskChar = mask[maskCharIndex];
      final valueChar = value[valueCharIndex];

      // value equals mask, just write value to the buffer
      if (maskChar == valueChar) {
        result.write(maskChar);
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match with the current mask character
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result.write(valueChar);
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }
      // not a masked value, fixed char on mask
      result.write(maskChar);
      maskCharIndex += 1;
    }
    return result.toString();
  }

  /// Removes the [mask] from the [value]
  String _removeMask(String mask, String value) {
    final result = StringBuffer('');
    var charIndex = 0;

    while (charIndex < mask.length && charIndex < value.length) {
      final maskChar = mask[charIndex];
      final valueChar = value[charIndex];

      // apply translator if match with the current mask character
      if (translator.containsKey(maskChar) && translator[maskChar]!.hasMatch(valueChar)) {
        result.write(valueChar);
      }

      charIndex += 1;
    }

    return result.toString();
  }

  /// Calculates next cursor position from given text alteration
  int _calculateCursorPosition(
    int oldCursor,
    String oldMask,
    String newMask,
    String oldText,
    String newText,
  ) {
    // it is better to remove mask since user can use inputFormatters
    // generating unknown alteration before listener is called
    final oldUnmask = _removeMask(oldMask, oldText);
    final newUnmask = _removeMask(newMask, newText);

    // find cursor when old text is unmask
    var oldUnmaskCursor = oldCursor;

    // NOTE: This is a bugfix for iOS platform.
    // When deleting one character, the listener method will trigger a cursor
    // update before triggering the text update, to compensate that, this
    // condition return the cursor for the previous location before calculation.
    if (!kIsWeb && Platform.isIOS && newUnmask.length == oldUnmask.length - 1) {
      oldUnmaskCursor++;
    }

    for (var k = 0; k < oldCursor && k < oldMask.length; k++) {
      if (!translator.containsKey(oldMask[k])) {
        oldUnmaskCursor--;
      }
    }

    // count how many new characters was added
    var unmaskNewChars = newUnmask.length - oldUnmask.length;
    if (unmaskNewChars == 0 && oldMask == newMask && oldText != newText && oldText.length == newText.length && oldCursor < oldMask.length) {
      // the next character was update, move cursor
      unmaskNewChars++;
    }

    // find new cursor position based on new mask
    var countDown = oldUnmaskCursor + unmaskNewChars;
    var maskCount = 0;
    for (var i = 0; i < newText.length && i < newMask.length && countDown > 0; i++) {
      if (!translator.containsKey(newMask[i])) {
        maskCount++;
      } else {
        countDown--;
      }
    }

    return oldUnmaskCursor + maskCount + unmaskNewChars;
  }
}

/// A [TextEditingController] extended to apply masks to currency values
class MoneyMaskedTextController extends TextEditingController {
  MoneyMaskedTextController({
    double? initialValue,
    this.decimalSeparator = ',',
    this.thousandSeparator = '.',
    this.rightSymbol = '',
    this.leftSymbol = '',
    this.precision = 2,
  }) {
    _validateConfig();
    _shouldApplyTheMask = true;

    addListener(() {
      if (_shouldApplyTheMask) {
        var parts = _getOnlyNumbers(text).split('').toList(growable: true);

        if (parts.isNotEmpty) {
          // Ensures that the list of parts contains the minimum amount of
          // characters to fit the precision
          if (parts.length < precision + 1) {
            parts = [...List.filled(precision, '0'), ...parts];
          }

          parts.insert(parts.length - precision, '.');
          updateValue(double.parse(parts.join()));
        }
      }
    });

    updateValue(initialValue);
  }

  /// Character used as decimal separator
  ///
  /// Defaults to ',' and must not be null.
  final String decimalSeparator;

  /// Character used as thousand separator
  ///
  /// Defaults to '.' and must not be null.
  final String thousandSeparator;

  /// Character used as right symbol
  ///
  /// Defaults to empty string. Must not be null.
  final String rightSymbol;

  /// Character used as left symbol
  ///
  /// Defaults to empty string. Must not be null.
  final String leftSymbol;

  /// Numeric precision to fraction digits
  ///
  /// Defaults to 2
  final int precision;

  /// The last valid numeric value
  double? _lastValue;

  /// Used to ensure that the listener will not try to update the mask when
  /// updating the text internally, thus reducing the number of operations when
  /// applying a mask (works as a mutex)
  late bool _shouldApplyTheMask;

  /// The numeric value of the text
  double get numberValue {
    final parts = _getOnlyNumbers(text).split('').toList(growable: true);

    if (parts.isEmpty) {
      return 0;
    }

    parts.insert(parts.length - precision, '.');
    return double.parse(parts.join());
  }

  static const int _maxNumLength = 12;

  /// Updates the value and applies the mask
  void updateValue(double? value) {
    if (value == null) {
      return;
    }

    double? valueToUse = value;

    if (value.toStringAsFixed(0).length > _maxNumLength) {
      valueToUse = _lastValue;
    } else {
      _lastValue = value;
    }

    final masked = _applyMask(valueToUse!);

    _updateText(masked);
  }

  /// Updates the [TextEditingController] and ensures that the listener will
  /// not trigger the mask update
  void _updateText(String newText) {
    if (text != newText) {
      _shouldApplyTheMask = false;

      final newSelection = _getNewSelection(newText);

      value = TextEditingValue(
        selection: newSelection,
        text: newText,
      );

      _shouldApplyTheMask = true;
    }
  }

  /// Returns the updated selection with the new cursor position
  TextSelection _getNewSelection(String newText) {
    // If baseOffset differs from extentOffset, user is selecting the text,
    // then we keep the current selection
    if (selection.baseOffset != selection.extentOffset) {
      return selection;
    }

    // When cursor is at the beginning, we set the cursor right after the first
    // character after the left symbol
    if (selection.baseOffset == 0) {
      return TextSelection.fromPosition(
        TextPosition(offset: leftSymbol.length + 1),
      );
    }

    // Cursor is not at the end of the text, so we need to calculate the updated
    // position taking into the new masked text and the current position for the
    // unmasked text
    if (selection.baseOffset != text.length) {
      try {
        // We take the number of leading zeros taking into account the behavior
        // when the text has only 4 characters
        var numberOfLeadingZeros = text.length - int.parse(text).toString().length;
        if (numberOfLeadingZeros == 2 && text.length == 4) {
          numberOfLeadingZeros = 1;
        }

        // Then we get the substring containing the characters to be skipped so
        // that we can position the cursor properly
        final skippedString = text.substring(numberOfLeadingZeros, selection.baseOffset);

        // Positions the cursor right after going through all the characters
        // that are in the skippedString
        var cursorPosition = leftSymbol.length + 1;
        if (skippedString != '') {
          for (var i = leftSymbol.length, j = 0; i < newText.length; i++) {
            if (newText[i] == skippedString[j]) {
              j++;
              cursorPosition = i + 1;
            }

            if (j == skippedString.length) {
              cursorPosition = i + 1;
              break;
            }
          }
        }

        return TextSelection.fromPosition(
          TextPosition(offset: cursorPosition),
        );
      } catch (_) {
        // If update fails, we set the cursor at end of the text
        return TextSelection.fromPosition(
          TextPosition(offset: newText.length - rightSymbol.length),
        );
      }
    }

    // Cursor is at end of the text
    return TextSelection.fromPosition(
      TextPosition(offset: newText.length - rightSymbol.length),
    );
  }

  /// Ensures [rightSymbol] does not contains numbers
  void _validateConfig() {
    if (_getOnlyNumbers(rightSymbol).isNotEmpty) {
      throw ArgumentError('rightSymbol must not have numbers.');
    }
  }

  String _getOnlyNumbers(String text) => text.replaceAll(RegExp(r'[^\d]'), '');

  /// Returns a masked String applying the mask to the value
  String _applyMask(double value) {
    final textRepresentation = value.toStringAsFixed(precision).replaceAll('.', '').split('').reversed.toList(growable: true);

    textRepresentation.insert(precision, decimalSeparator);

    for (var i = precision + 4; textRepresentation.length > i; i += 4) {
      if (textRepresentation.length > i) {
        textRepresentation.insert(i, thousandSeparator);
      }
    }

    var masked = textRepresentation.reversed.join('');

    if (rightSymbol.isNotEmpty) {
      masked += rightSymbol;
    }

    if (leftSymbol.isNotEmpty) {
      masked = leftSymbol + masked;
    }

    return masked;
  }
}
