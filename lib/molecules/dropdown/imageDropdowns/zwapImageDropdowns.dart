/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// Custom dropdown with a list of values with emoji and text values
class ZwapEmojiDropDowns extends StatefulWidget{

  /// The items to display inside this dropdown
  final Map<String, String> emojiItems;

  /// CallBack function on selecting item
  final Function(String selectedItem) onSelectCallBack;

  /// The optional preselected item
  final String? selectedItem;

  ZwapEmojiDropDowns({Key? key,
    required this.emojiItems,
    required this.onSelectCallBack,
    this.selectedItem
  }): super(key: key);

  _ZwapEmojiDropDownsState createState() => _ZwapEmojiDropDownsState(this.selectedItem);

}

/// The state for this custom widget
class _ZwapEmojiDropDownsState extends State<ZwapEmojiDropDowns>{

  /// The selected item
  String _selectedItem = "";

  /// Is the dropdown open or closed
  bool _isDropdownOpen = false;

  _ZwapEmojiDropDownsState(String? preSelectedItem){
    if(preSelectedItem != null){
      this._selectedItem = preSelectedItem;
    }
  }

  /// It opens or closes the dropdown element
  void _openCloseDropdown(){
    setState(() {
      this._isDropdownOpen = !this._isDropdownOpen;
    });
  }

  /// It selects the item from the dropdown values
  void _selectItem(String key){
    setState(() {
      this._selectedItem = key;
    });
    this._openCloseDropdown();
    widget.onSelectCallBack(key);
  }

  /// It gets the selected item
  String get selectedItem => this._selectedItem.trim() != "" ? this._selectedItem : widget.emojiItems.keys.toList().first;

  /// It builds the row item to display inside the emoji dropdown
  Widget _rowItem(String char, String itemName, bool isDropdownWidget){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: !isDropdownWidget && itemName == this.selectedItem ? ZwapColors.primary100 : ZwapColors.shades0
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(right: 3),
                child: ZwapText(
                  text: char.emojiChar(),
                  textColor: ZwapColors.error400,
                  zwapTextType: ZwapTextType.h3,
                ),
              ),
            ),
            Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: ZwapText(
                  text: itemName,
                  textColor: ZwapColors.neutral700,
                  zwapTextType: ZwapTextType.body1Regular,
                ),
              ),
            ),
            isDropdownWidget ? Flexible(
              flex: 0,
              fit: FlexFit.tight,
              child: Padding(
                padding: EdgeInsets.only(left: 3),
                child: Icon(
                    this._isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down
                ),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }


  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => this._openCloseDropdown(),
          child: this._rowItem(this.selectedItem, widget.emojiItems[this.selectedItem]!, true),
        ),
        this._isDropdownOpen ? Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapCard(
            cardWidth: getMultipleConditions(300, 250, 150, 150, 150),
            cardRadius: 14,
            zwapCardType: ZwapCardType.levelZero,
            child: Column(
              children: List<Widget>.generate(widget.emojiItems.keys.toList().length, ((index) =>
                  InkWell(
                    onTap: () => this._selectItem(widget.emojiItems.keys.toList()[index]),
                    child: this._rowItem(widget.emojiItems.keys.toList()[index], widget.emojiItems[widget.emojiItems.keys.toList()[index]]!, false),
                  )
              )),
            ),
          ),
        ) : Container()
      ],
    );
  }

}
