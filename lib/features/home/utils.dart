bool isSameDate(DateTime date1, DateTime date2) {
  return DateTime(date1.year, date1.month, date1.day) ==
      (DateTime(date2.year, date2.month, date2.day));
}

DateTime onlyDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}
