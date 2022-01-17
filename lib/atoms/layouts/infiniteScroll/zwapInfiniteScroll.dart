/// IMPORTING THIRD PARTY PACKAGES
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

  /// if [true] will have no max height/width (has no effects on grid type)
  final bool expand;

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
  }) : super(key: key) {
    if (this.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView) {
      assert(this.axisDirection == Axis.vertical, "On grid view infinite scroll the axis direction must be vertical");
    }
  }

  @override
  _ZwapInfiniteScrollState<T> createState() => _ZwapInfiniteScrollState<T>(controller: this.scrollController);
}

/// The infinite scroll state
class _ZwapInfiniteScrollState<T> extends State<ZwapInfiniteScroll<T>> {
  /// The future instance to render the data
  late Future<PageData<T>> _future;

  /// The scroll controller to manage the API calls
  late ScrollController controller;

  _ZwapInfiniteScrollState({ScrollController? controller}) {
    this.controller = controller ?? ScrollController();
  }

  /// The current page number
  int _pageNumber = 1;

  /// Is loading or not?
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    this._future = widget.initData != null ? Future.delayed(Duration.zero, () => widget.initData!) : widget.fetchMoreData(this._pageNumber);
    this._pageNumber++;
    this.controller.addListener(() async {
      if (this.controller.position.atEdge && this.controller.position.pixels != 0 && !this._loading && !this.controller.position.outOfRange) {
        setState(() {
          this._loading = true;
        });
        PageData<T> tmp = await widget.fetchMoreData(this._pageNumber);
        this._future.then((value) {
          setState(() {
            this._pageNumber++;
            List<T> newCombinedList = new List<T>.from(value.data)..addAll(tmp.data);
            value.data = newCombinedList;
            this._loading = false;
          });
        });
      }
    });
  }

  void didUpdateWidget(ZwapInfiniteScroll<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasToReloadOnDidUpdate) {
      this._future = widget.initData != null ? Future.delayed(Duration.zero, () => widget.initData!) : widget.fetchMoreData(this._pageNumber);
    }
  }

  /// It builds the list with a grid view
  Widget _getGridView(AsyncSnapshot<PageData<T>> snapshot) {
    List<T> results = snapshot.data!.data;
    return ResponsiveRow<List<Widget>>(
      customInternalPadding: widget.customInternalPadding,
      children: List<Widget>.generate(results.length, ((int index) => widget.getChildWidget(results[index]))),
      controller: this.controller,
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

  Widget _getExpandedView(AsyncSnapshot<PageData<T>> snapshot) {
    List<T> results = snapshot.data!.data;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...results.map((i) => widget.getChildWidget(i)),
        if (this._loading) Flexible(child: CircularProgressIndicator(), flex: 0, fit: FlexFit.tight),
      ],
    );
  }

  /// It builds the list with a list view
  Widget _getListView(AsyncSnapshot<PageData<T>> snapshot) {
    List<T> results = snapshot.data!.data;
    return this._getParentListView(ListView.builder(
        scrollDirection: widget.axisDirection!,
        shrinkWrap: widget.expand,
        padding: EdgeInsets.all(1.0),
        itemCount: results.length,
        controller: this.controller,
        itemBuilder: (BuildContext context, int index) {
          return widget.getChildWidget(results[index]);
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
  Widget _getChildWidget(AsyncSnapshot<PageData<T>> snapshot) {
    if (widget.expand) return _getExpandedView(snapshot);

    return this._getParentWidget(
      [
        Expanded(
          child: widget.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView ? this._getGridView(snapshot) : this._getListView(snapshot),
        ),
        this._loading
            ? Flexible(
                child: CircularProgressIndicator(),
                flex: 0,
                fit: FlexFit.tight,
              )
            : Container()
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
            if (snapshot.hasError)
              return this._getErrorWidget(snapshot.error.toString());
            else
              return widget.topWidget != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [widget.topWidget!(snapshot.data!), this._getChildWidget(snapshot)],
                    )
                  : this._getChildWidget(snapshot);
        }
      },
    );
  }
}
