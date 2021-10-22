/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL COMPONENTS KIT
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// The responsive column for the in
class ResponsiveColumnTag extends StatelessWidget implements ResponsiveWidget{

  /// Boolean flag to check if the element is a tag or the add tag button
  final bool checkCondition;

  /// The current element value
  final String? currentElement;

  /// The optionally current element value
  final List<String> suggestedElements;

  /// The current text editing controller for the input widget
  final TextEditingController textEditingController;

  /// The callBack to add a tag to the tag elements added
  final Function(String value) addTagCallBack;

  /// The callBack to remove a tag from the tag elements added
  final Function(String value) removeTagCallBack;

  /// The callBack to view the suggested values
  final Function() switchViewCallBack;

  /// Boolean flag to check if is it adding a tag or not
  final bool isAddingTagCheck;

  /// Boolean flag to check if is it showing the suggested or not
  final bool isShowingSuggested;

  ResponsiveColumnTag({Key? key,
    required this.checkCondition,
    required this.currentElement,
    required this.textEditingController,
    required this.suggestedElements,
    required this.removeTagCallBack,
    required this.switchViewCallBack,
    required this.addTagCallBack,
    required this.isAddingTagCheck,
    required this.isShowingSuggested
  }): super(key: key);

  /// It builds the tag element
  ZwapOpenToTag get openTagElement => ZwapOpenToTag(
    openToTagText: this.checkCondition ? Utils.translatedText("add_tag_text_button") : this.currentElement!,
    tagIcon: this.checkCondition ? Icons.add : Icons.close,
    isLeft: this.checkCondition,
    isClickAble: true,
    callBackClick: (_) => this.checkCondition ? this.switchViewCallBack() : this.removeTagCallBack(this.currentElement!),
  );

  /// It gets the adding list view to select one of them
  Widget _getAddingListView(){
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: ZwapColors.primary300,
        border: Border.all(
          color: ZwapColors.shades100
        ),
      ),
      child: ListView.builder(
          itemCount: suggestedElements.length,
          itemBuilder: (BuildContext context, int index){
            String element = suggestedElements[index];
            return InkWell(
              onTap: () => this.addTagCallBack(element),
              child: Row(
                children: [
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: ZwapText(
                      textColor: ZwapColors.neutral700,
                      text: element,
                      zwapTextType: ZwapTextType.body1Regular,
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  /// It gets the input widget to display the input to add a tag and a suggested list
  Widget _getInputAdd(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: ZwapInput(
            controller: this.textEditingController,
            keyCallBackFunction: (String value) => this.addTagCallBack(value),
          ),
        ),
        this.isShowingSuggested ? this._getAddingListView() : Container()
      ],
    );
  }

  Widget build(BuildContext context){
    return Column(
      children: [
        this.openTagElement,
        this.isAddingTagCheck && this.checkCondition ? Container(
          width: this.openTagElement.getSize(),
          child: this._getInputAdd(),
        ) : Container()
      ],
    );
  }

  double getSize(){
    return this.openTagElement.getSize();
  }


}


/// Custom component to display an adding interaction tag
class ZwapInteractionTag extends StatefulWidget{

  /// The interaction title to display inside the interaction tag element
  final String interactionTitle;

  /// The global tags added to display inside the advices
  final List<String> globalTags;

  ZwapInteractionTag({Key? key,
    required this.interactionTitle,
    required this.globalTags
  }): super(key: key);

  _ZwapInteractionTagState createState() => _ZwapInteractionTagState();

}

/// The state for this custom interaction tag
class _ZwapInteractionTagState extends State<ZwapInteractionTag>{

  /// Is active the view to type and add new tag
  bool _isAddingTag = false;

  /// Is showing the suggested elements to display some suggestions
  bool _isShowingSuggested = false;

  /// The elements added
  List<String> _elements = [];

  /// The text editing controller input to handle the input text to add custom tag
  final TextEditingController _textAddingController = TextEditingController();

  _ZwapInteractionTagState(){
    this._textAddingController.addListener(() => this._showSuggested());
  }

  /// It shows the suggested elements inside a list of values
  void _showSuggested(){
    setState(() {
      this._isShowingSuggested = this._textAddingController.text.trim() != "";
    });
  }

  /// It adds tag to the elements list
  void _addTag(String titleElement){
    this._switchView();
    this._textAddingController.value = TextEditingValue.empty;
    setState(() {
      this._elements.add(titleElement);
    });
  }

  /// It removes tag from the elements list
  void _removeTag(String titleElement){
    setState(() {
      this._elements.remove(titleElement);
    });
  }

  /// It switches from the view to type and add new tag
  void _switchView(){
    setState(() {
      this._isAddingTag = !this._isAddingTag;
    });
  }

  /// It gets the body with added tags and add new tag button
  Widget _getBodyChild(){
    List<String> totalElements = this._elements;
    totalElements.addAll(widget.globalTags);
    return ResponsiveRow<List<Widget>>(
      customInternalPadding: EdgeInsets.only(right: 10, bottom: 10),
      children: List<Widget>.generate(this._elements.length + 1, ((index) =>
          ResponsiveColumnTag(
            checkCondition: this._elements.length == index,
            currentElement: this._elements.length == index ? null : this._elements[index],
            removeTagCallBack: (String value) => this._removeTag(value),
            switchViewCallBack: () => this._switchView(),
            isAddingTagCheck: this._isAddingTag,
            addTagCallBack: (String value) => this._addTag(value),
            isShowingSuggested: this._isShowingSuggested,
            textEditingController: this._textAddingController,
            suggestedElements: totalElements,
          )
      )),
    );
  }

  Widget build(BuildContext context){
    return LayoutBuilder(builder: (builder, context){
      return this._getBodyChild();
    });
  }

}