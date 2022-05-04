/// IMPORTING THIRD PARTY PACKAGES

import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

//TODO (Marchetti): Add decorations

/// Define the switch provider state
class ZwapSwitch extends StatefulWidget {
  final bool value;

  /// The scale size for this custom switch component
  final double? scaleSize;

  final Function(bool value)? onValueChange;

  ZwapSwitch({
    Key? key,
    required this.value,
    this.onValueChange,
    this.scaleSize,
  }) : super(key: key);

  _ZwapSwitchState createState() => _ZwapSwitchState();
}

/// Custom widget to display a switch component
class _ZwapSwitchState extends State<ZwapSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ZwapSwitch oldWidget) {
    if (_value != widget.value) setState(() => _value = widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scaleSize ?? 1.0,
      child: CupertinoSwitch(
        activeColor: ZwapColors.primary700,
        trackColor: ZwapColors.neutral200,
        value: _value,
        onChanged: widget.onValueChange,
      ),
    );
  }
}
