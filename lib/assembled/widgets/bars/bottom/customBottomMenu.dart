/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The custom bottom bar for logged screen
class CustomBottomMenu extends StatelessWidget{

  /// The bottom navigation bar items
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  /// The callBack to change index of the bottom menu
  final Function(int newIndex) changeIndex;

  /// The current index inside the bottom menu
  final int currentIndex;

  CustomBottomMenu({Key? key,
    required this.bottomNavigationBarItems,
    required this.changeIndex,
    required this.currentIndex
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
          child: BottomNavigationBar(
            currentIndex: this.currentIndex,
            onTap: (int index) => this.changeIndex(index),
            items: this.bottomNavigationBarItems,
          ),
      )
    );
  }

}