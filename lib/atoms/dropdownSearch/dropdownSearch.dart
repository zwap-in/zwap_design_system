/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';

import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/text/text.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';
import 'package:zwap_design_system/atoms/layouts/zwapLayouts.dart';
import 'package:zwap_design_system/modelData/api.dart';

/// Custom component to build a dropdown with a search infinite scroll
class DropDownSearch extends StatefulWidget {

  /// The input controller
  final TextEditingController dropDownController;

  /// The init data for this input search
  final PageData<String> initData;

  /// The api call to fetch more data
  final Future<PageData<String>> Function(String inputValue, int pageNumber) fetchMoreData;

  /// The function to translate the text inside the dropdown list
  final Function(String keyText) translateText;

  /// The title name for the input widget
  final String? inputName;

  /// The placeholder for this input widget
  final String? placeholderName;

  DropDownSearch({Key? key,
    required this.dropDownController,
    required this.initData,
    required this.fetchMoreData,
    required this.translateText,
    this.inputName,
    this.placeholderName
  }): super(key: key);

  @override
  _DropDownSearchState createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> {

  /// The focus node for the input field
  final FocusNode _focusNode = FocusNode();

  /// The layer linked to the input field
  final LayerLink _layerLink = LayerLink();

  /// The overlay on the input field
  late OverlayEntry _overlayEntry;

  /// The init data for the infinite scroll dropdown
  late PageData<String> _initData;

  /// It handles the selecting value inside the dropdown menu
  void onSelectInput(String selectInput){
    setState(() {
      widget.dropDownController.value = TextEditingValue(text: selectInput);
    });
    this._focusNode.unfocus();
    this._overlayEntry.remove();
  }

  /// It handles any changes inside the overlay
  void changeOverlay(bool isLoading){
    this._overlayEntry.remove();
    this._overlayEntry = this._createOverlayEntry(isLoading);
    Overlay.of(context)?.insert(this._overlayEntry);
  }

  /// It handles any chang inside the input field
  Future onInputChanged(String newValue) async{
    this.changeOverlay(true);
    PageData<String> roles = await widget.fetchMoreData(newValue, 1);
    setState(() {
      this._initData = roles;
    });
    this.changeOverlay(false);
  }

  @override
  void initState() {
    this._initData = widget.initData;
    this._focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry(false);
        Overlay.of(context)?.insert(this._overlayEntry);

      } else {
        if(!this._overlayEntry.mounted){
          this._overlayEntry.remove();
        }
      }
    });
    super.initState();
  }


  /// It creates the overlay menu
  OverlayEntry _createOverlayEntry(bool isLoading) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: isLoading ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              ) : SizedBox(
                height: this._initData.data.length > 0 ? 200 : 40,
                child: this._initData.data.length > 0 ? ZwapInfiniteScroll<String>(
                    mainSizeDirection: 2000,
                    initData: this._initData,
                    scrollController: ScrollController(),
                    axisDirection: Axis.vertical,
                    zwapInfiniteScrollType: ZwapInfiniteScrollType.listView,
                    getChildWidget: (String role) => InkWell(
                      onTap: () => this.onSelectInput(role),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ZwapText(
                          textColor: ZwapColors.shades100,
                          text: role,
                          zwapTextType: ZwapTextType.bodyRegular,
                        ),
                      ),
                    ),
                    waitingWidget: Container(),
                    fetchMoreData: (int pageNumber) => widget.fetchMoreData(widget.dropDownController.text, pageNumber)
                ) : ListView(
                  children: [
                    InkWell(
                      onTap: () => this.onSelectInput(widget.dropDownController.text),
                      child: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), child: ZwapText(
                        text: "${widget.translateText("click_here_to_add")} ${widget.dropDownController.text}",
                        textColor: ZwapColors.shades100,
                        zwapTextType: ZwapTextType.bodyRegular,
                      ),),
                    )
                  ],
                ),
              )
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: ZwapInput(
        inputName: widget.inputName,
        placeholder: widget.placeholderName,
        controller: widget.dropDownController,
        focusNode: this._focusNode,
        onChanged: (String value) => this.onInputChanged(value),
      ),
    );
  }
}