part of weekly_calendar_picker;

class WeeklyCalendarPickerDatSlotWidget extends StatefulWidget {
  final bool _isCustomChild;
  final Widget Function(BuildContext)? _childBuilder;

  final bool disabled;
  final bool hovered;
  final bool selected;

  final String content;

  final double height;
  final double width;

  final Function()? callback;
  final Function()? disabledCallback;

  final Function(bool)? onHoverChange;

  final WCPDateSlotWidgetDecorations decorations;

  WeeklyCalendarPickerDatSlotWidget({
    required this.content,
    this.decorations = const WCPDateSlotWidgetDecorations.standard(),
    this.disabled = false,
    this.hovered = false,
    this.selected = false,
    this.height = 35,
    this.width = 55,
    this.callback,
    this.disabledCallback,
    this.onHoverChange,
    Key? key,
  })  : this._isCustomChild = false,
        this._childBuilder = null,
        super(key: key);

  WeeklyCalendarPickerDatSlotWidget.customChild({
    required Widget Function(BuildContext) builder,
    this.decorations = const WCPDateSlotWidgetDecorations.standard(),
    this.disabled = false,
    this.hovered = false,
    this.selected = false,
    this.height = 35,
    this.width = 55,
    this.callback,
    this.disabledCallback,
    this.onHoverChange,
    Key? key,
  })  : this.content = '',
        this._isCustomChild = true,
        this._childBuilder = builder,
        super(key: key);

  @override
  State<WeeklyCalendarPickerDatSlotWidget> createState() => _WeeklyCalendarPickerDatSlotWidgetState();
}

class _WeeklyCalendarPickerDatSlotWidgetState extends State<WeeklyCalendarPickerDatSlotWidget> {
  WCPDateSlotWidgetDecorations get _decorations => widget.decorations;

  late bool _disabled;
  late bool _hovered;
  late bool _selected;

  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();

    _disabled = widget.disabled;
    _hovered = widget.hovered;
    _selected = widget.selected;
    _width = widget.width;
    _height = widget.height;
  }

  @override
  void didUpdateWidget(covariant WeeklyCalendarPickerDatSlotWidget oldWidget) {
    if (_disabled != widget.disabled) setState(() => _disabled = widget.disabled);
    if (_hovered != widget.hovered) setState(() => _hovered = widget.hovered);
    if (_selected != widget.selected) setState(() => _selected = widget.selected);
    if (_width != widget.width) setState(() => _width = widget.width);
    if (_height != widget.height) setState(() => _height = widget.height);

    super.didUpdateWidget(oldWidget);
  }

  Border? get _border => _selected
      ? _disabled
          ? _decorations.selectedBorder.diasabled
          : _hovered
              ? _decorations.selectedBorder.hovered
              : _decorations.selectedBorder.standard
      : _disabled
          ? _decorations.notSelectedBorder.diasabled
          : _hovered
              ? _decorations.notSelectedBorder.hovered
              : _decorations.notSelectedBorder.standard;

  Color? get _backgroundColor => _selected
      ? _disabled
          ? _decorations.selectedBackgroundColor.diasabled
          : _hovered
              ? _decorations.selectedBackgroundColor.hovered
              : _decorations.selectedBackgroundColor.standard
      : _disabled
          ? _decorations.notSelectedBackgroundColor.diasabled
          : _hovered
              ? _decorations.notSelectedBackgroundColor.hovered
              : _decorations.notSelectedBackgroundColor.standard;

  Color? get _textColor => _selected
      ? _disabled
          ? _decorations.selectedTextColor.diasabled
          : _hovered
              ? _decorations.selectedTextColor.hovered
              : _decorations.selectedTextColor.standard
      : _disabled
          ? _decorations.notSelectedTextColor.diasabled
          : _hovered
              ? _decorations.notSelectedTextColor.hovered
              : _decorations.notSelectedTextColor.standard;

  ZwapTextType? get _textType => _selected
      ? _disabled
          ? _decorations.selectedTextType.diasabled
          : _hovered
              ? _decorations.selectedTextType.hovered
              : _decorations.selectedTextType.standard
      : _disabled
          ? _decorations.notSelectedTextType.diasabled
          : _hovered
              ? _decorations.notSelectedTextType.hovered
              : _decorations.notSelectedTextType.standard;

  TextStyle? get _textStyle => _selected
      ? _disabled
          ? _decorations.selectedTextStyle.diasabled
          : _hovered
              ? _decorations.selectedTextStyle.hovered
              : _decorations.selectedTextStyle.standard
      : _disabled
          ? _decorations.notSelectedTextStyle.diasabled
          : _hovered
              ? _decorations.notSelectedTextStyle.hovered
              : _decorations.notSelectedTextStyle.standard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _decorations.internalPadding,
      child: InkWell(
        onTap: _disabled ? widget.disabledCallback : widget.callback,
        onHover: _disabled ? null : widget.onHoverChange,
        borderRadius: _decorations.borderRadius,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        mouseCursor: _disabled ? SystemMouseCursors.forbidden : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            borderRadius: _decorations.borderRadius,
            border: _border,
            color: _backgroundColor,
          ),
          child: widget._isCustomChild
              ? Builder(builder: widget._childBuilder!)
              : Center(
                  child: _textStyle != null
                      ? ZwapText.customStyle(text: widget.content, customTextStyle: _textStyle)
                      : ZwapText(
                          text: widget.content,
                          textColor: _textColor ?? ZwapColors.whiteTransparent,
                          zwapTextType: _textType ?? ZwapTextType.mediumBodyRegular,
                        ),
                ),
        ),
      ),
    );
  }
}
