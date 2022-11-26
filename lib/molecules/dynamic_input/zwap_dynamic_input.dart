import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

extension ZwapDynamicInputKeyExt on GlobalKey<ZwapDynamicInputState> {
  void toggleOverlay() => currentState?.toggleOverlay();
  void openIfClose() => currentState?.openIfClose();
  void closeIfOpen() => currentState?.closeIfOpen();

  void updateOverlayPosition() => currentState?._updateOverlayPosition();
}

class ZwapDynamicInput extends StatefulWidget {
  final bool focussed;

  final Widget content;
  final Widget overlay;

  final Function()? onOpen;
  final Function()? onClose;

  final Color? backgroundColor;

  final Widget Function(BuildContext, Widget)? builder;

  final bool _lockHeight;

  /// This color is used for the border on the active
  /// and hovered state
  final Color? activeColor;

  /// This color is used for the border where not on the active
  /// or hovered state
  final Color? defaultColor;

  const ZwapDynamicInput({
    required this.content,
    required this.overlay,
    this.backgroundColor = ZwapColors.shades0,
    this.builder,
    this.focussed = false,
    this.onOpen,
    this.onClose,
    this.activeColor,
    this.defaultColor,
    Key? key,
  })  : this._lockHeight = true,
        super(key: key);

  /// Same as [ZwapDynamicInput] but the content child has not a
  /// pre defined height
  const ZwapDynamicInput.customSizeContent({
    required this.content,
    required this.overlay,
    this.backgroundColor = ZwapColors.shades0,
    this.builder,
    this.focussed = false,
    this.onOpen,
    this.activeColor,
    this.defaultColor,
    this.onClose,
    Key? key,
  })  : this._lockHeight = false,
        super(key: key);

  @override
  State<ZwapDynamicInput> createState() => ZwapDynamicInputState();
}

class ZwapDynamicInputState extends State<ZwapDynamicInput> {
  final GlobalKey _inputKey = GlobalKey();
  final GlobalKey<ZwapOverlayEntryChildState> _entryKey = GlobalKey();

  late bool _focussed;
  bool _hovered = false;

  double? _overlayTopOffset;
  double? _overlayBottomOffset;
  double? _overlayLeftOffset;

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

  void closeIfOpen() {
    if (_isOverlayOpen) _closeOverlay();
  }

  void openIfClose() {
    if (!_isOverlayOpen) _openOverlay();
  }

  void _openOverlay() {
    if (_entry != null) return;

    final Rect? _inputRect = _inputKey.globalPaintBounds;
    if (_inputRect == null) return;

    final bool _openOnTop = MediaQuery.of(context).size.height - (_inputRect.bottomCenter.dy + 8) - 50 < 225;

    _overlayTopOffset = _openOnTop ? null : _inputRect.bottomLeft.dy + 8;
    _overlayBottomOffset = _openOnTop ? (MediaQuery.of(context).size.height - _inputRect.topCenter.dy) + 8 : null;
    _overlayLeftOffset = _inputRect.left;

    final Widget _child = ZwapOverlayEntryWidget(
      onAutoClose: _closeOverlay,
      child: ZwapOverlayEntryChild(
        key: _entryKey,
        top: _overlayTopOffset,
        bottom: _overlayBottomOffset,
        left: _overlayLeftOffset,
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

  void _updateOverlayPosition() {
    if (_entry == null) return;

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 32));

      final Rect? _inputRect = _inputKey.globalPaintBounds;
      if (_inputRect == null) return;

      final bool _openOnTop = (_entryKey.currentWidget as ZwapOverlayEntryChild).bottom != null;

      _overlayTopOffset = _openOnTop ? null : _inputRect.bottomLeft.dy + 8;
      _overlayBottomOffset = _openOnTop ? (MediaQuery.of(context).size.height - _inputRect.topCenter.dy) + 8 : null;
      _overlayLeftOffset = _inputRect.left;

      _entryKey.updatePosition(
        top: _overlayTopOffset,
        bottom: _overlayBottomOffset,
        left: _overlayLeftOffset,
      );
    });
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
          height: widget._lockHeight ? 48 : null,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _active ? (widget.activeColor ?? ZwapColors.primary900Dark) : (widget.defaultColor ?? ZwapColors.neutral300),
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
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ZwapColors.transparent,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 175),
        curve: Curves.fastOutSlowIn,
        opacity: _visible ? 1 : 0.05,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          decoration: BoxDecoration(
            boxShadow: [
              if (_visible) ...[
                BoxShadow(color: Color(0x00808080).withOpacity(0.05), blurRadius: 60, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x00808080).withOpacity(0.15), blurRadius: 60, offset: Offset(0, 30), spreadRadius: -4),
              ],
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
    );
  }
}
