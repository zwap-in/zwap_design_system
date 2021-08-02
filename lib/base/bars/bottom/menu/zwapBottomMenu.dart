/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Handle the state inside the zwap bottom
class ZwapBottomMenuState extends ChangeNotifier{

  /// The current index inside the bottom menu
  int currentIndex = 0;

  void changeIndex(int newIndex){
    this.currentIndex = newIndex;
    notifyListeners();
  }

}

/// The custom bottom menu bar
class ZwapBottomMenu extends StatelessWidget{

  /// The bottom navigation bar items
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  ZwapBottomMenu({Key? key,
    required this.bottomNavigationBarItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30)
          ),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.09339488297700882),
                offset: Offset(0,-4),
                blurRadius: 42
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Consumer<ZwapBottomMenuState>(
            builder: (builder, provider, child){
              return BottomNavigationBar(
                currentIndex: provider.currentIndex,
                onTap: (int index) => provider.changeIndex(index),
                items: this.bottomNavigationBarItems,
              );
            }
          ),
      )
    );
  }

}