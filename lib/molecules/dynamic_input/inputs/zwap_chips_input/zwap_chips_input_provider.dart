part of zwap.dynamic_inputs.chips_input;

class _ZwapChipsInputProvider<T> extends ChangeNotifier {
  final List<T> values;
  final List<T>? lessItems;
  final bool showLessItems;
  final int showLessItemsUntil;

  final ChipsInputItemBuilder<T> builderCallback;
  final ChipsInputItemSearch<T> searchCallback;

  final int maxItems;

  /// [isSelected] is true if item has been selected
  final void Function(T, bool isSelected)? onItemPicked;

  List<int> _selectedHashcodes;
  List<T> get selectedItems => values.where((i) => _selectedHashcodes.contains(i.hashCode)).toList();

  String _search = '';

  String get search => _search;

  set search(String value) => _search != value ? {_search = value, notifyListeners()} : null;

  List<T> get activeItems {
    if (showLessItems && _search.length <= showLessItemsUntil) return lessItems!;

    return _search.isEmpty ? values : values.where((i) => searchCallback(i, _search)).toList();
  }

  _ZwapChipsInputProvider({
    required this.builderCallback,
    required this.searchCallback,
    required this.onItemPicked,
    required this.maxItems,
    required this.values,
    required this.showLessItems,
    required this.lessItems,
    required this.showLessItemsUntil,
    List<int> initialSelectedItems = const [],
  })  : this._selectedHashcodes = initialSelectedItems,
        super();

  void toggleItem(T item) {
    final int _hashCode = item.hashCode;

    if (_selectedHashcodes.contains(_hashCode)) {
      _selectedHashcodes.remove(item.hashCode);
    } else {
      if (_selectedHashcodes.length >= maxItems) return;

      _selectedHashcodes.add(item.hashCode);
    }
    if (onItemPicked != null) onItemPicked!(item, _selectedHashcodes.contains(_hashCode));
  }

  bool isItemSelected(T item) => _selectedHashcodes.contains(item.hashCode);

  void updateSelected(List<int> selected) {
    _selectedHashcodes = List.from(selected);
    notifyListeners();
  }
}
