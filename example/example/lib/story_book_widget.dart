import 'package:example/main.dart';
import 'package:example/stories.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:provider/provider.dart';

class StoryBookWidget extends StatelessWidget {
  const StoryBookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ZwapStories _currentStory = context.select<StoryProvider, ZwapStories>((pro) => pro.currentStory);

    return Scaffold(
      appBar: AppBar(title: const Text("Zwap ~ Storybook")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(color: ZwapColors.neutral200, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: stories.map((e) => _getStorySelector(e, () => context.read<StoryProvider>().currentStory = e.story)).toList(),
                ),
              ),
            ),
            Expanded(child: Builder(builder: stories.firstWhere((s) => s.story == _currentStory).builder)),
          ],
        ),
      ),
    );
  }

  Widget _getStorySelector(ZwapStory story, Function() onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        child: ListTile(
          title: Text(
            story.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
