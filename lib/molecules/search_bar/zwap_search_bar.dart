library zwap_search_bar;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

/// Zwap component to manage dynamic search with filters
class ZwapSearchBar extends StatefulWidget {
  const ZwapSearchBar({Key? key}) : super(key: key);

  @override
  State<ZwapSearchBar> createState() => _ZwapSearchBarState();
}

class _ZwapSearchBarState extends State<ZwapSearchBar> {
  final GlobalKey _searchBarKey = GlobalKey();
  late final TextEditingController _searchController;

  bool _showClearAll = false;

  double? get _searchBarWidth => _searchBarKey.globalPaintBounds?.width;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_searchControllerListener);
  }

  void _searchControllerListener() {
    final bool _shouldShowClearAll = _searchController.text.isNotEmpty;
    if (_shouldShowClearAll != _showClearAll) setState(() => _showClearAll = _shouldShowClearAll);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_searchControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    print(_searchBarWidth);
    return Row(
      key: _searchBarKey,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: ZwapColors.shades0,
              border: Border.all(color: ZwapColors.neutral300),
            ),
            padding: const EdgeInsets.only(left: 18, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        child: ZwapIcons.icons('search2', iconColor: ZwapColors.neutral400, iconSize: 20),
                      ),
                      hintText: "Search lorem ipsum...",
                      hintStyle: getTextStyle(ZwapTextType.mediumBodyRegular).apply(color: ZwapColors.neutral400),
                    ),
                    style: getTextStyle(ZwapTextType.mediumBodyRegular).apply(color: ZwapColors.neutral800),
                  ),
                ),
                ZwapButton(
                  height: 52,
                  width: 52,
                  buttonChild: ZwapButtonChild.customIcon(
                    icon: (_) => ZwapIcons.icons('search2', iconColor: ZwapColors.shades0, iconSize: 20),
                  ),
                  decorations: ZwapButtonDecorations.primaryLight(internalPadding: EdgeInsets.zero, borderRadius: BorderRadius.circular(100)),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: _showClearAll
              ? ZwapButton(
                  margin: const EdgeInsets.only(left: 12),
                  buttonChild: (_searchBarWidth ?? 0) > 300
                      ? ZwapButtonChild.text(text: "Clear All", fontSize: 15, fontWeight: FontWeight.w500)
                      : ZwapButtonChild.icon(icon: Icons.clear, iconSize: 20),
                  decorations: ZwapButtonDecorations.quaternary(internalPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                  width: (_searchBarWidth ?? 0) > 300 ? 112 : 44,
                  height: 44,
                  onTap: () => _searchController.clear(),
                )
              : Container(height: 0),
        ),
      ],
    );
  }
}
