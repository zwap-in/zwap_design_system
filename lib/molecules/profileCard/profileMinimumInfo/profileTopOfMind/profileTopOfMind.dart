/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/molecules/molecules.dart';

/// The top of mind section
class ProfileTopOfMind extends StatefulWidget {

  /// The optionally text for the topOfMind value
  final String? topOfMind;

  ProfileTopOfMind({Key? key, required this.topOfMind}) : super(key: key);

  @override
  State<ProfileTopOfMind> createState() => _ProfileTopOfMindState();
}

class _ProfileTopOfMindState extends State<ProfileTopOfMind> {

  @override
  Widget build(BuildContext context) {
    return this.widget.topOfMind != null && this.widget.topOfMind!.trim() != ""
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: ZwapSmallTitle(
            title: Utils.translatedText("profile_top_of_mind_title"),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: new ZwapLongText(
              text: this.widget.topOfMind!,
              readMoreText: " ${Utils.translatedText("profile_bio_expander")}",
              readLessText: " ${Utils.translatedText("profile_bio_cropped")}",
              maxChars: 200,
            ))
      ],
    )
        : Container();
  }
}
