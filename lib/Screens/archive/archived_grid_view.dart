import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/providers/archive_provider.dart';
import 'package:sanjay_notes/widget_helper.dart';

import '../../Database/data_manager.dart';

class ArchivedGridView extends StatefulWidget {
  const ArchivedGridView({
    Key? key,
  }) : super(key: key);

  @override
  State<ArchivedGridView> createState() => _ArchivedGridViewState();
}

class _ArchivedGridViewState extends State<ArchivedGridView> {
  late ArchiveProvider archiveProvider;

  @override
  void initState() {
    archiveProvider = context.read<ArchiveProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
    context.watch<ArchiveProvider>();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
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
            Align(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (int i = 0; i < DataManager().archivedNotes.length; i++)
                    if (DataManager().archivedNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: archiveProvider.selectedIds,
                        note: DataManager().archivedNotes[i],
                        onUpdateRequest: () => archiveProvider.notify(),
                      ),
                  for (int i = 0; i < DataManager().archivedListModels.length; i++)
                    if (DataManager().archivedListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: archiveProvider.selectedIds,
                        listModel: DataManager().archivedListModels[i],
                        onUpdateRequest: () => archiveProvider.notify(),
                      ),
                ],
              ),
            ),
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
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Wrap(
                children: [
                  for (int i = 0; i < DataManager().archivedNotes.length; i++)
                    if (!DataManager().archivedNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: archiveProvider.selectedIds,
                        note: DataManager().archivedNotes[i],
                        onUpdateRequest: () => archiveProvider.notify(),
                      ),
                  for (int i = 0; i < DataManager().archivedListModels.length; i++)
                    if (!DataManager().archivedListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: archiveProvider.selectedIds,
                        listModel: DataManager().archivedListModels[i],
                        onUpdateRequest: () => archiveProvider.notify(),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
