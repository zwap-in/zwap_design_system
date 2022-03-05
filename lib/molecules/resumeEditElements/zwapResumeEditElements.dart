/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom popup to edit the social links related to this user
class ResumeEditElements<T> extends StatelessWidget {
  /// The elements list to display inside this view
  final List<T> elements;

  /// The function to retrieve the widget element in this custom list view
  final Widget Function(T element) getElementWidget;

  /// The callBack function to handle the add button click
  final Function() addElementCallBackClick;

  ResumeEditElements({Key? key, required this.elements, required this.getElementWidget, required this.addElementCallBackClick}) : super(key: key);

  /// It gets the elements list view
  Widget _getElementsListView() {
    return Column(
      children: List<Widget>.generate(this.elements.length, ((int index) => this.getElementWidget(this.elements[index]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapButton(
            decorations: ZwapButtonDecorations.quaternary(),
            buttonChild: ZwapButtonChild.text(text: Utils.translatedText("add_button")),
            onTap: () => this.addElementCallBackClick(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ZwapVerticalScroll(
            child: this._getElementsListView(),
          ),
        )
      ],
    );
  }
}
