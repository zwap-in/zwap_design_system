part of zwap.dynamic_inputs.search_picker;

class _ZwapSearchInputProvider<T> extends ChangeNotifier {
  final GlobalKey<ZwapDynamicInputState> _inputKey = GlobalKey();
  Timer? _searchTimer;

  late List<T> _emptySearchData;
  int _emptySearchLastPage = 1;

  GetCopyOfItemCallback<T> getCopyOfItemCallback;
  PerformSearchCallback<T> _performSearchCallback;
  ItemSelectedCallback<T>? _onItemSelected;

  T? _selectedItem;
  List<T> _data;
  int _page = 1;

  String _search = '';
  bool __loading = false;
  bool __loadingMoreData = false;

  _ZwapSearchInputProvider(
    this._data,
    this._performSearchCallback,
    this._onItemSelected,
    this._selectedItem,
    this.getCopyOfItemCallback,
  ) : super() {
    _emptySearchData = _data;
  }

  bool get loading => __loading;
  bool get loadingMoreData => __loadingMoreData;
  T? get selectedItem => _selectedItem;
  List<T> get data => _data;
  GlobalKey<ZwapDynamicInputState> get inputKey => _inputKey;

  set search(String value) {
    _startSearchTimer();

    _search = value;
    notifyListeners();
  }

  set _loading(bool value) {
    __loading = value;
    notifyListeners();
  }

  set _loadingMoreData(bool value) {
    __loadingMoreData = value;
    notifyListeners();
  }

  void _startSearchTimer() {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 500), _performSearch);
  }

  void _performSearch() async {
    if (_search.isEmpty) {
      _data = _emptySearchData;
      _page = _emptySearchLastPage;
      notifyListeners();
      return;
    }

    _loading = true;

    final List<T> _results = await _performSearchCallback(_search, _page = 1);
    _data = _results;
    _loading = false;

    notifyListeners();
  }

  void endReached() async {
    if (__loadingMoreData) return;

    _loadingMoreData = true;
    final String _referringSearch = _search;

    final List<T> _results = await _performSearchCallback(_referringSearch, ++_page);
    _data = [..._data, ..._results];

    if (_referringSearch.isEmpty) {
      _emptySearchData = _data;
      _emptySearchLastPage = _page;
    }
    _loadingMoreData = false;
  }

  void pickItem(T? item) {
    _selectedItem = item;
    _inputKey.closeIfOpen();

    if (_onItemSelected != null) _onItemSelected!(item);

    notifyListeners();
  }
}
