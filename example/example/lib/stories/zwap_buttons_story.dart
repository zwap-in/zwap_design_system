import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/radio/zwap_radio_widget.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/utils/edge_notifier_scroll_controller.dart';

const List<IconData> _icons = [
  Icons.ac_unit,
  Icons.safety_divider,
  Icons.javascript,
  Icons.abc,
  Icons.mail_outlined,
  Icons.label_important_outline_sharp,
  Icons.dangerous,
  Icons.kayaking,
  Icons.label,
  Icons.mail,
];

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

  /// can be 0 or 1
  int _selectedRadio = 0;

  String _completeText = 'Consequat eu voluptate proident';
  int? _showedChars = 12;

  String get _textPiece => _completeText.substring(0, _showedChars!);

  @override
  Widget build(BuildContext context) {
    final LinearGradient _buttonGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ZwapColors.warning200, ZwapColors.warning400, ZwapColors.buttonGrad.colors.first],
    );

    final LinearGradient _hoverButtonGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [ZwapColors.warning300, ZwapColors.warning400, ZwapColors.buttonGrad.colors.last],
    );

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
                  ZwapSwitch(
                    value: _loading,
                    onChange: (v) => setState(() => _loading = v),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ZwapText(text: 'Disabled State', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
                  const SizedBox(width: 20),
                  ZwapSwitch(value: _disabled, onChange: (v) => setState(() => _disabled = v)),
                ],
              ),
              const SizedBox(height: 20),
              ZwapText(text: 'Completion Value (0...1)', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              Slider(
                value: _completionValue,
                onChanged: (value) {
                  setState(() => _completionValue = value);
                },
                max: 1,
                min: 0,
              ),
              const SizedBox(height: 20),
              ZwapSwitch(
                value: _selectedRadio == 1,
                onChange: (value) => setState(() => _selectedRadio = value ? 1 : 0),
                activeColor: ZwapColors.shades0,
                activeThumbColor: ZwapColors.shades100,
                color: ZwapColors.neutral200,
                gradient: ZwapColors.acquaGradient(),
                thumbGradient: ZwapColors.violetGradient(),
                draggingThumbExtent: -6,
              ),
              const SizedBox(height: 20),
              ZwapText(text: 'Text lenght: $_showedChars', zwapTextType: ZwapTextType.bigBodyRegular, textColor: ZwapColors.shades100),
              Slider(
                value: (_showedChars ?? 1).toDouble(),
                onChanged: (value) => setState(() => _showedChars = value.toInt()),
                max: _completeText.length.toDouble(),
                divisions: _completeText.length,
                min: 0,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: EdgeNotifierScrollController(
              delayDuration: const Duration(seconds: 2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: false
                  ? [
                      SizedBox(height: 24),
                      ZwapButton(
                        width: 170,
                        height: 40,
                        buttonChild: ZwapButtonChild.text(text: "Prova prova"),
                        decorations: ZwapButtonDecorations.primaryLight(
                          gradient: _buttonGradient,
                          hoverGradient: _hoverButtonGradient,
                          pressedGradient: _hoverButtonGradient,
                          disabledGradient: _buttonGradient,
                          focussedGradient: _hoverButtonGradient,
                          pressedBorder: Border.all(color: ZwapColors.warning200),
                        ),
                        onTap: () => {},
                      ),
                      SizedBox(height: 24)
                    ]
                  : [
                      Row(
                        children: [
                          ZwapButton(
                            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            buttonChild: ZwapButtonChild.text(text: _textPiece),
                            loading: _loading,
                            disabled: _disabled,
                            height: 55,
                            width: 194,
                            decorations: ZwapButtonDecorations.primaryLight(),
                            onTap: ZwapButton.openOptions,
                            rightOptions: ZwapButtonOptions(
                              options: [
                                ZwapButtonOption(
                                  label: 'Deseleziona',
                                  icon: Icons.remove_circle_outline,
                                  onTap: () => print('Deseleziona'),
                                ),
                                ZwapButtonOption(
                                  label: 'Scarta',
                                  icon: Icons.cancel_outlined,
                                  onTap: () => print('Scarta'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 400,
                        height: 400,
                        color: ZwapColors.neutral200,
                        child: Column(
                          children: [
                            Center(
                              child: ZwapButton(
                                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                buttonChild: ZwapButtonChild.text(text: _textPiece),
                                loading: _loading,
                                disabled: _disabled,
                                decorations: ZwapButtonDecorations.primaryLight(),
                                onTap: ZwapButton.openOptions,
                                /* rightOptions: ZwapButtonOptions(
                                    options: [
                                      ZwapButtonOption(
                                        label: 'Deseleziona',
                                        icon: Icons.remove_circle_outline,
                                        onTap: () => print('Deseleziona'),
                                      ),
                                      ZwapButtonOption(
                                        label: 'Scarta',
                                        icon: Icons.cancel_outlined,
                                        onTap: () => print('Scarta'),
                                      ),
                                    ],
                                  ), */
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ZwapButton(
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        height: 32,
                        width: 130,
                        buttonChild: ZwapButtonChild.text(text: "Label"),
                        loading: _loading,
                        disabled: _disabled,
                        decorations: ZwapButtonDecorations.quaternary(
                          border: Border.all(color: ZwapColors.neutral200),
                        ),
                        onTap: ZwapButton.openOptions,
                        rightOptions: ZwapButtonOptions(
                          openOnBottom: true,
                          options: [
                            ZwapButtonOption(
                              label: 'Deseleziona',
                              icon: Icons.remove_circle_outline,
                              onTap: () => print('Deseleziona'),
                            ),
                            ZwapButtonOption(
                              label: 'Scarta',
                              icon: Icons.cancel_outlined,
                              onTap: () => print('Scarta'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ZwapButton(
                        key: ValueKey('slkdfjaksdfj'),
                        width: 194,
                        height: 55,
                        decorations: ZwapButtonDecorations.primaryLight(
                          internalPadding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(100),
                          gradient: ZwapColors.violetGradient(),
                        ),
                        completionValue: _completionValue,
                        disabled: false,
                        loading: _loading,
                        buttonChild: ZwapButtonChild.textWithIcon(
                          text: 'Prossimo',
                          iconPosition: ZwapButtonIconPosition.right,
                          icon: Icons.arrow_circle_right_outlined,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          iconSize: 20,
                        ),
                        onTap: () async {
                          print('asdlfkasjdklfajsdklfa');
                        },
                      ),
                      const SizedBox(height: 24),
                      ZwapButton(
                        key: ValueKey('next_ob_button'),
                        width: 194,
                        height: 55,
                        decorations: ZwapButtonDecorations.primaryLight(
                          internalPadding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        completionValue: _completionValue,
                        disabled: false,
                        loading: _loading,
                        buttonChild: ZwapButtonChild.textWithIcon(
                          text: 'Prossimo',
                          iconPosition: ZwapButtonIconPosition.right,
                          icon: Icons.arrow_circle_right_outlined,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          iconSize: 20,
                        ),
                        onTap: () async {
                          print('asdlfkasjdklfajsdklfa');
                        },
                      ),
                      if (_selectedRadio != 0)
                        ZwapTooltip(
                          message: 'sdlkfasdkfljaskdlf',
                          child: InkWell(
                            onTap: () {
                              setState(() => _selectedRadio = 0);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ZwapRadioButton(active: _selectedRadio == 0),
                                SizedBox(width: 24),
                                ZwapRadioButton(active: _selectedRadio == 1),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 24),
                      ZwapButton(
                        width: 170,
                        height: 40,
                        buttonChild: ZwapButtonChild.text(text: "Prova prova"),
                        decorations: ZwapButtonDecorations.primaryLight(
                          gradient: _buttonGradient,
                          hoverGradient: _buttonGradient,
                          pressedGradient: _buttonGradient,
                          disabledGradient: _buttonGradient,
                          focussedGradient: _buttonGradient,
                        ),
                        onTap: () => {},
                      ),
                      SizedBox(height: 24),
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
                        tooltip: "cioa ciadlkfahsòjdlfkha òjg alskdfaòsoidghaòis hgaòkj sfhglakjsfhgls jkdfhglsjdhfgljsdh flgsjhddslfhasdklfhasd",
                        showTooltipOnlyOnDisabledState: true,
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
                              onTap: () => ZwapToasts.showSuccessToast("akdjfaskdjfaklsdjfòja hdfajkòsdfa", context: context),
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
                              onTap: () => ZwapToasts.defaultDuration = const Duration(hours: 1),
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
                      SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 8,
                        textDirection: TextDirection.ltr,
                        children: List.generate(7, (i) => i)
                            .map(
                              (e) => ZwapButton(
                                width: null,
                                height: 44,
                                decorations:
                                    ZwapButtonDecorations.selectableButtonDecorations.defaultDecorations(internalPadding: const EdgeInsets.all(12)),
                                selectedDecorations:
                                    ZwapButtonDecorations.selectableButtonDecorations.selectedDecorations(internalPadding: const EdgeInsets.all(12)),
                                buttonChild: ZwapButtonChild.textWithIcon(
                                  text: 'Lorem $e',
                                  icon: _icons[e],
                                  spaceBetween: 8,
                                  iconSize: 16,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(60, (i) => i)
                              .map(
                                (e) => ZwapButton(
                                  margin: const EdgeInsets.only(left: 4, top: 5, bottom: 15),
                                  width: null,
                                  height: 44,
                                  decorations:
                                      ZwapButtonDecorations.selectableButtonDecorations.defaultDecorations(internalPadding: const EdgeInsets.all(12)),
                                  selectedDecorations: ZwapButtonDecorations.selectableButtonDecorations
                                      .selectedDecorations(internalPadding: const EdgeInsets.all(12)),
                                  buttonChild: ZwapButtonChild.textWithIcon(
                                    text: 'Lorem $e ${e % 4 == 0 ? 'ljkdsfhaskjdfhjaskljdfjaslkdf' : ''}',
                                    icon: _icons[e % 7],
                                    spaceBetween: 8,
                                    iconSize: 16,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}
