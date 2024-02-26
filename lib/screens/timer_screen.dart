import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_timer/utils/themes.dart';

class TimerScreen extends StatefulWidget {
  final String title;
  const TimerScreen({super.key, required this.title});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Center(
              child: Text(
                "12 : 01 : 30",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                color: colors[AppThemeColors.mainThemeColor],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Start",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
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
