import 'package:flutter/material.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapTextTag {
  final String content;
  final bool selected;
  ZwapTextTag({
    required this.content,
    required this.selected,
  });
}

final kZwapTextTagString = '_';

class TagsTextController extends TextEditingController {
  /// key: position on first character of the tag
  /// value: lenght of the tag content
  Map<int, ZwapTextTag> tags = {
    3: ZwapTextTag(content: "Content 1", selected: false),
  };

  TagsTextController({String? text}) : super(text: 'pr _ ciaociao');

  @override
  set value(TextEditingValue newValue) {
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

    for (int index = 0; index < text.length; index++) {
      if (tags.containsKey(index)) {
        _spans.add(
          WidgetSpan(
            child: _TagWidget(content: tags[index]!.content),
          ),
        );
        continue;
      }

      final int _nextKey = tags.keys.firstWhere((i) => i >= index, orElse: () => -1);
      if (_nextKey == -1) {
        _spans.add(TextSpan(text: text.substring(index)));
        break;
      }

      _spans.add(TextSpan(text: text.substring(index, _nextKey)));
      index = _nextKey - 1;
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: ZwapColors.neutral300,
      child: Text(content),
    );
  }
}
