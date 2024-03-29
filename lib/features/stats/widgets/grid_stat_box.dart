import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:study_timer/features/settings/view_models/show_percent_change_vm.dart';
import 'package:study_timer/features/themes/utils/colors.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';

class GridStatBox extends ConsumerWidget {
  final String title;
  final String stat;
  final String? change;
  const GridStatBox({
    required this.title,
    required this.stat,
    this.change,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: getStatsBoxColor(ref),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: ref.watch(darkmodeProvider) ? Colors.white : Colors.black,
            ),
          ),
          const Gap(10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stat,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                  ),
                ),
                if (change != null && ref.watch(showPercentChangeProvider)) ...[
                  const Gap(5),
                  Text(
                    change!,
                    style: TextStyle(
                      fontSize: 13,
                      color: change!.contains('-')
                          ? Colors.red
                          : double.parse(change!.replaceAll("%", "")) == 0
                              ? Colors.grey
                              : Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
