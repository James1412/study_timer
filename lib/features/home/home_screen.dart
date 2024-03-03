import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/date_model.dart';
import 'package:study_timer/features/home/models/study_time_model.dart';
import 'package:study_timer/features/home/view%20models/study_date_vm.dart';
import 'package:study_timer/features/themes/colors.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController =
      PageController(initialPage: dates.length - 1);

  late List<DateModel> dates = context.watch<StudyDateViewModel>().dates;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool isToday(DateTime date) {
    return DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)
        .isAtSameMomentAs(
      DateTime(date.year, date.month, date.day),
    );
  }

  late TextEditingController controller;
  void onEditTap(StudyTimeModel studyTimeModel) async {
    controller = TextEditingController(text: studyTimeModel.subjectName);
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
              controller: controller,
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
                Navigator.pop(context);
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: dates.length,
      scrollDirection: Axis.horizontal,
      controller: pageController,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        Duration totalDuration = const Duration();
        Duration getDuration(int index) {
          for (var element in dates[index].studyTimes) {
            totalDuration += element.duration;
          }
          return totalDuration;
        }

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
                "${DateFormat.yMEd().format(dates[index].date)}${isToday(dates[index].date) ? " (Today)" : ''}"),
          ),
          body: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: blueButtonColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
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
                            getDuration(index),
                            tersity: DurationTersity.minute,
                            conjunction: ' and ',
                          ),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dates[index].studyTimes.length,
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
                      dates[index].studyTimes[studyIndex].duration,
                      tersity: DurationTersity.minute,
                      upperTersity: DurationTersity.hour,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    dates[index].studyTimes[studyIndex].subjectName,
                  ),
                  trailing: GestureDetector(
                    onTap: () => onEditTap(dates[index].studyTimes[studyIndex]),
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
