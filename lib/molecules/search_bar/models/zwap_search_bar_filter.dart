import 'dart:async';

import 'package:flutter/material.dart';

typedef BuildItemFunction = Widget Function(BuildContext context, bool isSmall, bool isHovered);
typedef BuildWidgetFunction = Widget Function(BuildContext context, bool isSmall);

class ZwapSearchBarFilter<T> {
  /// If true [_getItems] must be not null. [_items] will be ignored.
  ///
  /// Otherwise, if false, [_items] must be not null and its value will be used
  final bool _isAsync;

  /// List of items to show in filter
  final List<T>? _items;

  /// Get the list of items to show in filter
  final Future<List<T>> Function()? _getItems;

  /// Used to build a single element inside the current picker.
  ///
  /// There are 3 types of picker:
  /// * Dropdown picker: used when the filter is inside the search bar
  /// * Mobile picker: used inside the [ZwapSbMobileFilter] widget on mobile devices
  /// * Big Dropdown: used on external filters on big screen (ie: when the provided filters
  /// need more than the available space and some filters are showed in a lateral drawer)
  ///
  /// [isSmall] is true when the filter shoud be compact (default min-compact size is 200px,
  /// but this can be customized, see ZwapSearchBar for more details)
  ///
  /// [isHovered] is true when the user hover the item. If you want to perform animation on
  /// rebuilding return a StatefulWidget.
  final BuildItemFunction buildPickItem;

  /// If not null and [_isAsync] is true, used to build the
  /// loader while awaiting data from [_getItems]
  ///
  /// If not provided (and async is true), a default widget will be shown
  final BuildWidgetFunction? buildLoader;

  /// The first widget that return true will be shown
  /// when the filter is closed
  ///
  /// If no items return true [buildPlaceholder] widget
  /// will be shown.
  final Function(T) getIsSelected;

  /// Used to build the placeholder when no item are selected.
  ///
  /// If not provided, a default widget will be shown
  final BuildWidgetFunction? buildPlaceholder;

  /// Called when a item is tapped.
  final FutureOr Function(T item)? onItemTap;

  /// Called when the current picker is opened.
  ///
  /// Ie:
  /// * if is a dropdown, when the user open the overlay
  /// * If is a list (mobile picker) when the user enter the page with the list
  final FutureOr Function()? onOpenPicker;

  /// Called when the current picker is closed.
  ///
  /// Ie:
  /// * if is a dropdown, when the user close the overlay
  /// * If is a list (mobile picker) when the user exit the page with the list
  final FutureOr Function()? onClosePicker;

  ZwapSearchBarFilter({
    required List<T> items,
    required this.buildPickItem,
    required this.getIsSelected,
    this.buildPlaceholder,
    this.buildLoader,
    this.onItemTap,
    this.onOpenPicker,
    this.onClosePicker,
  })  : this._isAsync = false,
        this._items = items,
        this._getItems = null;

  ZwapSearchBarFilter.async({
    required Future<List<T>> Function() items,
    required this.buildPickItem,
    required this.getIsSelected,
    this.buildPlaceholder,
    this.buildLoader,
    this.onItemTap,
    this.onOpenPicker,
    this.onClosePicker,
  })  : this._isAsync = true,
        this._items = null,
        this._getItems = items;
}
