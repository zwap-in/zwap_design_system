import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/utils/edge_notifier_scroll_controller.dart';

class ZwapButtonsStory extends StatefulWidget {
  const ZwapButtonsStory({Key? key}) : super(key: key);

  @override
  State<ZwapButtonsStory> createState() => _ZwapButtonsStoryState();
}

class _ZwapButtonsStoryState extends State<ZwapButtonsStory> {
  bool _disabled = false;
  bool _loading = false;

  bool _isSelected = false;

  double _completionValue = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Loading State', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _loading, onValueChange: (v) => setState(() => _loading = v)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Disabled State', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  SizedBox(width: 20),
                  ZwapSwitch(value: _disabled, onValueChange: (v) => setState(() => _disabled = v)),
                ],
              ),
              SizedBox(height: 20),
              ZwapText(text: 'Completion Value (0...1)', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              Slider(
                value: _completionValue,
                onChanged: (value) {
                  setState(() => _completionValue = value);
                },
                max: 1,
                min: 0,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: EdgeNotifierScrollController(
              onEndReached: () => print('endReached'),
              delayDuration: const Duration(seconds: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ZwapText(text: 'ZwapButton with completion', zwapTextType: ZwapTextType.bigBodySemibold, textColor: ZwapColors.shades100),
                ZwapButton(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  height: 40,
                  width: 88,
                  buttonChild: ZwapButtonChild.text(text: "Label"),
                  loading: _loading,
                  disabled: _disabled,
                  decorations: ZwapButtonDecorations.primaryLight(),
                  completionValue: _completionValue,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text - Primary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.primaryLight(),
                      ),
                    ),
                    Tooltip(
                      message: "Text - Secondary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.secondaryLight(),
                      ),
                    ),
                    Tooltip(
                      message: "Text - Tertiary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.tertiary(),
                      ),
                    ),
                    Tooltip(
                      message: "Text - Quaternary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 45,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.quaternary(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text and Icon - Primary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.primaryLight(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Secondary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.secondaryLight(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Tertiary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.tertiary(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Quaternary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.quaternary(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Icon - Primary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.primaryLight(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Icon - Secondary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.secondaryLight(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Icon - Tertiary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.tertiary(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Icon - Quaternary",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 45,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.quaternary(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text - Gradient",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.gradient(),
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Gradient",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.gradient(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Icon - Gradient",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.gradient(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text - Primary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.primaryDark(),
                      ),
                    ),
                    Tooltip(
                      message: "Text - Secondary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.secondaryDark(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text and Icon - Primary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.primaryDark(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Secondary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.secondaryDark(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Icon - Primary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.primaryDark(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Icon - Secondary Dark",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.secondaryDark(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text - Primary Destructive",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.destructivePrimary(),
                      ),
                    ),
                    Tooltip(
                      message: "Text - Secondary Destructive",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 88,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.destructiveSecondary(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Text and Icon - Primary Destructive",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.destructivePrimary(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                    Tooltip(
                      message: "Text and Icon - Secondary Destructive",
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 44,
                        buttonChild: ZwapButtonChild.textWithIcon(text: "Label", icon: Icons.settings),
                        decorations: ZwapButtonDecorations.destructiveSecondary(),
                        loading: _loading,
                        disabled: _disabled,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: 'Icon - Primary Destructive',
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.destructivePrimary(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Icon - Secondary Destructive',
                      child: ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 40,
                        width: 44,
                        buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.destructiveSecondary(
                          borderRadius: BorderRadius.circular(100),
                          internalPadding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ZwapColors.neutral800.withOpacity(0.7),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: 'Icon - Trasparent Roud ~ Video Platform',
                        child: ZwapButton(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          height: 40,
                          width: 44,
                          buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                          loading: _loading,
                          disabled: _disabled,
                          decorations: ZwapButtonDecorations.videoPlatformDecorations.transparentRound(),
                        ),
                      ),
                      Tooltip(
                        message: 'Icon - Destructive Roud ~ Video Platform',
                        child: ZwapButton(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          height: 40,
                          width: 44,
                          buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                          loading: _loading,
                          disabled: _disabled,
                          decorations: ZwapButtonDecorations.videoPlatformDecorations.destructiveRound(),
                        ),
                      ),
                      Tooltip(
                        message: 'Icon - Full Trasparent Roud ~ Video Platform',
                        child: ZwapButton(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          height: 40,
                          width: 44,
                          buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                          loading: _loading,
                          disabled: _disabled,
                          decorations: ZwapButtonDecorations.videoPlatformDecorations.fullTranparentRound(),
                        ),
                      ),
                      Tooltip(
                        message: 'Icon - Filled Round ~ Video Platform',
                        child: ZwapButton(
                          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          height: 40,
                          width: 44,
                          buttonChild: ZwapButtonChild.icon(icon: Icons.settings),
                          loading: _loading,
                          disabled: _disabled,
                          decorations: ZwapButtonDecorations.videoPlatformDecorations.filledRound(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                ZwapText(
                  text: "A strange concept of button",
                  zwapTextType: ZwapTextType.bigBodySemibold,
                  textColor: ZwapColors.primary900Dark,
                ),
                SizedBox(height: 8),
                ZwapButton.customChild(
                  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  height: 260,
                  width: 208,
                  hoverElevation: 4,
                  isSelected: _isSelected,
                  selectedDecorations: ZwapButtonDecorations.selectableButtonDecorations.selectedDecorations(),
                  child: (state) => Column(
                    children: [
                      Icon(Icons.tab, size: 35, color: ZwapColors.primary700),
                      SizedBox(height: 20),
                      ZwapText(
                        text: "Press me",
                        zwapTextType: ZwapTextType.mediumBodyRegular,
                        textColor: ZwapColors.primary900Dark,
                      ),
                    ],
                  ),
                  loading: _loading,
                  disabled: _disabled,
                  decorations: ZwapButtonDecorations.selectableButtonDecorations.defaultDecorations(),
                  onTap: () => setState(() => _isSelected = !_isSelected),
                ),
                SizedBox(height: 230),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
