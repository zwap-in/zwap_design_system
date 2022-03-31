import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/select/zwapSelect.dart';

class ZwapSelectStory extends StatefulWidget {
  const ZwapSelectStory({Key? key}) : super(key: key);

  @override
  State<ZwapSelectStory> createState() => _ZwapSelectStoryState();
}

class _ZwapSelectStoryState extends State<ZwapSelectStory> {
  String? _selected;

  double __top = 0;
  set _top(double value) {
    __top = min(max(0, value), MediaQuery.of(context).size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          setState(() => _top = __top - signal.scrollDelta.dy);
          print(signal.device);
        }
      },
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _DraggableIndicator(
                onChangeDx: (top) => setState(() => _top = top),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 30),
                top: __top,
                left: 400,
                child: Container(
                  width: 300,
                  child: ZwapSelect(
                    canSearch: true,
                    values: Map.fromEntries(List.generate(50, (i) => MapEntry<String, String>(i.toString(), '$i-$i•$i'))),
                    fetchMoreData: (String newQuery, int pageNumber) async => {},
                    hintText: "Seleziona un elemento",
                    label: "Zwap Select",
                    callBackFunction: (value, _) => setState(() => _selected = value),
                    selected: _selected,
                    initialPageNumber: 2,
                    betweenFetchDuration: const Duration(seconds: 2),
                    onEmptyResponseDuration: const Duration(seconds: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraggableIndicator extends StatefulWidget {
  final Function(double) onChangeDx;

  const _DraggableIndicator({required this.onChangeDx, Key? key}) : super(key: key);

  @override
  State<_DraggableIndicator> createState() => __DraggableIndicatorState();
}

class __DraggableIndicatorState extends State<_DraggableIndicator> {
  double _top = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 30),
      top: _top,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() => _top += details.delta.dy);
          widget.onChangeDx(_top);
        },
        child: Container(height: 20, width: 20, color: ZwapColors.primary700),
      ),
    );
  }
}
