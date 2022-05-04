import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/text_controller/tags_text_conroller.dart';
import 'package:zwap_design_system/molecules/zwap_scroll_controls_list_tile/zwap_scroll_controls_list_tile.dart';
import 'package:zwap_design_system/molecules/scroll_arrow/zwap_scroll_arrow.dart';
import 'package:zwap_design_system/zwap_design_system.dart';

class ZwapScrollItemsStory extends StatefulWidget {
  const ZwapScrollItemsStory({Key? key}) : super(key: key);

  @override
  State<ZwapScrollItemsStory> createState() => _ZwapScrollItemsStoryState();
}

class _ZwapScrollItemsStoryState extends State<ZwapScrollItemsStory> {
  final ScrollController _scrollController = ScrollController();

  static const int _childWidth = 150;

  bool _enabledLeft = true;
  bool _enabledBottom = true;
  bool _enableRigth = true;
  bool _enableTop = true;
  bool _enableScrollControls = true;
  bool _showViewAll = true;

  bool _isAtStart = true;
  bool _isAtEnd = false;

  bool _isRowLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _isAtEnd = _scrollController.position.atEdge && _scrollController.offset != 0;
        _isAtStart = _scrollController.position.atEdge && _scrollController.offset == 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable Rigth', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _enabledLeft, onValueChange: (v) => setState(() => _enabledLeft = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable Left', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _enableRigth, onValueChange: (v) => setState(() => _enableRigth = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable Top', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _enableTop, onValueChange: (v) => setState(() => _enableTop = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable Bottom', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _enabledBottom, onValueChange: (v) => setState(() => _enabledBottom = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable Scroll Controls', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _enableScrollControls, onValueChange: (v) => setState(() => _enableScrollControls = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Enable View All', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _showViewAll, onValueChange: (v) => setState(() => _showViewAll = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Set Row Loading', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _isRowLoading, onValueChange: (v) => setState(() => _isRowLoading = v)),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: double.infinity,
          color: ZwapColors.neutral300,
        ),
        SizedBox(width: 20),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: "ZwapScrollArrows", zwapTextType: ZwapTextType.bigBodyBold, textColor: ZwapColors.neutral800),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(width: 30),
                      ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.bottom,
                        disabled: !_enabledBottom,
                        onTap: () {},
                      ),
                      SizedBox(width: 20),
                      ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.top,
                        disabled: !_enableTop,
                        onTap: () {},
                      ),
                      SizedBox(width: 20),
                      ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.left,
                        disabled: !_enabledLeft,
                        onTap: () {},
                      ),
                      SizedBox(width: 20),
                      ZwapScrollArrow(
                        direction: ZwapScrollArrowDirection.right,
                        disabled: !_enableRigth,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  ZwapText(text: "ZwapScrollControlsListTile", zwapTextType: ZwapTextType.bigBodyBold, textColor: ZwapColors.neutral800),
                  SizedBox(height: 12),
                  ZwapScrollControlsListTile(
                    title: "Title of ListTile",
                    translateKeyFunction: (key) => {'view_all': "Vedi tutti"}[key]!,
                    leftEnabled: _enabledLeft,
                    rigthEnabled: _enableRigth,
                    showScrollControls: _enableScrollControls,
                    showViewAll: _showViewAll,
                    onLeftScrollControlTap: () {},
                    onRigthScrollControlTap: () {},
                    onViewAllTap: () {},
                  ),
                  SizedBox(height: 50),
                  ZwapText(text: "ZwapScrollControlsListTile Use Example", zwapTextType: ZwapTextType.bigBodyBold, textColor: ZwapColors.neutral800),
                  SizedBox(height: 12),
                  ZwapScrollControlsListTile(
                    title: "Title of ListTile",
                    translateKeyFunction: (key) => {'view_all': "Vedi tutti"}[key]!,
                    leftEnabled: _enabledLeft && !_isAtStart,
                    rigthEnabled: _enableRigth && !_isAtEnd,
                    showScrollControls: _enableScrollControls,
                    showViewAll: _showViewAll,
                    onLeftScrollControlTap: () {
                      final int visibleChildCount = (MediaQuery.of(context).size.width - 400) ~/ 190;

                      _scrollController.animateTo(
                          max(_scrollController.position.minScrollExtent, _scrollController.offset - visibleChildCount * _childWidth),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn);
                    },
                    onRigthScrollControlTap: () {
                      final int visibleChildCount = (MediaQuery.of(context).size.width - 400) ~/ 190;

                      _scrollController.animateTo(
                          min(_scrollController.position.maxScrollExtent, _scrollController.offset + visibleChildCount * _childWidth),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn);
                    },
                    onViewAllTap: () {
                      ZwapToasts.showSuccessToast("Vedi tutti cliccato", context: context);
                    },
                    trailing: _isRowLoading
                        ? Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.3,
                              valueColor: AlwaysStoppedAnimation(ZwapColors.primary700),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 400,
                    height: 190,
                    child: ListView.builder(
                      itemCount: 30,
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        width: _childWidth.toDouble(),
                        height: 150,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
