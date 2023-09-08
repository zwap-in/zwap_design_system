part of zwap_button;

class ZwapButtonOptionDecorations {
  final Color? contentColor;
  final Color? hoveredColor;

  const ZwapButtonOptionDecorations({
    this.contentColor,
    this.hoveredColor,
  });

  const ZwapButtonOptionDecorations.defaultDecoration()
      : contentColor = Colors.white,
        hoveredColor = Colors.white;

  const ZwapButtonOptionDecorations.destructive()
      : contentColor = ZwapColors.error400,
        hoveredColor = ZwapColors.error400;
}

/// This class is used to describe the extra options
/// for this button
class ZwapButtonOptions {
  final ZwapButtonOptionDecorations defaultDecorations;
  final List<ZwapButtonOption> options;

  const ZwapButtonOptions({
    this.defaultDecorations = const ZwapButtonOptionDecorations.defaultDecoration(),
    required this.options,
  });
}

class ZwapButtonOption {
  final String label;

  final IconData? icon;
  final Widget Function(bool)? customIcon;

  final ZwapButtonOptionDecorations? decorations;

  final void Function() onTap;

  /// The destructive option will be grouped
  /// at the bottom of the overlay
  final bool isDestructive;

  const ZwapButtonOption({
    required this.label,
    required IconData icon,
    required this.onTap,
    this.decorations,
    this.isDestructive = false,
  })  : this.icon = icon,
        this.customIcon = null;

  const ZwapButtonOption.customIcon({
    required this.label,
    required Widget Function(bool) icon,
    required this.onTap,
    this.decorations,
    this.isDestructive = false,
  })  : this.icon = null,
        this.customIcon = icon;
}

class _ZwapButtonOptionsAppendice extends StatefulWidget {
  final double height;

  final ZwapButtonOptions options;
  final ZwapButtonDecorations decorations;

  const _ZwapButtonOptionsAppendice({
    required this.height,
    required this.options,
    required this.decorations,
    super.key,
  });

  @override
  State<_ZwapButtonOptionsAppendice> createState() => _ZwapButtonOptionsAppendiceState();
}

class _ZwapButtonOptionsAppendiceState extends State<_ZwapButtonOptionsAppendice> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _entry;

  bool get _isOpened => _entry?.mounted ?? false;

  void showOverlay() {
    if (_isOpened) return;

    final Size _overlaySize = Size(200, 100);

    final double _bottom = _key.globalPaintBounds?.bottom ?? 0;
    final double _screenHeight = MediaQuery.of(context).size.height;

    Offset _overlayOffset = Offset(
      (_key.globalOffset ?? Offset.zero).dx - _overlaySize.width + 40,
      (_screenHeight - _bottom) + widget.height + 9.5,
    );

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (context) => ZwapOverlayEntryWidget(
          entity: _entry,
          onAutoClose: () => setState(() => _entry = null),
          child: ZwapOverlayEntryChild(
            left: _overlayOffset.dx,
            bottom: _overlayOffset.dy,
            child: _ZwapButtonOptionOverlay(
              options: widget.options,
              closeOverlay: () {
                _entry?.remove();
                _entry = null;

                setState(() {});
              },
            ),
          ),
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _key,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (_isOpened) {
          _entry?.remove();
          _entry = null;

          setState(() {});
        } else {
          showOverlay();
        }
      },
      child: Container(
        width: 40,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.decorations.backgroundColor,
          borderRadius: (widget.decorations.borderRadius ?? BorderRadius.circular(0)).copyWith(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
        ),
        child: Center(
          child: AnimatedRotation(
            turns: _isOpened ? 0.25 : -0.25,
            duration: Duration(milliseconds: 200),
            child: Icon(
              color: widget.decorations.contentColor,
              Icons.chevron_left_rounded,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZwapButtonOptionOverlay extends StatelessWidget {
  final ZwapButtonOptions options;
  final void Function() closeOverlay;

  const _ZwapButtonOptionOverlay({
    required this.options,
    required this.closeOverlay,
    super.key,
  });

  void _handle(void Function() onTap) {
    closeOverlay();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final List<ZwapButtonOption> _options = options.options.where((o) => !o.isDestructive).toList();
    final List<ZwapButtonOption> _destructiveOptions = options.options.where((o) => o.isDestructive).toList();

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xff19193B),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: ZwapColors.shades100.withOpacity(.2), offset: const Offset(0, 20), blurRadius: 60),
            BoxShadow(color: ZwapColors.shades100.withOpacity(.3), offset: const Offset(0, 30), blurRadius: 60, spreadRadius: -4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._options.mapIndexed(
              (i, o) => Padding(
                padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 12),
                child: _ZwapButtonSingleOptionWidget(
                  option: o,
                  decorations: options.defaultDecorations,
                  onTap: () => _handle(o.onTap),
                ),
              ),
            ),
            if (_options.isNotEmpty && _destructiveOptions.isNotEmpty)
              Divider(
                height: 32,
                thickness: 1,
                color: ZwapColors.shades0.withOpacity(.1),
              ),
            ..._destructiveOptions.mapIndexed(
              (i, o) => Padding(
                padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 12),
                child: _ZwapButtonSingleOptionWidget(
                  option: o,
                  decorations: options.defaultDecorations,
                  onTap: () => _handle(o.onTap),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZwapButtonSingleOptionWidget extends StatefulWidget {
  final ZwapButtonOption option;
  final ZwapButtonOptionDecorations decorations;

  final void Function() onTap;

  const _ZwapButtonSingleOptionWidget({
    required this.option,
    required this.decorations,
    required this.onTap,
    super.key,
  });

  @override
  State<_ZwapButtonSingleOptionWidget> createState() => __ZwapButtonSingleOptionWidgetState();
}

class __ZwapButtonSingleOptionWidgetState extends State<_ZwapButtonSingleOptionWidget> {
  bool _hovered = false;

  Color get _contentColor {
    final ZwapButtonOptionDecorations decorations = widget.option.decorations ?? widget.decorations;

    return (_hovered ? decorations.hoveredColor : decorations.contentColor) ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: widget.onTap,
      onHover: (hovered) => setState(() => _hovered = hovered),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.option.icon != null)
            Icon(
              widget.option.icon,
              color: _contentColor,
              size: 16,
            )
          else if (widget.option.customIcon != null)
            widget.option.customIcon!.call(_hovered),
          SizedBox(width: 8),
          ZwapText(
            text: widget.option.label,
            zwapTextType: ZwapTextType.mediumBodySemibold,
            textColor: _contentColor,
          ),
        ],
      ),
    );
  }
}
