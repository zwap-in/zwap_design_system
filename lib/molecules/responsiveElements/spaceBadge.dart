/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

import 'package:zwap_design_system/objects/objects.dart';

/// Responsive component for the badge for the membership
class SpaceBadge extends StatelessWidget implements ResponsiveWidget {

  /// The image path for this space membership
  final Membership space;

  /// The size for the space membership
  final double size;

  SpaceBadge({Key? key, required this.space, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: space.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Image(
          image: NetworkImage(space.brandImage),
          height: this.size,
          width: this.size,
        ),
      ),
    );
  }

  @override
  double getSize() {
    return this.size;
  }
}