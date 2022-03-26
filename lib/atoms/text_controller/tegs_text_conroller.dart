import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

final List<String> dictionary = [
  'ciao',
  'bello',
  'sette',
];

class TagsTextController extends TextEditingController {
  /// key: position on first character of the tag
  /// value: lenght of the tag content
  Map<int, String> tags = {};

  TagsTextController({String? text}) : super();

  Map<int, String> _buildTags() {
    Map<int, String> _tmp = {};

    for (int i = 0; i < text.length; i++) {
      for (int j = 0; j < dictionary.length; j++)
        if (text.indexOf(dictionary[j], i) == i) {
          _tmp[i] = dictionary[j];
          i += dictionary[j].length;
        }
    }

    return _tmp;
  }

  /* /// Check if current selection is inside a tag
  ///
  /// If true, return the most far index of valid text from current offset
  ///
  /// ! Call only where selection is collapsed
  int? _isInsideSelection() {
    if (!selection.isCollapsed) return null;

    /// Looks for a tag that contains current offset, return -1 if not found
    int initialtagPosition = tags.keys.firstWhere((i) => i <= selection.baseOffset && (i + tags[i]!) >= selection.baseOffset, orElse: () => -1);
    if (initialtagPosition == -1) return null;

    return selection.baseOffset - initialtagPosition < 1 ? initialtagPosition + tags[initialtagPosition]! : initialtagPosition;
  } */

  @override
  set value(TextEditingValue newValue) {
    Map<int, String> _tmp = _buildTags();

    if (_tmp.isNotEmpty) {
      int removed = 0;

      for (int index in _tmp.keys) {
        newValue = newValue.copyWith(
            text: '${newValue.text.substring(0, index - removed)}${newValue.text.substring(index + _tmp[index]!.length - removed)}');
        removed += _tmp[index]!.length;
      }

      tags = {...tags, ..._tmp};
    }

    /* int? _tmp;

    if (selection.isCollapsed && (_tmp = _isInsideSelection()) != null)
      newValue = newValue.copyWith(selection: TextSelection.collapsed(offset: _tmp!)); */

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<InlineSpan> _spans = [];

    if (tags.isEmpty)
      _spans = [TextSpan(text: text)];
    else
      _spans = _buildTaggedSpans();

    return TextSpan(style: style, children: _spans);
  }

  List<InlineSpan> _buildTaggedSpans() {
    List<InlineSpan> _spans = [];

    if (tags.isNotEmpty) {
      print(234234);
    }

    for (int index = 0; index < text.length; index++) {
      if (tags.containsKey(index)) {
        _spans.add(WidgetSpan(child: _TagWidget(content: tags[index]!)));
        index++;
        continue;
      }

      final int _nextKey = tags.keys.firstWhere((i) => i >= index, orElse: () => -1);
      if (_nextKey == -1) {
        _spans.add(TextSpan(text: text.substring(index)));
        break;
      }

      _spans.add(TextSpan(text: text.substring(index, _nextKey)));
      index = _nextKey;
    }

    return _spans;
  }
}

class _TagWidget extends StatelessWidget {
  final String content;

  const _TagWidget({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      color: ZwapColors.neutral300,
      child: Text(content),
    );
  }
}
