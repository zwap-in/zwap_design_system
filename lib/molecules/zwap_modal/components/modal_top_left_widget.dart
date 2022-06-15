part of zwap_modal;

enum _NewModalTopLeftWidgetType { backButton }


class NewModalTopLeftWidget extends StatelessWidget {
  final Function()? onTap;
  final BorderRadius borderRadius;
  final double iconSize;
  final Color? iconColor;

  final _NewModalTopLeftWidgetType _type;

  NewModalTopLeftWidget.backButton({
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.iconSize = 24,
    this.iconColor,
  }) : this._type = _NewModalTopLeftWidgetType.backButton;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _NewModalTopLeftWidgetType.backButton:
        return InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: ZwapIcons.icons(
            "arrow_left",
            iconColor: iconColor ?? ZwapColors.shades100,
            iconSize: iconSize,
          ),
        );
    }
  }
}