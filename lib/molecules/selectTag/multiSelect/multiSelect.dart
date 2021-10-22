import 'package:flutter/material.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

import 'package:zwap_design_system/molecules/selectTag/multiSelectTag/multiSelectTag.dart';
import 'package:zwap_design_system/molecules/selectTag/multiSelectField/multiSelectField.dart';


class MultiSelectFormField extends StatefulWidget {

  /// The list of elements
  final List<ZwapMultiSelectFormFieldItem> elementList;

  /// The tag color
  final Color tagColor;

  /// The empty label value
  final String emptyLabel;

  MultiSelectFormField({Key? key,
    required this.elementList,
    required this.emptyLabel,
    required this.tagColor,
  }) : super(key: key);

  @override
  MultiSelectFormFieldState createState() => MultiSelectFormFieldState();
}

class MultiSelectFormFieldState extends State<MultiSelectFormField> {

  /// Retrieve the list of selected elements
  get selectedElements => widget.elementList.where((e) => e.isSelected == true).toList();

  /// Retrieve the list of unselected elements
  get unselectedElements => widget.elementList.where((e) => e.isSelected == false).toList();

  /// Is the dropdown open or not fro th
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Stack(
        children: <Widget>[
          this.isDropdownOpen ? Container(
            height: size.height * 0.3,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.15),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 55.0, left: 12.0, right: 12.0),
              child: ListView.builder(
                itemCount: widget.elementList.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = widget.elementList[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.elementList[index].isSelected = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            if (element.leading != null) ...[
                              element.leading!,
                              SizedBox(width: 5)
                            ],
                            if (element.label != null)
                              Expanded(
                                child: ZwapText(
                                  zwapTextType: ZwapTextType.body1Regular,
                                  textColor: ZwapColors.neutral700,
                                  text: element.label,
                                ),
                              ),
                            if (element.trailing != null) ...[
                              SizedBox(width: 5),
                              element.trailing!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ) : Container(),
          InkWell(
            onTap: () => this._openDropDown(),
            child: _buildSelectedList(),
          )
        ],
      ),
    );
  }

  void _openDropDown(){
    setState(() {
      this.isDropdownOpen = !this.isDropdownOpen;
    });
  }

  _buildSelectedList() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              ..._buildSelectedElementList(),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectedElementList() {
    final elementList =
    widget.elementList.where((e) => e.isSelected == true).toList();
    if (elementList.isEmpty) return [_buildEmptyLabel()];
    return elementList
        .map(
          (e) => ZwapMultiSelectTag(
        label: e.label,
        onRemove: () {
          widget.elementList.where((elt) => elt == e).first.isSelected =
          false;
          setState(() {});
        },
      ),
    )
        .toList();
  }

  _buildEmptyLabel() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No item selected yet",
          style: TextStyle(fontSize: 12.0, color: Colors.black38),
        ),
      ),
    );
  }
}