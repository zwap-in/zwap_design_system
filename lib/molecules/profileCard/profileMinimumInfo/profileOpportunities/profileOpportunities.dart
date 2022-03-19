/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/objects/objects.dart';

import 'package:zwap_design_system/molecules/moleculesText/smallTitle/zwapSmallTitle.dart';
import 'package:zwap_design_system/molecules/openToTag/zwapOpenToTag.dart';


/// The opportunities for this profile
class ProfileOpportunities extends StatelessWidget {
  /// The opportunities owned by the user
  final Map<Opportunity, bool> opportunities;

  ProfileOpportunities({
    Key? key,
    required this.opportunities,
  }) : super(key: key);

  /// It renders the opportunities column list
  Widget _buildOpportunitiesColumn(BuildContext context) {
    List<Opportunity> keys = this.opportunities.keys.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: ZwapSmallTitle(
            title: Utils.translatedText("profile_open_to_tags_title"),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Wrap(
            spacing: 4,
            runSpacing: 7,
            children: List<Widget>.generate(
              keys.length,
              ((index) => ZwapOpenToTag(
                    openToTagText: keys[index].opportunityName,
                    tagIcon: keys[index].opportunityIcon,
                    callBackClick: (String opportunityName) => {},
                    isClickAble: false,
                  )),
            ),
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return this.opportunities.keys.length > 0
        ? LayoutBuilder(builder: (item, constraints) {
      return _buildOpportunitiesColumn(item);
    })
        : Container();
  }
}
