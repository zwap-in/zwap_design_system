/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// The component to
class ZwapMultiSelectTag extends StatelessWidget {

  final Function() onRemove;

  final String label;

  ZwapMultiSelectTag({
    required this.onRemove,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "$label",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  color: Colors.black26,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}