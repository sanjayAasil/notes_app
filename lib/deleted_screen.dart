import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:sanjay_notes/widget_helper.dart';

import 'list_model.dart';
import 'note.dart';

class DeletedScreen extends StatefulWidget {
  const DeletedScreen({super.key});

  @override
  State<DeletedScreen> createState() => _DeletedScreenState();
}

class _DeletedScreenState extends State<DeletedScreen> {
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(
        selectedTab: 'deletedScreen',
      ),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: const MediaQueryData().padding.top + 50,
                left: const MediaQueryData().padding.left + 10,
                bottom: 20,
              ),
              child: Row(
                children: [
                  Builder(
                      builder: (context) => InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.menu,
                                color: Colors.grey.shade800,
                                size: 30,
                              ),
                            ),
                          )),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: Text(
                      'Deleted',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              alignment: Alignment.centerLeft,
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
                          color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false),
                    ),
                    Expanded(
                        child: Text(
                      '${selectedIds.length}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    )),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.recycling_rounded,
                          color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        List<Note> notes =
                            DataManager().deletedNotes.where((element) => selectedIds.contains(element.id)).toList();
                        for (Note note in notes) {
                          if (note.isArchive) {
                            note.isDeleted = false;
                            NotesDb.addNote(NotesDb.archivedNotesKey, note);
                          } else if (note.isFavorite) {
                            note.isDeleted = false;
                            NotesDb.addNote(NotesDb.favoriteNotesKey, note);
                          } else if (note.isPinned) {
                            note.isDeleted = false;
                            NotesDb.addNote(NotesDb.pinnedNotesKey, note);
                          } else {
                            note.isDeleted = false;
                            NotesDb.addNote(NotesDb.notesKey, note);
                          }
                        }
                        if (notes.isNotEmpty) {
                          NotesDb.removeNotes(NotesDb.deletedNotesKey, selectedIds);
                        }

                        List<ListModel> listModels = DataManager()
                            .deletedListModel
                            .where((element) => selectedIds.contains(element.id))
                            .toList();

                        for (ListModel listModel in listModels) {
                          if (listModel.isArchive) {
                            listModel.isDeleted = false;
                            ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, listModel);
                          } else if (listModel.isFavorite) {
                            listModel.isDeleted = false;
                            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
                          } else if (listModel.isPinned) {
                            listModel.isDeleted = false;
                            ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, listModel);
                          } else {
                            listModel.isDeleted = false;
                            ListModelsDb.addListModel(ListModelsDb.listModelKey, listModel);
                          }
                        }
                        if (listModels.isNotEmpty) {
                          ListModelsDb.removeListModels(ListModelsDb.deletedListModelKey, selectedIds);
                        }
                        selectedIds.clear();
                        setState(() {});
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        if (DataManager().deletedNotes.isNotEmpty) {
                          NotesDb.removeNotes(NotesDb.deletedNotesKey, selectedIds);
                        }
                        if (DataManager().deletedListModel.isNotEmpty) {
                          ListModelsDb.removeListModels(ListModelsDb.deletedListModelKey, selectedIds);
                        }
                        selectedIds.clear();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          if (DataManager().deletedNotes.isEmpty && DataManager().deletedListModel.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.delete_simple,
                    size: 140,
                    color: Colors.yellow.shade800,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Your archived notes appear here'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 20),
                    for (Note note in DataManager().deletedNotes)
                      NoteTileListView(
                        note: note,
                        selectedIds: selectedIds,
                        onUpdateRequest: () => setState(() {}),
                      ),
                    for (ListModel listModel in DataManager().deletedListModel)
                      ListModelTileListView(
                        selectedIds: selectedIds,
                        listModel: listModel,
                        onUpdateRequest: () => setState(() {}),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
