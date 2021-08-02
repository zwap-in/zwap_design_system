/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import '../classic/zwapButton.dart';

/// The state for the row buttons
class ZwapRowButtonsState extends ChangeNotifier{

  /// Selected button
  int selected;

  ZwapRowButtonsState({required this.selected}){
    assert(this.selected >= 0 && this.selected < 2, "selected value must be 0 or 1");
  }

  /// Handle click on some button
  void handleClick(int newSelected){
    this.selected = newSelected;
    notifyListeners();
  }

}

/// The row buttons widget to display two side buttons
class ZwapRowButtons extends StatelessWidget{

  /// The label text on the left button
  final String leftLabelText;

  /// The label text on the right button
  final String rightLabelText;

  ZwapRowButtons({Key? key,
    required this.leftLabelText,
    required this.rightLabelText
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapRowButtonsState>(
      builder: (builder, provider, child){
        return Row(
          children: [
            Flexible(
              child: ZwapButton(
                isAttachedRight: true,
                buttonTypeStyle: provider.selected == 0 ? ZwapButtonType.pinkyButton : ZwapButtonType.greyButton,
                buttonText: this.leftLabelText,
                onPressedCallback: () => provider.handleClick(0),
              ),
              flex: 0,
            ),
            Flexible(
              child: ZwapButton(
                isAttachedLeft: true,
                buttonTypeStyle: provider.selected == 1 ? ZwapButtonType.pinkyButton : ZwapButtonType.greyButton,
                buttonText: this.rightLabelText,
                onPressedCallback: () => provider.handleClick(1),
              ),
              flex: 0,
            )
          ],
        );
      }
    );
  }



}