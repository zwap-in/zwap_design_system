part of zwap.dynamic_inputs.floating_picker;

class ZwapFloatingPickerProvider<T> extends ChangeNotifier {
  final GlobalKey<ZwapDynamicInputState> inputKey;
  final List<T> values;
  T? _selectedValue;

  final void Function(T?)? onSelected;

  final String Function(T) getCopy;

  T? get selectedValue => _selectedValue;

  set selectedValue(T? value) => value.hashCode != _selectedValue.hashCode
      ? () {
          _selectedValue = value;
          notifyListeners();

          if (onSelected != null) onSelected!(value);
        }()
      : null;

  ZwapFloatingPickerProvider({
    required this.inputKey,
    required this.values,
    required this.getCopy,
    this.onSelected,
    T? selectedValue,
  })  : this._selectedValue = selectedValue,
        super();
}
