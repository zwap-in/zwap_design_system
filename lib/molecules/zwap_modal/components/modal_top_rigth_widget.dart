part of zwap_modal;

enum _NewModalTopRightWidgetType { close }

class NewModalTopRightWidget extends StatelessWidget {
  final Function()? onClose;
  final BorderRadius borderRadius;
  /// Default from [ZwapComponentsTheme], then [ZwapColors.neutral400]
  final Color? iconColor;

  final _NewModalTopRightWidgetType _type;

  NewModalTopRightWidget.closeButton({
    this.onClose,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.iconColor,
  }) : this._type = _NewModalTopRightWidgetType.close;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _NewModalTopRightWidgetType.close:
        return InkWell(
          onTap: this.onClose != null ? () => this.onClose!() : () => {},
          borderRadius: borderRadius,
          child: ZwapIcons.icons(
            "close",
            iconColor: iconColor ?? ZwapComponentsTheme.maybeOf(context)?.modalIconColor ?? ZwapColors.neutral400,
          ),
        );
    }
  }
}
