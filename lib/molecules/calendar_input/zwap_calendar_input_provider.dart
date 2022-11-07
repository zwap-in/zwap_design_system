part of zwap.calendar_input;

class _ZwapCalendarInputProvider extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) => value.isEqualTo(_selectedDate) ? null : {_selectedDate = value, notifyListeners()};

  _ZwapCalendarInputProvider({DateTime? initialDate})
      : this._selectedDate = initialDate,
        super();
}
