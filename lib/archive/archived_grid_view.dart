
import 'package:flutter/material.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../data_manager.dart';

class ArchivedGridView extends StatefulWidget {
  final List<String> selectedIds;
  final Function()? onUpdateRequest;
  final bool isPinned, others;

  const ArchivedGridView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.isPinned,
    required this.others,
  }) : super(key: key);

  @override
  State<ArchivedGridView> createState() => _ArchivedGridViewState();
}

class _ArchivedGridViewState extends State<ArchivedGridView> {
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
            Align(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (int i = 0; i < DataManager().archivedNotes.length; i++)
                    if (DataManager().archivedNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: widget.selectedIds,
                        note: DataManager().archivedNotes[i],
                        onUpdateRequest: () => setState(() {
                          widget.onUpdateRequest?.call();
                        }),
                      ),
                  for (int i = 0; i < DataManager().archivedListModels.length; i++)
                    if (DataManager().archivedListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: widget.selectedIds,
                        listModel: DataManager().archivedListModels[i],
                        onUpdateRequest: () => setState(() {
                          widget.onUpdateRequest?.call();
                        }),
                      ),
                ],
              ),
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
                  for (int i = 0; i < DataManager().archivedNotes.length; i++)
                    if (!DataManager().archivedNotes[i].isPinned)
                      NoteTileGridView(
                        selectedIds: widget.selectedIds,
                        note: DataManager().archivedNotes[i],
                        onUpdateRequest: () => setState(() {
                          widget.onUpdateRequest?.call();
                        }),
                      ),

                  ///listModel notPinned

                  for (int i = 0; i < DataManager().archivedListModels.length; i++)
                    if (!DataManager().archivedListModels[i].isPinned)
                      ListModelTileGridView(
                        selectedIds: widget.selectedIds,
                        listModel: DataManager().archivedListModels[i],
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
