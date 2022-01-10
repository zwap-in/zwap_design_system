/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';

/// The multi select form field
class ZwapMultiSelectFormFieldItem {

  /// The text to display on the list element
  String label;

  /// a boolean determining weather the element is selected or not
  bool isSelected;

  /// The value of the item, intended to be exploited later
  dynamic value;

  ZwapMultiSelectFormFieldItem({
    required this.label,
    required this.value,
    this.isSelected = false,
  });
}

/// Custom input with select tag
class ZwapMultiSelectFormField extends StatefulWidget {

  /// The list of elements
  final List<ZwapMultiSelectFormFieldItem> elementList;

  /// The label name for this input
  final String labelName;

  /// Is it an enabled input
  final bool isEnabled;

  final Function(String newValue, bool isAdding) manageValueCallBack;

  ZwapMultiSelectFormField({Key? key,
    required this.elementList,
    required this.labelName,
    required this.isEnabled,
    required this.manageValueCallBack
  }) : super(key: key);

  @override
  ZwapMultiSelectFormFieldState createState() => ZwapMultiSelectFormFieldState();
}

/// The state for this component
class ZwapMultiSelectFormFieldState extends State<ZwapMultiSelectFormField> {

  /// Retrieve the list of selected elements
  get selectedElements => widget.elementList.where((e) => e.isSelected == true).toList();

  /// Retrieve the list of unselected elements
  get unselectedElements => widget.elementList.where((e) => e.isSelected == false).toList();

  /// Is the dropdown open or not fro th
  bool isDropdownOpen = false;

  /// It opens or close the dropdown
  void _openCloseDropDown(){
    setState(() {
      this.isDropdownOpen = !this.isDropdownOpen;
    });
  }

  /// It handles the adding value
  void onAddValue(int index){
    setState(() {
      widget.elementList[index].isSelected = true;
    });
    widget.manageValueCallBack(widget.elementList[index].value, true);
  }

  /// It handles the removing value
  void onRemoveValue(ZwapMultiSelectFormFieldItem e){
    widget.elementList.where((elt) => elt == e).first.isSelected = false;
    setState(() {});
    widget.manageValueCallBack(e.value, false);
  }

  Widget _dropDownCard(Size size) =>
      Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        child: ZwapCard(
          cardHeight: size.height * 0.3,
          cardWidth: size.width,
          zwapCardType: ZwapCardType.levelTwo,
          child: ListView.builder(
            itemCount: widget.elementList.length,
            itemBuilder: (BuildContext context, int index) {
              final element = widget.elementList[index];
              return InkWell(
                onTap: () => this.onAddValue(index),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ZwapText(
                    zwapTextType: ZwapTextType.bodyRegular,
                    textColor: ZwapColors.neutral700,
                    text: element.label,
                  ),
                ),
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: ZwapText(
            text: widget.labelName,
            zwapTextType: ZwapTextType.bodySemiBold,
            textColor: ZwapColors.neutral600,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 3),
          child: Container(
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
                border: Border.all(
                    color: ZwapColors.neutral300,
                    style: BorderStyle.solid,
                    width: 1
                )
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () => this._openCloseDropDown(),
                  child: _buildSelectedList(),
                ),
                this.isDropdownOpen ? this._dropDownCard(size) : Container(),
              ],
            ),
          ),
        )
      ],
    );
  }

  /// It builds the selected elements list
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
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 2),
                  child: ZwapHorizontalScroll(
                    child: Row(
                      children: <Widget>[
                        ..._buildSelectedElementList(),
                      ],
                    ),
                  ),
                )
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 2),
                child: this.isDropdownOpen ? ZwapIcons.icons("arrow_up_2") : ZwapIcons.icons("arrow_down_2"),
              ),
              flex: 0,
              fit: FlexFit.tight,
            )
          ],
        ),
      ),
    );
  }

  /// It builds the component per each component inside the list
  _buildSelectedElementList() {
    final elementList =
    widget.elementList.where((e) => e.isSelected == true).toList();
    if (elementList.isEmpty) return [_buildEmptyLabel()];
    return elementList
        .map(
          (e) => Padding(
        padding: EdgeInsets.only(right: 10),
        child: ZwapTag(
          tagText: e.label,
          zwapContentType: ZwapTagContentType.rightIcon,
          zwapIconType: ZwapIconType.zwapIcon,
          iconName: "close",
          zwapTagType: ZwapTagType.clickable,
          onCallBackClick: () => this.onRemoveValue(e),
        ),
      ),
    ).toList();
  }

  /// It builds the label for the empty state
  _buildEmptyLabel() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(),
      ),
    );
  }
}