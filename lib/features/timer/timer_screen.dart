import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:study_timer/features/home/models/study_session_model.dart';
import 'package:study_timer/features/home/utils.dart';
import 'package:study_timer/features/home/view_models/study_session_vm.dart';
import 'package:study_timer/features/settings/view_models/auto_brightness_vm.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/features/timer/utils.dart';
import 'package:study_timer/features/timer/widgets/timer_widget.dart';
import 'package:study_timer/utils/ios_haptic.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  bool isPlaying = false;
  Duration duration = const Duration();
  Timer? timer;

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

  void resetTimer() {
    if (timer != null) {
      duration = const Duration();
      timer!.cancel();
      timer = null;
      isPlaying = false;
      setState(() {});
    }
  }

  void togglePlay() async {
    iosHeavyFeedback();
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      startTimer();
      if (ref.watch(autoBrightnessControlProvider)) {
        try {
          final currentBrightness = await ScreenBrightness().current;
          await ScreenBrightness().setScreenBrightness(currentBrightness / 5);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else {
      stopTimer();
      if (ref.watch(autoBrightnessControlProvider)) {
        try {
          await ScreenBrightness().resetScreenBrightness();
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
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
            textStyle: TextStyle(color: ref.watch(mainColorProvider)),
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Clear"),
            onPressed: () {
              iosLightFeedback();
              resetTimer();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void onDoneTap() async {
    TextEditingController controller = TextEditingController();
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Done studying?"),
        content: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: CupertinoTextField(
            clearButtonMode: OverlayVisibilityMode.editing,
            autofocus: true,
            spellCheckConfiguration: SpellCheckConfiguration(
              spellCheckService: DefaultSpellCheckService(),
            ),
            placeholder: "Subject name",
            controller: controller,
            cursorColor: ref.watch(mainColorProvider),
            style: TextStyle(
                color:
                    ref.watch(darkmodeProvider) ? Colors.white : Colors.black),
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
            textStyle: TextStyle(color: ref.watch(mainColorProvider)),
            child: const Text("Done"),
            onPressed: () {
              iosLightFeedback();
              duration = roundSeconds(duration);
              StudySessionModel newStudySession = StudySessionModel(
                icon: null,
                subjectName: controller.text,
                date: onlyDate(DateTime.now()),
                duration: duration,
                uniqueKey: UniqueKey().hashCode,
              );
              ref
                  .read(studySessionProvider.notifier)
                  .addStudySession(newStudySession);
              resetTimer();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    controller.dispose();
  }

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
                child: const Text(
                  "Clear",
                  style: TextStyle(
                    color: Colors.red,
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
                  color: ref.watch(mainColorProvider),
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
                    color: ref.watch(mainColorProvider),
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
