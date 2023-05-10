part of zwap.check_box_picker;

class ZwapCheckBoxPickerChipDecoration {
  //* Chips decorations
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Border? border;
  final EdgeInsets padding;

  //* Remove icon
  final bool showRemove;
  final IconData removeIcon;
  final Color removeIconColor;

  //* Text decorations
  final ZwapTextType textType;
  final Color textColor;

  const ZwapCheckBoxPickerChipDecoration({
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.backgroundColor = ZwapColors.neutral100,
    this.border,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    this.showRemove = true,
    this.removeIcon = Icons.close,
    this.removeIconColor = ZwapColors.text65,
    this.textType = ZwapTextType.bigBodyMedium,
    this.textColor = ZwapColors.primary900Dark,
  });

  const ZwapCheckBoxPickerChipDecoration.primary({
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
    this.backgroundColor = ZwapColors.primary50,
    this.border = const Border.fromBorderSide(BorderSide(color: ZwapColors.primary700, width: 1)),
    this.padding = const EdgeInsets.fromLTRB(16, 6, 12, 6),
    this.showRemove = false,
    this.removeIcon = Icons.close,
    this.removeIconColor = ZwapColors.text65,
    this.textType = ZwapTextType.bigBodyMedium,
    this.textColor = ZwapColors.primary700,
  });
}

class _SingleChipWidget extends StatelessWidget {
  final String keyValue;
  final ZwapCheckBoxPickerItemBuilder? builder;
  final ZwapCheckBoxPickerChipDecoration chipDecorations;

  const _SingleChipWidget({
    required this.builder,
    required this.keyValue,
    required this.chipDecorations,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _text = context.select<_ZwapCheckBoxPickerProvider, String>((state) => state.values[keyValue] ?? '--');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: chipDecorations.borderRadius,
        color: chipDecorations.backgroundColor,
        border: chipDecorations.border,
      ),
      child: Row(
        children: [
          if (builder != null)
            builder!(context, keyValue, _text)
          else
            ZwapText(
              text: _text,
              zwapTextType: chipDecorations.textType,
              textColor: chipDecorations.textColor,
            ),
          if (chipDecorations.showRemove) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: () => context.read<_ZwapCheckBoxPickerProvider>().toggleItem(keyValue),
              child: Container(
                width: 20,
                height: 20,
                child: Icon(
                  chipDecorations.removeIcon,
                  size: 16,
                  color: chipDecorations.removeIconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
