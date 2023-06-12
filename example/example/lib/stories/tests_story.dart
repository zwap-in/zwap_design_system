import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/percent_widget/percent_widget.dart';
import 'package:zwap_design_system/molecules/zwap_modal/zwap_modal.dart';
import 'package:zwap_design_system/zwap_design_system.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_utils/zwap_utils.dart';



class ZwapTestsStory extends StatefulWidget {
  const ZwapTestsStory({Key? key}) : super(key: key);

  @override
  State<ZwapTestsStory> createState() => _ZwapTestsStoryState();
}

class _ZwapTestsStoryState extends State<ZwapTestsStory> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleTalentWidget(),
            SizedBox(height: 20),
            SingleTalentWidget(),
            SizedBox(height: 20),
            SingleTalentWidget(),
          ],
        ),
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

class SingleTalentWidget extends StatelessWidget {
  const SingleTalentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _topPadding(double padding, Widget child) {
      return Padding(
        padding: EdgeInsets.only(top: padding),
        child: child,
      );
    }

    return SizedBox(
      height: 64,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ZwapCheckBox(
            value: false,
            onCheckBoxClick: (value) {},
          ),
          const SizedBox(width: 16),
          _PersonalInfo(),
          const Spacer(),
          _topPadding(
            15,
            const _AvatarsWidget(urls: [
              "https://picsum.photos/200/200",
              "https://picsum.photos/200/200",
              "https://picsum.photos/200/200",
            ]),
          ),
          const Spacer(),
          _topPadding(18, const _StateBadge()),
          const Spacer(),
          _topPadding(20, _CityBadge(city: "London")),
          const Spacer(),
          _topPadding(20, const _MockTag(text: "Engineering")),
          const Spacer(),
          _topPadding(20, const _MockTag(text: "Mobile")),
        ],
      ),
    );
  }
}

class _PersonalInfo extends StatelessWidget {
  const _PersonalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZwapText(
          text: "Alessandro Marchetti",
          zwapTextType: ZwapTextType.bigBodyBold,
          textColor: ZwapColors.primary900Dark,
        ),
        ZwapText(
          text: "Frontend Developer",
          zwapTextType: ZwapTextType.mediumBodyRegular,
          textColor: ZwapColors.primary900Dark,
        ),
        ZwapText(
          text: 'alessandro@zwap.in',
          zwapTextType: ZwapTextType.mediumBodyRegular,
          textColor: ZwapColors.text65,
        ),
      ],
    );
  }
}

class _AvatarsWidget extends StatelessWidget {
  final List<String> urls;

  const _AvatarsWidget({required this.urls, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _images = urls.take(2).toList();
    final int _remaining = urls.length - 2;

    return SizedBox(
      height: 38,
      width: 88,
      child: Stack(
        children: [
          ..._images
              .mapIndexed(
                (i, url) => Positioned(
                  left: i * 25,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: ZwapColors.shades0, width: 1.5),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(url, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          if (_remaining > 0)
            Positioned(
              left: 50,
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: ZwapColors.shades0, width: 1.5),
                ),
                child: Center(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: ZwapColors.text65,
                    ),
                    child: Center(
                      child: ZwapText(
                        text: "+$_remaining",
                        zwapTextType: ZwapTextType.smallBodyRegular,
                        textColor: ZwapColors.shades0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StateBadge extends StatelessWidget {
  const _StateBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: ZwapColors.error100,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ZwapText(
        text: "Waiting for contract sign ✍️",
        zwapTextType: ZwapTextType.mediumBodyRegular,
        textColor: ZwapColors.error400,
      ),
    );
  }
}

class _CityBadge extends StatelessWidget {
  final String city;

  const _CityBadge({required this.city, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZwapText(
      text: city.capitalize(),
      zwapTextType: ZwapTextType.mediumBodyRegular,
      textColor: ZwapColors.primary900Dark,
    );
  }
}

class _MockTag extends StatelessWidget {
  final String text;
  const _MockTag({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: ZwapColors.primary50,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ZwapText(
        text: text,
        zwapTextType: ZwapTextType.mediumBodyRegular,
        textColor: ZwapColors.primary700,
      ),
    );
  }
}
