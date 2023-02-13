import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/button/zwap_button.dart';
import 'package:zwap_design_system/atoms/clippers/zwap_message_clipper.dart';
import 'package:zwap_design_system/atoms/text/text.dart';
import 'package:zwap_design_system/atoms/toolTip/zwap_tooltip.dart';
import 'package:zwap_design_system/molecules/tutorial_overlay/zwap_tutorial_overlay.dart';
import 'package:provider/provider.dart';

class FakeProvider extends ChangeNotifier {
  int get constantInt => 4;
}

class ZwapTutorialOverlayStory extends StatefulWidget {
  const ZwapTutorialOverlayStory({Key? key}) : super(key: key);

  @override
  State<ZwapTutorialOverlayStory> createState() => _ZwapTutorialOverlayStoryState();
}

class _ZwapTutorialOverlayStoryState extends State<ZwapTutorialOverlayStory> {
  late final ZwapTutorialController _controller;
  final GlobalKey _key = GlobalKey();

  final FakeProvider _fakeProvider = FakeProvider();

  @override
  void initState() {
    super.initState();

    _controller = ZwapTutorialController(
      insertOverlayCallback: (entry) => Overlay.of(context)?.insert(entry),
      steps: [
        ZwapTutorialStep(
            showSkip: true,
            width: 220,
            overlayOffset: const Offset(30, 0),
            content: ZwapTutorialStepContent(
              title: 'Da qui potrai condividere la tua agenda con tutti.',
              subtitle: "Da qui potrai condividere la tua agenda con tutti.",
            )),
        ZwapTutorialStep(
            showBack: true,
            content: ZwapTutorialStepContent(
              title: 'Ciao 2',
              subtitle: "Irure do fugiat mollit irure est et.",
            )),
        ZwapTutorialStep(
            decorationDirection: DecorationDirection.right,
            decorationTranslation: 13,
            focusWidgetWrapper: (_, child) => Container(
                  color: ZwapColors.success400,
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                  child: child,
                ),
            overlayOffset: Offset(10, 0),
            showSkip: true,
            content: ZwapTutorialStepContent(
              title: 'Ciao 3',
              subtitle: "Irure do fugiat mollit irure est et.",
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<FakeProvider>.value(
            value: _fakeProvider,
          )
        ],
        child: Center(
          key: _controller.registerTutorialStepBackgroundRegion(0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 120),
                child: Center(
                  child: GestureDetector(
                    onTap: () => _controller.start(),
                    child: ZwapTutorialOverlayFocusWidget(
                      key: _controller.registerTutorialStep(0),
                      childBuilder: (context) {
                        return Container(
                          width: 200,
                          height: 100,
                          color: Colors.green,
                          child: ZwapTooltip(
                            message: "Cupidatat velit commodo labore\nullamco incididunt anim minim nulla sit\nfugiat ea excepteur quis pariatur.",
                            child: Center(child: Text("PASSO 1")),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              ZwapTutorialOverlayFocusWidget(
                key: _controller.registerTutorialStep(2),
                childBuilder: (context) {
                  return Container(
                    width: 200,
                    height: 100,
                    color: Colors.red,
                    child: ZwapTooltip(
                      animationDuration: Duration(milliseconds: 200),
                      position: TooltipPosition.rigth,
                      padding: const EdgeInsets.all(12),
                      decorationTranslation: -15,
                      message: "Clicca e trascina per\nselezionare più slot\nconsecutivi.",
                      child: Center(child: Text("PASSO 3")),
                      style: getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.shades0),
                      delay: const Duration(milliseconds: 150),
                      disappearAfter: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              SizedBox(height: 60),
              Container(
                margin: const EdgeInsets.only(right: 75),
                child: ZwapTutorialOverlayFocusWidget(
                  key: _controller.registerTutorialStep(1),
                  childBuilder: (context) {
                    return Container(
                      width: 200,
                      height: 100,
                      color: Colors.blue,
                      child: Center(child: Text("PASSO 2")),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  var entry;
                  entry = ZwapTutorialOverlayEntry(
                    uniqueKey: GlobalKey(),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    builder: (_) => ZwapSimpleTutorialWidget(
                      overlayOffset: const Offset(-130, 5),
                      focusWidgetWrapper: (context, child) => ChangeNotifierProvider.value(
                        value: _fakeProvider,
                        child: child,
                      ),
                      width: 320,
                      focusWidgetKey: _key,
                      onClose: () => entry.remove(),
                      blur: false,
                      dismissible: true,
                      child: ZwapTutorialStepContent.customChild(
                        builder: (context) => Container(
                          width: 292,
                          decoration: BoxDecoration(
                            color: ZwapColors.shades100.withOpacity(.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ZwapText(
                                text: 'Da qui potrai gestire e condividere il tuo progetto!',
                                zwapTextType: ZwapTextType.bigBodySemibold,
                                textColor: ZwapColors.shades0,
                              ),
                              ZwapText(
                                text: 'Clicca sul pulsate per condividere, modificare o eliminare questo progetto.',
                                zwapTextType: ZwapTextType.smallBodyRegular,
                                textColor: ZwapColors.shades0,
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ZwapButton(
                                  width: 80,
                                  height: 32,
                                  decorations: ZwapButtonDecorations.quaternary(
                                    internalPadding: EdgeInsets.zero,
                                    backgroundColor: ZwapColors.whiteTransparent,
                                    hoverColor: ZwapColors.shades0.withOpacity(0.75),
                                    focussedColor: ZwapColors.shades0.withOpacity(0.75),
                                    pressedColor: ZwapColors.shades0.withOpacity(0.9),
                                    contentColor: ZwapColors.shades0,
                                    hoverContentColor: ZwapColors.primary900Dark,
                                    focussedContentColor: ZwapColors.primary900Dark,
                                    pressedContentColor: ZwapColors.primary900Dark,
                                    border: Border.all(color: ZwapColors.shades0),
                                    hoverBorder: Border.all(color: ZwapColors.shades0),
                                    focussedBorder: Border.all(color: ZwapColors.shades0),
                                    pressedBorder: Border.all(color: ZwapColors.shades0),
                                  ),
                                  buttonChild: ZwapButtonChild.text(text: 'Ho capito', fontSize: 12, fontWeight: FontWeight.w500),
                                  onTap: () => entry.remove(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      cta: ZwapButton(
                        buttonChild: ZwapButtonChild.text(text: 'Fatto'),
                        decorations: ZwapButtonDecorations.quaternary(pressedBorder: null),
                        height: 35,
                        width: 130,
                        onTap: () => entry.remove(),
                      ),
                    ),
                  );

                  Overlay.of(context)?.insert(entry);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 75),
                  child: ZwapTutorialOverlayFocusWidget(
                    key: _key,
                    childBuilder: (context) {
                      final int fakeInt = context.read<FakeProvider>().constantInt;

                      return Container(
                        width: 200,
                        height: 100,
                        color: Colors.blue,
                        child: Center(child: Text("SINGOLO $fakeInt")),
                      );
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
