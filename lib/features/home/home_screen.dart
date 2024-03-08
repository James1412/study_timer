import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/settings/view_models/show_percent_change_vm.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late PageController pageController;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        initialPage: ref.read(studyDatesProvider.notifier).state.length - 1);
  }

  void onEditTap(StudySessionModel studyTimeModel) async {
    TextEditingController editController =
        TextEditingController(text: studyTimeModel.subjectName);
    iosLightFeedback();
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
              cursorColor: ref.watch(mainColorProvider),
              style: TextStyle(
                  color: ref.watch(darkmodeProvider)
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Delete"),
              onPressed: () {
                iosLightFeedback();
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Delete the study session?"),
                    content:
                        const Text("This will permanently delete the session"),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        textStyle:
                            TextStyle(color: ref.watch(mainColorProvider)),
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text("Delete"),
                        onPressed: () {
                          ref
                              .read(studySessionProvider.notifier)
                              .deleteStudySession(studyTimeModel);
                          iosLightFeedback();
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
              textStyle: TextStyle(color: ref.watch(mainColorProvider)),
              child: const Text("Done"),
              onPressed: () {
                iosLightFeedback();
                StudySessionModel newStudyModel = studyTimeModel
                  ..subjectName = editController.text;
                ref
                    .read(studySessionProvider.notifier)
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
    for (StudySessionModel studyTimeModel in ref.watch(studySessionProvider)) {
      if (areSameDate(studyDates[index], studyTimeModel.date)) {
        totalDuration += studyTimeModel.duration;
      }
    }
    return totalDuration;
  }

  double getPercentChange(int dateIndex, List studyDates) {
    if (dateIndex <= 0) {
      return 100;
    } else {
      return double.parse(((getTotalDuration(studyDates, dateIndex).inMinutes -
                  getTotalDuration(studyDates, dateIndex - 1).inMinutes) /
              getTotalDuration(studyDates, dateIndex - 1).inMinutes *
              100)
          .toStringAsFixed(1));
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
    ref.read(studySessionProvider.notifier).editSubjectIcon(studySessionModel);

    // TODO: save codePoint, fontFamily, and fontPackage in Hive
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Icon(
          IconData(
            icon.codePoint,
            fontFamily: icon.fontFamily,
            fontPackage: icon.fontPackage,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> studyDates = ref.watch(studyDatesProvider);
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
              List<StudySessionModel> studySessionsOnDate = ref
                  .watch(studySessionProvider)
                  .where((element) =>
                      areSameDate(element.date, studyDates[dateIndex]))
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
                          if (ref.watch(showPercentChangeProvider))
                            Text(
                              "${getPercentChange(dateIndex, studyDates) > 0.0 ? "+" : ""}${getPercentChange(dateIndex, studyDates)}%",
                              style: TextStyle(
                                color: getPercentChange(dateIndex, studyDates) <
                                        0.0
                                    ? Colors.red
                                    : getPercentChange(dateIndex, studyDates) ==
                                            0.0
                                        ? Colors.grey
                                        : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(5),
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
                              color: getStatsBoxColor(ref),
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
