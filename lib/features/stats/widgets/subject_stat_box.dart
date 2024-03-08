import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/study_sessions/models/study_session_model.dart';
import 'package:study_timer/features/study_sessions/view_models/study_session_vm.dart';
import 'package:study_timer/features/stats/calculations/stats_calculation.dart';
import 'package:study_timer/features/themes/utils/colors.dart';

class SubjectStatBox extends ConsumerWidget {
  const SubjectStatBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedEntries = weeklySubjectDurationMap(ref).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: getStatsBoxColor(ref),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Subjects of the week",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          const Gap(10),
          ...sortedEntries.map((e) => subjectRow(
              ref
                  .watch(studySessionProvider)
                  .where((element) => element.subjectName == e.key)
                  .first,
              double.parse((e.value.inMinutes / 60).toStringAsFixed(1))))
        ],
      ),
    );
  }
}

Widget subjectRow(StudySessionModel model, double hour) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              IconData(
                model.iconData[0],
                fontFamily: model.iconData[1],
                fontPackage: model.iconData[2],
              ),
            ),
            const Gap(5),
            Text(
              model.subjectName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          "${hour}h",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
