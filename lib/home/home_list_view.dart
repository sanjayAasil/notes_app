import 'package:flutter/material.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../widget_helper.dart';

class HomeScreenListView extends StatefulWidget {
  const HomeScreenListView({Key? key, required this.selectedIds, this.onUpdateRequest}) : super(key: key);

  final List<String> selectedIds;
  final Function()? onUpdateRequest;

  @override
  State<HomeScreenListView> createState() => _HomeScreenListViewState();
}

class _HomeScreenListViewState extends State<HomeScreenListView> {
  @override
  Widget build(BuildContext context) {
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
                  selectedIds: widget.selectedIds,
                  onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
                ),

              ///ListView pinned ListModel
              for (ListModel listModel in DataManager().pinnedListModels)
                ListModelTileListView(
                  selectedIds: widget.selectedIds,
                  listModel: listModel,
                  onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
                )
            ],
          ),

        ///ListView Notes

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
                selectedIds: widget.selectedIds,
                onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
              ),
          ],
        ),

        for (ListModel listModel in DataManager().listModels)
          ListModelTileListView(
            selectedIds: widget.selectedIds,
            listModel: listModel,
            onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
          ),
      ],
    );
  }
}
