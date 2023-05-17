library zwap.wrap_selector;

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:provider/provider.dart';
part 'wrap_selector_provider.dart';

class ZwapWrapSelector<T> extends StatefulWidget {
  /// Called each time user stops typing
  ///
  /// Should return a list of items that the user can
  /// select
  final List<T> Function(String search) items;

  /// The widget showed inside the select, usually a
  /// text or a row with icon and text
  ///
  /// Max height is 36, max width 225
  final Widget Function(T item) selectBuilder;

  /// Usually chips of the selected items
  final List<Widget> children;

  /// Called each time an item in selected in the overlay
  final void Function(T item) onSelected;

  /// Placeholder text for the search field
  final String placeholder;

  /// Basically a wrap that has an input field
  /// where the user can search and select items
  ///
  /// [children] should ne manually updated when `onSelected(item)`
  /// is called
  const ZwapWrapSelector({
    required this.items,
    required this.children,
    required this.onSelected,
    required this.selectBuilder,
    this.placeholder = 'Search here',
    super.key,
  });

  @override
  State<ZwapWrapSelector<T>> createState() => _ZwapWrapSelectorState<T>();
}

class _ZwapWrapSelectorState<T> extends State<ZwapWrapSelector<T>> {
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = widget.children;
  }

  @override
  void didUpdateWidget(covariant ZwapWrapSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_children != widget.children) setState(() => _children = widget.children);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._children,
          _WrapSearchChip<T>(
            items: widget.items,
            onSelected: widget.onSelected,
            selectBuilder: widget.selectBuilder,
            placeholder: widget.placeholder,
          ),
        ],
      ),
    );
  }
}

class _WrapSearchChip<T> extends StatefulWidget {
  final List<T> Function(String search) items;
  final void Function(T item) onSelected;
  final Widget Function(T item) selectBuilder;
  final String placeholder;

  const _WrapSearchChip({
    required this.items,
    required this.onSelected,
    required this.selectBuilder,
    required this.placeholder,
    super.key,
  });

  @override
  State<_WrapSearchChip<T>> createState() => _WrapSearchChipState<T>();
}

class _WrapSearchChipState<T> extends State<_WrapSearchChip<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  late _ZwapWrapSelectorProvider<T> _provider;

  bool _focussed = false;

  OverlayEntry? _entry;

  double get _textWidth {
    double getTextWidth(String text) => textWidth(text, ZwapTextType.bigBodyMedium.copyWith()) + 8;

    if (_controller.text.isEmpty) return getTextWidth(widget.placeholder);
    return getTextWidth(_controller.text);
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_controllerListener);
    _focusNode.addListener(_focusNodeListener);

    _provider = _ZwapWrapSelectorProvider<T>(
      items: widget.items,
      selectBuilder: widget.selectBuilder,
      onSelected: (item) {
        widget.onSelected(item);
        _onItemSelected();
      },
    );
  }

  void _controllerListener() => setState(() {});

  void _focusNodeListener() {
    if (_focussed && !_focusNode.hasFocus) {
      //? Node has lost focus
      if (!_provider._isOverlayHovered) {
        _onItemSelected();
      }
    }

    if (!_focussed && _focusNode.hasFocus) {
      //? Node has gained focus
      _showOverlay();
    }

    if (_focussed != _focusNode.hasFocus) {
      setState(() => _focussed = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_controllerListener);
    _focusNode.removeListener(_focusNodeListener);
  }

  void _onItemSelected() {
    _controller.clear();
    _provider.clean();
    _closeOverlay();
  }

  void _showOverlay() {
    if (_entry?.mounted ?? false) return;

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (_) => Positioned(
          width: 245,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, 50),
            child: ChangeNotifierProvider<_ZwapWrapSelectorProvider<T>>.value(
              value: _provider,
              child: _WrapSelectorOverlay<T>(),
            ),
          ),
        ),
      ),
    );
  }

  void _closeOverlay() {
    if (_entry?.mounted ?? false) {
      _entry?.remove();
    }

    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(100),
        color: _focussed ? ZwapColors.text65 : ZwapColors.neutral400,
        child: Container(
          width: 60 + _textWidth,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ZwapIcons.icons(
                'search',
                iconSize: 16,
                iconColor: _focussed ? ZwapColors.primary900Dark : ZwapColors.neutral400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.placeholder,
                    hintStyle: ZwapTextType.bigBodyMedium.copyWith(color: ZwapColors.neutral400),
                  ),
                  style: ZwapTextType.bigBodyMedium.copyWith(color: ZwapColors.primary900Dark),
                  onChanged: (v) => _provider.search(v),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WrapSelectorOverlay<T> extends StatelessWidget {
  const _WrapSelectorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final List<T> items = context.select<_ZwapWrapSelectorProvider<T>, List<T>>((pro) => pro.availableItems);
    final Widget Function(T item) builder = context.select<_ZwapWrapSelectorProvider<T>, Widget Function(T item)>((pro) => pro.selectBuilder);

    if (items.isEmpty) return Container();

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: ZwapColors.transparent,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff808080).withOpacity(.15),
              blurRadius: 60,
              spreadRadius: -4,
              offset: const Offset(0, 30),
            ),
            BoxShadow(
              color: Color(0xff808080).withOpacity(.05),
              blurRadius: 60,
              spreadRadius: -6,
              offset: const Offset(0, 30),
            ),
          ],
        ),
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: InkWell(
            onTap: () {},
            onHover: (hovered) => context.read<_ZwapWrapSelectorProvider<T>>()._isOverlayHovered = hovered,
            borderRadius: BorderRadius.circular(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: ZwapColors.shades0,
                  borderRadius: BorderRadius.circular(16),
                ),
                constraints: BoxConstraints(maxHeight: 250),
                width: 245,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(children: items.map((i) => _SingleOverlayItem<T>(item: i, child: builder(i))).toList()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleOverlayItem<T> extends StatefulWidget {
  final T item;
  final Widget child;

  const _SingleOverlayItem({
    required this.item,
    required this.child,
    super.key,
  });

  @override
  State<_SingleOverlayItem<T>> createState() => __SingleOverlayItemState<T>();
}

class __SingleOverlayItemState<T> extends State<_SingleOverlayItem<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<_ZwapWrapSelectorProvider<T>>().onSelected(widget.item),
      onHover: (hovered) => setState(() => _hovered = hovered),
      child: Container(
        width: double.infinity,
        height: 36,
        color: _hovered ? ZwapColors.primary50 : ZwapColors.shades0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: widget.child,
      ),
    );
  }
}
