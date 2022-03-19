/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The data model about any opportunity data
class Opportunity {
  /// The primary pk for this open to tag data model
  final int pk;

  /// The name for this opportunity
  final String opportunityName;

  /// The description for this opportunity
  final String opportunityDescription;

  /// The icon data for this opportunity
  final IconData opportunityIcon;

  /// The color for the icon of this opportunity
  final Color opportunityColor;

  Opportunity({
    required this.pk,
    required this.opportunityName,
    required this.opportunityDescription,
    required this.opportunityIcon,
    required this.opportunityColor,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      pk: json['pk'],
      opportunityName: json['open_to_tag_name'],
      opportunityDescription: json['opportunity_description'],
      opportunityIcon: ZwapFaIcons.getIconFromName(json['icon_name']),
      opportunityColor: ZwapColors.getRandomColor(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Opportunity &&
        other.pk == pk &&
        other.opportunityName == opportunityName &&
        other.opportunityDescription == opportunityDescription &&
        other.opportunityIcon == opportunityIcon &&
        other.opportunityColor == opportunityColor;
  }

  @override
  int get hashCode {
    return pk.hashCode ^ opportunityName.hashCode ^ opportunityDescription.hashCode ^ opportunityIcon.hashCode ^ opportunityColor.hashCode;
  }
}
