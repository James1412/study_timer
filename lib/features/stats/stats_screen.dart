import 'package:duration/duration.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/view%20models/study_session_vm.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    StudySessionViewModel viewModel =
        Provider.of<StudySessionViewModel>(context);

    DateTime now = DateTime.now();

    List<StudySessionModel> sessionsThisMonth = viewModel.studySessions
        .where(
          (session) => DateTime(session.date.year, session.date.month)
              .isAtSameMomentAs(DateTime(now.year, now.month)),
        )
        .toList();

    Duration totalStudyTimeThisMonth = sessionsThisMonth.fold(Duration.zero,
        (previousValue, session) => previousValue + session.duration);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(FluentIcons.settings_28_regular),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 70,
            height: MediaQuery.of(context).size.width - 70,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDarkMode(context)
                      ? const Color(0xff444652)
                      : const Color(0xffDEDEDE)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Study Time",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  const Gap(5),
                  Text(
                    prettyDuration(
                      totalStudyTimeThisMonth,
                      tersity: DurationTersity.minute,
                      upperTersity: DurationTersity.hour,
                    ),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  const Gap(5),
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      "Past 30 days",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
