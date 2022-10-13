import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

int _decadeOfYear(int year) => year - (year % 10);

class _ZwapYearPickerProvider extends ChangeNotifier {
  int _minYear;
  int _maxYear;

  int _firstYearSelectedPage;
  int? _selected;

  int get minYear => _minYear;
  int get maxYear => _maxYear;
  int get firstYearSelectedPage => _firstYearSelectedPage;
  int? get selected => _selected;

  set minYear(int value) => value != _minYear ? {_minYear = value, notifyListeners()} : null;
  set maxYear(int value) => value != _maxYear ? {_maxYear = value, notifyListeners()} : null;
  set firstYearSelectedPage(int value) => value != _firstYearSelectedPage ? {_firstYearSelectedPage = value, notifyListeners()} : null;
  set selected(int? value) {
    if (value != _selected) {
      _selected = value;
      if (value != null && _decadeOfYear(value) != _firstYearSelectedPage) _firstYearSelectedPage = _decadeOfYear(value);
      notifyListeners();
    }
  }

  _ZwapYearPickerProvider({
    required int minYear,
    required int maxYear,
    required int firstYearSelectedPage,
    required int? selected,
  })  : this._minYear = minYear,
        this._maxYear = maxYear,
        this._firstYearSelectedPage = firstYearSelectedPage,
        this._selected = selected;

  void nextPage() => firstYearSelectedPage += 10;
  void previousPage() => firstYearSelectedPage -= 10;
}

/// The provider state to handle this component
class ZwapYearPicker extends StatefulWidget {
  /// The placeholder text inside this input widget
  final String hintText;

  /// The text editing controller
  final TextEditingController? inputController;

  /// The title text for this input date picker widget
  final String? label;

  final int? selectedYear;

  final int? minYear;

  final int? maxYear;

  final Function(int year)? onYearSelected;

  final String? invalidInputMessage;

  final BorderRadius borderRadius;

  ZwapYearPicker({
    Key? key,
    required this.hintText,
    this.inputController,
    this.onYearSelected,
    this.label,
    this.maxYear,
    this.minYear,
    this.selectedYear,
    this.invalidInputMessage,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  })  : assert((maxYear ?? DateTime.now().year + 30) > (minYear ?? 1900)),
        super(key: key);

  _ZwapYearPickerState createState() => _ZwapYearPickerState();
}

/// Component to handle the input date picker
class _ZwapYearPickerState extends State<ZwapYearPicker> {
  final GlobalKey _yearInputKey = GlobalKey();

  /// The focus node for the input field
  late final FocusNode _inputFocus;

  late final TextEditingController _inputController;

  /// The overlay on the input field
  OverlayEntry? _pickerOverlay;

  bool get _isOverlayOpened => _pickerOverlay?.mounted ?? false;
  int get _minYear => widget.minYear ?? 1900;
  int get _maxYear => widget.maxYear ?? DateTime.now().year + 30;

  late bool _isHovered;

  late final _ZwapYearPickerProvider _yearPickerProvider;

  Timer? _stoppedWritingTimer;
  String? _error;

  @override
  void initState() {
    _isHovered = false;
    _inputController = widget.inputController ?? TextEditingController(text: '${widget.selectedYear ?? ""}');
    _inputFocus = FocusNode(onKeyEvent: (node, event) {
      if (_isOverlayOpened) _toggleOverlay();
      return KeyEventResult.ignored;
    });

    _inputController.addListener(_controllerListener);
    _inputFocus.addListener(_focusNodeListener);

    final int _tmpYear = (widget.minYear ?? 1900) + ((widget.maxYear ?? (DateTime.now().year + 30) - (widget.minYear ?? 1900)) ~/ 2);

    _yearPickerProvider = _ZwapYearPickerProvider(
      minYear: widget.minYear ?? 1900,
      maxYear: widget.maxYear ?? DateTime.now().year + 30,
      firstYearSelectedPage: _decadeOfYear(widget.selectedYear ?? _tmpYear),
      selected: widget.selectedYear,
    );

    super.initState();
  }

  void _controllerListener() {
    if (_stoppedWritingTimer?.isActive ?? false) _stoppedWritingTimer?.cancel();
    if (_error != null) setState(() => _error = null);

    if (_inputController.text.trim().isEmpty) return;

    _stoppedWritingTimer = Timer(const Duration(milliseconds: 800), () => _checkManualInput());
  }

  void _focusNodeListener() {
    if (!kIsWeb) {
      if (_inputFocus.hasFocus) _inputFocus.unfocus();
      return;
    }

    if (_inputFocus.hasFocus && !_isOverlayOpened) _toggleOverlay();
    if (!_inputFocus.hasFocus && _isOverlayOpened) _toggleOverlay();

    if (!_inputFocus.hasFocus &&
        (_yearPickerProvider.selected == null || int.tryParse(_inputController.text) != _yearPickerProvider.selected) &&
        _inputController.text.isNotEmpty) _inputController.text = '${_yearPickerProvider.selected ?? ''}';
  }

  void _toggleOverlay() {
    if (_pickerOverlay?.mounted ?? false) {
      try {
        _pickerOverlay!.remove();
      } catch (e) {}
      _pickerOverlay = null;
    } else {
      Overlay.of(context)?.insert(_pickerOverlay = _createOverlay());
      if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant ZwapYearPicker oldWidget) {
    if (widget.selectedYear != oldWidget.selectedYear) _yearPickerProvider.selected = widget.selectedYear;
    if (widget.minYear != oldWidget.minYear) _yearPickerProvider.minYear = _minYear;
    if (widget.maxYear != oldWidget.maxYear) _yearPickerProvider.maxYear = _maxYear;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _inputFocus.removeListener(_focusNodeListener);
    _inputController.removeListener(_controllerListener);

    super.dispose();
  }

  void _checkManualInput() {
    int? _tmpYear = int.tryParse(_inputController.text);

    if (_tmpYear == null || _tmpYear < _minYear || _tmpYear > _maxYear) {
      setState(() => _error = widget.invalidInputMessage);
      return;
    }
    if (_tmpYear != _yearPickerProvider.selected) _yearSelected(_tmpYear);
  }

  void _yearSelected(int year) {
    _yearPickerProvider.selected = year;
    _inputController.text = '$year';
    _inputController.selection = TextSelection.collapsed(offset: '$year'.length);
    if (widget.onYearSelected != null) widget.onYearSelected!(year);
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(builder: (context) {
      final Rect? _inputSize = _yearInputKey.globalPaintBounds;
      final _width = min(285, MediaQuery.of(context).size.width * 0.8);

      double _dx = (_yearInputKey.globalOffset?.dx ?? 0);
      double _dy = (_yearInputKey.globalOffset?.dy ?? 0);

      if ((_inputSize?.width ?? 0) > _width) _dx += (_inputSize!.width - _width) / 2;
      if (_dy + 265 + 70 > MediaQuery.of(context).size.height) _dy = max(MediaQuery.of(context).size.height - 320, 0);

      return ZwapOverlayEntryWidget(
        entity: _pickerOverlay,
        onAutoClose: () => _inputFocus.hasFocus ? _inputFocus.unfocus() : null,
        child: ZwapOverlayEntryChild(
          top: _dy,
          left: _dx,
          child: ChangeNotifierProvider.value(
            value: _yearPickerProvider,
            child: _ZwapYearPickerOverlayContent(
              onYearSelected: (y) {
                _yearSelected(y);
                if (_isOverlayOpened) _toggleOverlay();
              },
            ),
          ),
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _yearPickerProvider,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              ZwapText(
                text: widget.label!,
                zwapTextType: ZwapTextType.bodySemiBold,
                textColor: ZwapColors.neutral600,
              ),
              SizedBox(height: 5),
            ],
            InkWell(
              onHover: (bool value) => setState(() => _isHovered = value),
              onTap: () {
                if (!_inputFocus.hasFocus) _inputFocus.requestFocus();

                if (_inputFocus.hasFocus && !_isOverlayOpened) _toggleOverlay();
              },
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                key: _yearInputKey,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: this._isHovered ? ZwapColors.primary300 : ZwapColors.neutral300),
                  borderRadius: widget.borderRadius,
                ),
                padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        focusNode: _inputFocus,
                        decoration: InputDecoration.collapsed(hintText: widget.hintText),
                        cursorColor: ZwapColors.shades100,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onTap: () {
                          if (!_inputFocus.hasFocus) _inputFocus.requestFocus();

                          if (_inputFocus.hasFocus && !_isOverlayOpened) _toggleOverlay();
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    AnimatedRotation(
                      turns: _isOverlayOpened ? 0 : 0.5,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(_isOverlayOpened)),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _error != null
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5),
                      child: ZwapText(
                        text: _error!,
                        zwapTextType: ZwapTextType.bodySemiBold,
                        textColor: ZwapColors.error700,
                      ),
                    )
                  : Container(width: double.infinity),
            ),
          ],
        );
      },
    );
  }
}

class _ZwapYearPickerOverlayContent extends StatefulWidget {
  final Function(int year) onYearSelected;

  const _ZwapYearPickerOverlayContent({required this.onYearSelected, Key? key}) : super(key: key);

  @override
  State<_ZwapYearPickerOverlayContent> createState() => _ZwapYearPickerOverlayContentState();
}

class _ZwapYearPickerOverlayContentState extends State<_ZwapYearPickerOverlayContent> {
  int? _hoverlayedYear;

  @override
  Widget build(BuildContext context) {
    final double _width = min(285, MediaQuery.of(context).size.width * 0.8);

    final int _firstYear = context.select<_ZwapYearPickerProvider, int>((pro) => pro.firstYearSelectedPage);
    final int? _selectedYear = context.select<_ZwapYearPickerProvider, int?>((pro) => pro.selected);

    final int _maxYear = context.select<_ZwapYearPickerProvider, int>((pro) => pro.maxYear);
    final int _minYear = context.select<_ZwapYearPickerProvider, int>((pro) => pro.minYear);

    Widget _getYearWidget(int year, {bool foggy = false, Function()? onTap}) {
      final bool enabled = year >= _minYear && year <= _maxYear;

      return InkWell(
        onTap: enabled ? onTap : null,
        onHover: enabled ? (hover) => setState(() => _hoverlayedYear = hover ? year : null) : null,
        mouseCursor: enabled ? null : SystemMouseCursors.forbidden,
        child: Container(
          width: (_width - 60) / 3,
          height: 37,
          decoration: BoxDecoration(
            color: _selectedYear == year
                ? _hoverlayedYear == year && enabled
                    ? ZwapColors.primary50
                    : ZwapColors.primary100
                : _hoverlayedYear == year && enabled
                    ? ZwapColors.neutral100
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: _selectedYear == year
                ? _hoverlayedYear == year && enabled
                    ? Border.all(color: ZwapColors.primary200)
                    : Border.all(color: ZwapColors.primary100)
                : _hoverlayedYear == year && enabled
                    ? Border.all(color: ZwapColors.neutral300)
                    : null,
          ),
          child: Center(
            child: ZwapText(
              text: '$year',
              zwapTextType: year == _selectedYear ? ZwapTextType.bodySemiBold : ZwapTextType.bodyRegular,
              textColor: foggy
                  ? ZwapColors.neutral400
                  : enabled
                      ? year == _selectedYear
                          ? ZwapColors.primary700
                          : ZwapColors.shades100
                      : ZwapColors.neutral400,
            ),
          ),
        ),
      );
    }

    List<Widget> _getCalendar() {
      Widget _getCalendarRow(int firstYear, {bool isFirst = false, bool isLast = false}) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getYearWidget(
              firstYear,
              foggy: isFirst,
              onTap: () {
                if (isFirst) context.read<_ZwapYearPickerProvider>().previousPage();
                widget.onYearSelected(firstYear);
              },
            ),
            _getYearWidget(
              firstYear + 1,
              onTap: () => widget.onYearSelected(firstYear + 1),
            ),
            _getYearWidget(
              firstYear + 2,
              foggy: isLast,
              onTap: () {
                if (isLast) context.read<_ZwapYearPickerProvider>().nextPage();
                widget.onYearSelected(firstYear + 2);
              },
            ),
          ],
        );
      }

      return [
        _getCalendarRow(_firstYear - 1, isFirst: true),
        _getCalendarRow(_firstYear + 2),
        _getCalendarRow(_firstYear + 5),
        _getCalendarRow(_firstYear + 8, isLast: true),
      ];
    }

    return Material(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.decelerate,
        tween: Tween(begin: 0, end: 1),
        builder: (context, animation, child) => Opacity(
          opacity: animation,
          child: Container(
            width: _width,
            height: 265,
            decoration: BoxDecoration(
              color: ZwapColors.shades0,
              boxShadow: [ZwapShadow.levelOne],
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => context.read<_ZwapYearPickerProvider>().previousPage(),
                      hoverColor: ZwapColors.neutral200,
                      splashColor: ZwapColors.neutral300,
                      child:
                          Container(width: 40, height: 40, child: Icon(Icons.chevron_left, color: ZwapColors.neutral800), color: Colors.transparent),
                    ),
                    ZwapText(
                      text: '$_firstYear-${_firstYear + 9}',
                      zwapTextType: ZwapTextType.bodyRegular,
                      textColor: ZwapColors.shades100,
                    ),
                    InkWell(
                      onTap: () => context.read<_ZwapYearPickerProvider>().nextPage(),
                      hoverColor: ZwapColors.neutral200,
                      splashColor: ZwapColors.neutral300,
                      child:
                          Container(width: 40, height: 40, child: Icon(Icons.chevron_right, color: ZwapColors.neutral800), color: Colors.transparent),
                    ),
                  ],
                ),
                ..._getCalendar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
