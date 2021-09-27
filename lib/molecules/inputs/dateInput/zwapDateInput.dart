/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import '../classicInput/zwapInput.dart';

import 'picker/zwapDatePicker.dart';

/// The provider state to handle this component
class ZwapDateInputProviderState extends ChangeNotifier{

  /// Is this input opened
  bool isOpen = false;

  /// The text editing controller
  final TextEditingController textEditingController = TextEditingController();

  /// It opens or close the input widget
  void openClose(int? year){
    if(year != null){
      this.textEditingController.value = TextEditingValue(text: year.toString());
    }
    this.isOpen = !this.isOpen;
    notifyListeners();
  }

}

/// Component to handle the input date picker
class ZwapDateInput extends StatelessWidget{

  /// The placeholder text inside this input widget
  final String placeholderText;

  /// The title text for this input date picker widget
  final String titleText;

  ZwapDateInput({Key? key,
    required this.placeholderText,
    required this.titleText,
  }): super(key: key);

  Widget build(BuildContext context){
    return ChangeNotifierProvider<ZwapDatePickerProviderState>(
      create: (context) {
        ZwapDateInputProviderState provider = context.read<ZwapDateInputProviderState>();
        return ZwapDatePickerProviderState(callBack: (int year) => provider.openClose(year), currentYear: 1982);
      },
      builder: (context, child){
        ZwapDateInputProviderState providerDateInput = context.read<ZwapDateInputProviderState>();
        ZwapDatePickerProviderState providerDatePicker = context.read<ZwapDatePickerProviderState>();
        providerDateInput.textEditingController.value = TextEditingValue(text: providerDatePicker.selectedYear.toString());
        return Column(
          children: [
            InkWell(
              onTap: () => providerDateInput.openClose(null),
              child: ZwapInput(
                controller: providerDateInput.textEditingController,
                inputName: this.titleText,
                placeholder: this.placeholderText,
                enableInput: false,
                suffixIcon: Icons.lock_clock,
              ),
            ),
            Consumer<ZwapDateInputProviderState>(
                builder: (context, provider, child){
                  return provider.isOpen ? SizedBox(
                    height: 400,
                    child: ZwapDatePicker(
                      minYear: 1900,
                      maxYear: DateTime.now().year,
                    ),
                  ) : Container();
                }
            )
          ],
        );
      }
    );
  }

}