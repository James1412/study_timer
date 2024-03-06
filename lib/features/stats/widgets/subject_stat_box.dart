import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/themes/colors.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_vm.dart';

class SubjectStatBox extends ConsumerWidget {
  const SubjectStatBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color:
            ref.watch(darkmodeProvider) ? darkStatBoxColor : lightStatBoxColor,
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
          //TODO: parameter value -> model
          subjectRow("Science"),
          subjectRow("Math"),
          subjectRow("Computer"),
          subjectRow("Linear"),
          subjectRow("IDk"),
          subjectRow("Sleep"),
        ],
      ),
    );
  }
}

Widget subjectRow(String subjectName) {
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Text(
          "6.5h",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
