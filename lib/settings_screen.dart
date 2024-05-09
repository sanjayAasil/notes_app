import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:sanjay_notes/settings_model.dart';
import 'my_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ValueNotifier<bool> showTimeChecked;
  late ValueNotifier<bool> olderNotesChecked;
  late ValueNotifier<bool> showLabelsOnHomeScreen;

  @override
  void initState() {
    showTimeChecked = ValueNotifier(settingsModel.showTimeChecked);
    olderNotesChecked = ValueNotifier(settingsModel.olderNotesChecked);
    showLabelsOnHomeScreen = ValueNotifier(settingsModel.showLabelsOnHomeScreen);
    super.initState();
  }

  SettingsModel get settingsModel => DataManager().settingsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Text(
              'Sort',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Show Time for Notes',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: showTimeChecked,
                  builder: (context, value, child) {
                    return Switch(
                      value: showTimeChecked.value,
                      onChanged: (bool value) {
                        showTimeChecked.value = value;
                        settingsModel.showTimeChecked = showTimeChecked.value;
                        prefs.setString('settings', jsonEncode(settingsModel.json));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Show older notes first',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: olderNotesChecked,
                  builder: (context, value, child) {
                    return Switch(
                      value: olderNotesChecked.value,
                      onChanged: (bool value) {
                        olderNotesChecked.value = value;
                        settingsModel.olderNotesChecked = olderNotesChecked.value;
                        prefs.setString('settings', jsonEncode(settingsModel.json));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Show labels on home screen',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: showLabelsOnHomeScreen,
                  builder: (context, value, child) {
                    return Switch(
                      value: showLabelsOnHomeScreen.value,
                      onChanged: (bool value) {
                        showLabelsOnHomeScreen.value = value;
                        settingsModel.showLabelsOnHomeScreen = showLabelsOnHomeScreen.value;
                        prefs.setString('settings', jsonEncode(settingsModel.json));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
