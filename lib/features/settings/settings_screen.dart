import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_timer/features/themes/dark%20mode/dark_mode_mvvm.dart';
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
            title: const Text("Dark Mode"),
            trailing: CupertinoSwitch(
              onChanged: (val) {
                context.read<DarkModelViewModel>().setDarkMode(val);
              },
              value: isDarkMode(context),
            ),
          ),
        ],
      ),
    );
  }
}
