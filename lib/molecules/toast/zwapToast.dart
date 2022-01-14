/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom class to show toast message
class ZwapToasts {
  static Widget toastWidget(String normalText, bool isError, double width, Function() dismiss) {
    Size size = getTextSize(normalText, ZwapTextType.h3);
    int line = (size.width / (width - 130)).floor();

    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: isError ? ZwapColors.error400 : ZwapColors.success700, boxShadow: [BoxShadow(color: Color.fromRGBO(199, 199, 199, 0.5), blurRadius: 30, spreadRadius: 4, offset: Offset(0, 15))]),
          width: width,
          height: 48 + max(line * 26, 0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ZwapText(text: isError ? '😵' : '✅', zwapTextType: ZwapTextType.bodySemiBold, textColor: ZwapColors.shades0),
              SizedBox(width: 20),
              Expanded(
                child: ZwapText(
                  text: normalText,
                  textColor: Colors.white,
                  textAlign: TextAlign.center,
                  zwapTextType: ZwapTextType.h3,
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => dismiss(),
                child: Icon(Icons.close, color: ZwapColors.shades0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// It shows the modal
  static void showSuccessToast(String meetingConfirmedText, {Duration? duration, required BuildContext context}) {
    final double _width = min(350, MediaQuery.of(context).size.width * 0.8);

    ToastFuture? _toast;

    _toast = showToastWidget(
      ZwapToasts.toastWidget(meetingConfirmedText, false, _width, () => _toast?.dismiss(showAnim: true)),
      duration: duration ?? const Duration(seconds: 3),
      position: ToastPosition.top,
      handleTouch: true,
    );
  }

  /// It shows an error toast message
  static void showErrorToast(String errorToastMessage, {Duration? duration, required BuildContext context}) {
    final double _width = min(350, MediaQuery.of(context).size.width * 0.8);
    ToastFuture? _toast;

    _toast = showToastWidget(
      ZwapToasts.toastWidget(errorToastMessage, true, _width, () => _toast?.dismiss(showAnim: true)),
      duration: duration ?? const Duration(seconds: 3),
      position: ToastPosition.top,
      handleTouch: true,
    );
  }
}
