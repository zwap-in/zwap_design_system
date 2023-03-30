library zwap.dynamic_inputs.search_picker;

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/utils/edge_notifier_scroll_controller.dart';

import '../../zwap_dynamic_input.dart';

part 'zwap_search_picker_provider.dart';

typedef PerformSearchCallback<T> = FutureOr<List<T>> Function(String search, int page);
typedef ItemSelectedCallback<T> = void Function(T? item);
typedef GetCopyOfItemCallback<T> = String Function(T item);

class ZwapSearchPicker<T> extends StatefulWidget {
  final T? selectedItem;
  final List<T> initialValues;

  final PerformSearchCallback<T> performSearch;
  final ItemSelectedCallback<T>? onItemSelected;
  final GetCopyOfItemCallback<T> getItemCopy;

  final String? placeholder;

  /// If not provided [translateKey] must be not null
  final Widget? noResultsWidget;

  /// If not provided [noResultsWidget] must be not null
  ///
  /// Used to translate keys:
  /// * no_results_found
  final String Function(String)? translateKey;

  final bool showClear;

  const ZwapSearchPicker({
    required this.performSearch,
    required this.getItemCopy,
    this.selectedItem,
    this.onItemSelected,
    this.initialValues = const [],
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
    this.showClear = true,
    Key? key,
  })  : assert(noResultsWidget != null || translateKey != null),
        super(key: key);

  @override
  State<ZwapSearchPicker<T>> createState() => _ZwapSearchPickerState<T>();
}

class _ZwapSearchPickerState<T> extends State<ZwapSearchPicker<T>> {
  late final _ZwapSearchInputProvider<T> _provider;

  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputNode = FocusNode();

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _provider = _ZwapSearchInputProvider<T>(
      widget.initialValues,
      widget.performSearch,
      (item) {
        if (widget.onItemSelected != null) widget.onItemSelected!(item);
        if (item != null) _inputController.text = widget.getItemCopy(item);
      },
      widget.selectedItem,
      widget.getItemCopy,
    );

    if (widget.selectedItem != null) _inputController.text = widget.getItemCopy(widget.selectedItem!);

    _inputNode.addListener(_focusListener);
  }

  void _focusListener() {
    setState(() => _hasFocus = _inputNode.hasFocus);
    if (_hasFocus) {
      _inputController.text = '';
      _provider.inputKey.openIfClose();
    }

    if (!_hasFocus) {
      _inputController.text = _provider.selectedItem == null ? '' : widget.getItemCopy(_provider.selectedItem!);
    }
  }

  @override
  void didUpdateWidget(covariant ZwapSearchPicker<T> oldWidget) {
    if (widget.selectedItem != _provider.selectedItem) {
      _provider._selectedItem = widget.selectedItem;
      _inputController.text = widget.selectedItem == null ? '' : widget.getItemCopy(widget.selectedItem!);
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapSearchInputProvider<T>>.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final T? _selectedItem = context.select<_ZwapSearchInputProvider<T>, T?>((pro) => pro.selectedItem);

          return ZwapDynamicInput(
            key: _provider.inputKey,
            builder: (context, child) => ChangeNotifierProvider.value(
              value: _provider,
              child: child,
            ),
            content: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _inputController,
                      focusNode: _inputNode,
                      style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.primary900Dark),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.placeholder ?? '',
                      ),
                      cursorColor: ZwapColors.primary900Dark,
                      onChanged: (value) => context.read<_ZwapSearchInputProvider<T>>().search = value,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  turns: _hasFocus ? 0.25 : 0.75,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: ZwapColors.text65,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            overlay: _ZwapSearchInputOverlay<T>(
              noResultsWidget: widget.noResultsWidget,
              translateKey: widget.translateKey,
            ),
            showDeleteIcon: widget.showClear && _selectedItem != null,
            onDelete: () {
              context.read<_ZwapSearchInputProvider<T>>().pickItem(null);
              if (!_hasFocus) _inputController.text = '';
            },
            focussed: _hasFocus,
            onOpen: () {
              if (_inputNode.hasFocus) return;
              _inputNode.requestFocus();
            },
            onClose: () {
              _provider.clearSearch();

              if (!_inputNode.hasFocus) return;
              _inputNode.unfocus();
            },
          );
        },
      ),
    );
  }
}

class _ZwapSearchInputOverlay<T> extends StatefulWidget {
  final Function(String)? translateKey;
  final Widget? noResultsWidget;

  const _ZwapSearchInputOverlay({
    this.translateKey,
    this.noResultsWidget,
    Key? key,
  }) : super(key: key);

  @override
  State<_ZwapSearchInputOverlay<T>> createState() => _ZwapSearchInputOverlayState<T>();
}

class _ZwapSearchInputOverlayState<T> extends State<_ZwapSearchInputOverlay<T>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EdgeNotifierScrollController(
      delayDuration: const Duration(milliseconds: 800),
      onEndReached: () => context.read<_ZwapSearchInputProvider<T>>().endReached(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<T> _items = context.select<_ZwapSearchInputProvider<T>, List<T>>((pro) => pro.data);
    final bool _isLoading = context.select<_ZwapSearchInputProvider<T>, bool>((pro) => pro.loading);
    final bool _isLoadingMoreData = context.select<_ZwapSearchInputProvider<T>, bool>((pro) => pro.loadingMoreData);

    if (_isLoading)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LinearProgressIndicator(
          minHeight: 1.5,
          valueColor: AlwaysStoppedAnimation(ZwapColors.primary700),
        ),
      );

    if (_items.isEmpty) {
      if (widget.noResultsWidget != null) return widget.noResultsWidget!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: ZwapText(
          text: widget.translateKey!('no_results_found'),
          zwapTextType: ZwapTextType.mediumBodyRegular,
          textColor: ZwapColors.primary900Dark,
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 240),
      child: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._items.map((i) => Flexible(child: _SingleItemWidget<T>(item: i))),
            if (_isLoadingMoreData)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: LinearProgressIndicator(
                  minHeight: 1.5,
                  valueColor: AlwaysStoppedAnimation(ZwapColors.primary700),
                ),
              )
            else
              const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SingleItemWidget<T> extends StatefulWidget {
  final T item;

  const _SingleItemWidget({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleItemWidget<T>> createState() => _SingleItemWidgetState<T>();
}

class _SingleItemWidgetState<T> extends State<_SingleItemWidget<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final GetCopyOfItemCallback<T> _getCopy = context.read<_ZwapSearchInputProvider<T>>().getCopyOfItemCallback;
    final bool _selected = context.select<_ZwapSearchInputProvider<T>, bool>((pro) => pro.selectedItem == widget.item);

    Color _getColor() {
      //if (_disabled && _selected) return ZwapColors.primary50;
      //if (_disabled) return ZwapColors.shades0;
      if (_hovered) return ZwapColors.neutral50;
      if (_selected) return ZwapColors.primary50;

      return ZwapColors.shades0;
    }

    Color _textColor() {
      //if (_disabled && _selected) return ZwapColors.neutral700;
      //if (_disabled) return ZwapColors.neutral500;
      if (_selected) return ZwapColors.text65;

      return ZwapColors.primary900Dark;
    }

    return InkWell(
      onTap: () {
        context.read<_ZwapSearchInputProvider<T>>().pickItem(widget.item);
      },
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _getColor(),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: ZwapText(
                text: _getCopy(widget.item),
                zwapTextType: ZwapTextType.bigBodyRegular,
                textColor: _textColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
