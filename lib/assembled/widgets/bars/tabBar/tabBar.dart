/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/base.dart';

/// Custom tab bar to display tab slides
class CustomTabBar extends StatelessWidget{

  /// The tab elements
  final Map<Tab, Widget> tabElements;

  /// The app bar inside this custom tab bar
  final Widget appBar;

  /// The custom bottom menu
  final Widget? customBottomMenu;

  CustomTabBar({Key? key,
    required this.tabElements,
    required this.appBar,
    this.customBottomMenu,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: this.tabElements.length,
      child: Scaffold(
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent
            ),
            child: this.customBottomMenu!,
          ),
          appBar: AppBar(
            backgroundColor: DesignColors.scaffoldColor,
            bottom: TabBar(
              tabs: this.tabElements.keys.toList(),
            ),
            title: this.appBar,
          ),
        body: TabBarView(
          children: this.tabElements.values.toList(),
        ),
      ),
    );
  }



}