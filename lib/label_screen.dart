import 'package:flutter/material.dart';
import 'package:sanjay_notes/routes.dart';
import 'data_manager.dart';
import 'list_model.dart';
import 'list_model_db.dart';
import 'note.dart';
import 'notes_db.dart';

class LabelScreen extends StatefulWidget {
  final List<String> selectedIds;

  const LabelScreen({super.key, required this.selectedIds});

  @override
  State<LabelScreen> createState() => _LabelScreenState();
}

class _LabelScreenState extends State<LabelScreen> {
  TextEditingController controller = TextEditingController();
  List<String> selectedLabels = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: EdgeInsets.only(top: const MediaQueryData().padding.top + 40),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: onBackPress,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter label name',
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (int i = DataManager().labels.length - 1; i >= 0; i--)
            LabelTile(
              label: DataManager().labels[i],
              selectedLabels: selectedLabels,
            ),
        ],
      ),
    );
  }

  onBackPress() {
    List<Note> notes = DataManager().notes.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<Note> pinnedNotes =
        DataManager().pinnedNotes.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<Note> archivedNotes =
        DataManager().archivedNotes.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<Note> favoriteNotes =
        DataManager().favoriteNotes.where((element) => widget.selectedIds.contains(element.id)).toList();

    List<ListModel> listModels =
        DataManager().listModels.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<ListModel> pinnedListModels =
        DataManager().pinnedListModels.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<ListModel> archivedListModels =
        DataManager().archivedListModels.where((element) => widget.selectedIds.contains(element.id)).toList();
    List<ListModel> favoriteListModels =
        DataManager().favoriteListModels.where((element) => widget.selectedIds.contains(element.id)).toList();

    for (int i = 0; i < selectedLabels.length; i++) {
      for (Note note in notes) {
        if (!note.labels.contains(selectedLabels[i])) note.labels.add(selectedLabels[i]);
      }
      for (Note note in archivedNotes) {
        if (!note.labels.contains(selectedLabels[i])) note.labels.add(selectedLabels[i]);
      }
      for (Note note in pinnedNotes) {
        if (!note.labels.contains(selectedLabels[i])) note.labels.add(selectedLabels[i]);
      }
      for (Note note in favoriteNotes) {
        if (!note.labels.contains(selectedLabels[i])) note.labels.add(selectedLabels[i]);
      }
      for (ListModel listModel in listModels) {
        if (!listModel.labels.contains(selectedLabels[i])) listModel.labels.add(selectedLabels[i]);
      }
      for (ListModel listModel in archivedListModels) {
        if (!listModel.labels.contains(selectedLabels[i])) listModel.labels.add(selectedLabels[i]);
      }
      for (ListModel listModel in pinnedListModels) {
        if (!listModel.labels.contains(selectedLabels[i])) listModel.labels.add(selectedLabels[i]);
      }
      for (ListModel listModel in favoriteListModels) {
        if (!listModel.labels.contains(selectedLabels[i])) listModel.labels.add(selectedLabels[i]);
      }
    }

    NotesDb.removeNotes(NotesDb.notesKey, widget.selectedIds);
    NotesDb.addNotes(NotesDb.notesKey, notes);

    NotesDb.removeNotes(NotesDb.archivedNotesKey, widget.selectedIds);
    NotesDb.addNotes(NotesDb.archivedNotesKey, archivedNotes);
    NotesDb.removeNotes(NotesDb.pinnedNotesKey, widget.selectedIds);
    NotesDb.addNotes(NotesDb.pinnedNotesKey, pinnedNotes);
    NotesDb.removeNotes(NotesDb.favoriteNotesKey, widget.selectedIds);
    NotesDb.addNotes(NotesDb.favoriteNotesKey, favoriteNotes);

    ListModelsDb.removeListModels(ListModelsDb.listModelKey, widget.selectedIds);
    ListModelsDb.addListModels(ListModelsDb.listModelKey, listModels);
    ListModelsDb.removeListModels(ListModelsDb.archivedListModelKey, widget.selectedIds);
    ListModelsDb.addListModels(ListModelsDb.archivedListModelKey, archivedListModels);
    ListModelsDb.removeListModels(ListModelsDb.pinnedListModelKey, widget.selectedIds);
    ListModelsDb.addListModels(ListModelsDb.pinnedListModelKey, pinnedListModels);
    ListModelsDb.removeListModels(ListModelsDb.favoriteListModelKey, widget.selectedIds);
    ListModelsDb.addListModels(ListModelsDb.favoriteListModelKey, favoriteListModels);

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
  }
}

class LabelTile extends StatefulWidget {
  final List<String> selectedLabels;
  final String label;

  const LabelTile({super.key, required this.label, required this.selectedLabels});

  @override
  State<LabelTile> createState() => _LabelTileState();
}

class _LabelTileState extends State<LabelTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.label_outline_rounded,
              color: Colors.grey.shade800,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.label),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              if (widget.selectedLabels.contains(widget.label)) {
                widget.selectedLabels.remove(widget.label);
              } else {
                widget.selectedLabels.add(widget.label);
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.selectedLabels.contains(widget.label)
                  ? Icon(
                      Icons.check_box,
                      color: Colors.blue.shade700,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey.shade800,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
