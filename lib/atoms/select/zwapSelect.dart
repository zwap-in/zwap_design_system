/// IMPORTING THIRD PARTY PACKAGES
import 'package:collection/src/list_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';
import 'package:zwap_design_system/atoms/overlayEntryWidget/zwapOverlayEntryWidget.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_utils/zwap_utils/type.dart';

///This should be used only for interactions between ZwapSelect and its overlay
class _ZwapSelectProvider extends ChangeNotifier {
  List<String> allValues;
  bool isLoading;
  String searchedValue;

  _ZwapSelectProvider(this.allValues)
      : this.isLoading = false,
        this.searchedValue = '';

  set searched(String value) => searchedValue != value ? {searchedValue = value, notifyListeners()} : null;

  void addNewValues(List<String> newValues) {
    allValues = {...newValues, ...allValues}.toList();
    notifyListeners();
  }

  void setLoading(bool newValue) {
    if (newValue != isLoading) {
      isLoading = newValue;
      notifyListeners();
    }
  }
}

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

  final double? maxOverlayHeight;

  final String? label;

  final Future<List<String>> Function(String inputValue, int pageNumber)? fetchMoreData;

  final int initialPageNumber;

  ZwapSelect({
    Key? key,
    required this.values,
    required this.callBackFunction,
    this.selected,
    this.hintText = '',
    this.canAddItem = false,
    this.onAddItem,
    this.canSearch = false,
    this.maxOverlayHeight,
    this.label,
    this.fetchMoreData,
    this.initialPageNumber = 1,
  })  : assert(values.isNotEmpty),
        super(key: key);

  _ZwapSelectState createState() => _ZwapSelectState();
}

/// Description: the state for this current widget
class _ZwapSelectState extends State<ZwapSelect> {
  final GlobalKey _selectKey = GlobalKey();
  final ScrollController _overlayScrollController = ScrollController();

  late final _ZwapSelectProvider _provider;

  /// The value to display
  String? _selectedValue;

  /// Is this select hoovered
  bool _isHover = false;

  String? _hoveredItem;

  OverlayEntry? _selectOverlay;

  late final TextEditingController _inputController;
  late final FocusNode _inputFocus;

  late int _pageNumber;

  @override
  void initState() {
    super.initState();
    this._selectedValue = widget.selected;

    _pageNumber = widget.initialPageNumber;

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
    _overlayScrollController.addListener(_scrollControllerListener);

    _provider = _ZwapSelectProvider(widget.values);
  }

  void _focusListener() {
    final bool _isOpened = _selectOverlay?.mounted ?? false;

    if ((_isOpened && !_inputFocus.hasFocus) || (!_isOpened && _inputFocus.hasFocus)) {
      _toggleOverlay();

      if (!_isOpened) {
        _inputController.text = '';
        _inputController.selection = TextSelection.collapsed(offset: 0);
      }
    }
  }

  void _controllerListener() {
    _provider.searched = _inputController.text;
  }

  void _scrollControllerListener() async {
    if (widget.fetchMoreData == null) return;

    if (_overlayScrollController.position.atEdge && _overlayScrollController.position.pixels != 0 && !_provider.isLoading && !_overlayScrollController.position.outOfRange) {
      _provider.setLoading(true);

      List<String> tmp = await widget.fetchMoreData!(_inputController.text, _pageNumber);

      _pageNumber = _pageNumber + 1;

      _provider.addNewValues(tmp);
      _provider.setLoading(false);
    }
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
    _overlayScrollController.removeListener(_scrollControllerListener);
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
        return ChangeNotifierProvider.value(
          value: _provider,
          child: Builder(
            builder: (context) {
              bool _isLoading = context.select<_ZwapSelectProvider, bool>((pro) => pro.isLoading);
              List<String> _allValues = context.select<_ZwapSelectProvider, List<String>>((pro) => pro.allValues);
              String _searchedValue = context.select<_ZwapSelectProvider, String>((pro) => pro.searchedValue);

              List<String> _toShowValues = _allValues.where((s) => s.toLowerCase().trim().contains(_searchedValue.toLowerCase().trim())).toList();

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
                          constraints: BoxConstraints(maxHeight: widget.maxOverlayHeight ?? MediaQuery.of(context).size.height * 0.3),
                          child: SingleChildScrollView(
                            controller: _overlayScrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _toShowValues.isEmpty
                                  ? ([
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
                                        Material(
                                          child: ZwapText(
                                            text: "Nessun risulatato",
                                            zwapTextType: ZwapTextType.bodyRegular,
                                            textColor: ZwapColors.shades100,
                                          ),
                                        ),
                                    ])
                                  : [
                                      Column(
                                        key: UniqueKey(),
                                        children: _toShowValues
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
                                                                child: ZwapText(
                                                                    text: value,
                                                                    zwapTextType: ZwapTextType.bodyRegular,
                                                                    textColor: value == _selectedValue ? ZwapColors.primary800 : ZwapColors.shades100)),
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
                                      if (_isLoading)
                                        Center(
                                          child: Container(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                                              strokeWidth: 0.5,
                                            ),
                                          ),
                                        )
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          ZwapText(
            text: widget.label!,
            zwapTextType: ZwapTextType.bodySemiBold,
            textColor: ZwapColors.neutral600,
          ),
        InkWell(
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
                      cursorColor: widget.canSearch ? ZwapColors.shades100 : ZwapColors.shades0,
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
        ),
      ],
    );
  }
}
