/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Component for range slider
class ZwapRangeSlider extends StatefulWidget{

  /// The title inside this range slider
  final String title;

  /// The callBack function to handle change inside the range values
  final Function(RangeValues rangeValues) handleChangeRange;

  ZwapRangeSlider({Key? key,
    required this.title,
    required this.handleChangeRange,
  }): super(key: key);

  _ZwapRangeSliderState createState() => _ZwapRangeSliderState();

}

/// The state for this component
class _ZwapRangeSliderState extends State<ZwapRangeSlider>{

  /// The current range value
  RangeValues _currentRangeValues = const RangeValues(18, 60);

  /// It changes the current value for this range values component
  void onChange(RangeValues newValues){
    widget.handleChangeRange(newValues);
    setState(() {
      this._currentRangeValues = newValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: ZwapText(
                  text: widget.title,
                  zwapTextType: ZwapTextType.bodySemiBold,
                  textColor: ZwapColors.neutral800,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ZwapText(
                        text: "${this._currentRangeValues.start.toInt()} - ${this._currentRangeValues.end.toInt()}",
                        textColor: ZwapColors.neutral600,
                        zwapTextType: ZwapTextType.bodyRegular,
                      ),
                      fit: FlexFit.tight,
                      flex: 0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: RangeSlider(
            values: this._currentRangeValues,
            min: 18,
            max: 60,
            divisions: 42,
            activeColor: ZwapColors.primary700,
            inactiveColor: ZwapColors.neutral200,
            labels: RangeLabels(
              this._currentRangeValues.start.round().toString(),
              this._currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              this.onChange(values);
            },
          ),
        )
      ],
    );
  }



}