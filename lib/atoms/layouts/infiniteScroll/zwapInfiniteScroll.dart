/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/modelData/api.dart';

import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';
import 'package:zwap_design_system/atoms/layouts/waiting/zwapWaiting.dart';

/// It defines the possible types for the infinite scroll
enum ZwapInfiniteScrollType {
  gridView,
  listView,
}

/// The infinite scroll component
class ZwapInfiniteScroll<T> extends StatefulWidget {
  /// It fetches more data from the API call
  ///
  /// If [initData] != null, pageNumber will start from 2, otherwise will start with 1.
  ///
  /// If [fetchMoreData] return an empty PageData<T>:
  ///   * [pageNumber] will not be incremented
  ///   * await [noDataDuration] before the next call
  ///
  /// otherwise:
  ///   * [pageNumber]++;
  ///   *  await [fetchDelayDuration] before the next call
  final Future<PageData<T>> Function(int pageNumber) fetchMoreData;

  /// It builds the child with the item builder
  final Widget Function(T element) getChildWidget;

  /// The max size for height or width in base of the main axis direction
  final double mainSizeDirection;

  /// The max size for the grid view in base of the cross axis direction
  final double? crossSizeDirection;

  /// The infinite scroll type
  final ZwapInfiniteScrollType zwapInfiniteScrollType;

  /// The axis direction for this infinite scroll
  final Axis? axisDirection;

  /// The optional init data
  final PageData<T>? initData;

  /// The optional custom waiting widget
  final Widget? waitingWidget;

  /// The widget to display on top inside this component
  final Widget Function(PageData<T> elements)? topWidget;

  /// The scroll controller for this infinite scroll
  final ScrollController? scrollController;

  /// Custom internal padding for the responsive row component
  final EdgeInsets? customInternalPadding;

  final bool hasToReloadOnDidUpdate;

  /// if [true] will have no max height/width
  final bool expand;

  /// ! Used only if [expand] is true and [zwapInfiniteScrollType] is gridView
  final int? rowWidgetsCount;

  final Duration noDataDuration;
  final Duration fetchDelayDuration;

  /// If [filter] is provided is used to remove elements e that not satisfy `filter(e)` only from view
  final bool Function(T element)? filter;

  ZwapInfiniteScroll({
    Key? key,
    required this.fetchMoreData,
    required this.getChildWidget,
    required this.zwapInfiniteScrollType,
    required this.mainSizeDirection,
    this.axisDirection = Axis.vertical,
    this.hasToReloadOnDidUpdate = false,
    this.initData,
    this.crossSizeDirection,
    this.waitingWidget,
    this.topWidget,
    this.scrollController,
    this.customInternalPadding,
    this.expand = false,
    this.rowWidgetsCount,
    this.fetchDelayDuration = const Duration(milliseconds: 300),
    this.noDataDuration = const Duration(milliseconds: 1000),
    this.filter,
  })  : assert((!expand || zwapInfiniteScrollType == ZwapInfiniteScrollType.listView) || rowWidgetsCount != null,
            "If expand is true and zwapInfinityScrollType is gridView, rowWidgetsCount must be provided"),
        super(key: key) {
    if (this.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView) {
      assert(this.axisDirection == Axis.vertical, "On grid view infinite scroll the axis direction must be vertical");
    }
  }

  @override
  _ZwapInfiniteScrollState<T> createState() => _ZwapInfiniteScrollState<T>();
}

/// The infinite scroll state
class _ZwapInfiniteScrollState<T> extends State<ZwapInfiniteScroll<T>> {
  /// Used to update [_cansearch] after a delay
  Timer? _updateCanSearchTimer;

  /// Used to stop fetching more data in some conditions
  bool _canFetchData = true;

  /// The future instance to render the data
  late Future<PageData<T>> _future;

  /// The scroll controller to manage the API calls
  late ScrollController _scrollController;

  late bool Function(T e)? _filter;

  /// The current page number
  int _pageNumber = 1;

  /// Is loading or not?
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    this._scrollController = widget.scrollController ?? ScrollController();
    _filter = widget.filter;

    this._future = widget.initData != null ? Future.delayed(Duration.zero, () => widget.initData!) : widget.fetchMoreData(this._pageNumber);
    this._pageNumber++;
    this._scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    final bool _isAtEdge =
        _scrollController.position.atEdge && _scrollController.position.pixels != 0 && !_loading && !_scrollController.position.outOfRange;

    if (_isAtEdge && !_canFetchData) print('ricerca bloccata');

    if (_isAtEdge && _canFetchData) {
      setState(() => this._loading = true);

      final value = await _future;
      PageData<T> tmp = await widget.fetchMoreData(this._pageNumber);
      List<T> newCombinedList = new List<T>.from(value.data)..addAll(tmp.data);

      _canFetchData = false;
      _setCanFetchTimer(dataIsEmpty: tmp.data.isEmpty);
      print('ricerca: ${tmp.data.isEmpty}');

      setState(() {
        if (tmp.data.isNotEmpty) _pageNumber++;
        value.data = newCombinedList;
        _loading = false;
      });
    }
  }

  void _setCanFetchTimer({bool dataIsEmpty = false}) {
    if (_updateCanSearchTimer?.isActive ?? false) return;

    if (dataIsEmpty)
      _updateCanSearchTimer = Timer(widget.noDataDuration, () => _canFetchData = true);
    else
      _updateCanSearchTimer = Timer(widget.fetchDelayDuration, () => _canFetchData = true);
  }

  @override
  void didUpdateWidget(ZwapInfiniteScroll<T> oldWidget) {
    if (!mounted) return;
    super.didUpdateWidget(oldWidget);

    if (widget.hasToReloadOnDidUpdate) {
      this._future = widget.initData != null ? Future.delayed(Duration.zero, () => widget.initData!) : widget.fetchMoreData(this._pageNumber);
    }
    if (widget.filter != oldWidget.filter) setState(() => _filter = widget.filter);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _updateCanSearchTimer?.cancel();
    super.dispose();
  }

  /// It builds the list with a grid view
  Widget _getGridView(List<T> data) {
    return ResponsiveRow<List<Widget>>(
      customInternalPadding: widget.customInternalPadding,
      children: List<Widget>.generate(data.length, ((int index) => widget.getChildWidget(data[index]))),
      controller: this._scrollController,
    );
  }

  /// It gets the parent widget in case of list view
  Widget _getParentListView(Widget child) {
    if (widget.expand) return child;

    return widget.axisDirection == Axis.vertical
        ? SizedBox(
            width: widget.mainSizeDirection,
            child: child,
          )
        : SizedBox(
            height: widget.mainSizeDirection,
            child: child,
          );
  }

  Widget _getExpandedListView(List<T> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(data.length, (i) => widget.getChildWidget(data[i])).toList(),
        if (this._loading) Flexible(child: CircularProgressIndicator(), flex: 0, fit: FlexFit.tight),
      ],
    );
  }

  Widget _getExpandedGridView(List<T> data) {
    int _rowsCount = (data.length / widget.rowWidgetsCount!).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          _rowsCount,
          (i) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                min(widget.rowWidgetsCount!, data.length - (i * widget.rowWidgetsCount!)),
                (_i) => widget.getChildWidget(data[(i * widget.rowWidgetsCount!) + _i]),
              )),
        ).toList(),
        if (this._loading) Flexible(child: CircularProgressIndicator(), flex: 0, fit: FlexFit.tight),
      ],
    );
  }

  /// It builds the list with a list view
  Widget _getListView(List<T> data) {
    return this._getParentListView(ListView.builder(
        scrollDirection: widget.axisDirection!,
        shrinkWrap: widget.expand,
        padding: EdgeInsets.all(1.0),
        itemCount: data.length,
        controller: this._scrollController,
        itemBuilder: (BuildContext context, int index) {
          return widget.getChildWidget(data[index]);
        }));
  }

  /// It gets the parent widget in base of axis direction
  Widget _getParentWidget(List<Widget> children) {
    return widget.axisDirection == Axis.horizontal
        ? Row(
            children: List<Widget>.generate(children.length, (index) => children[index]),
          )
        : Column(
            children: List<Widget>.generate(children.length, (index) => children[index]),
          );
  }

  /// It gets the child widget in case of error
  Widget _getErrorWidget(String errorText) {
    return Center(
      child: ZwapText(
        text: Utils.translatedText("error_infinite_loading").replaceAll("error_message", errorText),
        textColor: ZwapColors.shades100,
        zwapTextType: ZwapTextType.bodyRegular,
      ),
    );
  }

  /// It gets the child widget to rendering data
  Widget _getChildWidget(List<T> data) {
    if (widget.expand) {
      if (widget.zwapInfiniteScrollType == ZwapInfiniteScrollType.listView) return _getExpandedListView(data);
      return _getExpandedGridView(data);
    }

    return this._getParentWidget(
      [
        Expanded(
          child: widget.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView ? this._getGridView(data) : this._getListView(data),
        ),
        Container(
          height: 35,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: this._loading
                ? Flexible(
                    key: ValueKey('true_sufgbajsbgaòbgòa'),
                    child: Container(height: 35, child: CircularProgressIndicator()),
                    flex: 0,
                    fit: FlexFit.tight,
                  )
                : Container(
                    key: ValueKey('false_dkgahsrughaòrgh'),
                    height: 35,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PageData<T>>(
      future: this._future,
      builder: (context, AsyncSnapshot<PageData<T>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return widget.waitingWidget ?? ZwapWaiting();
          default:
            break;
        }

        List<T> data = List.from(snapshot.data!.data)..removeWhere((e) => _filter != null ? !_filter!(e) : false);

        if (snapshot.hasError)
          return this._getErrorWidget(snapshot.error.toString());
        else
          return widget.topWidget != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [widget.topWidget!(snapshot.data!), this._getChildWidget(data)],
                )
              : this._getChildWidget(data);
      },
    );
  }
}
