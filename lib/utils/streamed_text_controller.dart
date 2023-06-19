import 'package:flutter/material.dart';

/// A normal [TextEditingController] with:
/// * an initial state where the content is being generated by a stream
/// * a *done* state when the controller is a normal [TextEditingController]
class StreamedTextController<T> extends TextEditingController {
  bool _isLoading;

  StreamedTextController()
      : _isLoading = true,
        super();

  void updateLoadingData(String text) {
    if (!_isLoading) return;
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(affinity: TextAffinity.downstream, offset: text.length),
      composing: TextRange.collapsed(-1),
    );
  }

  void loadingDone() {
    _isLoading = false;
  }

  @override
  set value(TextEditingValue newValue) {
    if (_isLoading) return;
    super.value = newValue;
  }
}
