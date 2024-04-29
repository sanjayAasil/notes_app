import 'package:flutter/material.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';

class HomeScreenGridView extends StatefulWidget {
  final List<String> selectedIds;
  final Function? onUpdateRequest;

  const HomeScreenGridView({Key? key, required this.selectedIds, this.onUpdateRequest}) : super(key: key);

  @override
  State<HomeScreenGridView> createState() => _HomeScreenGridViewState();
}

class _HomeScreenGridViewState extends State<HomeScreenGridView> {
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
                  selectedIds: widget.selectedIds,
                  note: DataManager().pinnedNotes[i],
                  onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
                ),
              for (int i = 0; i < DataManager().pinnedListModels.length; i++)
                ListModelTileGridView(
                  selectedIds: widget.selectedIds,
                  listModel: DataManager().pinnedListModels[i],
                  onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Wrap(
              children: [
                for (int i = 0; i < DataManager().notes.length; i++)
                  NoteTileGridView(
                    selectedIds: widget.selectedIds,
                    onUpdateRequest: () => setState(() => widget.onUpdateRequest?.call()),
                    note: DataManager().notes[i],
                  ),
                for (int i = 0; i < DataManager().listModels.length; i++)
                  ListModelTileGridView(
                    selectedIds: widget.selectedIds,
                    listModel: DataManager().listModels[i],
                    onUpdateRequest: () => setState(() {
                      widget.onUpdateRequest?.call();
                    }),
                  ),

                ///Grid view listModel
              ],
            ),
          ),
        ),
      ],
    );
  }
}
