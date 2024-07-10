import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/providers/favourite_provider.dart';
import 'package:sanjay_notes/Common/widget_helper.dart';
import '../../Database/data_manager.dart';


class FavoriteGridView extends StatefulWidget {
  const FavoriteGridView({Key? key}) : super(key: key);

  @override
  State<FavoriteGridView> createState() => _FavoriteGridViewState();
}

class _FavoriteGridViewState extends State<FavoriteGridView> {
  late FavouriteProvider favouriteProvider;

  @override
  void initState() {
    favouriteProvider = context.read<FavouriteProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FavouriteProvider>();
    context.watch<DataManager>();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
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
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                  if (DataManager().favoriteNotes[i].isPinned)
                    NoteTileGridView(
                      selectedIds: favouriteProvider.selectedIds,
                      note: DataManager().favoriteNotes[i],
                      onUpdateRequest: () => favouriteProvider.notify(),
                    ),
                for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                  if (DataManager().favoriteListModels[i].isPinned)
                    ListModelTileGridView(
                      selectedIds: favouriteProvider.selectedIds,
                      listModel: DataManager().favoriteListModels[i],
                      onUpdateRequest: () => favouriteProvider.notify(),
                    ),
              ],
            ),
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
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Wrap(
                children: [
                  for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                    if (!DataManager().favoriteNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: favouriteProvider.selectedIds,
                        note: DataManager().favoriteNotes[i],
                        onUpdateRequest: () => favouriteProvider.notify(),
                      ),

                  for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                    if (!DataManager().favoriteListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: favouriteProvider.selectedIds,
                        listModel: DataManager().favoriteListModels[i],
                        onUpdateRequest: () => favouriteProvider.notify(),
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
