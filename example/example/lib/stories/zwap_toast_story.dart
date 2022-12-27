import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/toast/zwapToast.dart';

class ZwapToastStory extends StatefulWidget {
  const ZwapToastStory({Key? key}) : super(key: key);

  @override
  State<ZwapToastStory> createState() => _ZwapToastStoryState();
}

class _ZwapToastStoryState extends State<ZwapToastStory> {
  final TextEditingController _controller = TextEditingController(text: 'Eu adipisicing consequat quis nulla fugiat et consectetur proident.');
  bool _showDismiss = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 300, child: ZwapInput(controller: _controller)),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ZwapText(
              text: 'Show dismiss',
              zwapTextType: ZwapTextType.mediumBodyRegular,
              textColor: ZwapColors.primary900Dark,
            ),
            const SizedBox(width: 12),
            ZwapSwitch(
              value: _showDismiss,
              onChange: (value) => setState(() => _showDismiss = value),
            ),
          ],
        ),
        const SizedBox(height: 55),
        ZwapButton(
          width: 220,
          height: 45,
          decorations: ZwapButtonDecorations.quaternary(),
          buttonChild: ZwapButtonChild.text(text: 'Show success toast'),
          onTap: () => ZwapToasts.showSuccessToast(_controller.text, context: context, showDismiss: _showDismiss),
        ),
        const SizedBox(height: 16),
        ZwapButton(
          width: 220,
          height: 45,
          decorations: ZwapButtonDecorations.quaternary(),
          buttonChild: ZwapButtonChild.text(text: 'Show error toast'),
          onTap: () => ZwapToasts.showErrorToast(_controller.text, context: context, showDismiss: _showDismiss),
        ),
        const SizedBox(height: 16),
        ZwapButton(
          width: 220,
          height: 45,
          decorations: ZwapButtonDecorations.quaternary(),
          buttonChild: ZwapButtonChild.text(text: 'Show warning toast'),
          onTap: () => ZwapToasts.showWarningToast(_controller.text, context: context, showDismiss: _showDismiss),
        ),
        const SizedBox(height: 16),
        ZwapButton(
          width: 220,
          height: 45,
          decorations: ZwapButtonDecorations.quaternary(),
          buttonChild: ZwapButtonChild.text(text: 'Show info toast'),
          onTap: () => ZwapToasts.showInfoToast(_controller.text, context: context, showDismiss: _showDismiss),
        ),
      ],
    );
  }
}
