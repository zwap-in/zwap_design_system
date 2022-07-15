import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/input/zwap_hint_input/zwap_hint_provider.dart';

class ZwapHintOverlayWidget extends StatelessWidget {
  final int maxHints;

  const ZwapHintOverlayWidget({this.maxHints = 4, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _doNotSuggestAlreadySelected = context.select<ZwapHintProvider, bool>((pro) => pro.doNotSuggestAlreadySelected);
    final String _searchValue = context.select<ZwapHintProvider, String>((pro) => pro.currentSearchValue);
    final Map<String, String> _items = context.select<ZwapHintProvider, Map<String, String>>((pro) => pro.items);
    final List<String> _selectedItems = context.select<ZwapHintProvider, List<String>>((pro) => pro.selectedItems);

    final Rect _searchFieldRect = context.select<ZwapHintProvider, Rect>((pro) => pro.currentSearchFieldRect);
    List<String> _showedItemsKeys = _searchValue.isEmpty
        ? []
        : List.from(_items.entries
            .where((e) =>
                (_doNotSuggestAlreadySelected ? !_selectedItems.contains(e.key) : true) &&
                e.value.toLowerCase().contains(_searchValue.toLowerCase().trim()))
            .map((e) => e.key));
    _showedItemsKeys = _showedItemsKeys.sublist(0, min(_showedItemsKeys.length, maxHints));

    if (_showedItemsKeys.isEmpty) return Container();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      top: _searchFieldRect.top + _searchFieldRect.height + 7,
      left: _searchFieldRect.left - 5,
      child: Container(
        decoration: BoxDecoration(
          color: ZwapColors.shades0,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Color(0x26808080), blurRadius: 60, spreadRadius: -4, offset: Offset(0, 30)),
            BoxShadow(color: Color(0x0d808080), blurRadius: 60, spreadRadius: -6, offset: Offset(0, 30)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _showedItemsKeys
              .map((key) => _SingleItemWidget(
                    keyId: key,
                    value: _items[key]!,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _SingleItemWidget extends StatefulWidget {
  final String keyId;
  final String value;

  const _SingleItemWidget({
    required this.keyId,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  State<_SingleItemWidget> createState() => _SingleItemWidgetState();
}

class _SingleItemWidgetState extends State<_SingleItemWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onHover: (hovered) => setState(() => _hovered = hovered),
        onTap: () {
          context.read<ZwapHintProvider>().currentSearchValue = '';
          context.read<ZwapHintProvider>().notifyNewItemSelected(widget.keyId);
        },
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _hovered ? ZwapColors.primary50 : ZwapColors.whiteTransparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ZwapText(
            text: widget.value,
            zwapTextType: ZwapTextType.mediumBodyRegular,
            textColor: ZwapColors.neutral700,
          ),
        ),
      ),
    );
  }
}
