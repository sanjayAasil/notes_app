import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/providers/home_screen_provider.dart';

import '../../models/list_model.dart';
import '../../models/note.dart';
import '../../widget_helper.dart';

class HomeScreenListView extends StatefulWidget {
  const HomeScreenListView({Key? key}) : super(key: key);

  @override
  State<HomeScreenListView> createState() => _HomeScreenListViewState();
}

class _HomeScreenListViewState extends State<HomeScreenListView> {
  late HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    homeScreenProvider = context.read<HomeScreenProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HomeScreenProvider>();
    context.watch<DataManager>();
    _timeSorting();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Pinned',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              for (Note note in DataManager().pinnedNotes)
                NoteTileListView(
                  note: note,
                  selectedIds: homeScreenProvider.selectedIds,
                  onUpdateRequest: () => homeScreenProvider.notify(),
                ),
              for (ListModel listModel in DataManager().pinnedListModels)
                ListModelTileListView(
                  selectedIds: homeScreenProvider.selectedIds,
                  listModel: listModel,
                  onUpdateRequest: () => homeScreenProvider.notify(),
                )
            ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty ||
                DataManager().pinnedNotes.isNotEmpty && DataManager().listModels.isNotEmpty ||
                DataManager().pinnedListModels.isNotEmpty && DataManager().listModels.isNotEmpty ||
                DataManager().pinnedListModels.isNotEmpty && DataManager().notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Others',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            for (Note note in DataManager().notes)
              NoteTileListView(
                note: note,
                selectedIds: homeScreenProvider.selectedIds,
                onUpdateRequest: () => homeScreenProvider.notify(),
              ),
          ],
        ),
        for (ListModel listModel in DataManager().listModels)
          ListModelTileListView(
            selectedIds: homeScreenProvider.selectedIds,
            listModel: listModel,
            onUpdateRequest: () => homeScreenProvider.notify(),
          ),
      ],
    );
  }

  _timeSorting() {
    DataManager().settingsModel.olderNotesChecked
        ? DataManager().notes.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    DataManager().settingsModel.olderNotesChecked
        ? DataManager().pinnedNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().pinnedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    DataManager().settingsModel.olderNotesChecked
        ? DataManager().listModels.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().listModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    DataManager().settingsModel.olderNotesChecked
        ? DataManager().pinnedListModels.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().pinnedListModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
