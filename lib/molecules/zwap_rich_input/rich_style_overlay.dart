part of zwap.rich_input;

class RichStyleOverlay extends StatelessWidget {
  const RichStyleOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final bool _isBold =
        context.select<_ZwapRichInputProvider, bool>((pro) => pro._richInputController.currentTextStyle.fontWeight == FontWeight.w700);
    final bool _isUnderlined =
        context.select<_ZwapRichInputProvider, bool>((pro) => pro._richInputController.currentTextStyle.decoration == TextDecoration.underline);
    final bool _isItalic =
        context.select<_ZwapRichInputProvider, bool>((pro) => pro._richInputController.currentTextStyle.fontStyle == FontStyle.italic);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ZwapColors.primary900Dark.withOpacity(.05),
            blurRadius: 20,
            spreadRadius: -12,
            offset: const Offset(0, 2),
          ),
        ],
        color: ZwapColors.shades0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SimpleButton(
            icon: Icons.format_bold_rounded,
            onTap: () => context.read<_ZwapRichInputProvider>().toggleBold(),
            tooltip: 'Grassetto',
            isSelected: _isBold,
          ),
          const SizedBox(width: 8),
          _SimpleButton(
            icon: Icons.format_italic_outlined,
            onTap: () => context.read<_ZwapRichInputProvider>().toggleItalic(),
            tooltip: 'Corsivo',
            isSelected: _isItalic,
          ),
          const SizedBox(width: 8),
          _SimpleButton(
            icon: Icons.format_underline_rounded,
            onTap: () => context.read<_ZwapRichInputProvider>().toggleUnderlined(),
            tooltip: 'Sottolineato',
            isSelected: _isUnderlined,
          ),
        ],
      ),
    );
  }
}

class _SimpleButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final Function() onTap;

  const _SimpleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ZwapButton(
      isSelected: isSelected,
      tooltip: tooltip,
      width: 32,
      height: 32,
      decorations: ZwapButtonDecorations.quaternary(
        backgroundColor: ZwapColors.whiteTransparent,
        hoverContentColor: ZwapColors.primary900Dark,
        pressedContentColor: ZwapColors.primary900Dark,
        internalPadding: EdgeInsets.zero,
      ),
      selectedDecorations: ZwapButtonDecorations.quaternary(
        backgroundColor: ZwapColors.neutral200,
        hoverContentColor: ZwapColors.primary900Dark,
        pressedContentColor: ZwapColors.primary900Dark,
        internalPadding: EdgeInsets.zero,
      ),
      buttonChild: ZwapButtonChild.icon(icon: icon, iconSize: 20),
      onTap: onTap,
    );
  }
}
