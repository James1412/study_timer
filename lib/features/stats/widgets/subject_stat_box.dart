import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/themes/utils/colors.dart';

class SubjectStatBox extends ConsumerWidget {
  final Map<String, Duration> map;
  const SubjectStatBox(this.map, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedEntries = map.entries.toList()
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
            "Subjects this week",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
          ),
          const Gap(10),
          ...sortedEntries.map((e) => subjectRow(
              e.key, double.parse((e.value.inMinutes / 60).toStringAsFixed(1))))
        ],
      ),
    );
  }
}

Widget subjectRow(String subjectName, double hour) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(CupertinoIcons.book),
            const Gap(5),
            Text(
              subjectName,
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
