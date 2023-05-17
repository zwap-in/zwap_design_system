part of zwap.wrap_selector;

class _ZwapWrapSelectorProvider<T> extends ChangeNotifier {
  final List<T> Function(String search) items;
  final void Function(T item) onSelected;
  final Widget Function(T item) selectBuilder;

  late List<T> _availableItems;

  List<T> get availableItems => _availableItems;

  bool _isOverlayHovered = false;

  _ZwapWrapSelectorProvider({
    required this.items,
    required this.onSelected,
    required this.selectBuilder,
  }) {
    this._availableItems = items('');
  }

  void search(String search) {
    _availableItems = items(search);
    notifyListeners();
  }

  void clean() => _availableItems = items('');
}
