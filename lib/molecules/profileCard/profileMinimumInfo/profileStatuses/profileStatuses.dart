/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

import 'package:zwap_design_system/objects/objects.dart';

import 'subComponents/statusesList.dart';


class ProfileStatuses extends StatelessWidget {

  /// The opportunities owned by the user
  final List<StatusModel> statuses;

  ProfileStatuses({Key? key, required this.statuses}) : super(key: key);

  Widget build(BuildContext context) {
    return this.statuses.length > 0
        ? LayoutBuilder(
      builder: (item, constraints) {
        return StatusesListWidget(
          statuses: statuses,
          onStatusTap: (dynamic status) => Utils.currentState.goToScreen("/status/${status.statusName}", context, {}),
        );
      },
    )
        : Container();
  }
}
