/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/text/zwapText.dart';

/// ProviderNotifier to handle the checkbox state
class ZwapClassicCheckBoxState extends ChangeNotifier{

  /// The state value
  bool value;

  ZwapClassicCheckBoxState({this.value = false});

  /// Handling the changing of this value
  void changeValue(bool newValue){
    this.value = newValue;
    notifyListeners();
  }

}

/// Custom widget to render a custom checkbox
class ZwapClassicCheckBox extends StatelessWidget {

  /// The label text as widget inside this classic checkbox component
  final ZwapText labelText;

  ZwapClassicCheckBox({Key? key,
    required this.labelText
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapClassicCheckBoxState>(
      builder: (builder, provider, child){
        return CheckboxListTile(
          value: provider.value,
          onChanged: (dynamic newValue) => provider.changeValue(newValue),
          title: this.labelText,
        );
      }
    );
  }

}