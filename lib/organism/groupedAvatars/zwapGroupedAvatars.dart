/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/molecules.dart';

/// The grouped avatar images
class ZwapGroupedAvatars extends StatelessWidget{

  /// Mapping each avatar image with a boolean value to check if is it an external asset or not
  final Map<String, bool> avatarImagePaths;

  /// The number for the max connections to group
  final int maxConnections;

  ZwapGroupedAvatars({Key? key,
    required this.avatarImagePaths,
    this.maxConnections = 3
  }): super(key: key);

  Widget build(BuildContext context){
    List<String> keys = this.avatarImagePaths.keys.toList();
    return Row(
      children: List<Widget>.generate(keys.length, (index) =>
      index - 1 <= this.maxConnections ? Transform.translate(
        offset: Offset(-10.0*index, 0),
        child: ZwapAvatar(
          size: 10,
          imagePath: keys[index],
          isExternal: this.avatarImagePaths[keys[index]]!,
        ),
      ) : Container()
      ),
    );

  }
}