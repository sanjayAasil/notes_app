import 'package:flutter/material.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';

class FavoriteGridView extends StatefulWidget {
  final List<String> selectedIds;
  final Function()? onUpdateRequest;
  final bool isPinned, others;

  const FavoriteGridView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.isPinned,
    required this.others,
  }) : super(key: key);

  @override
  State<FavoriteGridView> createState() => _FavoriteGridViewState();
}

class _FavoriteGridViewState extends State<FavoriteGridView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
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
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                  if (DataManager().favoriteNotes[i].isPinned)
                    NoteTileGridView(
                      selectedIds: widget.selectedIds,
                      note: DataManager().favoriteNotes[i],
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    ),
                for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                  if (DataManager().favoriteListModels[i].isPinned)
                    ListModelTileGridView(
                      selectedIds: widget.selectedIds,
                      listModel: DataManager().favoriteListModels[i],
                      onUpdateRequest: () => setState(() {
                        widget.onUpdateRequest?.call();
                      }),
                    ),
              ],
            ),
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
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Wrap(
                children: [
                  for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                    if (!DataManager().favoriteNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: widget.selectedIds,
                        note: DataManager().favoriteNotes[i],
                        onUpdateRequest: () => setState(() {
                          widget.onUpdateRequest?.call();
                        }),
                      ),

                  ///listModel notPinned

                  for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                    if (!DataManager().favoriteListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: widget.selectedIds,
                        listModel: DataManager().favoriteListModels[i],
                        onUpdateRequest: () => setState(() {
                          widget.onUpdateRequest?.call();
                        }),
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
