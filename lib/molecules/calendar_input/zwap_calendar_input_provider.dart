part of zwap.calendar_input;

class _ZwapCalendarInputProvider extends ChangeNotifier {
  DateTime? _selectedDate;

  final void Function(DateTime?)? onDatePicked;

  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) => value.isEqualTo(_selectedDate)
      ? null
      : () {
          _selectedDate = value;
          notifyListeners();

          if (onDatePicked != null) onDatePicked!(value);
        }();

  _ZwapCalendarInputProvider({required this.onDatePicked, DateTime? initialDate})
      : this._selectedDate = initialDate,
        super();
}
