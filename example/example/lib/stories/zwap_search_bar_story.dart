import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';
import 'package:zwap_design_system/molecules/search_bar/zwap_search_bar.dart';

class ZwapSearchBarStory extends StatefulWidget {
  const ZwapSearchBarStory({Key? key}) : super(key: key);

  @override
  State<ZwapSearchBarStory> createState() => _ZwapSearchBarStoryState();
}

class _ZwapSearchBarStoryState extends State<ZwapSearchBarStory> {
  final GlobalKey _containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: _containerKey,
          width: double.infinity,
          height: 24,
          color: ZwapColors.warning300,
          child: Center(
            child: ZwapText(
              key: ValueKey(MediaQuery.of(context).size.width), 
              text: '${_containerKey.globalPaintBounds?.width}',
              textColor: ZwapColors.neutral900,
              zwapTextType: ZwapTextType.mediumBodyBold,
            ),
          ),
        ),
        SizedBox(height: 120),
        Flexible(child: ZwapSearchBar()),
      ],
    );
  }
}
