import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/molecules/tabBar/chips_tab_bar/chips_tab_bar.dart';
import 'package:zwap_design_system/molecules/tabBar/tabBar.dart';

enum Ciao { a, b, c }

class ZwapTabBarsStory extends StatefulWidget {
  const ZwapTabBarsStory({Key? key}) : super(key: key);

  @override
  State<ZwapTabBarsStory> createState() => _ZwapTabBarsStoryState();
}

class _ZwapTabBarsStoryState extends State<ZwapTabBarsStory> {
  final List<String> _tabs = ['one', 'two', 'three', 'four'];
  String _selected = 'one';
  Ciao? _selectedChip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZwapPrimaryTabBar(
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
          SizedBox(height: 40),
          ZwapPrimaryTabBar(
            selected: _selected,
            tabs: _tabs,
            textType: ZwapTextType.semiboldH3,
            textColor: ZwapColors.primary900Dark,
            notSelectedTextType: ZwapTextType.semiboldH3,
            notSelectedTextColor: ZwapColors.text65,
            selectedThickness: 2,
            tabWidth: 110,
            thickness: 1,
            onTabChanges: (tab) => setState(() => _selected = tab),
            roundTabIndicator: false,
          ),
          SizedBox(height: 40),
          ChipsTabBar<Ciao>(
            items: Ciao.values,
            translateItem: (i) => '${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}',
            onTabSelected: (i) {
              setState(() => _selectedChip = i);
            },
            selectedTab: _selectedChip,
          ),
          SizedBox(height: 40),
          ChipsTabBar<Ciao>(
            items: Ciao.values,
            translateItem: (i) => '${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}${i.name}',
            onTabSelected: (i) {
              setState(() => _selectedChip = i);
            },
            selectedTab: _selectedChip,
            selectedTabTextStyle: getTextStyle(ZwapTextType.smallBodyBold),
          ),
        ],
      ),
    );
  }
}
