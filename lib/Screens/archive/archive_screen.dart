import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Screens/my_drawer.dart';
import 'package:sanjay_notes/providers/archive_provider.dart';
import '../../Database/data_manager.dart';
import 'archive_app_bar.dart';
import 'archived_grid_view.dart';
import 'archived_list_view.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  ArchiveProvider archiveProvider = ArchiveProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => archiveProvider,
        builder: (context, child) {
          context.watch<ArchiveProvider>();
          return Scaffold(
            drawer: const MyDrawer(
              selectedTab: HomeDrawerEnum.archive,
            ),
            body: Column(
              children: [
                if (archiveProvider.selectedIds.isEmpty)
                  const DefaultArchiveAppBar()
                else
                  const SelectedArchiveAppBar(),
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
                  DataManager().archiveScreenView ? const ArchivedListView() : const ArchivedGridView(),
              ],
            ),
          );
        });
  }
}
