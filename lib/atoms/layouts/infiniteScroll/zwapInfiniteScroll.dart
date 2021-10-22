/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/modelData/api.dart';

import '../../colors/zwapColors.dart';
import '../../typography/zwapTypography.dart';
import '../../text/text.dart';

import '../waiting/zwapWaiting.dart';
import '../gridView/zwapGridView.dart';

/// It defines the possible types for the infinite scroll
enum ZwapInfiniteScrollType{
  gridView,
  listView
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

  /// The optional custom waiting widget
  final Widget? waitingWidget;

  ZwapInfiniteScroll({Key? key,
    required this.fetchMoreData,
    required this.getChildWidget,
    required this.zwapInfiniteScrollType,
    required this.mainSizeDirection,
    this.axisDirection = Axis.vertical,
    this.crossSizeDirection,
    this.waitingWidget
  }): super(key: key){
   if(this.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView){
     assert(this.axisDirection == Axis.vertical, "On grid view infinite scroll the axis direction must be vertical");
   }
  }

  @override
  _ZwapInfiniteScrollState<T> createState() => _ZwapInfiniteScrollState<T>();
}

/// The infinite scroll state
class _ZwapInfiniteScrollState<T> extends State<ZwapInfiniteScroll<T>> {

  /// The future instance to render the data
  late Future<PageData<T>> _future;

  /// The scroll controller to manage the API calls
  final ScrollController controller = ScrollController();

  /// The current page number
  int _pageNumber = 0;

  /// Is loading or not?
  bool _loading = false;

  @override
  void initState(){
    super.initState();
    this._future = widget.fetchMoreData(this._pageNumber);
    this._pageNumber++;
    this.controller.addListener(() async {
      if(this.controller.position.atEdge && this.controller.position.pixels != 0 && !this._loading && !this.controller.position.outOfRange){
        setState(() {
          this._loading = true;
        });
        PageData<T> tmp = await widget.fetchMoreData(this._pageNumber);
        setState(() {
          this._pageNumber++;
          this._future.then((value) =>
               value.data.addAll(tmp.data)
          );
          this._loading = false;
        });
      }
    });
  }

  /// It builds the list with a grid view
  Widget _getGridView(AsyncSnapshot snapshot) {
    List<T> results = snapshot.data.data;
    return ZwapGridView<T>(
      controller: this.controller,
      children: results,
      maxElementsPerRow: getMultipleConditions(4, 4, 3, 2, 1),
      maxHeight: widget.mainSizeDirection,
      maxWidth: widget.crossSizeDirection,
      getChildWidget: (T item) => widget.getChildWidget(item),
    );
  }

  /// It gets the parent widget in case of list view
  Widget _getParentListView(Widget child){
    return widget.axisDirection == Axis.vertical ? SizedBox(
      width: widget.mainSizeDirection,
      child: child,
    ) : SizedBox(
      height: widget.mainSizeDirection,
      child: child,
    );
  }

  /// It builds the list with a list view
  Widget _getListView(AsyncSnapshot snapshot){
    List<T> results = snapshot.data.data;
    return this._getParentListView(
        ListView.builder(
            scrollDirection: widget.axisDirection!,
            padding: EdgeInsets.all(1.0),
            itemCount: results.length,
            controller: this.controller,
            itemBuilder: (BuildContext context, int index){
              return widget.getChildWidget(results[index]);
            }
        )
    );
  }

  /// It gets the parent widget in base of axis direction
  Widget _getParentWidget(List<Widget> children){
    return widget.axisDirection == Axis.horizontal ?
    Row(
      children: List<Widget>.generate(children.length, (index) => children[index]),
    ) : Column(
      children: List<Widget>.generate(children.length, (index) => children[index]),
    );
  }

  /// It gets the child widget in case of error
  Widget _getErrorWidget(String errorText){
    return Center(
      child: ZwapText(
        text: "Error during fetching data due to $errorText",
        textColor: ZwapColors.shades100,
        zwapTextType: ZwapTextType.body1Regular,
      ),
    );
  }

  /// It gets the child widget to rendering data
  Widget _getChildWidget(AsyncSnapshot snapshot){
    return this._getParentWidget(
      [
        Expanded(
          child: widget.zwapInfiniteScrollType == ZwapInfiniteScrollType.gridView ? this._getGridView(snapshot) : this._getListView(snapshot),
        ),
        this._loading ? Flexible(
          child: CircularProgressIndicator(),
          flex: 0,
          fit: FlexFit.tight,
        ) : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._future,
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.waiting:
            return widget.waitingWidget ?? ZwapWaiting();
          default:
            if (snapshot.hasError)
              return this._getErrorWidget(snapshot.error.toString());
            else
              return this._getChildWidget(snapshot);
        }
      },
    );
  }
}