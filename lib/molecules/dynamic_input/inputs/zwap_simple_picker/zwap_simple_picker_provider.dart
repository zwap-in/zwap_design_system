part of zwap.dynamic_inputs.simple_picker;

class _ZwapSimplePickerProvider<T> extends ChangeNotifier {
  final List<T> items;

  final SimplePickerGetCopy<T>? getCopy;
  final SimplePickerItemBuilder<T>? itemBuilder;
  final SimplePickerGetIsSelected<T> getIsSelected;
  final SimplePickerSearchItem<T> searchItem;

  final void Function(T item)? _onItemTap;

  String _searchValue = '';

  List<T> get _filteredItems => _searchValue.length < 2 ? items : items.where((i) => searchItem(i, _searchValue)).toList();

  set search(String value) => _searchValue != value
      ? {
          _searchValue = value,
          notifyListeners(),
        }
      : null;

  _ZwapSimplePickerProvider({
    required this.items,
    required this.getCopy,
    required this.itemBuilder,
    required this.searchItem,
    required this.getIsSelected,
    void Function(T item)? onItemTap,
  })  : this._onItemTap = onItemTap,
        assert(getCopy != null || itemBuilder != null),
        super();

  void onItemTap(T item) {
    if (_onItemTap != null) _onItemTap!(item);
  }
}
