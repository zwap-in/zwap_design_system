import 'package:flutter/material.dart';
import 'package:zwap_design_system/extensions/dateTimeExtension.dart';
import 'package:zwap_design_system/molecules/calendarPicker/zwap_weekly_calendar_picker.dart';
import 'package:zwap_design_system/zwap_design_system.dart';
import 'package:zwap_utils/zwap_utils.dart';

class ZwapCalendarPickerStory extends StatefulWidget {
  const ZwapCalendarPickerStory({Key? key}) : super(key: key);

  @override
  State<ZwapCalendarPickerStory> createState() => _ZwapCalendarPickerStoryState();
}

class _ZwapCalendarPickerStoryState extends State<ZwapCalendarPickerStory> {
  List<TupleType<DateTime, TimeOfDay>> blockedSlots = [
    TupleType(a: DateTime(2022, 2, 22, 0, 0, 0, 0, 0), b: TimeOfDay(hour: 12, minute: 30)),
    TupleType(a: DateTime(2022, 2, 24, 0, 0, 0, 0, 0), b: TimeOfDay(hour: 12, minute: 30)),
    TupleType(a: DateTime(2022, 2, 24, 0, 0, 0, 0, 0), b: TimeOfDay(hour: 17, minute: 0)),
  ];

  Map<int, List<TimeOfDay>> times = {
    2: [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 12, minute: 30), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)],
    3: [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 12, minute: 30), TimeOfDay(hour: 17, minute: 0)],
    4: [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 12, minute: 00), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)],
    5: [TimeOfDay(hour: 9, minute: 0), TimeOfDay(hour: 12, minute: 30), TimeOfDay(hour: 19, minute: 0)],
  };

  List<TupleType<DateTime, TimeOfDay>> selected = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZwapWeeklyCalendarPicker(
        selected: selected,
        onChange: (selected) => setState(() => this.selected = selected),
        times: ZwapWeeklyCalendarTimes.weekly(weeklyTimes: times),
        showFilters: [
          ZwapWeeklyCalendarShowFilter.showWeekDays([1, 2, 3, 4, 5, 6]),
          ZwapWeeklyCalendarShowFilter.disableItems(blockedSlots, onThoseDaysTap: (item) {
            ZwapToasts.showErrorToast("Hai gia prenotato un meeting in questo slot", context: context, duration: const Duration(milliseconds: 2300));
            return null;
          }),
        ],
        pickFilters: [
          ZwapWeeklyCalendarPickFilter.notPast(),
          ZwapWeeklyCalendarPickFilter.maxPerWeek(4, onFilterCatch: (item) {
            ZwapToasts.showErrorToast("Hai gia selezionato 4 meet, effettua l'upgrade a pro per selezionarne ancora",
                context: context, duration: const Duration(milliseconds: 3500));

            return null;
          }),
          ZwapWeeklyCalendarPickFilter.disableWhere((item) {
            return DateTime.now().pureDate.difference(item.a).inHours.abs() <= 24;
          }, onFilterCatch: (item) {
            ZwapToasts.showErrorToast("Ci spiace, non puoi prenotare meet per domani",
                context: context, duration: const Duration(milliseconds: 3500));
            return null;
          }),
        ],
        handleKeyName: (String key) => {
          "sundayAbbr": "Dom",
          "thursdayAbbr": "Gio",
          "tuesdayAbbr": "Mar",
          "aprilAbbr": "Apr",
          "decemberAbbr": "Dic",
          "augustAbbr": "Ago",
          "februaryAbbr": "Feb",
          "fridayAbbr": "Ven",
          "januaryAbbr": "Gen",
          "novemberAbbr": "Nov",
          "octoberAbbr": "Ott",
          "mondayAbbr": "Lun",
          "wednesdayAbbr": "Mer",
          "julyAbbr": "Lug",
          "juneAbbr": "Giu",
          "saturdayAbbr": "Sab",
          "septemberAbbr": "Set",
          "marchAbbr": "Mar",
          "mayAbbr": "Mag",
          'january': 'Gennaio',
          'february': 'Febbraio',
          'march': 'Marzo',
          'april': 'Aprile',
          'may': 'Maggio',
          'june': 'Giugno',
          'july': 'Luglio',
          'august': 'Aogsto',
          'september': 'Settembre',
          'october': 'Ottobre',
          'november': 'Novembre',
          'december': 'Dicembre',
        }[key],
      ),
    );
  }
}
