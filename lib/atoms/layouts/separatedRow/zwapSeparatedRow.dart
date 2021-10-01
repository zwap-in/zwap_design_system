/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Component to rendering a row with element at the extreme positions
class ZwapSeparatedRow extends StatelessWidget{

  /// Widgets at the left side
  final List<Widget> leftWidgets;

  /// Widgets at the right side
  final List<Widget> rightWidgets;

  /// The optionally crossAxisAlignment for this row
  final CrossAxisAlignment? crossAxisAlignment;

  ZwapSeparatedRow({Key? key,
    required this.leftWidgets,
    required this.rightWidgets,
    this.crossAxisAlignment
  }): super(key: key);

  /// It gets the items for each side
  List<Widget> _getItems(List<Widget> items){
    return List<Widget>.generate(items.length, (index) =>
        Flexible(
          child: items[index],
          flex: 0,
          fit: FlexFit.tight,
        ),
    );
  }

  /// It gets the right side
  Widget _getRightSide(){
    List<Widget> rights = this._getItems(this.rightWidgets);
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List<Widget>.generate(rights.length, (index) => rights[index]),
      ),
    );
  }

  Widget build(BuildContext context){
    List<Widget> finals = this._getItems(this.leftWidgets);
    finals.add(this._getRightSide());
    return Row(
      crossAxisAlignment: this.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: List<Widget>.generate(finals.length, (index) => finals[index]),
    );
  }

}