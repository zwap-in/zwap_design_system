part of zwap_tutorial_overlay;

class ZwapTutorialStepContent {
  final Widget? _leading;
  final String? _subtitle;
  final String? _title;
  final Widget Function(BuildContext)? _customChild;

  bool get _isCustomChild => _customChild != null;
  final bool _isCustomContent;

  ZwapTutorialStepContent({
    Widget? leading,
    required String title,
    String? subtitle,
  })  : this._leading = leading,
        this._title = title,
        this._subtitle = subtitle,
        this._isCustomContent = false,
        this._customChild = null;

  ZwapTutorialStepContent.customContent({required Widget Function(BuildContext) builder})
      : this._leading = null,
        this._title = null,
        this._subtitle = null,
        this._isCustomContent = true,
        this._customChild = builder;

  ZwapTutorialStepContent.customChild({required Widget Function(BuildContext) builder})
      : this._leading = null,
        this._title = null,
        this._subtitle = null,
        this._isCustomContent = false,
        this._customChild = builder;
}
