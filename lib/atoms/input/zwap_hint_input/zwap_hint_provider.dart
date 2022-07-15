import 'dart:async';

import 'package:flutter/material.dart';

class ZwapHintProvider extends ChangeNotifier {
  final FutureOr Function(String)? _notifyNewItemAdded;
  final FocusNode _focusNode = FocusNode();
  final bool doNotSuggestAlreadySelected;

  List<String> _selectedItems;
  Map<String, String> _items;
  String _currentSearchValue;

  Rect _currentSearchFieldRect = Rect.zero;

  List<String> get selectedItems => _selectedItems;
  Map<String, String> get items => _items;
  String get currentSearchValue => _currentSearchValue;
  Rect get currentSearchFieldRect => _currentSearchFieldRect;

  FocusNode get focusNode => _focusNode;

  ZwapHintProvider(
    this._items,
    this._selectedItems,
    this._notifyNewItemAdded, {
    this.doNotSuggestAlreadySelected = true,
  }) : this._currentSearchValue = '';

  set items(Map<String, String> value) => {_items = value, notifyListeners()};
  set selectedItems(List<String> value) => {_selectedItems = value, notifyListeners()};
  set currentSearchFieldRect(Rect value) => {_currentSearchFieldRect = value, notifyListeners()};
  set currentSearchValue(String value) => {_currentSearchValue = value, notifyListeners()};

  void notifyNewItemSelected(String itemKey) async {
    if (_notifyNewItemAdded != null) await _notifyNewItemAdded!(itemKey);
    Future.delayed(Duration(milliseconds: 20), () => _focusNode.unfocus());
    Future.delayed(Duration(milliseconds: 200), () => _focusNode.requestFocus());
  }
}
