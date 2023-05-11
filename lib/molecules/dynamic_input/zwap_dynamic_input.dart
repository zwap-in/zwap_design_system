import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

extension ZwapDynamicInputKeyExt on GlobalKey<ZwapDynamicInputState> {
  void toggleOverlay() => currentState?.toggleOverlay();
  void openIfClose() => currentState?.openIfClose();
  void closeIfOpen() => currentState?.closeIfOpen();

  void updateOverlayPosition() => currentState?._updateOverlayPosition();
}

extension ZwapDynamicInputOverlayExt on GlobalKey {
  /// Return true if overlay should be mounted on the top
  /// of the input field
  bool get openOverlayOnTop {
    if (globalPaintBounds == null || currentContext == null) return false;

    return MediaQuery.of(currentContext!).size.height - (globalPaintBounds!.bottomCenter.dy + 8) - 50 < 225;
  }
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

  /// If provided, showed on the border
  final String? dynamicLabel;

  final bool showDeleteIcon;

  final void Function()? onDelete;

  final bool expanded;

  /// If not provided 220 is used
  final double? minOverlayWidth;

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
    this.dynamicLabel,
    this.showDeleteIcon = false,
    this.onDelete,
    this.expanded = true,
    this.minOverlayWidth,
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
    this.dynamicLabel,
    this.showDeleteIcon = false,
    this.onDelete,
    this.expanded = true,
    this.minOverlayWidth,
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

  late bool _showDeleteIcon;

  OverlayEntry? _entry;

  String? _dynamicLabel;

  bool get _active => _focussed || _hovered;
  bool get _isOverlayOpen => _entry?.mounted ?? false;

  @override
  void initState() {
    super.initState();
    _focussed = widget.focussed;
    _dynamicLabel = widget.dynamicLabel;
    _showDeleteIcon = widget.showDeleteIcon;
  }

  @override
  void didUpdateWidget(covariant ZwapDynamicInput oldWidget) {
    if (_focussed != widget.focussed) setState(() => _focussed = widget.focussed);
    if (_dynamicLabel != widget.dynamicLabel) setState(() => _dynamicLabel = widget.dynamicLabel);
    if (_showDeleteIcon != widget.showDeleteIcon) setState(() => _showDeleteIcon = widget.showDeleteIcon);
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
          width: max(widget.minOverlayWidth ?? 220, _inputRect.width),
        ),
      ),
      entity: _entry,
    );

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (_) => widget.builder != null ? widget.builder!(context, _child) : _child,
      ),
    );

    if (widget.onOpen != null) widget.onOpen!();
  }

  void _closeOverlay() {
    _entry?.remove();
    _entry = null;

    if (widget.onClose != null) widget.onClose!();
  }

  void _updateOverlayPosition() {
    if (_entry == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    Widget _wrapWithExpanded(Widget child) => widget.expanded ? Expanded(child: child) : child;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: toggleOverlay,
        child: Stack(
          children: [
            Row(
              mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                _wrapWithExpanded(
                  AnimatedContainer(
                    key: _inputKey,
                    duration: const Duration(milliseconds: 200),
                    width: widget.expanded ? double.infinity : null,
                    height: widget._lockHeight ? (_dynamicLabel != null && _dynamicLabel!.isNotEmpty ? 52 : 48) : null,
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
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: _showDeleteIcon
                      ? ZwapButton(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decorations: ZwapButtonDecorations.quaternary(
                            internalPadding: EdgeInsets.zero,
                            contentColor: ZwapColors.primary900Dark,
                            backgroundColor: ZwapColors.whiteTransparent,
                          ),
                          buttonChild: ZwapButtonChild.customIcon(
                            icon: (state) => ZwapIcons.icons(
                              'trash',
                              iconSize: 20,
                              iconColor: state.decorations!.contentColor,
                            ),
                          ),
                          onTap: widget.onDelete,
                        )
                      : Container(),
                ),
              ],
            ),
            if (_dynamicLabel != null && _dynamicLabel!.isNotEmpty)
              Positioned(
                left: 10,
                child: Transform.translate(
                  offset: Offset(0, -8),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.decelerate,
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ZwapColors.shades0,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [ZwapColors.whiteTransparent, ZwapColors.shades0],
                          stops: [0, 0.47],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ZwapText.customStyle(
                        text: _dynamicLabel!,
                        customTextStyle: getTextStyle(ZwapTextType.extraSmallBodyRegular).copyWith(
                          color: _active ? widget.activeColor ?? ZwapColors.primary900Dark : (widget.defaultColor ?? ZwapColors.neutral500),
                          fontSize: 11,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
