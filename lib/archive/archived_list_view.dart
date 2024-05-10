import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/providers/archive_provider.dart';

import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';

class ArchivedListView extends StatefulWidget {
  const ArchivedListView({
    Key? key,
  }) : super(key: key);

  @override
  State<ArchivedListView> createState() => _ArchivedListViewState();
}

class _ArchivedListViewState extends State<ArchivedListView> {
  late ArchiveProvider archiveProvider;

  @override
  void initState() {
    archiveProvider = context.read<ArchiveProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ArchiveProvider>();
    DataManager().settingsModel.olderNotesChecked
        ? DataManager().archivedNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().archivedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    DataManager().settingsModel.olderNotesChecked
        ? DataManager().archivedListModels.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().archivedListModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (archiveProvider.isPinned)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Pinned',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                for (Note note in DataManager().archivedNotes)
                  if (note.isPinned)
                    NoteTileListView(
                      note: note,
                      selectedIds: archiveProvider.selectedIds,
                      onUpdateRequest: () => archiveProvider.notify(),
                    ),
                for (ListModel listModel in DataManager().archivedListModels)
                  if (listModel.isPinned)
                    ListModelTileListView(
                        listModel: listModel,
                        selectedIds: archiveProvider.selectedIds,
                        onUpdateRequest: () => archiveProvider.notify()),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (archiveProvider.isPinned && archiveProvider.others)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Others',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                for (Note note in DataManager().archivedNotes)
                  if (!note.isPinned)
                    NoteTileListView(
                      note: note,
                      selectedIds: archiveProvider.selectedIds,
                      onUpdateRequest: () => archiveProvider.notify(),
                    ),
                for (ListModel listModel in DataManager().archivedListModels)
                  if (!listModel.isPinned)
                    ListModelTileListView(
                      listModel: listModel,
                      selectedIds: archiveProvider.selectedIds,
                      onUpdateRequest: () => archiveProvider.notify(),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
