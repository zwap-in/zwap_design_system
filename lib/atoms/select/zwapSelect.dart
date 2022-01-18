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
  Map<String, String> _originalValues;
  bool isLoading;
  String searchedValue;

  Map<String, String> _dynamicValues = {};

  Map<String, String> get allValues => {..._originalValues, ..._dynamicValues};

  _ZwapSelectProvider(this._originalValues)
      : this.isLoading = false,
        this.searchedValue = '';

  set searched(String value) => searchedValue != value ? {searchedValue = value, notifyListeners()} : null;

  void addNewValues(Map<String, String> newValues) {
    newValues.removeWhere((k, v) => _originalValues.keys.contains(k));
    _dynamicValues = {..._dynamicValues, ...newValues};
    notifyListeners();
  }

  void originalValuesChanged(Map<String, String> newValues) {
    _originalValues = newValues;
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
  final Map<String, String> values;

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

  final Future<Map<String, String>> Function(String inputValue, int pageNumber)? fetchMoreData;

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

  dynamic _hoveredItem;

  OverlayEntry? _selectOverlay;

  late final TextEditingController _inputController;
  late final FocusNode _inputFocus;

  late int _pageNumber;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selected;

    _pageNumber = widget.initialPageNumber;

    _inputController = TextEditingController(text: widget.selected);
    _inputFocus = FocusNode(onKey: (node, event) {
      if (event.physicalKey == PhysicalKeyboardKey.end || event.physicalKey == PhysicalKeyboardKey.enter || event.physicalKey == PhysicalKeyboardKey.tab) {
        _inputFocus.unfocus();
        _inputController.text = widget.values[_selectedValue] ?? '';

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
    _requestData(forcePageToOne: true);
  }

  void _scrollControllerListener() async {
    if (_overlayScrollController.position.atEdge && _overlayScrollController.position.pixels != 0 && !_provider.isLoading && !_overlayScrollController.position.outOfRange) _requestData();
  }

  _requestData({bool forcePageToOne = false}) async {
    if (widget.fetchMoreData == null) return;

    _provider.setLoading(true);

    Map<String, String> tmp = await widget.fetchMoreData!(forcePageToOne ? _inputController.text : '', forcePageToOne ? 1 : _pageNumber);

    if (!forcePageToOne) _pageNumber += 1;

    _provider.addNewValues(tmp);
    _provider.setLoading(false);
  }

  @override
  void didUpdateWidget(covariant ZwapSelect oldWidget) {
    if (!mapEquals(oldWidget.values, widget.values)) WidgetsBinding.instance?.addPostFrameCallback((_) => _provider.originalValuesChanged(widget.values));
    if (widget.selected != oldWidget.selected) WidgetsBinding.instance?.addPostFrameCallback((_) => onChangeValue(widget.selected, callCallback: false));

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
  void onChangeValue(String? value, {bool callCallback = true}) {
    if (value == null) return;

    if (callCallback) widget.callBackFunction(value);

    if (_inputFocus.hasFocus) _inputFocus.unfocus();

    _inputController.text = _provider.allValues[value] ?? '';

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
              Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.allValues);
              String _searchedValue = context.select<_ZwapSelectProvider, String>((pro) => pro.searchedValue);

              Map<String, String> _toShowValues = Map.from(_allValues)..removeWhere((k, v) => v.isNotEmpty && !v.toLowerCase().trim().contains(_searchedValue.toLowerCase().trim()));

              return ZwapOverlayEntryWidget(
                entity: _selectOverlay,
                onAutoClose: () {
                  _inputController.text = _provider.allValues[_selectedValue] ?? '';

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
                          constraints: BoxConstraints(maxHeight: widget.maxOverlayHeight ?? MediaQuery.of(context).size.height * 0.3),
                          child: SingleChildScrollView(
                            controller: _overlayScrollController,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 13),
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
                                        children: _toShowValues.keys
                                            .toList()
                                            .mapIndexed((i, key) => Container(
                                                  color: Colors.transparent,
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(bottom: i != (_toShowValues.length - 1) ? 8 : 0),
                                                  child: Material(
                                                    color: key == _selectedValue
                                                        ? key == _hoveredItem
                                                            ? ZwapColors.primary50
                                                            : ZwapColors.primary100
                                                        : key == _hoveredItem
                                                            ? ZwapColors.neutral100
                                                            : ZwapColors.shades0,
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: InkWell(
                                                      onTap: () => this.onChangeValue(key),
                                                      hoverColor: key == _selectedValue ? ZwapColors.primary50 : ZwapColors.neutral100,
                                                      splashColor: key == _selectedValue ? Colors.transparent : null,
                                                      onHover: (hovered) => setState(() => _hoveredItem = hovered ? key : null),
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
                                                                    text: _allValues[key] ?? '<error>',
                                                                    zwapTextType: ZwapTextType.bodyRegular,
                                                                    textColor: key == _selectedValue ? ZwapColors.primary800 : ZwapColors.shades100)),
                                                            if (key == _selectedValue) ...[
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
