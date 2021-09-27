/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// The provider state for the list details component
class ListDetailsProvideState<T> extends ChangeNotifier{

  /// The filters to get the correct elements
  Map<String, bool> filters;

  /// The elements mapping inside the scroll cards list
  Map<DateTime, Map<T, bool>> elements;

  /// It handles the callBack click
  final Function(Widget newBody) handleCallBack;

  ListDetailsProvideState({required this.elements, required this.filters, required this.handleCallBack}){
    bool check = false;
    int i = 0;
    List<DateTime> keys = this.elements.keys.toList();
    while(!check && i < keys.length){
      Map<T, bool> tmpValue = this.elements[keys[i]]!;
      int j = 0;
      List<T> tmpKeys = tmpValue.keys.toList();
      while(!check && j < tmpKeys.length){
        check = tmpValue[tmpKeys[j]]!;
        j++;
      }
      i++;
    }
    if(!check){
      T firstKeys = this.elements[keys.first]!.keys.toList().first;
      this.elements[keys.first]![firstKeys] = true;
    }
  }

  /// It selects any element inside the scroll list cards
  void selectElement(DateTime keyDate, T element, Widget? newBody){
    if(newBody != null){
      this.handleCallBack(newBody);
    }
    this.elements.forEach((key, value) {
      Map<T, bool> mappingTmpValues = this.elements[key]!;
      mappingTmpValues.forEach((tmpKey, tmpValue) {
        this.elements[key]![tmpKey] = false;
      });
    });
    this.elements[keyDate]![element] = true;
    notifyListeners();
  }

  /// It gets the current element
  T? get getCurrentElement {
    T? tmp;
    int i = 0;
    List<DateTime> keys = this.elements.keys.toList();
    while(tmp == null && i < keys.length){
      Map<T, bool> tmpValue = this.elements[keys[i]]!;
      int j = 0;
      List<T> tmpKeys = tmpValue.keys.toList();
      while(tmp == null && j < tmpKeys.length){
        if(tmpValue[tmpKeys[j]]!){
          tmp = tmpKeys[j];
        }
        j++;
      }
      i++;
    }
    return tmp;
  }

  /// It changes the current filter
  void changeFilter(String newFilter){
    this.filters.forEach((key, value) {
      this.filters[key] = false;
    });
    this.filters[newFilter] = true;
    notifyListeners();
  }

}