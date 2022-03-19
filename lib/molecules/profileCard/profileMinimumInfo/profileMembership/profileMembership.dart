import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

import 'package:zwap_design_system/objects/objects.dart';

import 'package:zwap_design_system/molecules/moleculesText/smallTitle/zwapSmallTitle.dart';
import 'package:zwap_design_system/molecules/responsiveElements/spaceBadge.dart';

class ProfileMembership extends StatelessWidget {

  final List<Membership> spaces;

  ProfileMembership({Key? key, required this.spaces}) : super(key: key);

  Widget _getSpaces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapSmallTitle(title: Utils.translatedText("profile_space_title")),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ResponsiveRow<List<Widget>>(
            customInternalPadding: const EdgeInsets.only(right: 10, bottom: 10),
            children: List<Widget>.generate(spaces.length, ((index) => SpaceBadge(space: spaces[index]))),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (item, constraints) {
      return _getSpaces();
    });
  }
}
