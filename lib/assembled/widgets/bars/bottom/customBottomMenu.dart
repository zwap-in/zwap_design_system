/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomBottomMenuState extends ChangeNotifier{

  int _currentIndex = 0;

  void changeIndex(int newIndex){
    this._currentIndex = newIndex;
    notifyListeners();
  }

  int get index => this._currentIndex;

}

/// The custom bottom bar for logged screen
class CustomBottomMenu extends StatelessWidget{

  /// The bottom navigation bar items
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

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
            currentIndex: this.provider.index,
            onTap: (int index) => this.provider.changeIndex(index),
            items: this.bottomNavigationBarItems,
          ),
      )
    );
  }

}