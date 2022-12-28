/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

enum ZwapToastType {
  success,
  error,
  warning,
  info;

  const ZwapToastType();

  Color get bgColor {
    switch (this) {
      case ZwapToastType.success:
        return ZwapColors.success700;
      case ZwapToastType.error:
        return ZwapColors.warning700;
      case ZwapToastType.warning:
        return ZwapColors.warning400;
      case ZwapToastType.info:
        return ZwapColors.primary200;
    }
  }

  Color get contentColor {
    switch (this) {
      case ZwapToastType.success:
      case ZwapToastType.error:
      case ZwapToastType.warning:
        return ZwapColors.shades0;
      case ZwapToastType.info:
        return ZwapColors.primary900Dark;
    }
  }

  IconData get icon {
    switch (this) {
      case ZwapToastType.success:
        return Icons.check_rounded;
      case ZwapToastType.error:
        return Icons.error_outline_rounded;
      case ZwapToastType.warning:
        return Icons.warning_amber_rounded;
      case ZwapToastType.info:
        return Icons.info_outline_rounded;
    }
  }
}

/// Custom class to show toast message
class ZwapToasts {
  static ZwapToasts? __instance;
  static ZwapToasts get _instance => __instance ??= ZwapToasts._();

  ToastFuture? _lastToast;

  ZwapToasts._();

  @Deprecated("This widget should never be used as it is not optimized, use static methods instead.\nWill be removed in the future")
  static Widget toastWidget(String normalText, bool isError, double width, Function() dismiss) {
    Size size = getTextSize(normalText, ZwapTextType.mediumBodyMedium);
    int line = (size.width / (width - 130)).floor();

    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: isError ? ZwapColors.error400 : ZwapColors.success400,
              boxShadow: [BoxShadow(color: Color.fromRGBO(199, 199, 199, 0.5), blurRadius: 30, spreadRadius: 4, offset: Offset(0, 15))]),
          width: width,
          height: 48 + max(line * 26, 0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ZwapText(text: isError ? '😵' : '✅', zwapTextType: ZwapTextType.mediumBodyMedium, textColor: ZwapColors.shades0),
              SizedBox(width: 20),
              Flexible(
                child: ZwapText(
                  text: normalText,
                  textColor: Colors.white,
                  textAlign: TextAlign.center,
                  zwapTextType: ZwapTextType.mediumBodyMedium,
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

  /// Show a custom ZwapToast
  static void _showToast(
    ZwapToastType type,
    String message, {
    required BuildContext context,
    Duration? duration,
    bool showDismiss = false,
    Function()? onDismiss,
  }) {
    if (_instance._lastToast != null) {
      _instance._lastToast!.dismiss();
    }

    _instance._lastToast = showToastWidget(
      _ZwapToast(
        type: type,
        text: message,
        showDismiss: showDismiss,
        onDismiss: () {
          _instance._lastToast?.dismiss(showAnim: true);
          if (onDismiss != null) onDismiss();
        },
      ),
      duration: duration ?? const Duration(seconds: 3),
      position: ToastPosition.top,
      handleTouch: showDismiss,
      onDismiss: () {
        _instance._lastToast = null;
        if (onDismiss != null) onDismiss();
      },
    );
  }

  /// Show a [ZwapToastType.success] toast
  static void showSuccessToast(
    String message, {
    required BuildContext context,
    Duration? duration,
    bool showDismiss = false,
    Function()? onDismiss,
  }) =>
      _showToast(
        ZwapToastType.success,
        message,
        context: context,
        duration: duration,
        onDismiss: onDismiss,
        showDismiss: showDismiss,
      );

  /// Show a [ZwapToastType.error] toast
  static void showErrorToast(
    String message, {
    required BuildContext context,
    Duration? duration,
    bool showDismiss = true,
    Function()? onDismiss,
  }) =>
      _showToast(
        ZwapToastType.error,
        message,
        context: context,
        duration: duration,
        onDismiss: onDismiss,
        showDismiss: showDismiss,
      );

  /// Show a [ZwapToastType.warning] toast
  static void showWarningToast(
    String message, {
    required BuildContext context,
    Duration? duration,
    bool showDismiss = false,
    Function()? onDismiss,
  }) =>
      _showToast(
        ZwapToastType.warning,
        message,
        context: context,
        duration: duration,
        onDismiss: onDismiss,
        showDismiss: showDismiss,
      );

  /// Show a [ZwapToastType.info] toast
  static void showInfoToast(
    String message, {
    required BuildContext context,
    Duration? duration,
    bool showDismiss = false,
    Function()? onDismiss,
  }) =>
      _showToast(
        ZwapToastType.info,
        message,
        context: context,
        duration: duration,
        onDismiss: onDismiss,
        showDismiss: showDismiss,
      );
}

class _ZwapToast extends StatelessWidget {
  final ZwapToastType type;
  final String text;

  final bool showDismiss;
  final Function() onDismiss;

  const _ZwapToast({
    required this.type,
    required this.text,
    required this.showDismiss,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: ZwapColors.whiteTransparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: min(700, MediaQuery.of(context).size.width - 50)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: type.bgColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, color: type.contentColor, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Transform.translate(
                  offset: const Offset(0, -1),
                  child: ZwapText(
                    text: text,
                    textColor: type.contentColor,
                    zwapTextType: ZwapTextType.mediumBodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (showDismiss) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: onDismiss,
                  child: Icon(Icons.close, color: type.contentColor, size: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
