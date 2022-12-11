library zwap.dynamic_inputs.search_picker;

import 'dart:async';

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
  final T? initialSelectedItem;
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

  const ZwapSearchPicker({
    required this.performSearch,
    required this.getItemCopy,
    this.initialSelectedItem,
    this.onItemSelected,
    this.initialValues = const [],
    this.placeholder,
    this.noResultsWidget,
    this.translateKey,
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
      widget.onItemSelected,
      widget.initialSelectedItem,
      widget.getItemCopy,
    );

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
      _provider.inputKey.closeIfOpen();
    }
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
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 12),
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
            overlay: _ZwapSearchInputOverlay<T>(
              noResultsWidget: widget.noResultsWidget,
              translateKey: widget.translateKey,
            ),
            showDeleteIcon: _selectedItem != null,
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
              if (!_inputNode.hasFocus) return;
              _inputNode.unfocus();
            },
          );
        },
      ),
    );
  }
}

class _ZwapSearchInputOverlay<T> extends StatelessWidget {
  final Function(String)? translateKey;
  final Widget? noResultsWidget;

  const _ZwapSearchInputOverlay({
    this.translateKey,
    this.noResultsWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<T> _items = context.select<_ZwapSearchInputProvider<T>, List<T>>((pro) => pro.data);
    final bool _isLoading = context.select<_ZwapSearchInputProvider<T>, bool>((pro) => pro.loading);
    final bool _isLoadingMoreData = context.select<_ZwapSearchInputProvider<T>, bool>((pro) => pro.loadingMoreData);

    Widget _getChild() {
      if (_isLoading)
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: LinearProgressIndicator(
            minHeight: 1.5,
            valueColor: AlwaysStoppedAnimation(ZwapColors.primary700),
          ),
        );

      if (_items.isEmpty) {
        if (noResultsWidget != null) return noResultsWidget!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: ZwapText(
            text: translateKey!('no_results_found'),
            zwapTextType: ZwapTextType.mediumBodyRegular,
            textColor: ZwapColors.primary900Dark,
          ),
        );
      }

      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 240),
        child: SingleChildScrollView(
          controller: EdgeNotifierScrollController(
            onEndReached: () => context.read<_ZwapSearchInputProvider<T>>().endReached(),
          ),
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._items.map((i) => _SingleItemWidget<T>(item: i)).toList(),
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

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      child: _getChild(),
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
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: (_selected /* || _disabled */) ? null : () => context.read<_ZwapSearchInputProvider<T>>().pickItem(widget.item),
      onHover: (isHovered) => setState(() => _hovered = isHovered),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _getColor(),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ZwapText(
          text: _getCopy(widget.item),
          zwapTextType: ZwapTextType.bigBodyRegular,
          textColor: _textColor(),
        ),
      ),
    );
  }
}
