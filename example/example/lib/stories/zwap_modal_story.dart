import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/percent_widget/percent_widget.dart';
import 'package:zwap_design_system/molecules/zwap_modal/zwap_modal.dart';
import 'package:zwap_design_system/zwap_design_system.dart';
import 'package:provider/provider.dart';

class ZwapModalStory extends StatefulWidget {
  const ZwapModalStory({Key? key}) : super(key: key);

  @override
  State<ZwapModalStory> createState() => _ZwapModalStoryState();
}

class _ZwapModalStoryState extends State<ZwapModalStory> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZwapButton(
        buttonChild: ZwapButtonChild.text(text: "Open Modal"),
        decorations: ZwapButtonDecorations.primaryLight(),
        onTap: () {
          showNewZwapModal(context, _ModalChild());
        },
      ),
    );
  }
}

enum _ModalSteps { first, second, third }

class _ModalProdiver extends ChangeNotifier {
  _ModalSteps _step = _ModalSteps.first;

  _ModalSteps get step => _step;

  set step(_ModalSteps value) => value != _step ? {_step = value, notifyListeners()} : null;

  _ModalProdiver() : super();

  void back() {
    switch (_step) {
      case _ModalSteps.first:
        break;
      case _ModalSteps.second:
        step = _ModalSteps.first;
        break;
      case _ModalSteps.third:
        step = _ModalSteps.second;
        break;
    }
  }

  bool forward() {
    switch (_step) {
      case _ModalSteps.first:
        step = _ModalSteps.second;
        break;
      case _ModalSteps.second:
        step = _ModalSteps.third;
        break;
      case _ModalSteps.third:
        return true;
    }
    return false;
  }
}

class _ModalChild extends StatelessWidget {
  _ModalChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ModalProdiver>(
      create: (_) => _ModalProdiver(),
      child: Builder(builder: (context) {
        return NewModal(
          scrollable: false,
          width: 400,
          topLeftWidget: Builder(
            builder: (context) {
              final _ModalSteps step = context.select<_ModalProdiver, _ModalSteps>((state) => state.step);

              if (step != _ModalSteps.first)
                return NewModalTopLeftWidget.backButton(
                  onTap: () => context.read<_ModalProdiver>().back(),
                );
              return Container();
            },
          ),
          title: Text("Titolooo"),
          addPaddingToBodyWidget: false,
          bodyWidget: Builder(builder: (context) {
            int step = context.select<_ModalProdiver, int>((state) => state.step.index);
            return NewModalMultiStepWidget(
              currentStep: step,
              children: [
                Container(key: ValueKey(1), width: 400, color: Colors.blue),
                Container(key: ValueKey("fkjgbnadkfjgnsadòjkfgnòsdfjn"), width: 400, color: Colors.amber),
                Container(key: ValueKey("ldkgnadsljgnadl"), width: 400, color: Colors.red),
              ],
              heigth: 500,
            );
          }),
          bottomWidget: Builder(
            builder: (context) {
              final _ModalSteps step = context.select<_ModalProdiver, _ModalSteps>((state) => state.step);

              return NewModalBottomWidget.singleButton(
                buttonText: step == _ModalSteps.third ? "Done" : "Continue",
                onTapButton: () {
                  if (context.read<_ModalProdiver>().forward()) Navigator.pop(context);
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _ModalBody extends StatefulWidget {
  _ModalBody({Key? key}) : super(key: key);

  @override
  State<_ModalBody> createState() => _ModalBodyState();
}

class _ModalBodyState extends State<_ModalBody> {
  final PageController c = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ModalBody oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _ModalSteps step = context.select<_ModalProdiver, _ModalSteps>((state) => state.step);

    if (c.positions.isNotEmpty && (c.page ?? 0) != step.index) {
      c.animateToPage(step.index, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
    }

    return Container(
      height: 400,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: c,
        children: [
          Container(key: ValueKey(1), width: 400, color: Colors.blue),
          Container(key: ValueKey("fkjgbnadkfjgnsadòjkfgnòsdfjn"), width: 400, color: Colors.amber),
          Container(key: ValueKey("ldkgnadsljgnadl"), width: 400, color: Colors.red),
        ],
      ),
    );
  }
}
