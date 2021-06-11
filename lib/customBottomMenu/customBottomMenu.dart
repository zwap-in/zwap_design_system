/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// The custom bottom bar for logged screen
class CustomBottomMenu extends StatelessWidget{

  /// The bottom navigation bar items
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  CustomBottomMenu({
    Key? key,
    required this.bottomNavigationBarItems
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
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: this.bottomNavigationBarItems,
          ),
      )
    );
  }

}