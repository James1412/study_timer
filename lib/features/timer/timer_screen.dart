import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view%20models/study_session_vm.dart';
import 'package:study_timer/features/themes/colors.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';
import 'package:study_timer/features/timer/widgets/timer_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isPlaying = false;
  Duration duration = const Duration();
  Timer? timer;
  TextEditingController? controller;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void togglePlay() async {
    if (Platform.isIOS) {
      HapticFeedback.heavyImpact();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      startTimer();
      try {
        await ScreenBrightness().setScreenBrightness(0.2);
      } catch (e) {
        //print(e);
      }
    } else {
      stopTimer();
      try {
        await ScreenBrightness().resetScreenBrightness();
      } catch (e) {
        //print(e);
      }
    }
    WakelockPlus.toggle(enable: isPlaying);
  }

  void onClearTap() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Clear the timer?"),
        content: const Text("It will clear and reset the timer"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            textStyle: TextStyle(color: blueButtonColor),
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Clear"),
            onPressed: () {
              if (timer != null) {
                duration = const Duration();
                timer!.cancel();
                timer = null;
                isPlaying = false;
                setState(() {});
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void onDoneTap() async {
    controller = TextEditingController();
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Done studying?"),
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
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            textStyle: TextStyle(color: blueButtonColor),
            child: const Text("Done"),
            onPressed: () {
              if (duration < const Duration(minutes: 1) &&
                  duration > const Duration(minutes: 0)) {
                duration = const Duration(minutes: 1);
              }
              StudySessionModel studyTimeModel = StudySessionModel(
                  subjectName: controller!.text,
                  dateTime: onlyDate(DateTime.now()),
                  duration: duration,
                  uniqueKey: UniqueKey().hashCode);
              context
                  .read<StudySessionViewModel>()
                  .addStudySession(studyTimeModel);
              if (timer != null) {
                duration = const Duration();
                timer!.cancel();
                timer = null;
                isPlaying = false;
                setState(() {});
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    controller!.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Study Timer"),
        leading: !isPlaying && timer != null
            ? CupertinoButton(
                padding: const EdgeInsets.only(left: 10.0),
                onPressed: onClearTap,
                child: Text(
                  "Clear",
                  style: TextStyle(
                    color: redButtonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        actions: [
          if (!isPlaying && timer != null)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              onPressed: onDoneTap,
              child: Text(
                "Done",
                style: TextStyle(
                  color: blueButtonColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerWidget(hours: hours, minutes: minutes, seconds: seconds),
            const Gap(50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: togglePlay,
                child: Container(
                  width: double.maxFinite,
                  height: 50,
                  decoration: BoxDecoration(
                    color: blueButtonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      isPlaying
                          ? "Stop"
                          : timer == null
                              ? "Start"
                              : "Resume",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
