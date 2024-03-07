import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/settings/view_models/auto_brightness_vm.dart';
import 'package:study_timer/features/themes/models/main_color_model.dart';
import 'package:study_timer/features/themes/view_models/dark_mode_vm.dart';
import 'package:study_timer/features/themes/view_models/main_color_vm.dart';
import 'package:study_timer/utils/ios_haptic.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        iosLightFeedback();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(FluentIcons.dark_theme_20_filled),
              title: const Text("Dark Mode"),
              trailing: CupertinoSwitch(
                onChanged: (val) {
                  ref.read(darkmodeProvider.notifier).setDarkMode(val);
                },
                value: ref.watch(darkmodeProvider),
              ),
            ),
            ListTile(
              leading: const Icon(FluentIcons.brightness_low_16_filled),
              title: const Text("Auto Brightness Control"),
              trailing: CupertinoSwitch(
                onChanged: (val) {
                  ref
                      .read(autoBrightnessControlProvider.notifier)
                      .changeIsAutoBrightnessControl(val);
                },
                value: ref.watch(autoBrightnessControlProvider),
              ),
            ),
            //TODO: remove ads by watching rewarded ads or pay $1.99
            ListTile(
              leading: const Icon(FluentIcons.gift_24_regular),
              title: const Text("Remove Ads for Today"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(FluentIcons.gift_24_filled),
              title: const Text("Remove Ads Forever"),
              onTap: () {},
            ),
            //TODO: Main Colors
            ListTile(
              leading: const Icon(FluentIcons.gift_24_filled),
              title: const Text("Blue"),
              onTap: () {
                ref
                    .read(mainColorProvider.notifier)
                    .changeMainColor(MainColors.blue);
              },
            ),
            ListTile(
              leading: const Icon(FluentIcons.gift_24_filled),
              title: const Text("Red"),
              onTap: () {
                ref
                    .read(mainColorProvider.notifier)
                    .changeMainColor(MainColors.red);
              },
            ),
            ListTile(
              leading: const Icon(FluentIcons.gift_24_filled),
              title: const Text("Green"),
              onTap: () {
                ref
                    .read(mainColorProvider.notifier)
                    .changeMainColor(MainColors.green);
              },
            ),
            ListTile(
              leading: const Icon(FluentIcons.info_20_regular),
              title: const Text("About"),
              onTap: () {
                showAboutDialog(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
