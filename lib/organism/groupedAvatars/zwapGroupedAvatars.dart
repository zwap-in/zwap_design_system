/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/molecules.dart';

/// The grouped avatar images
class ZwapGroupedAvatars extends StatelessWidget{

  /// Mapping each avatar image with a boolean value to check if is it an external asset or not
  final Map<String, bool> avatarImagePaths;

  ZwapGroupedAvatars({Key? key,
    required this.avatarImagePaths
  }): super(key: key);

  Widget build(BuildContext context){
    List<String> keys = this.avatarImagePaths.keys.toList();
    return Row(
      children: List<Widget>.generate(keys.length, (index) =>
        Transform.translate(
          offset: Offset(-30.0*index, 0),
          child: ZwapAvatar(
            imagePath: keys[index],
            isExternal: this.avatarImagePaths[keys[index]]!,
          ),
        )
      ),
    );

  }
}