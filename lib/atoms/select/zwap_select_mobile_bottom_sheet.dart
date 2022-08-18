part of zwap_select;

Future<void> _showMobileBottomSheet(BuildContext context, _ZwapSelectProvider provider) async {
  provider.isOverlayOpen = true;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ChangeNotifierProvider.value(value: provider, child: _MobileBottomSheet()),
  );
  provider.isOverlayOpen = false;
}

class _MobileBottomSheet extends StatelessWidget {
  const _MobileBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _canSearch = context.select<_ZwapSelectProvider, bool>((pro) => pro._canSearch);
    Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.values);

    final bool _fullScreenModal = _canSearch ? true : _allValues.length >= 10;
    return Container(
      height: _fullScreenModal ? MediaQuery.of(context).size.height * 0.9 : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: EdgeNotifierScrollController(onEndReached: () => context.read<_ZwapSelectProvider>().endReached()),
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: _ModalBodyWidget(),
      ),
    );
  }
}

class _ModalBodyWidget extends StatelessWidget {
  const _ModalBodyWidget({Key? key}) : super(key: key);

  void _simulateEnter(BuildContext context) {
    final _ZwapSelectProvider _provider = context.read<_ZwapSelectProvider>();

    _provider._inputFocusNodeHandler(
      _provider._inputFocusNode,
      KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.enter,
          logicalKey: LogicalKeyboardKey.enter,
          timeStamp: Duration(
            milliseconds: DateTime.now().millisecondsSinceEpoch,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _allValues = context.select<_ZwapSelectProvider, Map<String, String>>((pro) => pro.values);
    final bool _isLoading = context.select<_ZwapSelectProvider, bool>((pro) => pro.isLoading);
    final bool _canAddItem = context.select<_ZwapSelectProvider, bool>((pro) => pro.isLoading);
    final bool _canSearch = context.select<_ZwapSelectProvider, bool>((pro) => pro._canSearch);
    final String? _hoveredItemKey = context.select<_ZwapSelectProvider, String?>((pro) => pro.currentHoveredKey);
    final String? _label = context.select<_ZwapSelectProvider, String?>((pro) => pro.label);
    final String? _placeholder = context.select<_ZwapSelectProvider, String?>((pro) => pro.placeholder);
    final String _currentValue = context.select<_ZwapSelectProvider, String>((pro) => pro._currentValue);
    final List<String> _selectedValues = context.select<_ZwapSelectProvider, List<String>>((pro) => pro.selectedValues);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_label != null || _placeholder != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_label != null) ...[
                        ZwapText(text: _label, zwapTextType: ZwapTextType.bigBodySemibold, textColor: ZwapColors.shades100),
                        SizedBox(height: 4),
                      ],
                      if (_placeholder != null)
                        ZwapText(text: _placeholder, zwapTextType: ZwapTextType.mediumBodyRegular, textColor: ZwapColors.neutral800),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.close, color: ZwapColors.shades100, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ] else
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.close, color: ZwapColors.shades100, size: 22),
              ),
            ),
          ),
        ..._allValues.isEmpty
            ? _isLoading
                ? [
                    Container(
                      height: 2,
                      child: _isLoading
                          ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                              minHeight: 2,
                            )
                          : Container(),
                    )
                  ]
                : ([
                    if (_canAddItem)
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Material(
                          color: '_random_key_for_this_item_2341234112341252456375' == _hoveredItemKey ? ZwapColors.neutral100 : ZwapColors.shades0,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () => _simulateEnter(context),
                            hoverColor: ZwapColors.neutral100,
                            onHover: (hovered) => context.read<_ZwapSelectProvider>().currentHoveredKey =
                                hovered ? '_random_key_for_this_item_2341234112341252456375' : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                              child: Row(
                                children: [
                                  //TODO: traduci
                                  ZwapRichText.safeText(
                                    textSpans: [
                                      ZwapTextSpan.fromZwapTypography(
                                        text: '$_currentValue',
                                        textType: ZwapTextType.bodySemiBold,
                                        textColor: ZwapColors.shades100,
                                      ),
                                      ZwapTextSpan.fromZwapTypography(
                                        text: ' ${context.read<_ZwapSelectProvider>().translateKey('not_here')} ',
                                        textType: ZwapTextType.bodyRegular,
                                        textColor: ZwapColors.shades100,
                                      ),
                                      ZwapTextSpan.fromZwapTypography(
                                        text: context.read<_ZwapSelectProvider>().translateKey('add_here'),
                                        textType: ZwapTextType.bodySemiBold,
                                        textColor: ZwapColors.shades100,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Material(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ZwapText(
                            text: "No results",
                            zwapTextType: ZwapTextType.bodyRegular,
                            textColor: ZwapColors.shades100,
                          ),
                        ),
                      ),
                    SizedBox(height: 13),
                  ])
            : [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  //TODO: categories are not currently supported
                  child: /* widget._hasCategories
                                              ? _ZwapOverlayChildrenList.withCategories(
                                                  hoveredItem: _hoveredItemKey,
                                                  onHoverItem: (key, isHovered) => setState(() => _hoveredItemKey = isHovered ? key : null),
                                                  onItemTap: (key) => onChangeValue(key),
                                                  selectedValues: _selectedValues,
                                                  valuesByCategory: _getToShowValuesByCategory(_allValues),
                                                  reverse: _reverseOpen,
                                                )
                                              : */
                      _ZwapOverlayChildrenList(
                    hoveredItem: _hoveredItemKey,
                    onHoverItem: (key, isHovered) => context.read<_ZwapSelectProvider>().currentHoveredKey = isHovered ? key : null,
                    onItemTap: (key) {
                      final bool _pop = context.read<_ZwapSelectProvider>().selectType == _ZwapSelectTypes.regular;

                      if (_pop) context.read<_ZwapSelectProvider>().isOverlayOpen = false;
                      context.read<_ZwapSelectProvider>().toggleItem(key);
                      if (_pop) Navigator.pop(context);
                    },
                    selectedValues: _selectedValues,
                    values: _allValues,
                  ),
                ),
                Container(
                  child: _isLoading
                      ? LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ZwapColors.primary800),
                          minHeight: 2,
                        )
                      : SizedBox(height: 13),
                )
              ],
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
