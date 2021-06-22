/// IMPORTING THIRD PARTY COMPONENTS
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to show an image with text on bottom all inside a card with fixed dimensions
class ImageCard extends StatelessWidget {

  /// The image path asset
  final String imagePath;

  /// The card title
  final String textCard;

  /// Is this icon an internal asset
  final bool? isInternalAsset;

  ImageCard({Key? key,
    required this.imagePath,
    required this.textCard,
    this.isInternalAsset,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SizedBox(
      child: CustomCard(
        childComponent: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: CustomAsset(
                assetPathUrl: this.imagePath,
                isInternal: this.isInternalAsset ?? false,
              ),
            ),
            BaseText(
              texts: [this.textCard],
              baseTextsType: [BaseTextType.normal],
              textAlignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}
