import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/radio/zwap_radio_widget.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/decorations/zwap_input_decorations.dart';

class _RadioOverlayPickerProvider<T extends Enum> extends ChangeNotifier {
  List<T> _availableValues;
  T? _selectedValue;

  /// Used to check if close the overlay when focus dismissed
  bool isOverlayHovered = false;

  Function(T) onSelectedValue;

  List<T> get availableValues => _availableValues;
  T? get selectedValue => _selectedValue;

  set selectedValue(T? value) {
    if (value == null) return;
    onSelectedValue(value);
  }

  _RadioOverlayPickerProvider({
    required this.onSelectedValue,
    required List<T> values,
    T? initialValue,
  })  : this._availableValues = values,
        this._selectedValue = initialValue,
        super();

  void updateSelectedValue(T? value) {
    _selectedValue = value;
    notifyListeners();
  }

  void updateAvailableValues(List<T> values) {
    _availableValues = values;
  }
}

/// A body less (has only a text with a chevron) widget that opens
/// an overlay to choose one sigle options of the available ones.
class RadioOverlayPicker<T extends Enum> extends StatefulWidget {
  /// The current selected value, if it
  /// is null the placeholder will be shown
  final T? selected;

  /// The label of a single item
  final String Function(T value) getValueLabel;

  /// If not provided [getValueLabel] will be used
  ///
  /// The label of the selected value in the "body-less" widget
  final String Function(T value)? headerValueLabel;

  /// The placeholder to show if the selected value is null
  ///
  /// Must be not null if the selected value is null
  final String? placeholder;

  /// The available values to choose from
  final List<T> values;

  /// The callback called when a value is selected
  final Function(T) onSelectedValue;

  final Offset overlayOffset;

  final double chevronSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double spaceBetween;

  final ZwapInputDecorations? inputDecorations;

  RadioOverlayPicker({
    this.selected,
    required this.values,
    required this.getValueLabel,
    required this.onSelectedValue,
    this.placeholder,
    this.chevronSize = 20,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
    this.spaceBetween = 4,
    this.headerValueLabel,
    this.overlayOffset = const Offset(0, 30),
    this.inputDecorations,
    super.key,
  })  : assert(values.isNotEmpty, "Values cannot be empty"),
        assert(placeholder != null || selected != null, "Placeholder cannot be null if selected is null");

  @override
  State<RadioOverlayPicker<T>> createState() => RadioOverlayPickerState<T>();
}

class RadioOverlayPickerState<T extends Enum> extends State<RadioOverlayPicker<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _widgetKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  late _RadioOverlayPickerProvider<T> _provider;
  OverlayEntry? _overlay;

  bool get _isOverlayMounted => _overlay?.mounted ?? false;

  @override
  void initState() {
    super.initState();
    _provider = _RadioOverlayPickerProvider<T>(
      onSelectedValue: widget.onSelectedValue,
      values: widget.values,
      initialValue: widget.selected,
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (!_provider.isOverlayHovered) {
          _removeOverlay();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.requestFocus();
          });
        }
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(RadioOverlayPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_provider.availableValues != widget.values) _provider.updateAvailableValues(widget.values);
      if (_provider.selectedValue != widget.selected) _provider.updateSelectedValue(widget.selected);
    });
  }

  void toggleOverlay() {
    if (_isOverlayMounted) {
      _removeOverlay();
      _focusNode.unfocus();
    } else {
      _insertOverlay();
      _focusNode.requestFocus();
    }
  }

  void _insertOverlay() {
    if (_overlay?.mounted ?? false) return;

    Overlay.of(context).insert(
      _overlay = OverlayEntry(
        builder: (_) => Positioned(
          width: 175,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: widget.overlayOffset,
            child: ChangeNotifierProvider<_RadioOverlayPickerProvider<T>>.value(
              value: _provider,
              child: _RadioOverlay<T>(
                getValueLabel: widget.getValueLabel,
                inputDecorations: widget.inputDecorations,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  Widget build(BuildContext context) {
    late String _currentValue;
    if (widget.selected == null) {
      _currentValue = widget.placeholder!;
    } else if (widget.headerValueLabel != null) {
      _currentValue = widget.headerValueLabel!(widget.selected!);
    } else {
      _currentValue = widget.getValueLabel(widget.selected!);
    }

    return InkWell(
      onTap: toggleOverlay,
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Row(
          key: _widgetKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ZwapText.customStyle(
                text: _currentValue,
                customTextStyle: ZwapTextType.bigBodySemibold.copyWith(
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  color: widget.inputDecorations?.textColor ?? ZwapColors.primary900Dark,
                ),
              ),
            ),
            SizedBox(width: widget.spaceBetween),
            AnimatedRotation(
              duration: const Duration(milliseconds: 150),
              curve: Curves.decelerate,
              turns: _isOverlayMounted ? .5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: widget.chevronSize,
                color: widget.inputDecorations?.textColor ?? ZwapColors.primary900Dark,
              ),
            ),
            Container(
              width: 0,
              height: 0,
              child: Visibility.maintain(
                visible: false,
                child: TextField(focusNode: _focusNode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioOverlay<T extends Enum> extends StatefulWidget {
  final String Function(T value) getValueLabel;
  final ZwapInputDecorations? inputDecorations;

  const _RadioOverlay({
    required this.getValueLabel,
    required this.inputDecorations,
    super.key,
  });

  @override
  State<_RadioOverlay<T>> createState() => _RadioOverlayState<T>();
}

class _RadioOverlayState<T extends Enum> extends State<_RadioOverlay<T>> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _visible = true));
  }

  @override
  Widget build(BuildContext context) {
    final List<T> _values = context.select<_RadioOverlayPickerProvider<T>, List<T>>((provider) => provider.availableValues);
    final T? _selectedValue = context.select<_RadioOverlayPickerProvider<T>, T?>((provider) => provider.selectedValue);

    return Material(
      color: ZwapColors.transparent,
      child: InkWell(
        focusColor: ZwapColors.transparent,
        hoverColor: ZwapColors.transparent,
        splashColor: ZwapColors.transparent,
        highlightColor: ZwapColors.transparent,
        onTap: () {},
        onHover: (hovered) => context.read<_RadioOverlayPickerProvider<T>>().isOverlayHovered = hovered,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          opacity: _visible ? 1 : 0,
          child: Container(
            width: 220,
            constraints: BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: widget.inputDecorations?.overlayColor ?? ZwapColors.shades0,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(offset: const Offset(0, 30), blurRadius: 60, spreadRadius: -6, color: Color(0xff808080).withOpacity(.05)),
                BoxShadow(offset: const Offset(0, 30), blurRadius: 60, spreadRadius: -4, color: Color(0xff808080).withOpacity(.15)),
                BoxShadow(offset: const Offset(0, 20), blurRadius: 60, spreadRadius: 0, color: Color(0xff808080).withOpacity(.05)),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                children: _values
                    .mapIndexed((i, value) => Container(
                          height: 22,
                          margin: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 12),
                          child: InkWell(
                            onTap: () => context.read<_RadioOverlayPickerProvider<T>>().selectedValue = value,
                            child: Row(
                              children: [
                                ZwapRadioButton(
                                  active: _selectedValue == value,
                                  onTap: () => context.read<_RadioOverlayPickerProvider<T>>().selectedValue = value,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: ZwapText(
                                    text: widget.getValueLabel(value),
                                    zwapTextType: _selectedValue == value ? ZwapTextType.bigBodySemibold : ZwapTextType.bigBodyRegular,
                                    textColor: widget.inputDecorations?.overlayTextColor ?? ZwapColors.primary900Dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
