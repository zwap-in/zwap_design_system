import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/toast/zwapToast.dart';

//TODO: move to design_system

/// This components show a **read only** field with a
/// "Copy" action button
///
/// [showToast] decide if a toast should be showed on user copy button click
///
/// [copyText], if provided, override the standard "Copy" text inside copy button
///
/// [toastMessage], if provided, override the standard "Copied" text inside the toast
///
/// Other fields will be added in the future when needed (such as: text style, background color
/// button icon)
class ZwapCopyFieldWidget extends StatelessWidget {
  final String content;
  final String? copyText;
  final String? toastMessage;
  final bool showToast;
  final Function()? onCopy;

  final ZwapTextType? textType;
  final ZwapTextType? buttonType;

  /// If provided and the returned value is not null the returned string
  /// will be used instead of [content]
  final String? Function()? overrideText;

  final double? height;
  final double? radius;

  const ZwapCopyFieldWidget({
    required this.content,
    this.copyText,
    this.toastMessage,
    this.showToast = true,
    this.onCopy,
    this.overrideText,
    this.height,
    this.radius,
    this.textType,
    this.buttonType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _copyText() async {
      if (onCopy != null) await onCopy!();

      final String? _overrideContent = overrideText == null ? null : overrideText!();

      await Clipboard.setData(ClipboardData(text: _overrideContent ?? content));
      ZwapToasts.showSuccessToast(toastMessage ?? "Copied to clipboard", context: context);
    }

    return InkWell(
      onTap: () => _copyText(),
      child: Container(
        height: height ?? 35,
        width: double.infinity,
        decoration: BoxDecoration(color: ZwapColors.neutral100, borderRadius: BorderRadius.circular(radius ?? 8)),
        padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(right: 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                content,
                style: textType?.copyWith(color: ZwapColors.neutral600) ??
                    getTextStyle(ZwapTextType.mediumBodyMedium).copyWith(color: ZwapColors.neutral600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            SizedBox(width: 10),
            ZwapButton(
              buttonChild: ZwapButtonChild.textWithCustomIcon(
                text: copyText ?? "Copy",
                fontWeight: buttonType?.copyWith().fontWeight ?? FontWeight.w500,
                fontSize: buttonType?.copyWith().fontSize?.toInt() ?? 14,
                icon: (status) => ZwapIcons.icons(
                  'copy_clipboard',
                  iconSize: 16,
                  iconColor: ZwapColors.primary700,
                ),
              ),
              width: 130,
              height: height ?? 45,
              decorations: ZwapButtonDecorations.quaternary(
                borderWitdh: 0,
                internalPadding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
                backgroundColor: ZwapColors.whiteTransparent,
                contentColor: ZwapColors.primary700,
              ),
              onTap: () => _copyText(),
            ),
          ],
        ),
      ),
    );
  }
}
