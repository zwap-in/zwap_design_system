import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_chips_input/zwap_chips_input.dart';

class ZwapChipsInputProvider<T> extends ChangeNotifier {
  final List<T> values;
  final ChipsInputItemBuilder<T> builderCallback;
  final ChipsInputItemSearch<T> searchCallback;

  /// [isSelected] is true if item has been selected
  final Function(T, bool isSelected)? onItemPicked;

  List<int> _selectedHashcodes;
  List<T> get selectedItems => values.where((i) => _selectedHashcodes.contains(i.hashCode)).toList();

  String _search = '';

  set search(String value) => _search != value ? {_search = value, notifyListeners()} : null;

  List<T> get activeItems => _search.isEmpty ? values : values.where((i) => searchCallback(i, _search)).toList();

  ZwapChipsInputProvider({
    required this.builderCallback,
    required this.searchCallback,
    required this.onItemPicked,
    required this.values,
    List<int> initialSelectedItems = const [],
  })  : this._selectedHashcodes = initialSelectedItems,
        super();

  void toggleItem(T item) {
    final int _hashCode = item.hashCode;

    if (_selectedHashcodes.contains(_hashCode)) {
      _selectedHashcodes.remove(item.hashCode);
    } else {
      _selectedHashcodes.add(item.hashCode);
    }
    if (onItemPicked != null) onItemPicked!(item, _selectedHashcodes.contains(_hashCode));
  }

  bool isItemSelected(T item) => _selectedHashcodes.contains(item.hashCode);

  void updateSelected(List<int> selected) {
    _selectedHashcodes = selected;
    notifyListeners();
  }
}
