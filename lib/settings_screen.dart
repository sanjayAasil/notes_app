import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/notes_db.dart';
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

  @override
  void initState() {
    showTimeChecked = ValueNotifier(settingsModel.showTimeChecked);
    olderNotesChecked = ValueNotifier(settingsModel.olderNotesChecked);
    super.initState();
  }

  SettingsModel get settingsModel => DataManager().settingsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(
        selectedTab: 'Settings',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: const MediaQueryData().padding.top + 50,
              left: const MediaQueryData().padding.left + 10,
              bottom: 20,
            ),
            child: Row(
              children: [
                Builder(
                  builder: (context) => InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    borderRadius: BorderRadius.circular(40),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.grey.shade800,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 18),
                  ),
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
        ],
      ),
    );
  }
}
