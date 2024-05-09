import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/providers/home_screen_provider.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';

class HomeScreenGridView extends StatefulWidget {
  const HomeScreenGridView({Key? key}) : super(key: key);

  @override
  State<HomeScreenGridView> createState() => _HomeScreenGridViewState();
}

class _HomeScreenGridViewState extends State<HomeScreenGridView> {
  late HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    homeScreenProvider = context.read<HomeScreenProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
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
          alignment: AlignmentDirectional.topStart,
          child: Wrap(
            children: [
              for (int i = 0; i < DataManager().pinnedNotes.length; i++)
                NoteTileGridView(
                  selectedIds: homeScreenProvider.selectedIds,
                  note: DataManager().pinnedNotes[i],
                  onUpdateRequest: () => homeScreenProvider.notify(),
                ),
              for (int i = 0; i < DataManager().pinnedListModels.length; i++)
                ListModelTileGridView(
                  selectedIds: homeScreenProvider.selectedIds,
                  listModel: DataManager().pinnedListModels[i],
                  onUpdateRequest: () => homeScreenProvider.notify(),
                ),
            ],
          ),
        ),

        ///GridView notes

        if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty ||
            DataManager().pinnedListModels.isNotEmpty && DataManager().listModels.isNotEmpty)
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
              for (int i = 0; i < DataManager().notes.length; i++)
                NoteTileGridView(
                  selectedIds: homeScreenProvider.selectedIds,
                  onUpdateRequest: () => homeScreenProvider.notify(),
                  note: DataManager().notes[i],
                ),
              for (int i = 0; i < DataManager().listModels.length; i++)
                ListModelTileGridView(
                  selectedIds: homeScreenProvider.selectedIds,
                  listModel: DataManager().listModels[i],
                  onUpdateRequest: () => homeScreenProvider.notify(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
