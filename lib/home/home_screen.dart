import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/home/home_grid_view.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';
import 'home_app_bar.dart';
import 'home_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(selectedTab: 'homeScreen'),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            DefaultHomeAppBar(onViewChanged: () => setState(() {}))
          else
            SelectedHomeAppBar(
              onSelectedIdsCleared: () => setState(() {}),
              selectedIds: selectedIds,
            ),
          if (DataManager().notes.isEmpty &&
              DataManager().listModels.isEmpty &&
              DataManager().pinnedNotes.isEmpty &&
              DataManager().pinnedListModels.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.sticky_note_2_outlined,
                    color: Colors.yellow.shade800,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text('Notes you add appear here'),
                  const Expanded(child: SizedBox()),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: DataManager().homeScreenView
                    ? HomeScreenListView(
                        selectedIds: selectedIds,
                        onUpdateRequest: () => setState(() {}),
                      )
                    : HomeScreenGridView(
                        selectedIds: selectedIds,
                        onUpdateRequest: () => setState(() {}),
                      ),
              ),
            ),

          Container(
            color: Colors.grey.shade200,
            height: 45,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(Routes.newListScreen),
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check_box_outlined,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.draw_outlined,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.mic_none_rounded,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.photo_outlined,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Expanded(child: SizedBox()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(Routes.createNewNoteScreen),
        backgroundColor: Colors.grey.shade200,
        elevation: 20,
        child: const Icon(
          Icons.add,
          size: 40,
          color: CupertinoColors.activeBlue,
        ),
      ),
    );
  }
}
