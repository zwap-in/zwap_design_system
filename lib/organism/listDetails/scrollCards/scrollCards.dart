/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

import '../providerState/providerState.dart';

/// It builds the scroll cards list with each element
class ScrollCards<T> extends StatelessWidget{

  /// It gets the widget card
  final Widget Function(T element, bool isSelected) getCard;

  ScrollCards({Key? key,
    required this.getCard,
  }): super(key: key);

  /// It gets each section elements divided by date
  Widget _daySection(DateTime day, ListDetailsProvideState<T> provider){
    List<T> mappingElements = provider.elements[day]!.keys.toList();
    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    String title = today == day ? Utils.translatedText("today") : "${Utils.translatedText(Constants.weekDayAbbrName()[day.weekday]!)}, ${day.day} ${Utils.translatedText(Constants.monthlyAbbrName()[day.month]!)}";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: ZwapText(
              textColor: ZwapColors.shades100,
              text: title,
              zwapTextType: ZwapTextType.h3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List<Widget>.generate(mappingElements.length, ((index) {
                Widget newBody = this.getCard(mappingElements[index], provider.elements[day]![mappingElements[index]]!);
                return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () => provider.selectElement(day, mappingElements[index], getMultipleConditions(null, null, newBody, newBody, newBody)),
                    child: newBody,
                  ),
                );
              })
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ListDetailsProvideState<T> provider = context.read<ListDetailsProvideState<T>>();
    List<DateTime> keysDateTime = provider.elements.keys.toList();
    return ZwapVerticalScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(keysDateTime.length, ((index) => this._daySection(keysDateTime[index], provider))),
        )
    );
  }



}