part of zwap.dynamic_inputs.search_picker;

class _ZwapSearchInputProvider<T> extends ChangeNotifier {
  final TextEditingController inputController = TextEditingController();
  final GlobalKey<ZwapDynamicInputState> _inputKey = GlobalKey();
  Timer? _searchTimer;

  final Map<T, String> _addedKeyValue = {};

  late List<T> _emptySearchData;
  int _emptySearchLastPage = 1;
  bool _emptySearchHasMoreResults = true;

  GetCopyOfItemCallback<T> _getCopyOfItemCallback;
  PerformSearchCallback<T> _performSearchCallback;
  ItemSelectedCallback<T>? _onItemSelected;
  AddItemCallback<T>? _onItemAdded;

  Duration? _debounceDuration;

  GetCopyOfItemCallback<T> get getCopyOfItemCallback => (item) {
        if (_addedKeyValue[item] != null) return _addedKeyValue[item]!;
        return _getCopyOfItemCallback(item);
      };

  T? _selectedItem;
  List<T> _data;
  int _page = 1;

  String _search = '';
  bool __loading = false;
  bool __loadingMoreData = false;
  bool _hasMoreResults = true;

  _ZwapSearchInputProvider(
    this._data,
    this._performSearchCallback,
    this._onItemSelected,
    this._selectedItem,
    this._getCopyOfItemCallback,
    this._onItemAdded,
    this._debounceDuration,
  ) : super() {
    _emptySearchData = _data;
  }

  bool get loading => __loading;
  bool get loadingMoreData => __loadingMoreData;
  T? get selectedItem => _selectedItem;
  List<T> get data => _data;
  GlobalKey<ZwapDynamicInputState> get inputKey => _inputKey;
  String get search => _search;

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
    _searchTimer = Timer(_debounceDuration ?? const Duration(milliseconds: 500), _performSearch);
  }

  void _performSearch() async {
    if (_search.isEmpty) {
      _data = _emptySearchData;
      _page = _emptySearchLastPage;
      _hasMoreResults = _emptySearchHasMoreResults;
      notifyListeners();
      return;
    }

    _loading = true;

    final List<T> _results = await _performSearchCallback(_search, _page = 1);
    _data = _results;
    _hasMoreResults = true;
    _loading = false;

    notifyListeners();
  }

  void endReached() async {
    if (__loadingMoreData || !_hasMoreResults) return;

    _loadingMoreData = true;
    final String _referringSearch = _search;

    final List<T> _results = await _performSearchCallback(_referringSearch, ++_page);
    _data = [..._data, ..._results];
    _hasMoreResults = _results.isNotEmpty;

    if (_referringSearch.isEmpty) {
      _emptySearchData = _data;
      _emptySearchLastPage = _page;
      _emptySearchHasMoreResults = _hasMoreResults;
    }
    _loadingMoreData = false;
  }

  void pickItem(T? item) {
    _selectedItem = item;
    _inputKey.closeIfOpen();

    if (_onItemSelected != null) _onItemSelected!(item);

    notifyListeners();
  }

  void clearSearch() {
    _search = '';
    _data = _emptySearchData;
    _page = _emptySearchLastPage;
    _hasMoreResults = _emptySearchHasMoreResults;
    notifyListeners();
  }

  void addItem(String value) async {
    if (_onItemAdded == null) return;
    final T? _newItem = await _onItemAdded!(_search);
    if (_newItem == null) return;

    Future.delayed(Duration.zero, () => inputController.text = value);
    _selectedItem = _newItem;
    _data = [_newItem, ..._data];

    _inputKey.closeIfOpen();

    notifyListeners();
  }
}
