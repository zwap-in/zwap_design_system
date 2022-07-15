import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_overlay_widget.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_provider.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

class ZwapHintInput extends StatefulWidget {
  /// List of keys of selected items
  final List<String> selectedItems;

  /// Keys are used for callbacks and comparison of items
  ///
  /// Values are used for suggestions (hint) while user
  /// is typing
  final Map<String, String> items;

  /// Used to build a widget for all selected items
  ///
  /// Called each time widget is rebuilded
  final Widget Function(String) buildSelectedItem;

  /// [TextStyle] of test typed by the user
  final TextStyle? textStyle;

  /// [TextStyle] of placeholder
  final TextStyle? placeholderTextStyle;

  /// Displayed when input is empty
  final String placeholder;

  final double minHeight;
  final double width;

  /// Notify that an item has been selected by the dropdown
  final Function(String)? onItemSelected;

  /// Is true all items already selected will not displayed
  /// in the hint overlay
  ///
  /// Default to true
  final bool doNotSuggestAlreadySelected;

  /// If not null and [selectedItems]'s length is not less
  /// than [minItems] the border color of the input will painted with
  /// [ZwapColors.success400] is not selected or hovered
  final int? minItems;

  const ZwapHintInput({
    required this.buildSelectedItem,
    required this.items,
    required this.selectedItems,
    this.textStyle,
    this.minHeight = 100,
    this.width = double.infinity,
    this.placeholder = '',
    this.placeholderTextStyle,
    this.onItemSelected,
    this.doNotSuggestAlreadySelected = true,
    this.minItems,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapHintInput> createState() => _ZwapHintInputState();
}

class _ZwapHintInputState extends State<ZwapHintInput> {
  final TextEditingController _controller = TextEditingController();
  late final ZwapHintProvider _provider;

  OverlayEntry? _entry;

  bool _hovered = false;
  bool _focussed = false;

  Color get _defaultBorderColor =>
      widget.minItems != null && _provider.selectedItems.length >= widget.minItems! ? ZwapColors.success400 : ZwapColors.neutral300;

  @override
  void initState() {
    super.initState();
    _provider = ZwapHintProvider(
      widget.items,
      widget.selectedItems,
      widget.onItemSelected,
      doNotSuggestAlreadySelected: widget.doNotSuggestAlreadySelected,
    );

    _provider.focusNode.addListener(_focusListener);
  }

  void _focusListener() {
    if (_focussed != _provider.focusNode.hasFocus) setState(() => _focussed = _provider.focusNode.hasFocus);
    _checkOverlay();
  }

  void _checkOverlay() {
    if (!_focussed && _entry != null) {
      _entry!.remove();
      _entry = null;
    }

    if (_focussed && _entry == null) {
      Overlay.of(context)?.insert(
        _entry = OverlayEntry(
          builder: (_) => ChangeNotifierProvider.value(
            value: _provider,
            child: ZwapHintOverlayWidget(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _provider.focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ZwapHintInput oldWidget) {
    if (!mapEquals(_provider.items, widget.items)) setState(() => _provider.items = Map.from(widget.items));
    if (!listEquals(_provider.selectedItems, widget.selectedItems)) setState(() => _provider.selectedItems = List.from(widget.selectedItems));

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ZwapHintProvider>.value(
      value: _provider,
      child: Builder(builder: (context) {
        final List<String> _selectedItems = context.select<ZwapHintProvider, List<String>>((pro) => pro.selectedItems);

        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onHover: (hovered) => setState(() => _hovered = hovered),
          onTap: () {
            if (!_provider.focusNode.hasFocus) _provider.focusNode.requestFocus();
          },
          child: AnimatedContainer(
            width: widget.width,
            constraints: BoxConstraints(minHeight: widget.minHeight),
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _hovered || _focussed ? ZwapColors.primary400 : _defaultBorderColor),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 4),
                child: Text.rich(
                  TextSpan(
                    children: [
                      ..._selectedItems
                          .map((e) => WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12, bottom: 12),
                                child: widget.buildSelectedItem(e),
                              )))
                          .toList(),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _InputSpan(
                          inputStyle: widget.textStyle ?? TextStyle(),
                          controller: _controller,
                          placeholder: _selectedItems.isNotEmpty ? '' : widget.placeholder,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _InputSpan extends StatefulWidget {
  final TextEditingController controller;

  final TextStyle inputStyle;
  final String placeholder;

  const _InputSpan({
    required this.controller,
    required this.inputStyle,
    this.placeholder = '',
    Key? key,
  }) : super(key: key);

  @override
  State<_InputSpan> createState() => __InputSpanState();
}

class __InputSpanState extends State<_InputSpan> {
  final GlobalKey _inputKey = GlobalKey();
  late double _width;

  String get _currentText => widget.controller.text.isEmpty ? widget.placeholder : widget.controller.text;

  double get _textWidth {
    final double _minWidth = textWidth(widget.placeholder, widget.inputStyle);
    final double _width = textWidth(_currentText, widget.inputStyle);
    return max(_minWidth, _width) + 40;
  } //(widget.inputStyle.fontSize ?? 20) / (widget.controller.text.length < 10 ? 1.7 : 2.3);

  @override
  void initState() {
    super.initState();

    _width = max(30, _textWidth);
    widget.controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() => _width = max(30, _textWidth));
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => context.read<ZwapHintProvider>().currentSearchFieldRect = _inputKey.globalPaintBounds ?? Rect.zero);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _currentSearchValue = context.select<ZwapHintProvider, String>((pro) => pro.currentSearchValue);
    if (_currentSearchValue != widget.controller.text)
      WidgetsBinding.instance?.addPostFrameCallback((_) => widget.controller.text = _currentSearchValue);

    return AnimatedContainer(
      key: _inputKey,
      duration: const Duration(milliseconds: 7),
      width: _width,
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: widget.controller,
        focusNode: context.select<ZwapHintProvider, FocusNode>((pro) => pro.focusNode),
        style: widget.inputStyle,
        onChanged: (value) => context.read<ZwapHintProvider>().currentSearchValue = value,
        decoration: InputDecoration.collapsed(hintText: widget.placeholder),
      ),
    );
  }
}
