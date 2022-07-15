import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/molecules/tabBar/tabBar.dart';

class ZwapTabBarsStory extends StatefulWidget {
  const ZwapTabBarsStory({Key? key}) : super(key: key);

  @override
  State<ZwapTabBarsStory> createState() => _ZwapTabBarsStoryState();
}

class _ZwapTabBarsStoryState extends State<ZwapTabBarsStory> {
  final List<String> _tabs = ['one', 'two', 'three', 'four'];
  String _selected = 'one';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZwapPrimaryTabBar(
        selected: _selected,
        tabs: _tabs,
        textType: ZwapTextType.semiboldH3,
        textColor: ZwapColors.primary900Dark,
        notSelectedTextType: ZwapTextType.semiboldH3,
        notSelectedTextColor: ZwapColors.text65,
        thickness: 1,
        selectedThickness: 2,
        tabWidth: 85,
        onTabChanges: (tab) => setState(() => _selected = tab),
      ),
    );
  }
}
