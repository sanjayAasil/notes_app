import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';

import 'my_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                Expanded(
                  child: Text(
                    'Show Time for Notes',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    DataManager().showTimeForNotes = !DataManager().showTimeForNotes;
                    setState(() {});
                  },
                  child: DataManager().showTimeForNotes
                      ? Icon(
                          Icons.toggle_on_outlined,
                          size: 50,
                          color: Colors.blue.shade600,
                        )
                      : Icon(
                          Icons.toggle_off_outlined,
                          size: 50,
                          color: Colors.grey.shade600,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Show older notes first',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    DataManager().olderNotesFirst = !DataManager().olderNotesFirst;
                    setState(() {});
                  },
                  child: DataManager().olderNotesFirst
                      ? Icon(
                          Icons.toggle_on_outlined,
                          size: 50,
                          color: Colors.blue.shade600,
                        )
                      : Icon(
                          Icons.toggle_off_outlined,
                          size: 50,
                          color: Colors.grey.shade600,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
