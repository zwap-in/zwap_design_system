/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

import '../classicInput/zwapInput.dart';

/// The state provider to handle the tags inside the zwap input tag
class ZwapInputTagState extends ChangeNotifier {
  /// The list of tags
  final List<String> tags = [];

  /// Add tag to the tags list
  void addTag(String tag) {
    this.tags.add(tag);
    notifyListeners();
  }

  /// Remove tag to the tags list
  void removeTag(String tag) {
    this.tags.remove(tag);
    notifyListeners();
  }
}

/// Widget to insert an input with tag element
class ZwapInputTag extends StatelessWidget {
  /// The validation function for each entry text in tag input
  final TupleType<bool, String> Function(String key) handleValidation;

  /// The hint text
  final String hintText;

  ZwapInputTag(
      {Key? key, required this.handleValidation, required this.hintText})
      : super(key: key);

  /// It retrieves the borderColor in base of the current status
  InputBorder _getInputBorder(ZwapInputStatus status) {
    Color finalColor = ZwapColors.neutral300;
    switch (status) {
      case ZwapInputStatus.defaultStatus:
        break;
      case ZwapInputStatus.disabled:
        finalColor = ZwapColors.neutral200;
        break;
      case ZwapInputStatus.disabledFilled:
        break;
      case ZwapInputStatus.errorStatus:
        finalColor = ZwapColors.error300;
        break;
      case ZwapInputStatus.successStatus:
        finalColor = ZwapColors.success700;
        break;
    }
    OutlineInputBorder inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
            color: Colors.black, width: 1, style: BorderStyle.solid));
    return inputBorder;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ZwapInputTagState>(builder: (context, provider, child) {
      return TextFieldTags(
        textSeparators: [" ", ".", ","],
        tagsStyler: TagsStyler(
          showHashtag: true,
          tagMargin: const EdgeInsets.only(right: 4.0),
          tagCancelIcon: Icon(Icons.cancel, size: 15.0, color: Colors.black),
          tagCancelIconPadding: EdgeInsets.only(left: 4.0, top: 2.0),
          tagPadding:
              EdgeInsets.only(top: 2.0, bottom: 4.0, left: 8.0, right: 4.0),
          tagDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          tagTextStyle:
              TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        textFieldStyler: TextFieldStyler(
          hintText: this.hintText,
          isDense: false,
          textFieldDisabledBorder:
              this._getInputBorder(ZwapInputStatus.disabledFilled),
          textFieldBorder: this._getInputBorder(ZwapInputStatus.defaultStatus),
        ),
        onDelete: (tag) {
          provider.removeTag(tag);
        },
        onTag: (tag) {
          provider.addTag(tag);
        },
        validator: (String tag) {
          TupleType<bool, String> validation = this.handleValidation(tag);
          if (!validation.a) {
            return validation.b;
          }
          return null;
        },
      );
    });
  }
}
