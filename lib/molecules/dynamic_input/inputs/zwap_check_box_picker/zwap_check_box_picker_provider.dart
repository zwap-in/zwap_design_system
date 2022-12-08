part of zwap.check_box_picker;

class _ZwapCheckBoxPickerProvider extends ChangeNotifier {
  final Map<String, String> values;
  List<String> selectedKeys;

  final Function(String, bool)? onToggleItem;
  final Function()? onClearAll;

  _ZwapCheckBoxPickerProvider({
    required this.onToggleItem,
    required this.values,
    required this.onClearAll,
    List<String>? initialSelectedKeys,
  })  : this.selectedKeys = initialSelectedKeys ?? [],
        super();

  void toggleItem(String item) {
    if (selectedKeys.contains(item))
      selectedKeys = List.from(selectedKeys)..remove(item);
    else
      selectedKeys = List.from(selectedKeys)..add(item);

    if (onToggleItem != null) onToggleItem!(item, selectedKeys.contains(item));

    notifyListeners();
  }

  void clear() {
    if (onClearAll != null) onClearAll!();
    
    selectedKeys = [];
    notifyListeners();
  }
}
