/// IMPORTING THIRD PARTY PACKAGES
import 'dart:ui';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';

/// The blur component to display some widgets with a blur applied on it
class ZwapBlurComponent extends StatelessWidget{

  /// The blur backed body
  final Widget blurBody;

  /// The body child to apply on top of this blur component
  final Widget bodyChild;

  ZwapBlurComponent({Key? key,
    required this.blurBody,
    required this.bodyChild
  }): super(key: key);

  Widget build(BuildContext context){
    return Stack(
      children: [
        this.blurBody,
        Positioned.fill(
          child: ClipRect(
            child: Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(215, 215, 215, 0.2),
                    borderRadius: BorderRadius.circular(ZwapRadius.popupRadius),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: this.bodyChild,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}