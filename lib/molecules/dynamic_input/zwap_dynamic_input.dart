import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

extension ZwapDynamicInputKeyExt on GlobalKey<ZwapDynamicInputState> {
  void toggleOverlay() => currentState?.toggleOverlay();
}

class ZwapDynamicInput extends StatefulWidget {
  final bool focussed;

  final Widget content;
  final Widget overlay;

  final Function()? onOpen;
  final Function()? onClose;

  final Color? backgroundColor;

  final Widget Function(BuildContext, Widget)? builder;

  const ZwapDynamicInput({
    required this.content,
    required this.overlay,
    this.backgroundColor = ZwapColors.shades0,
    this.builder,
    this.focussed = false,
    this.onOpen,
    this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapDynamicInput> createState() => ZwapDynamicInputState();
}

class ZwapDynamicInputState extends State<ZwapDynamicInput> {
  final GlobalKey _inputKey = GlobalKey();
  late bool _focussed;
  bool _hovered = false;

  OverlayEntry? _entry;

  bool get _active => _focussed || _hovered;
  bool get _isOverlayOpen => _entry?.mounted ?? false;

  @override
  void initState() {
    super.initState();
    _focussed = widget.focussed;
  }

  @override
  void didUpdateWidget(covariant ZwapDynamicInput oldWidget) {
    if (_focussed != widget.focussed) setState(() => _focussed = widget.focussed);
    super.didUpdateWidget(oldWidget);
  }

  void toggleOverlay() {
    if (_isOverlayOpen)
      _closeOverlay();
    else
      _openOverlay();
  }

  void _openOverlay() {
    if (_entry != null) return;

    final Rect? _inputRect = _inputKey.globalPaintBounds;
    if (_inputRect == null) return;

    final bool _openOnTop = MediaQuery.of(context).size.height - (_inputRect.bottomCenter.dy + 8) - 50 < 225;

    final Widget _child = ZwapOverlayEntryWidget(
      onAutoClose: _closeOverlay,
      child: ZwapOverlayEntryChild(
        top: _openOnTop ? null : _inputRect.bottomLeft.dy + 8,
        bottom: _openOnTop ? (MediaQuery.of(context).size.height - _inputRect.topCenter.dy) + 8 : null,
        left: _inputRect.left,
        child: _ZwapDynamicInputOverlay(
          child: widget.overlay,
          width: _inputRect.width,
        ),
      ),
      entity: _entry,
    );

    Overlay.of(context)?.insert(
      _entry = OverlayEntry(
        builder: (_) => widget.builder != null ? widget.builder!(context, _child) : _child,
      ),
    );

    if (widget.onOpen != null) widget.onOpen!();
  }

  void _closeOverlay() {
    if (_entry == null) return;

    _entry?.remove();
    _entry = null;

    if (widget.onClose != null) widget.onClose!();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: toggleOverlay,
        child: AnimatedContainer(
          key: _inputKey,
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _active ? ZwapColors.primary900Dark : ZwapColors.neutral300,
            ),
          ),
          child: widget.content,
        ),
      ),
    );
  }
}

class _ZwapDynamicInputOverlay extends StatefulWidget {
  final Widget child;
  final double width;

  const _ZwapDynamicInputOverlay({
    required this.child,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  State<_ZwapDynamicInputOverlay> createState() => _ZwapDynamicInputOverlayState();
}

class _ZwapDynamicInputOverlayState extends State<_ZwapDynamicInputOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _transitionTween;

  double get _transitionValue => _transitionTween.value;

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    _transitionTween = Tween(begin: 1.5, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() => _visible = true);
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ZwapColors.transparent,
      child: Transform.translate(
        offset: Offset(0, _transitionValue),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _visible ? 1 : 0.4,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Color(0x00808080).withOpacity(0.05), blurRadius: 60, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x00808080).withOpacity(0.15), blurRadius: 60, offset: Offset(0, 30), spreadRadius: -4),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                  color: ZwapColors.shades0,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
