import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/responsive.dart';
import '../../database/data_manager.dart';
import '../../common/widget_helper.dart';
import '../../providers/archive_provider.dart';

class ArchivedGridView extends StatefulWidget {
  const ArchivedGridView({
    super.key,
  });

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

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (Responsive.isDesktop(context)) {
          crossAxisCount = 4;
        } else if (Responsive.isTablet(context)) {
          crossAxisCount = 3;
        }

        double spacing = 10;
        double itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount + 1))) / crossAxisCount;

        return SingleChildScrollView(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (archiveProvider.isPinned)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    'Pinned',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (int i = 0; i < DataManager().archivedNotes.length; i++)
                      if (DataManager().archivedNotes[i].isPinned)
                        NoteTileGridView(
                          selectedIds: archiveProvider.selectedIds,
                          note: DataManager().archivedNotes[i],
                          onUpdateRequest: () => archiveProvider.notify(),
                          width: itemWidth,
                        ),
                    for (int i = 0; i < DataManager().archivedListModels.length; i++)
                      if (DataManager().archivedListModels[i].isPinned)
                        ListModelTileGridView(
                          selectedIds: archiveProvider.selectedIds,
                          listModel: DataManager().archivedListModels[i],
                          onUpdateRequest: () => archiveProvider.notify(),
                          width: itemWidth,
                        ),
                  ],
                ),
              ),
              if (archiveProvider.isPinned && archiveProvider.others)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (int i = 0; i < DataManager().archivedNotes.length; i++)
                      if (!DataManager().archivedNotes[i].isPinned)
                        NoteTileGridView(
                          selectedIds: archiveProvider.selectedIds,
                          note: DataManager().archivedNotes[i],
                          onUpdateRequest: () => archiveProvider.notify(),
                          width: itemWidth,
                        ),
                    for (int i = 0; i < DataManager().archivedListModels.length; i++)
                      if (!DataManager().archivedListModels[i].isPinned)
                        ListModelTileGridView(
                          selectedIds: archiveProvider.selectedIds,
                          listModel: DataManager().archivedListModels[i],
                          onUpdateRequest: () => archiveProvider.notify(),
                          width: itemWidth,
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
