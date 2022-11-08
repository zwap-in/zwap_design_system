part of zwap.dynamic_inputs.simple_picker;

class _ZwapSimplePickerProvider<T> extends ChangeNotifier {
  final List<T> items;

  final SimplePickerGetCopy<T>? getCopy;
  final SimplePickerItemBuilder<T>? itemBuilder;
  final SimplePickerGetIsSelected<T> getIsSelected;
  final SimplePickerSearchItem<T> searchItem;

  final void Function(T item)? _onItemTap;

  bool _disabled;

  String _searchValue = '';

  bool get disabled => _disabled;
  List<T> get _filteredItems => _searchValue.length < 2 ? items : items.where((i) => searchItem(i, _searchValue)).toList();

  set disabled(bool value) => value != _disabled ? {_disabled = value, notifyListeners()} : null;
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
    required bool disabled,
    void Function(T item)? onItemTap,
  })  : this._onItemTap = onItemTap,
        this._disabled = disabled,
        assert(getCopy != null || itemBuilder != null),
        super();

  void onItemTap(T item) {
    if (_onItemTap != null) _onItemTap!(item);
  }
}
