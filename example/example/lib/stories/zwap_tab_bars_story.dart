import 'package:flutter/material.dart';
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
        onTabChanges: (tab) => setState(() => _selected = tab),
      ),
    );
  }
}
