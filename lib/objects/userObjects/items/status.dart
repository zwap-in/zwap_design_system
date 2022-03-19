/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The data model for any status data
class StatusModel {
  /// The status pk
  final int pk;

  /// The status name
  final String statusName;

  /// The iconData for this status
  final IconData iconData;

  /// The color for this status
  final Color statusColor;

  StatusModel({required this.pk, required this.statusName, required this.iconData, required this.statusColor});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
        pk: json['pk'],
        statusName: json['status_name'],
        iconData: ZwapFaIcons.getIconFromName(json['status_icon']) ?? ZwapFaIcons.getIconFromName("ad"),
        statusColor: ZwapColors.getRandomColor());
  }

  @override
  operator ==(Object other) {
    return other is StatusModel && other.statusName == statusName;
  }

  @override
  int get hashCode => statusName.hashCode;
}
