import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/stats/widgets/grid_stat_box.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class HeatMapCalendarScreen extends ConsumerStatefulWidget {
  const HeatMapCalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends ConsumerState<HeatMapCalendarScreen> {
  Map<DateTime, int> getDatasets() {
    Map<DateTime, int> datasets = {};
    final dates = ref.watch(studyDatesProvider);
    final studySessions = ref.watch(studySessionProvider);
    for (DateTime date in dates) {
      int duration = 0;
      for (StudySessionModel studySessionModel in studySessions) {
        if (areSameDate(date, studySessionModel.date)) {
          duration += studySessionModel.duration.inMinutes;
        }
      }
      duration = (duration / 60).round();
      datasets.addEntries({date: duration}.entries);
    }
    return datasets;
  }

  late List<StudySessionModel> sessionsOnDate = ref
      .watch(studySessionProvider)
      .where((element) =>
          onlyDate(element.date).isAtSameMomentAs(onlyDate(DateTime.now())))
      .toList();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => iosLightFeedback(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calendar"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              HeatMapCalendar(
                showColorTip: false,
                initDate: onlyDate(DateTime.now()),
                onClick: (DateTime date) {
                  iosLightFeedback();
                  sessionsOnDate = ref
                      .watch(studySessionProvider)
                      .where((element) => onlyDate(element.date)
                          .isAtSameMomentAs(onlyDate(date)))
                      .toList();
                  selectedDate = date;
                  setState(() {});
                },
                colorsets: {
                  1: ref.watch(mainColorProvider),
                },
                defaultColor: ref.watch(darkmodeProvider)
                    ? darkNavigationBar(ref)
                    : lightNavigationBar,
                textColor:
                    ref.watch(darkmodeProvider) ? Colors.white : Colors.black,
                flexible: true,
                colorMode: ColorMode.opacity,
                datasets: getDatasets(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMEd().format(selectedDate),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sessionsOnDate.length,
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          sessionsOnDate[index].icon ?? CupertinoIcons.book,
                          size: 25,
                        ),
                        title: Text(sessionsOnDate[index].subjectName),
                        trailing: Text(
                          prettyDuration(
                            sessionsOnDate[index].duration,
                            tersity: DurationTersity.minute,
                            upperTersity: DurationTersity.hour,
                            abbreviated: true,
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.25,
                children: const [
                  //TODO: Fix this
                  GridStatBox(
                    title: 'Study time of the month',
                    stat: "10hr",
                    change: '10%',
                  ),
                  GridStatBox(
                    title: 'Study sessions of the month',
                    stat: "10",
                    change: '10%',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
