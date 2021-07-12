/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The state for infinite scroll with the class ChangeNotifier
class InfiniteScrollState<T> extends ChangeNotifier{

  /// List of elements to show inside this scroll
  late List<T> elements;

  /// The page number
  late int pageNumber;

  /// The error status
  bool _error = false;

  /// The loading status
  bool _loading = true;

  /// Stopping to loading
  bool _stop = false;

  /// The controller
  final ScrollController controller;

  /// Function to retrieve more data with the custom API
  final Future<List<T>> Function() fetchMoreData;

  InfiniteScrollState({
    required this.elements,
    required this.pageNumber,
    required this.fetchMoreData,
    required this.controller
  }){
    this.setElements();
  }

  /// Function to reload data
  Future<void> reloadData() async{
    this._loading = true;
    this._error = false;
    await this.loadMoreElements();
    notifyListeners();
  }

  /// Set elements function
  Future<void> setElements() async{
    this.controller.addListener(() async {
      if (this.controller.position.atEdge) {
        if (this.controller.position.pixels != 0) {
          await this.reloadData();
        }
      }
    });
    if (this.elements.isEmpty) {
      if (this._loading) {
        await this.reloadData();
      }
    }
  }

  /// Function to load more elements
  Future<void> loadMoreElements() async {
    if(!this._stop){
      try {
        List<T> fetchedElements = await this.fetchMoreData();
        if(fetchedElements.length == 0){
          this._stop = true;
        }else{
          this.pageNumber = this.pageNumber + 1;
        }
        this._loading = false;
        this.elements.addAll(fetchedElements);
      } catch (e) {
        this._loading = false;
        this._error = true;
      }
    }
  }

}

/// Custom component to display a list of widget of type T inside an infinite scroll
class InfiniteScroll<T> extends StatelessWidget {

  final Widget Function(T element) dynamicWidget;

  /// The type of the infinite scroll
  final bool scrollDirection;

  /// Number of _elements per page
  final int itemsPerPageCount;

  /// List of elements to show inside this scroll
  final List<T> elements;

  /// The page number
  final int pageNumber;

  /// Function to retrieve more data with the custom API
  final Future<List<T>> Function() fetchMoreData;

  final ScrollController scrollController;

  InfiniteScroll({Key? key,
    required this.dynamicWidget,
    this.scrollDirection = false,
    this.itemsPerPageCount = 10,
    required this.elements,
    required this.pageNumber,
    required this.fetchMoreData,
    required this.scrollController
  }): super(key: key);

  /// It retrieves the provider
  InfiniteScrollState<T> provider(BuildContext context){
    return context.read<InfiniteScrollState<T>>();
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InfiniteScrollState<T>(
          elements: this.elements,
          pageNumber: this.pageNumber,
          fetchMoreData: this.fetchMoreData,
          controller: this.scrollController
      ),
      builder: (context, child){
        return Consumer<InfiniteScrollState<T>>(
            builder: (builder, provider, child){
              return this.scrollDirection ? this._horizontalScroll(context) : this._verticalScroll(context);
            }
        );
      },
    );
  }

  /// It retrieves the correct item
  Widget _itemBuilder(int index, BuildContext context){
    InfiniteScrollState<T> provider = this.provider(context);
    if(index == provider.elements.length){
      if(!provider._error){
        return this._loadingBody();
      }
      else{
        return this._errorBody();
      }
    }
    final T element = provider.elements[index];
    return this.dynamicWidget(element);

  }

  /// It retrieves the responsive elements for the responsive row
  Map<Widget, Map<String, int>> _verticalResponsiveElements(BuildContext context){
    InfiniteScrollState<T> provider = this.provider(context);
    Map<Widget, Map<String, int>> finals = {};
    provider.elements.asMap().forEach((int index, T element) {
      Widget tmp = this._itemBuilder(index, context);
      finals[tmp] = {'xl': 4, 'lg': 4, 'md': 6, 'sm': 6, 'xs': 12};
    });
    if(!provider._stop){
      Widget tmp = this._itemBuilder(finals.length, context);
      finals[tmp] = {'xl': 12, 'lg': 12, 'md': 12, 'sm': 12, 'xs': 12};
    }
    return finals;
  }

  /// It retrieves the responsive elements for the responsive row
  List<Widget> _horizontalResponsiveElement(BuildContext context){
    List<Widget> finals = [];
    InfiniteScrollState<T> provider = this.provider(context);
    provider.elements.asMap().forEach((int index, T element) {
      Widget tmp = this._itemBuilder(index, context);
      finals.add(tmp);
    });
    if(!provider._stop){
      Widget tmp = this._itemBuilder(finals.length, context);
      finals.add(tmp);
    }
    return finals;
  }

  /// It retrieves the vertical scroll container
  Widget _verticalScroll(BuildContext context){
    InfiniteScrollState<T> provider = this.provider(context);
    return ResponsiveRow(
      children: this._verticalResponsiveElements(context),
      controller: provider.controller,
    );
  }

  /// It retrieves the horizontal scroll container
  Widget _horizontalScroll(BuildContext context){
    InfiniteScrollState<T> provider = this.provider(context);
    return ListView(
      scrollDirection: Axis.horizontal,
      controller: provider.controller,
      children: this._horizontalResponsiveElement(context),
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
}
