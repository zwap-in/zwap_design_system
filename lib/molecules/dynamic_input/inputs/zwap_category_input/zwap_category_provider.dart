part of zwap.dynamic_inputs.category_input;

class _ZwapCategoryProvider<T, S> extends ChangeNotifier {
  S? _selectedValue;
  final Map<T, List<S>> allValues;

  Map<T, List<S>> _tmpValues;

  final GetCopyOfItemCallback<T> getCopyOfCategory;
  final GetCopyOfItemCallback<S> getCopyOfItem;

  final FilterCallback<S> filterItems;
  final FutureOr<void> Function(S? item) onSelected;
  final Widget? Function(S item)? addDecoratorTo;

  final TextEditingController inputController = TextEditingController();
  final GlobalKey<ZwapDynamicInputState> inputKey = GlobalKey();

  _ZwapCategoryProvider({
    required S? selectedValue,
    required this.allValues,
    required this.getCopyOfCategory,
    required this.getCopyOfItem,
    required this.filterItems,
    required this.onSelected,
    required this.addDecoratorTo,
  })  : this._tmpValues = allValues,
        this._selectedValue = selectedValue;

  set filter(String filter) {
    if (filter.isEmpty) {
      _tmpValues = allValues;
      notifyListeners();
      return;
    }

    _tmpValues = allValues.map((key, value) {
      return MapEntry(
        key,
        value.where((element) => filterItems(element, filter)).toList(),
      );
    });
    _tmpValues.removeWhere((key, value) => value.isEmpty);

    notifyListeners();
  }

  Map<T, List<S>> get values => _tmpValues;
  S? get selectedValue => _selectedValue;

  set selectedValue(S? value) {
    _selectedValue = value;
    onSelected(value);
    inputController.text = value == null ? '' : getCopyOfItem(value);

    inputKey.closeIfOpen();

    notifyListeners();
  }
}
