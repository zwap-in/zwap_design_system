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
      child: NewModal(
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
        bodyWidget: _ModalBody(),
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
      ),
    );
  }
}

class _ModalBody extends StatelessWidget {
  int _previousIndex = 0;

  _ModalBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ModalSteps step = context.select<_ModalProdiver, _ModalSteps>((state) => state.step);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.decelerate,
      switchOutCurve: Curves.decelerate.flipped,
      child: Container(
        key: ValueKey(step),
        height: 400,
        color: Colors.red.withOpacity(0.3 + 0.6 * (step.index / 2)),
      ),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final inAnimation =
            Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(CurvedAnimation(parent: animation, curve: Curves.decelerate));
        final outAnimation = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(parent: animation, curve: Curves.decelerate.flipped));

        WidgetsBinding.instance?.addPostFrameCallback((_) => _previousIndex = step.index);

        if (child.key == ValueKey(step)) {
          return ClipRect(
            child: SlideTransition(
              position: step.index < _previousIndex ? outAnimation : inAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
          );
        } else {
          return ClipRect(
            child: SlideTransition(
              position: step.index < _previousIndex ? inAnimation : outAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
          );
        }
      },
    );
  }
}
