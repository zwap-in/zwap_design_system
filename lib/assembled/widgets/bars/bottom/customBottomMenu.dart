/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Custom bottom menu state for this widget
class CustomBottomMenuState extends ChangeNotifier{

  /// The current index
  int currentIndex;

  CustomBottomMenuState({required this.currentIndex});

  /// Change the index inside the bottom menu
  void changeIndex(int newIndex){
    this.currentIndex = newIndex;
    notifyListeners();
  }

}

/// The custom bottom bar for logged screen
class CustomBottomMenu extends StatelessWidget{

  /// The bottom navigation bar items
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  /// The provider to handle the state of the data
  final CustomBottomMenuState provider;

  CustomBottomMenu({Key? key,
    required this.bottomNavigationBarItems,
    required this.provider,
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
            currentIndex: this.provider.currentIndex,
            onTap: (int index) => this.provider.changeIndex(index),
            items: this.bottomNavigationBarItems,
          ),
      )
    );
  }

}