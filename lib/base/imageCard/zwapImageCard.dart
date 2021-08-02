/// IMPORTING THIRD PARTY COMPONENTS
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/media/media.dart';
import 'package:zwap_design_system/base/card/zwapCard.dart';

/// Custom widget to show an image with text on bottom all inside a card with fixed dimensions
class ZwapImageCard extends StatelessWidget {

  /// The image path asset
  final String imagePath;

  /// The card title
  final String textCard;

  /// Is this card selected?
  final bool isSelected;

  /// Is this icon an internal asset
  final bool? isInternalAsset;

  ZwapImageCard({Key? key,
    required this.imagePath,
    required this.textCard,
    required this.isSelected,
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
      child: ZwapCard(
        borderColor: this.isSelected ? DesignColors.pinkyPrimary : Colors.transparent,
        childComponent: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: ZwapAsset(
                assetPathUrl: this.imagePath,
                isInternal: this.isInternalAsset ?? false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ZwapText(
                texts: [this.textCard],
                baseTextsType: [ZwapTextType.normal],
                textAlignment: Alignment.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
