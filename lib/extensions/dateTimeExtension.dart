extension DateTimeExtension on DateTime {
  DateTime get pureDate => DateTime(this.year, this.month, this.day);

  DateTime get firstOfWeek => this.weekday > 1 ? this.add(Duration(days: -(this.weekday - 1))) : this;
}
