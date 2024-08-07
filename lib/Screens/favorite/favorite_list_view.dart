import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/providers/favourite_provider.dart';
import 'package:sanjay_notes/Common/widget_helper.dart';

import '../../Database/data_manager.dart';
import '../../models/list_model.dart';
import '../../models/note.dart';


class FavoriteListView extends StatefulWidget {
  const FavoriteListView({Key? key}) : super(key: key);

  @override
  State<FavoriteListView> createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  late FavouriteProvider favouriteProvider;

  @override
  void initState() {
    favouriteProvider = context.read<FavouriteProvider>();
    super.initState();
  }

  _handlePinned() {
    favouriteProvider.isPinned = DataManager().favoriteNotes.any((element) => element.isPinned);
    favouriteProvider.others = DataManager().favoriteNotes.any((element) => !element.isPinned);

    if (!favouriteProvider.isPinned) {
      favouriteProvider.isPinned = DataManager().favoriteListModels.any((element) => element.isPinned);
    }
    if (!favouriteProvider.others) {
      favouriteProvider.others = DataManager().favoriteListModels.any((element) => !element.isPinned);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handlePinned();
    context.watch<DataManager>();
    context.watch<FavouriteProvider>();
    DataManager().settingsModel.olderNotesChecked
        ? DataManager().favoriteNotes.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().favoriteNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    DataManager().settingsModel.olderNotesChecked
        ? DataManager().favoriteListModels.sort((a, b) => a.createdAt.compareTo(b.createdAt))
        : DataManager().favoriteListModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (favouriteProvider.isPinned)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Pinned',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                for (Note note in DataManager().favoriteNotes)
                  if (note.isPinned)
                    NoteTileListView(
                      note: note,
                      selectedIds: favouriteProvider.selectedIds,
                      onUpdateRequest: () => favouriteProvider.notify(),
                    ),
                for (ListModel listModel in DataManager().favoriteListModels)
                  if (listModel.isPinned)
                    ListModelTileListView(
                      selectedIds: favouriteProvider.selectedIds,
                      listModel: listModel,
                      onUpdateRequest: () => favouriteProvider.notify(),
                    ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (favouriteProvider.isPinned && favouriteProvider.others)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Others',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                for (Note note in DataManager().favoriteNotes)
                  if (!note.isPinned)
                    NoteTileListView(
                      note: note,
                      selectedIds: favouriteProvider.selectedIds,
                      onUpdateRequest: () => favouriteProvider.notify(),
                    ),
                for (ListModel listModel in DataManager().favoriteListModels)
                  if (!listModel.isPinned)
                    ListModelTileListView(
                      selectedIds: favouriteProvider.selectedIds,
                      listModel: listModel,
                      onUpdateRequest: () => favouriteProvider.notify(),
                    )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
