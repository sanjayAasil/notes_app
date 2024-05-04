import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/notification_manager.dart';
import 'package:sanjay_notes/utils.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../routes.dart';

class DefaultHomeAppBar extends StatelessWidget {
  final Function()? onViewChanged;

  const DefaultHomeAppBar({Key? key, this.onViewChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 10, right: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Builder(builder: (context) {
              return InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.menu,
                    size: 25,
                    color: Colors.grey.shade800,
                  ),
                ),
              );
            }),
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed(Routes.searchScreen),
                child: const Padding(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text(
                    'Search your notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                DataManager().homeScreenView = !DataManager().homeScreenView;
                onViewChanged?.call();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Icon(
                  DataManager().homeScreenView ? Icons.list : Icons.grid_view_outlined,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 30,
                    color: Colors.grey.shade800,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedHomeAppBar extends StatelessWidget {
  final Function()? onSelectedIdsCleared;
  final List<String> selectedIds;

  const SelectedHomeAppBar({
    Key? key,
    this.onSelectedIdsCleared,
    required this.selectedIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.grey.shade200,
      width: double.infinity,
      height: const MediaQueryData().padding.top + 100,
      child: Padding(
        padding: EdgeInsets.only(top: const MediaQueryData().padding.top + 50),
        child: Row(
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
              onTap: () {
                selectedIds.clear();
                onSelectedIdsCleared?.call();
              },
            ),
            Expanded(
                child: Text(
              '${selectedIds.length}',
              style: const TextStyle(
                fontSize: 20,
              ),
            )),
            InkWell(
              onTap: onPinned,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  CupertinoIcons.pin,
                  color: Colors.grey.shade800,
                  size: 25,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  CupertinoIcons.bell,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.label_outline_rounded,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
              onTap: () => Navigator.of(context).pushNamed(Routes.labelScreen, arguments: selectedIds),
            ),
            InkWell(
              onTap: () => Utils.commonDialog(
                context: context,
                function: onArchive,
                content: 'Archive',
                snackBarMessage: 'Notes moved to Archive',
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.archive_outlined,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            InkWell(
              onTap: () => Utils.commonDialog(
                context: context,
                function: onDeleted,
                content: 'Delete',
                snackBarMessage: 'Notes moved to Bin',
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.delete_outline,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onArchive() {
    List<Note> notes = DataManager().notes.where((element) => selectedIds.contains(element.id)).toList();
    List<Note> pinnedNotes = DataManager().pinnedNotes.where((element) => selectedIds.contains(element.id)).toList();
    List<ListModel> listModels = DataManager().listModels.where((element) => selectedIds.contains(element.id)).toList();
    List<ListModel> pinnedListModels =
        DataManager().pinnedListModels.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isArchive = true;
    }
    for (Note note in pinnedNotes) {
      note.isArchive = true;
    }
    for (ListModel listModel in listModels) {
      listModel.isArchive = true;
    }
    for (ListModel listModel in pinnedListModels) {
      listModel.isArchive = true;
    }

    if (notes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.archivedNotesKey, notes);
      NotesDb.removeNotes(NotesDb.notesKey, selectedIds);
    }
    if (pinnedNotes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.archivedNotesKey, pinnedNotes);
      NotesDb.removeNotes(NotesDb.pinnedNotesKey, selectedIds);
    }
    if (listModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.archivedListModelKey, listModels);
      ListModelsDb.removeListModels(ListModelsDb.listModelKey, selectedIds);
    }
    if (pinnedListModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.archivedListModelKey, pinnedListModels);
      ListModelsDb.removeListModels(ListModelsDb.pinnedListModelKey, selectedIds);
    }

    selectedIds.clear();
    onSelectedIdsCleared?.call();
  }

  onDeleted() {
    List<Note> notes = DataManager().notes.where((element) => selectedIds.contains(element.id)).toList();
    List<Note> pinnedNotes = DataManager().pinnedNotes.where((element) => selectedIds.contains(element.id)).toList();
    List<ListModel> listModels = DataManager().listModels.where((element) => selectedIds.contains(element.id)).toList();
    List<ListModel> pinnedListModels =
        DataManager().pinnedListModels.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isDeleted = true;
    }
    for (Note note in pinnedNotes) {
      note.isDeleted = true;
    }
    for (ListModel listModel in listModels) {
      listModel.isDeleted = true;
    }
    for (ListModel listModel in pinnedListModels) {
      listModel.isDeleted = true;
    }
    if (notes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.deletedNotesKey, notes);
      NotesDb.removeNotes(NotesDb.notesKey, selectedIds);
    }
    if (pinnedNotes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.deletedNotesKey, pinnedNotes);
      NotesDb.removeNotes(NotesDb.pinnedNotesKey, selectedIds);
    }
    if (listModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.deletedListModelKey, listModels);
      ListModelsDb.removeListModels(ListModelsDb.listModelKey, selectedIds);
    }
    if (pinnedListModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.deletedListModelKey, pinnedListModels);
      ListModelsDb.removeListModels(ListModelsDb.pinnedListModelKey, selectedIds);
    }

    selectedIds.clear();
    onSelectedIdsCleared?.call();
  }

  onPinned() {
    List<Note> notes = DataManager().notes.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isPinned = true;
    }

    NotesDb.addNotes(NotesDb.pinnedNotesKey, notes);
    NotesDb.removeNotes(NotesDb.notesKey, selectedIds);

    List<ListModel> listModels = DataManager().listModels.where((element) => selectedIds.contains(element.id)).toList();

    for (ListModel listModel in listModels) {
      listModel.isPinned = true;
    }

    ListModelsDb.addListModels(ListModelsDb.pinnedListModelKey, listModels);
    ListModelsDb.removeListModels(ListModelsDb.listModelKey, selectedIds);

    selectedIds.clear();
    onSelectedIdsCleared?.call();
  }
}
