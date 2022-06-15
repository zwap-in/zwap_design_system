part of zwap_modal;

enum _NewModalBottomWidgetType { loading, singleButton, doubleButton }

class NewModalBottomWidget extends StatelessWidget {
  final _NewModalBottomWidgetType _type;

  final Function()? onTapButton;
  final Function()? onTapSecondButton;

  final String? buttonText;
  final String? secondButtonText;

  final bool enabled;
  final bool secondEnabled;

  final Color? loaderColor;

  NewModalBottomWidget.loader({
    required this.loaderColor,
    Key? key,
  })  : assert(loaderColor != null, "A loader widget must have a not null color"),
        this._type = _NewModalBottomWidgetType.loading,
        this.onTapButton = null,
        this.onTapSecondButton = null,
        this.buttonText = null,
        this.secondButtonText = null,
        this.enabled = false,
        this.secondEnabled = false,
        super(key: key);

  /// All value must be not null
  NewModalBottomWidget.singleButton({
    required this.buttonText,
    required this.onTapButton,
    this.enabled = true,
    Key? key,
  })  : assert(buttonText != null),
        this._type = _NewModalBottomWidgetType.singleButton,
        this.loaderColor = null,
        this.onTapSecondButton = null,
        this.secondButtonText = null,
        this.secondEnabled = false,
        super(key: key);

  NewModalBottomWidget.doubleButton({
    required this.buttonText,
    required this.onTapButton,
    required this.onTapSecondButton,
    required this.secondButtonText,
    this.enabled = true,
    this.secondEnabled = true,
    Key? key,
  })  : assert(buttonText != null && secondButtonText != null),
        this._type = _NewModalBottomWidgetType.doubleButton,
        this.loaderColor = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _NewModalBottomWidgetType.loading:
        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(loaderColor)));
      case _NewModalBottomWidgetType.singleButton:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 7),
          child: ZwapButton(
            width: double.infinity,
            height: 50,
            buttonChild: ZwapButtonChild.text(text: buttonText!),
            decorations: ZwapButtonDecorations.primaryLight(internalPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
            disabled: !enabled,
            onTap: enabled ? onTapButton : null,
          ),
        );
      case _NewModalBottomWidgetType.doubleButton:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: ZwapButton(
                width: double.infinity,
                height: 50,
                buttonChild: ZwapButtonChild.text(text: buttonText!),
                decorations: ZwapButtonDecorations.primaryLight(internalPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                disabled: !enabled,
                onTap: enabled ? onTapButton : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: ZwapButton(
                width: double.infinity,
                height: 50,
                buttonChild: ZwapButtonChild.text(text: secondButtonText!),
                decorations: ZwapButtonDecorations.tertiary(internalPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                disabled: !enabled,
                onTap: secondEnabled ? onTapSecondButton : null,
              ),
            ),
          ],
        );
    }
  }
}
