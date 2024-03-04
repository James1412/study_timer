import 'dart:io';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/study_time_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view%20models/study_date_vm.dart';
import 'package:study_timer/features/themes/colors.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController = PageController(
      initialPage:
          context.watch<StudySessionViewModel>().studyDates.length - 1);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  late TextEditingController _editController;
  void onEditTap(StudySessionModel studyTimeModel) async {
    _editController = TextEditingController(text: studyTimeModel.subjectName);
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Edit Study Time"),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CupertinoTextField(
              autofocus: true,
              spellCheckConfiguration: SpellCheckConfiguration(
                spellCheckService: DefaultSpellCheckService(),
              ),
              placeholder: "Subject name",
              controller: _editController,
              cursorColor: blueButtonColor,
              style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : Colors.black),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Delete"),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Delete the study session?"),
                    content:
                        const Text("This will permanently delete the session"),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        textStyle: TextStyle(color: blueButtonColor),
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text("Delete"),
                        onPressed: () {
                          context
                              .read<StudySessionViewModel>()
                              .deleteStudySession(studyTimeModel);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            CupertinoDialogAction(
              textStyle: const TextStyle(color: Colors.red),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: TextStyle(color: blueButtonColor),
              child: const Text("Done"),
              onPressed: () {
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                StudySessionModel newStudyModel = studyTimeModel
                  ..subjectName = _editController.text;
                context
                    .read<StudySessionViewModel>()
                    .editStudySession(newStudyModel);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    _editController.dispose();
  }

  Duration getTotalDuration(List studyDates, index) {
    Duration totalDuration = const Duration();
    for (StudySessionModel studyTimeModel
        in context.watch<StudySessionViewModel>().studySessions) {
      if (isSameDate(studyDates[index], studyTimeModel.dateTime)) {
        totalDuration += studyTimeModel.duration;
      }
    }
    return totalDuration;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> studyDates =
        context.watch<StudySessionViewModel>().studyDates;
    List<StudySessionModel> studySessions =
        context.watch<StudySessionViewModel>().studySessions;
    return studyDates.isEmpty
        ? const Center(
            child: Text("No study session yet..."),
          )
        : PageView.builder(
            itemCount: studyDates.length,
            scrollDirection: Axis.horizontal,
            controller: pageController,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              List<StudySessionModel> studySessionsOnDate = studySessions
                  .where((element) =>
                      isSameDate(element.dateTime, studyDates[index]))
                  .toList();

              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(
                      "${DateFormat.yMEd().format(studyDates[index])}${isToday(studyDates[index]) ? " (Today)" : ''}"),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Study Time",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            prettyDuration(
                              getTotalDuration(studyDates, index),
                              tersity: DurationTersity.minute,
                              abbreviated: true,
                              conjunction: ' ',
                            ),
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(15),
                        ],
                      ),
                    ),
                    const Gap(20),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: studySessionsOnDate.length,
                      itemBuilder: (context, studyIndex) => ListTile(
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.shade100.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(FluentIcons.book_open_16_regular),
                        ),
                        title: Text(
                          prettyDuration(
                            locale: const EnglishDurationLocale(),
                            studySessionsOnDate[studyIndex].duration,
                            tersity: DurationTersity.minute,
                            upperTersity: DurationTersity.hour,
                            abbreviated: true,
                            conjunction: ' ',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          studySessionsOnDate[studyIndex].subjectName,
                        ),
                        trailing: GestureDetector(
                          onTap: () =>
                              onEditTap(studySessionsOnDate[studyIndex]),
                          child: const Icon(
                            FluentIcons.edit_12_regular,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
