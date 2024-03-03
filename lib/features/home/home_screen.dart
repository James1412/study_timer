import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController =
      PageController(initialPage: dates.length - 1);

  List dates = [
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().subtract(const Duration(days: 2)),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now(),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool isToday(DateTime date) {
    return DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)
        .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: dates.length,
      scrollDirection: Axis.horizontal,
      controller: pageController,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) => Scaffold(
        appBar: AppBar(
          title: Text(
              "${DateFormat.yMEd().format(dates[index])}${isToday(dates[index]) ? " (Today)" : ''}"),
        ),
        body: ListView(
          children: [
            Text(dates[index].toString()),
          ],
        ),
      ),
    );
  }
}
