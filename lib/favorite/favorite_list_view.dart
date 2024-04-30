import 'package:flutter/material.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';

class FavoriteListView extends StatefulWidget {
  const FavoriteListView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.isPinned,
    required this.others,
  }) : super(key: key);

  final List<String> selectedIds;
  final Function()? onUpdateRequest;
  final bool isPinned, others;

  @override
  State<FavoriteListView> createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  @override
  Widget build(BuildContext context) {
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
                if (widget.isPinned)
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
                      selectedIds: widget.selectedIds,
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    ),
                for (ListModel listModel in DataManager().favoriteListModels)
                  if (listModel.isPinned)
                    ListModelTileListView(
                      selectedIds: widget.selectedIds,
                      listModel: listModel,
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isPinned && widget.others)
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
                      selectedIds: widget.selectedIds,
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    ),
                for (ListModel listModel in DataManager().favoriteListModels)
                  if (!listModel.isPinned)
                    ListModelTileListView(
                      selectedIds: widget.selectedIds,
                      listModel: listModel,
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
