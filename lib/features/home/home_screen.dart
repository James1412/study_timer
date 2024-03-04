import 'dart:io';
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view%20models/study_session_vm.dart';
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

  void onEditTap(StudySessionModel studyTimeModel) async {
    TextEditingController editController =
        TextEditingController(text: studyTimeModel.subjectName);
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Edit Study Time"),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CupertinoTextField(
              clearButtonMode: OverlayVisibilityMode.editing,
              autofocus: true,
              spellCheckConfiguration: SpellCheckConfiguration(
                spellCheckService: DefaultSpellCheckService(),
              ),
              placeholder: "Subject name",
              controller: editController,
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
                  ..subjectName = editController.text;
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
    editController.dispose();
  }

  Duration getTotalDuration(List studyDates, index) {
    Duration totalDuration = const Duration();
    for (StudySessionModel studyTimeModel
        in context.watch<StudySessionViewModel>().studySessions) {
      if (isSameDate(studyDates[index], studyTimeModel.date)) {
        totalDuration += studyTimeModel.duration;
      }
    }
    return totalDuration;
  }

  double getPercentChange(int dateIndex, List studyDates) {
    if (dateIndex <= 0) {
      return 100;
    } else {
      return ((getTotalDuration(studyDates, dateIndex).inMinutes -
              getTotalDuration(studyDates, dateIndex - 1).inMinutes) /
          getTotalDuration(studyDates, dateIndex - 1).inMinutes *
          100);
    }
  }

  Future<void> onPickIcon(StudySessionModel studySessionModel) async {
    IconData? icon = await showIconPicker(
      showTooltips: true,
      iconPackModes: [
        IconPack.outlinedMaterial,
        IconPack.cupertino,
        IconPack.fontAwesomeIcons,
        IconPack.lineAwesomeIcons,
      ],
      context,
      adaptiveDialog: true,
    );
    if (icon == null || !mounted) return;
    studySessionModel = studySessionModel..icon = icon;
    context.read<StudySessionViewModel>().editSubjectIcon(studySessionModel);
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> studyDates =
        context.watch<StudySessionViewModel>().studyDates;
    if (pageController.hasClients) {
      pageController.jumpToPage(
        context.watch<StudySessionViewModel>().studyDates.length - 1,
      );
    }
    return studyDates.isEmpty
        ? const Center(
            child: Text("No study session yet..."),
          )
        : PageView.builder(
            itemCount: studyDates.length,
            scrollDirection: Axis.horizontal,
            controller: pageController,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, dateIndex) {
              List<StudySessionModel> studySessionsOnDate = context
                  .watch<StudySessionViewModel>()
                  .studySessions
                  .where((element) =>
                      isSameDate(element.date, studyDates[dateIndex]))
                  .toList();
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(
                      "${DateFormat.yMEd().format(studyDates[dateIndex])}${isToday(studyDates[dateIndex]) ? " (Today)" : ''}"),
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
                          const Gap(5),
                          Text(
                            prettyDuration(
                              getTotalDuration(studyDates, dateIndex),
                              tersity: DurationTersity.minute,
                              abbreviated: true,
                              conjunction: ' ',
                            ),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            "${getPercentChange(dateIndex, studyDates) > 0 ? "+" : ""}${getPercentChange(dateIndex, studyDates).toStringAsFixed(1)}%",
                            style: TextStyle(
                                color: getPercentChange(dateIndex, studyDates) <
                                        0
                                    ? redButtonColor
                                    : getPercentChange(dateIndex, studyDates) ==
                                            0
                                        ? Colors.grey
                                        : blueButtonColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: studySessionsOnDate.length,
                      itemBuilder: (context, sessionIndex) => ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            onPickIcon(studySessionsOnDate[sessionIndex]);
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color:
                                  Colors.blueAccent.shade100.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              studySessionsOnDate[sessionIndex].icon ??
                                  CupertinoIcons.book,
                            ),
                          ),
                        ),
                        title: Text(
                          prettyDuration(
                            locale: const EnglishDurationLocale(),
                            studySessionsOnDate[sessionIndex].duration,
                            tersity: DurationTersity.minute,
                            upperTersity: DurationTersity.hour,
                            abbreviated: true,
                            conjunction: ' ',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          studySessionsOnDate[sessionIndex].subjectName,
                        ),
                        trailing: GestureDetector(
                          onTap: () =>
                              onEditTap(studySessionsOnDate[sessionIndex]),
                          child: Container(
                            color: Colors.transparent,
                            height: double.maxFinite,
                            width: 70,
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              FluentIcons.edit_12_regular,
                              size: 20,
                            ),
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
