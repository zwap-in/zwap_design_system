/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The infinite scroll state
class InfiniteScrollState<T> extends ChangeNotifier{

  /// The elements fetched
  final List<T> _elements = [];

  /// The current page number to fetch more data
  int _pageNumber = 0;

  /// The error status
  bool _error = false;

  /// The loading status
  bool _loading = true;

  bool _stop = false;

  ScrollController controller = ScrollController();

  /// Number of elements per page
  final int defaultPhotosPerPageCount;

  /// The threshold to get more data during the scroll
  final int _nextPageThreshold = 5;

  /// Function to retrieve more data with the custom API
  final Future<List<T>> Function(int pageNumber) fetchMoreData;

  InfiniteScrollState({
    required this.fetchMoreData,
    required this.defaultPhotosPerPageCount
  });

  /// Function to reload data
  Future<void> reloadData() async{
    this._loading = true;
    this._error = false;
    await this.loadMoreElements();
    notifyListeners();
  }

  /// Function to load more elements
  Future<void> loadMoreElements() async {
    if(!this._stop){
      try {
        List<T> fetchedElements = await this.fetchMoreData(this._pageNumber);
        if(fetchedElements.length == 0){
          this._stop = true;
        }
        this._loading = false;
        this._pageNumber = this._pageNumber + 1;
        this._elements.addAll(fetchedElements);
      } catch (e) {
        this._loading = false;
        this._error = true;
      }
    }
  }

  /// It retrieves all elements fetched
  List<T> get elements => this._elements;

  /// The page number to fetch more data
  int get pageNumber => this._pageNumber;

  /// Is there any error?
  bool get error => this._error;

  /// Is still loading?
  bool get loading => this._loading;

  /// When it must retrieve the next page
  int get nextPageThreshold => this._nextPageThreshold;

}

/// Custom component to display a list of widget of type T inside an infinite scroll
class InfiniteScroll<T> extends StatelessWidget {

  /// The provider to handle the change state
  final InfiniteScrollState<T> provider;

  /// The dynamic widget to retrieve the custom widget element with dynamic data from the custom API
  final Widget Function(T element) dynamicWidget;

  /// The type of the infinite scroll
  final bool scrollDirection;

  InfiniteScroll({Key? key,
    required this.provider,
    required this.dynamicWidget,
    this.scrollDirection = false,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    try{
      this.provider.controller.position.maxScrollExtent;
    }
    catch(e){
      this.provider.reloadData();
    }
    this.provider.controller.addListener(() {
      if (this.provider.controller.position.atEdge) {
        if (this.provider.controller.position.pixels != 0) {
          this.provider.reloadData();
        }
      }
    });
    return getBody(this.provider.controller);
  }

  /// It retrieves the correct item
  Widget _itemBuilder(int index){
    if(index == this.provider.elements.length){
      if(!this.provider.error){
        return this._loadingBody();
      }
      else{
        return this._errorBody();
      }
    }
    final T element = this.provider.elements[index];
    return this.dynamicWidget(element);

  }

  /// It retrieve the responsive elements for the responsive row
  Map<Widget, Map<String, int>> _verticalResponsiveElements(){
    Map<Widget, Map<String, int>> finals = {};
    this.provider.elements.asMap().forEach((int index, T element) {
      Widget tmp = this._itemBuilder(index);
      finals[tmp] = {'xl': 4, 'lg': 4, 'md': 6, 'sm': 6, 'xs': 12};
    });
    if(!this.provider._stop){
      Widget tmp = this._itemBuilder(finals.length);
      finals[tmp] = {'xl': 12, 'lg': 12, 'md': 12, 'sm': 12, 'xs': 12};
    }
    return finals;
  }

  /// It retrieve the responsive elements for the responsive row
  List<Widget> _horizontalResponsiveElement(){
    List<Widget> finals = [];
    this.provider.elements.asMap().forEach((int index, T element) {
      Widget tmp = this._itemBuilder(index);
      finals.add(tmp);
    });
    if(!this.provider._stop){
      Widget tmp = this._itemBuilder(finals.length);
      finals.add(tmp);
    }
    return finals;
  }

  /// It retrieves the vertical scroll container
  Widget _verticalScroll(ScrollController controller){
    return ResponsiveRow(
      children: this._verticalResponsiveElements(),
      controller: controller,
    );
  }

  /// It retrieves the horizontal scroll container
  Widget _horizontalScroll(ScrollController controller){
    return ListView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: this._horizontalResponsiveElement(),
    );
  }


  /// It returns the body if there is any error
  Widget _errorBody(){
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: BaseText(
            texts: [""],
            baseTextsType: [BaseTextType.normalBold],
            callBacksClick: [() => {}],
            hasClick: [true],
          )
      ),
    );
  }

  /// It returns the body if it's the loading situation
  Widget _loadingBody(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// It returns the body of this custom widget
  Widget getBody(ScrollController controller) {
    if (this.provider.elements.isEmpty) {
      if (this.provider.loading) {
        this.provider.reloadData();
        return this._loadingBody();
      } else if (this.provider.error) {
        return this._errorBody();
      }
    }
    return this.scrollDirection ? this._horizontalScroll(controller) : this._verticalScroll(controller);
  }
}
