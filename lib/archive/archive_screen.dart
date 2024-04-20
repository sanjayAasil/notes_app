import 'package:flutter/material.dart';
import 'package:sanjay_notes/archive/archive_app_bar.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/my_drawer.dart';
import '../data_manager.dart';
import '../note.dart';
import 'archived_grid_view.dart';
import 'archived_list_view.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<String> selectedIds = [];
  bool isPinned = false;
  bool others = false;

  @override
  void initState() {
    super.initState();
    for (Note note in DataManager().archivedNotes) {
      if (note.isPinned) {
        isPinned = true;
      } else {
        others = true;
      }
    }
    if (!isPinned || !others) {
      for (ListModel listModel in DataManager().archivedListModels) {
        if (listModel.isPinned) {
          isPinned = true;
        } else {
          others = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(
        selectedTab: 'archiveScreen',
      ),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            DefaultArchiveAppBar(onViewChanged: () {
              debugPrint("_ArchiveScreenState build: check calling");
              setState(() {});
            })
          else
            SelectedArchiveAppBar(
              selectedIds: selectedIds,
              onSelectedIdsCleared: () => setState(() {}),
            ),
          if (DataManager().archivedNotes.isEmpty && DataManager().archivedListModels.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 140,
                    color: Colors.yellow.shade800,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your archived notes appear here'),
                  ),
                ],
              ),
            )
          else
            DataManager().archiveScreenView
                ?

                ///ListView of archived Notes
                ArchivedListView(
                    selectedIds: selectedIds,
                    isPinned: isPinned,
                    others: others,
                    onUpdateRequest: () => setState(() {}),
                  )
                :

                ///GRID VIEW
                ArchivedGridView(
                    selectedIds: selectedIds,
                    isPinned: isPinned,
                    others: others,
                    onUpdateRequest: () => setState(() {}),
                  ),
        ],
      ),
    );
  }
}
