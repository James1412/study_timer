import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/settings/utils.dart';
import 'package:study_timer/features/settings/view_models/auto_brightness_vm.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_vm.dart';
import 'package:study_timer/features/themes/dark%20mode/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                context.read<DarkModelViewModel>().setDarkMode(val);
              },
              value: isDarkMode(context),
            ),
          ),
          ListTile(
            leading: const Icon(FluentIcons.brightness_low_16_filled),
            title: const Text("Auto Brightness Control"),
            trailing: CupertinoSwitch(
              onChanged: (val) {
                context
                    .read<AutoBrightnessViewModel>()
                    .changeIsAutoBrightnessControl(val);
              },
              value: isAutoBrightnessControl(context),
            ),
          ),
        ],
      ),
    );
  }
}
