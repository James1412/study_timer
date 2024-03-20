import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:study_timer/features/settings/settings_screen.dart';
import 'package:study_timer/features/stats/functions/stats_calculation.dart';
import 'package:study_timer/features/stats/widgets/grid_stat_box.dart';
import 'package:study_timer/features/stats/widgets/week_bar_chart.dart';
import 'package:study_timer/features/stats/widgets/subject_stat_box.dart';
import 'package:study_timer/utils/ad_helper.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.statsScreenBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        actions: [
          GestureDetector(
            onTap: () {
              iosLightFeedback();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(FluentIcons.settings_28_regular),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        children: [
          const WeekBarChart(),
          const Gap(20),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.25,
            children: [
              GridStatBox(
                title: 'Average study time per day',
                stat: "${avgStudyHourPerDay(ref)}hr",
                change: '${avgStudyHourPerDayPercentChange(ref)}%',
              ),
              GridStatBox(
                title: 'Study sessions of the week',
                stat: studySessionsOfTheWeek(ref).length.toString(),
                change:
                    '${totalStudySessionComparedToPreviousWeekPercentage(ref)}%',
              ),
              GridStatBox(
                title: 'Top subject of the week',
                stat: findTopSubjectOfTheWeek(ref),
              ),
              GridStatBox(
                title: 'Longest study streak',
                stat: "${findLongestStudyStreak(ref)} day",
              ),
            ],
          ),
          const Gap(16),
          if (_ad != null && !kDebugMode)
            SizedBox(
              width: double.maxFinite,
              height: 100,
              child: AdWidget(
                ad: _ad!,
              ),
            ),
          const Gap(16),
          const SubjectStatBox(),
        ],
      ),
    );
  }
}
