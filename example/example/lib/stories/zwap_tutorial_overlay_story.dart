import 'package:example/stories/zwap_buttons_story.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/button/zwap_button.dart';
import 'package:zwap_design_system/molecules/tutorial_overlay/zwap_tutorial_overlay.dart';
import 'package:provider/provider.dart';

class FakeProvider extends ChangeNotifier {
  int get constantInt => 4;
}

class ZwapTutorialOverlayStory extends StatefulWidget {
  ZwapTutorialOverlayStory({Key? key}) : super(key: key);

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
            content: ZwapTutorialStepContent(
          leading: Text('✨', style: TextStyle(fontSize: 32)),
          title: 'Ciao 1',
          subtitle: "Irure do fugiat mollit irure est et.",
        )),
        ZwapTutorialStep(
            content: ZwapTutorialStepContent(
          leading: Text('🔮', style: TextStyle(fontSize: 32)),
          title: 'Ciao 2',
          subtitle: "Irure do fugiat mollit irure est et.",
        )),
        ZwapTutorialStep(
            content: ZwapTutorialStepContent(
          leading: Text('🫂', style: TextStyle(fontSize: 32)),
          title: 'Ciao 3',
          subtitle: "Irure do fugiat mollit irure est et.",
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FakeProvider>.value(
          value: _fakeProvider,
        )
      ],
      child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 120),
              child: GestureDetector(
                onTap: () => _controller.start(),
                child: ZwapTutorialOverlayFocusWidget(
                  key: _controller.registerTutorialStep(0),
                  childBuilder: (context) {
                    return Container(
                      width: 200,
                      height: 100,
                      color: Colors.green,
                      child: Center(child: Text("PASSO 1")),
                    );
                  },
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
                  child: Center(child: Text("PASSO 3")),
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
                  builder: (_) => ZwapSimpleTutorialWidget(
                    focusWidgetWrapper: (context, child) => ChangeNotifierProvider.value(
                      value: _fakeProvider,
                      child: child,
                    ),
                    width: 320,
                    focusWidgetKey: _key,
                    onClose: () => entry.remove(),
                    child: ZwapTutorialStepContent(
                      title: "Sono un coso singolo",
                      subtitle: "Enim et commodo ea deserunt est qui sint sit veniam ipsum esse proident voluptate.",
                      leading: Text('🐝', style: TextStyle(fontSize: 32)),
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
    );
  }
}
