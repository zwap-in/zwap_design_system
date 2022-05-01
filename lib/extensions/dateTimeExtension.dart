extension DateTimeExtension on DateTime {
  DateTime get pureDate => DateTime(this.year, this.month, this.day);

  DateTime get endOfDay => DateTime(this.year, this.month, this.day, 23, 59, 59);

  DateTime get firstOfWeek => this.add(Duration(days: -(this.weekday - 1)));

  DateTime get endOfWeek {
    final DateTime endOfWeek = this.pureDate.add(Duration(days: (7 - this.weekday)));
    return DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);
  }

  DateTime get firstOfMonth => DateTime(this.year, this.month, 1);

  DateTime get endOfMonth => DateTime(this.year, this.month + 1, 0);
}
