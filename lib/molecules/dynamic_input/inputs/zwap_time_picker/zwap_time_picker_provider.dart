part of zwap.dynamic_inputs.search_picker;

extension _TimeExt on TimeOfDay {
  static TimeOfDay? tryParse(String value) {
    if (value.isEmpty) return null;

    final _splitted = value.split(':');
    if (_splitted.length > 2) return null;

    if (_splitted.length == 1) _splitted.add('0');

    final _hour = int.tryParse(_splitted[0]);
    final _minute = int.tryParse(_splitted[1]);

    if (_hour == null || _minute == null) return null;
    if (_hour < 0 || _hour > 23) return null;
    if (_minute < 0 || _minute > 59) return null;

    return TimeOfDay(hour: _hour, minute: _minute);
  }
}

class _ZwapTimePickerProvider extends ChangeNotifier {
  bool suspendFocusOutListener = false;

  final GlobalKey<ZwapDynamicInputState> inputKey = GlobalKey();
  late final MaskedTextController inputController;
  Timer? _notifyTimer;

  final TimePickerGap _gap;
  final bool mustRespectGap;

  TimeOfDay? _value;
  Function(TimeOfDay?)? onChanged;

  String formatTime(TimeOfDay time) {
    String _addZeroIfNeeded(int value) {
      return value < 10 ? '0$value' : '$value';
    }

    return '${_addZeroIfNeeded(time.hour)}:${_addZeroIfNeeded(time.minute)}';
  }

  TimeOfDay? get value => _value;

  _ZwapTimePickerProvider(
    this._value,
    this.onChanged,
    this._gap,
    this.mustRespectGap,
  ) : super() {
    inputController = MaskedTextController(
      mask: '00:00',
      text: _value == null ? '' : formatTime(_value!),
    );

    inputController.addListener(_controllerListener);
  }

  void _controllerListener() {
    _notifyTimer?.cancel();

    if (inputController.text.length > 4) {
      _notifyTimer = Timer(const Duration(milliseconds: 200), () {
        validateInput();
      });
    }

    notifyListeners();
  }

  set value(TimeOfDay? value) {
    updateValue(value);
    inputKey.closeIfOpen();

    notifyListeners();
  }

  void updateValue(TimeOfDay? value, {bool callOnChanged = true}) {
    if (_value == value) return;

    _value = value;
    inputController.text = _value == null ? '' : formatTime(_value!);
    if (callOnChanged && onChanged != null) {
      onChanged!(_value);
    }
  }

  List<TimeOfDay> get suggestion {
    if (_gap.inMinutes == 0) return [];

    final int _gapCount = 24 * 60 ~/ _gap.inMinutes;

    final List<TimeOfDay> _suggestions = List.generate(_gapCount, (index) {
      final int _minutes = index * _gap.inMinutes;
      final int _hours = _minutes ~/ 60;
      final int _minutesLeft = _minutes % 60;

      return TimeOfDay(hour: _hours, minute: _minutesLeft);
    });

    if (inputController.text.isEmpty) return _suggestions;
    return _suggestions.where((s) => formatTime(s).contains(inputController.text.trim())).toList();
  }

  void validateInput() {
    inputKey.closeIfOpen();

    if (inputController.text.isEmpty) return;
    final TimeOfDay? _newValue = _TimeExt.tryParse(inputController.text);
    if (_newValue == null) return;

    if (!mustRespectGap || _gap.inMinutes == 0) {
      updateValue(_newValue);
      return;
    }

    updateValue(TimeOfDay(hour: _newValue.hour, minute: (_newValue.minute ~/ _gap.inMinutes) * _gap.inMinutes));
  }
}
