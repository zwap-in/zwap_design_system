import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/select/zwap_select.dart';

class ZwapSelectStory extends StatefulWidget {
  const ZwapSelectStory({Key? key}) : super(key: key);

  @override
  State<ZwapSelectStory> createState() => _ZwapSelectStoryState();
}

class _ZwapSelectStoryState extends State<ZwapSelectStory> {
  String? _selected;
  String? _secondSelected;
  List<String> _multipleSelected = [];

  double __top = 0;
  set _top(double value) {
    __top = min(max(0, value), MediaQuery.of(context).size.height);
  }

  List<String> _getValues() {
    String getRandomString() {
      const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890';
      final Random _rnd = Random();

      String _res = '';

      for (int i = 0; i < 20; i++) {
        _res += _chars[_rnd.nextInt(_chars.length)];
      }

      return _res;
    }

    return [
      for (int i = 0; i < 17; i++) getRandomString(),
    ];
  }

  Future<List<String>> _getNewValues(String search, int page) async {
    await Future.delayed(const Duration(milliseconds: 3750));

    if (search == 'ciao') return [];

    /* if (search.isEmpty) return _getValues();

    switch (search) {
      case "Roma":
        return [
          "Roma ${1 + (page * 6)}",
          "Roma ${2 + (page * 6)}",
          "Roma ${3 + (page * 6)}",
          "Roma ${4 + (page * 6)}",
          "Roma ${5 + (page * 6)}",
          "Roma ${6 + (page * 6)}",
        ];
      case "Milano":
        return [
          "Milano ${1 + (page * 6)}",
          "Milano ${2 + (page * 6)}",
          "Milano ${3 + (page * 6)}",
          "Milano ${4 + (page * 6)}",
          "Milano ${5 + (page * 6)}",
          "Milano ${6 + (page * 6)}",
        ];
    } */
    if (page > 4) return [];
    return _getValues();
  }

  List<String>? _values;

  @override
  Widget build(BuildContext context) {
    if (_values == null) {
      _values = _getValues();
    }

    return Listener(
      onPointerSignal: (signal) {
        if (signal is PointerScrollEvent) {
          setState(() => _top = __top - signal.scrollDelta.dy);
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
                left: min(MediaQuery.of(context).size.width * 0.25, 400),
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      child: ZwapSelect(
                        canSearch: true,
                        canAddItem: true,
                        onAddItem: (value) {
                          setState(() => _selected = value);
                        },
                        values: {
                          if (_selected != null && !_values!.any((e) => e == _selected)) _selected!: _selected!,
                          ...Map.fromIterable(_values!, key: (i) => i, value: (i) => i),
                        },
                        fetchMoreData: (String newQuery, int pageNumber) async {
                          return Map.fromIterable(await _getNewValues(newQuery, pageNumber), key: (i) => i, value: (i) => i);
                        },
                        hintText: "Seleziona un elemento",
                        label: "Zwap Select",
                        callBackFunction: (value, _) {
                          setState(() => _selected = value);
                        },
                        selected: _selected,
                        initialPageNumber: 2,
                        betweenFetchDuration: const Duration(seconds: 2),
                        onEmptyResponseDuration: const Duration(seconds: 10),
                        translateText: (key) => {
                          'not_here': 'non c\'è?',
                          'add_here': 'Aggiungilo qui',
                        }[key]!,
                        searchType: ZwapSelectSearchTypes.dynamic,
                      ),
                    ),
                    Container(
                      width: 300,
                      child: ZwapSelect(
                        values: {for (int i in List.generate(4, (i) => i)) '$i': '$i•••••••••$i'},
                        fetchMoreData: (String newQuery, int pageNumber) async {
                          await Future.delayed(const Duration(milliseconds: 1000));
                          return {};
                        },
                        hintText: "Seleziona un elemento",
                        label: "Zwap Select Lil",
                        callBackFunction: (value, _) => setState(() => _secondSelected = value),
                        selected: _secondSelected,
                        initialPageNumber: 2,
                        betweenFetchDuration: const Duration(seconds: 2),
                        onEmptyResponseDuration: const Duration(seconds: 10),
                        translateText: (key) => {
                          'not_here': 'non c\'è?',
                          'add_here': 'Aggiungilo qui',
                        }[key]!,
                      ),
                    ),
                    Container(
                      width: 500,
                      child: ZwapSelect.multiple(
                        canSearch: true,
                        values: Map.fromEntries(List.generate(50,
                            (i) => MapEntry<String, String>(i.toString(), '$i-$i•$i ${i % 3 == 0 ? 'djhfasjdhflajsdh fadhfdjfh adjf agh' : ''}'))),
                        hintText: "Seleziona un elemento",
                        label: "Zwap Select",
                        callBackFunction: (_, value) => setState(() => _multipleSelected = value ?? []),
                        selectedValues: _multipleSelected,
                        initialPageNumber: 2,
                        canAddItem: true,
                        onAddItem: (item) => print(item),
                        fetchMoreData: (search, _) async {
                          await Future.delayed(const Duration(milliseconds: 800));
                          return search.isEmpty ? {} : {search: search};
                        },
                        betweenFetchDuration: const Duration(seconds: 2),
                        onEmptyResponseDuration: const Duration(seconds: 10),
                        translateText: (key) => {
                          'not_here': 'Non trovi quello che cerchi?',
                          'add_here': 'Aggiungilo qui',
                        }[key]!,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 30),
                top: __top + 200,
                left: min(MediaQuery.of(context).size.width * 0.2, 250),
                child: Container(
                  width: 500,
                  child: ZwapSelect(
                    canSearch: true,
                    values: Map.fromEntries(List.generate(
                        50, (i) => MapEntry<String, String>(i.toString(), '$i-$i•$i ${i % 3 == 0 ? 'djhfasjdhflajsdh fadhfdjfh adjf agh' : ''}'))),
                    hintText: "Seleziona un elemento",
                    label: "Zwap Select",
                    callBackFunction: (_, value) => setState(() => _multipleSelected = [_]),
                    selected: '1',
                    initialPageNumber: 2,
                    betweenFetchDuration: const Duration(seconds: 2),
                    onEmptyResponseDuration: const Duration(seconds: 10),
                    translateText: (key) => {
                      'not_here': 'Non trovi quello che cerchi?',
                      'add_here': 'Aggiungilo qui',
                    }[key]!,
                    onAddItem: (item) => print(item),
                    fetchMoreData: (search, _) async {
                      await Future.delayed(const Duration(milliseconds: 800));
                      return search.isEmpty ? {} : {search: search};
                    },
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
