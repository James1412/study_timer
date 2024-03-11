import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/home/utils.dart';

class WeekDateViewModel extends Notifier<DateTime> {
  @override
  DateTime build() {
    return onlyDate(DateTime.now().toUtc());
  }

  void changeWeekDate(DateTime date) {
    state = onlyDate(date.toUtc());
  }
}

final weekDateProvider =
    NotifierProvider<WeekDateViewModel, DateTime>(() => WeekDateViewModel());
