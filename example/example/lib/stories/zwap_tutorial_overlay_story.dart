import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/tutorial_overlay/zwap_tutorial_overlay.dart';

class ZwapTutorialOverlayStory extends StatefulWidget {
  ZwapTutorialOverlayStory({Key? key}) : super(key: key);

  @override
  State<ZwapTutorialOverlayStory> createState() => _ZwapTutorialOverlayStoryState();
}

class _ZwapTutorialOverlayStoryState extends State<ZwapTutorialOverlayStory> {
  late final ZwapTutorialController _controller;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = ZwapTutorialController(
      betweenStepCallback: (a, b) => print('$a - $b'),
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
    return Container(
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
                    width: 320,
                    focusWidgetKey: _key,
                    onClose: () => entry.remove(),
                    child: ZwapTutorialStepContent(
                      title: "Sono un coso singolo",
                      subtitle: "Enim et commodo ea deserunt est qui sint sit veniam ipsum esse proident voluptate.",
                      leading: Text('🐝', style: TextStyle(fontSize: 32)),
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
                    return Container(
                      width: 200,
                      height: 100,
                      color: Colors.blue,
                      child: Center(child: Text("SINGOLO")),
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
