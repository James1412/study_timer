import 'package:flutter/material.dart';
import 'package:study_timer/features/timer/widgets/time_card.dart';

class TimerWidget extends StatelessWidget {
  final String hours;
  final String minutes;
  final String seconds;
  const TimerWidget(
      {super.key,
      required this.hours,
      required this.minutes,
      required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TimeCard(text: hours),
        const Text(
          ":",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        TimeCard(text: minutes),
        const Text(
          ":",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        TimeCard(text: seconds),
      ],
    );
  }
}
