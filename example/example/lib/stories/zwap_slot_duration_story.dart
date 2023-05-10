import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/dynamic_input/inputs/zwap_check_box_picker/zwap_check_box_picker.dart';
import 'package:zwap_design_system/molecules/radio_overlay_picker/radio_overlay_picker.dart';
import 'package:zwap_design_system/molecules/radio_overlay_picker/decorated_radio_overlay_picker.dart';

enum _SlotDuration {
  fifteen,
  thirty,
}

extension _SlotDurationExt on _SlotDuration {
  String get copy {
    switch (this) {
      case _SlotDuration.fifteen:
        return "15 minuti";
      case _SlotDuration.thirty:
        return "30 minuti";
    }
  }
}

class ZwapSlotDurationStory extends StatefulWidget {
  const ZwapSlotDurationStory({Key? key}) : super(key: key);

  @override
  State<ZwapSlotDurationStory> createState() => _ZwapSlotDurationStoryState();
}

class _ZwapSlotDurationStoryState extends State<ZwapSlotDurationStory> {
  final List<_SlotDuration> _selected = [];
  _SlotDuration? _radioValue = _SlotDuration.fifteen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          ZwapCheckBoxPicker(
            minSelectedItems: 1,
            overlayLabel: "DURATA MEETING",
            chipDecorations: const ZwapCheckBoxPickerChipDecoration.primary(),
            expand: false,
            sortItems: (a, b) {
              final _SlotDuration aDur = _SlotDuration.values[int.tryParse(a) ?? -1];
              final _SlotDuration bDur = _SlotDuration.values[int.tryParse(b) ?? -1];

              return aDur.index.compareTo(bDur.index);
            },
            selectedItems: _selected.map((e) => e.index.toString()).toList(),
            values: {
              for (_SlotDuration dur in _SlotDuration.values) '${dur.index}': dur.copy,
            },
            onToggleItem: (i, selected) {
              final int index = int.tryParse(i) ?? -1;
              if (index == -1) return;

              if (selected) {
                _selected.add(_SlotDuration.values[index]);
              } else {
                _selected.remove(_SlotDuration.values[index]);
              }

              setState(() {});
            },
          ),
          const SizedBox(width: 40),
          RadioOverlayPicker<_SlotDuration>(
            getValueLabel: (s) => s.copy,
            headerValueLabel: (s) {
              switch (s) {
                case _SlotDuration.fifteen:
                  return "15 min";
                case _SlotDuration.thirty:
                  return "30 min";
              }
            },
            onSelectedValue: (v) => setState(() => _radioValue = v),
            selected: _radioValue,
            values: _SlotDuration.values,
          ),
          const SizedBox(width: 40),
          DecoratedRadioOverlay<_SlotDuration>(
            title: "DURATA",
            getValueLabel: (s) => s.copy,
            headerValueLabel: (s) {
              switch (s) {
                case _SlotDuration.fifteen:
                  return "15 min";
                case _SlotDuration.thirty:
                  return "30 min";
              }
            },
            onSelectedValue: (v) => setState(() => _radioValue = v),
            selected: _radioValue,
            values: _SlotDuration.values,
          ),
        ],
      ),
    );
  }
}
