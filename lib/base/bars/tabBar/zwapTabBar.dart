/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// Custom tab bar
class ZwapTabBar extends StatefulWidget {

  /// The tab elements
  final Map<Tab, Widget> tabElements;

  /// The app bar inside this custom tab bar
  final Widget appBar;

  /// The custom bottom menu
  final Widget? customBottomMenu;

  /// On change tab callBack function
  final Function(int index) onChangeTabController;

  ZwapTabBar({Key? key,
    required this.tabElements,
    required this.appBar,
    required this.onChangeTabController,
    this.customBottomMenu,
  }): super(key: key);


  @override
  _ZwapTabControllerState createState() => _ZwapTabControllerState();

}
/// Custom tab bar state
class _ZwapTabControllerState extends State<ZwapTabBar> with SingleTickerProviderStateMixin{

  /// Tab controller to handle the change inside the tabBar
  late TabController tabController;

  void initState() {
    this.tabController = TabController(length: widget.tabElements.length, vsync: this, initialIndex: 0);
    this.tabController.addListener(()  => this.tabController.indexIsChanging ? widget.onChangeTabController(this.tabController.index) : {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabElements.length,
      child: Scaffold(
        bottomNavigationBar: widget.customBottomMenu != null ? new Theme(
          data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent
          ),
          child: widget.customBottomMenu!,
        ) : null,
          appBar: AppBar(
            backgroundColor: DesignColors.scaffoldColor,
            bottom: TabBar(
              controller: this.tabController,
              tabs: widget.tabElements.keys.toList(),
            ),
            title: widget.appBar,
          ),
        body: TabBarView(
          controller: this.tabController,
          children: widget.tabElements.values.toList(),
        ),
      ),
    );
  }



}