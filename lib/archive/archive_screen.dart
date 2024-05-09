import 'package:flutter/material.dart';
import 'package:sanjay_notes/archive/archive_app_bar.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';
import '../data_manager.dart';
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

  _handlePinned() {
    isPinned = DataManager().archivedNotes.any((element) => element.isPinned);
    others = DataManager().archivedNotes.any((element) => !element.isPinned);

    if (!isPinned) {
      isPinned = DataManager().archivedListModels.any((element) => element.isPinned);
    }
    if (!others) {
      others = DataManager().archivedListModels.any((element) => !element.isPinned);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handlePinned();
    return Scaffold(
      drawer: const MyDrawer(
        selectedTab: HomeDrawerEnum.archive,
      ),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            DefaultArchiveAppBar(onViewChanged: () {
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
                ? ArchivedListView(
                    selectedIds: selectedIds,
                    isPinned: isPinned,
                    others: others,
                    onUpdateRequest: () => setState(() {}),
                  )
                : ArchivedGridView(
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
