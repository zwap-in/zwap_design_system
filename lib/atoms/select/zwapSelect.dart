/// IMPORTING THIRD PARTY PACKAGES
import 'package:collection/src/list_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';
import 'package:zwap_design_system/atoms/overlayEntryWidget/zwapOverlayEntryWidget.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_utils/zwap_utils/type.dart';

/// custom dropdown widget to select some element from a list
class ZwapSelect extends StatefulWidget {
  /// The custom values to display inside this widget
  final List<String> values;

  /// It handles the selected value with a callBack function
  final Function(String key) callBackFunction;

  final Function(String newItem)? onAddItem;
  final bool canAddItem;

  /// The default value of this dropdown
  final String? selected;

  final String hintText;

  final bool canSearch;

  ZwapSelect({
    Key? key,
    required this.values,
    required this.callBackFunction,
    this.selected,
    this.hintText = '',
    this.canAddItem = true,
    this.onAddItem,
    this.canSearch = false,
  })  : assert(values.isNotEmpty),
        super(key: key);

  _ZwapSelectState createState() => _ZwapSelectState();
}

/// Description: the state for this current widget
class _ZwapSelectState extends State<ZwapSelect> {
  final GlobalKey _selectKey = GlobalKey();

  /// The value to display
  String? _selectedValue;

  /// Is this select hoovered
  bool _isHover = false;

  String? _hoveredItem;

  OverlayEntry? _selectOverlay;

  late final TextEditingController _inputController;
  late final FocusNode _inputFocus;

  List<String> _filteredValues = [];

  @override
  void initState() {
    super.initState();
    this._selectedValue = widget.selected;

    _inputController = TextEditingController(text: widget.selected);
    _inputFocus = FocusNode(onKey: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.end || event.physicalKey == PhysicalKeyboardKey.enter || event.physicalKey == PhysicalKeyboardKey.tab) {
        _inputFocus.unfocus();
        _inputController.text = _selectedValue ?? '';

        return KeyEventResult.handled;
      }

      if (!widget.canSearch) return KeyEventResult.handled;
      return KeyEventResult.ignored;
    });

    _inputController.addListener(_controllerListener);
    _inputFocus.addListener(_focusListener);

    _filteredValues = widget.values;
  }

  void _focusListener() {
    final bool _isOpened = _selectOverlay?.mounted ?? false;

    if ((_isOpened && !_inputFocus.hasFocus) || (!_isOpened && _inputFocus.hasFocus)) {
      _toggleOverlay();
      _inputController.selection = TextSelection(baseOffset: 0, extentOffset: _inputController.text.length);
    }
  }

  void _controllerListener() {
    List<String> _tmp = widget.values.where((v) => v.toLowerCase().trim().contains(_inputController.text.toLowerCase().trim())).toList();
    if (!listEquals(_filteredValues, _tmp)) setState(() => _filteredValues = _tmp);
  }

  @override
  void didUpdateWidget(ZwapSelect oldWidget) {
    if (widget.selected != oldWidget.selected) setState(() => onChangeValue(widget.selected));

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _inputController.removeListener(_controllerListener);
    _inputFocus.removeListener(_focusListener);
    super.dispose();
  }

  /// Selecting new value from the dropdown widget
  void onChangeValue(String? value) {
    if (value == null) return;

    widget.callBackFunction(value);

    if (_inputFocus.hasFocus) _inputFocus.unfocus();

    _inputController.text = value;

    setState(() {
      this._selectedValue = value;
    });
  }

  /// It opens the dropdown

  /// It hoovers the dropdown button
  void hoverButton(bool value) {
    setState(() {
      this._isHover = value;
    });
  }

  void _toggleOverlay() {
    if (_selectOverlay?.mounted ?? false) {
      try {
        _selectOverlay!.remove();
      } catch (e) {}
      _selectOverlay = null;
    } else {
      Overlay.of(context)?.insert(_selectOverlay = _createOverlay());
      if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
    }

    setState(() {});
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        return ZwapOverlayEntryWidget(
          entity: _selectOverlay,
          onAutoClose: () {
            _inputController.text = _selectedValue ?? '';

            if (_inputFocus.hasFocus) _inputFocus.unfocus();
          },
          child: ZwapOverlayEntryChild(
            top: (_selectKey.globalOffset?.dy ?? 0) + 45,
            left: _selectKey.globalOffset?.dx ?? 0,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.decelerate,
              tween: Tween(begin: 0, end: 1),
              builder: (context, animation, child) => Opacity(
                opacity: animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: ZwapColors.neutral300,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Container(
                    width: (_selectKey.globalPaintBounds?.size.width ?? 2) - 2,
                    decoration: BoxDecoration(
                      color: ZwapColors.shades0,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (widget.canSearch ? _filteredValues : widget.values).isEmpty
                          ? [
                              if (widget.canAddItem)
                                Container(
                                  color: Colors.transparent,
                                  width: double.infinity,
                                  child: Material(
                                    color: '_random_key_for_this_item_2341234112341252456375' == _hoveredItem ? ZwapColors.neutral100 : ZwapColors.shades0,
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: () => widget.onAddItem != null ? widget.onAddItem!(_inputController.text) : null,
                                      hoverColor: ZwapColors.neutral100,
                                      onHover: (hovered) => setState(() => _hoveredItem = hovered ? '_random_key_for_this_item_2341234112341252456375' : null),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                                        child: Row(
                                          children: [
                                            ZwapTextMultiStyle(
                                              texts: {
                                                '${_inputController.text}': TupleType(a: null, b: TupleType(a: ZwapTextType.bodySemiBold, b: ZwapColors.shades100)),
                                                ' not here? ': TupleType(a: null, b: TupleType(a: ZwapTextType.bodyRegular, b: ZwapColors.shades100)),
                                                'Add it here': TupleType(a: null, b: TupleType(a: ZwapTextType.bodySemiBold, b: ZwapColors.shades100)),
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ZwapText(
                                  text: "Nessun risulatato",
                                  zwapTextType: ZwapTextType.bodyRegular,
                                  textColor: ZwapColors.shades100,
                                ),
                            ]
                          : (widget.canSearch ? _filteredValues : widget.values)
                              .mapIndexed((i, value) => Container(
                                    color: Colors.transparent,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: i != (widget.values.length - 1) ? 8 : 0),
                                    child: Material(
                                      color: value == _selectedValue
                                          ? value == _hoveredItem
                                              ? ZwapColors.primary50
                                              : ZwapColors.primary100
                                          : value == _hoveredItem
                                              ? ZwapColors.neutral100
                                              : ZwapColors.shades0,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        onTap: () => this.onChangeValue(value),
                                        hoverColor: value == _selectedValue ? ZwapColors.primary50 : ZwapColors.neutral100,
                                        splashColor: value == _selectedValue ? Colors.transparent : null,
                                        onHover: (hovered) => setState(() => _hoveredItem = hovered ? value : null),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child:
                                                      ZwapText(text: value, zwapTextType: ZwapTextType.bodyRegular, textColor: value == _selectedValue ? ZwapColors.primary800 : ZwapColors.shades100)),
                                              if (value == _selectedValue) ...[
                                                SizedBox(width: 5),
                                                Icon(Icons.check, color: ZwapColors.shades100, size: 20),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (bool value) => this.hoverButton(value),
      onTap: () {
        if (!_inputFocus.hasFocus) _inputFocus.requestFocus();
      },
      child: Container(
        decoration: (_selectOverlay?.mounted ?? false)
            ? BoxDecoration(
                color: ZwapColors.neutral300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              )
            : BoxDecoration(
                color: this._isHover ? ZwapColors.primary300 : ZwapColors.neutral300,
                borderRadius: BorderRadius.circular(4),
              ),
        child: Container(
          key: _selectKey,
          height: 45,
          decoration: BoxDecoration(
            color: ZwapColors.shades0,
            borderRadius: (_selectOverlay?.mounted ?? false)
                ? BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  )
                : BorderRadius.circular(4),
          ),
          margin: _selectOverlay?.mounted ?? false ? const EdgeInsets.only(top: 1, left: 1, right: 1) : const EdgeInsets.all(1),
          padding: const EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _inputController,
                  focusNode: _inputFocus,
                  decoration: InputDecoration.collapsed(hintText: widget.hintText),
                  cursorColor: ZwapColors.shades100,
                ),
              ),
              SizedBox(width: 5),
              AnimatedRotation(
                turns: (_selectOverlay?.mounted ?? false) ? 0.5 : 0,
                duration: const Duration(milliseconds: 150),
                child: Icon(Icons.keyboard_arrow_up, color: Color.fromRGBO(50, 50, 50, 1), key: ValueKey(_selectOverlay?.mounted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
