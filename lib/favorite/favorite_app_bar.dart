import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../routes.dart';

class DefaultFavoriteAppBar extends StatelessWidget {
  const DefaultFavoriteAppBar({Key? key, this.onViewChanged}) : super(key: key);

  final Function()? onViewChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: const MediaQueryData().padding.top + 50, left: 15),
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
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Favorites',
              style: TextStyle(fontSize: 18),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              DataManager().favoriteScreenView = !DataManager().favoriteScreenView;
              onViewChanged?.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Icon(
                DataManager().favoriteScreenView ? Icons.list : Icons.grid_view_outlined,
                size: 30,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedFavoriteAppBar extends StatelessWidget {
  const SelectedFavoriteAppBar({Key? key, required this.selectedIds, this.onSelectedIdsCleared}) : super(key: key);

  final List<String> selectedIds;
  final Function()? onSelectedIdsCleared;

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
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 25,
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
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  CupertinoIcons.pin,
                  size: 25,
                ),
              ),
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  CupertinoIcons.bell,
                  size: 25,
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.labelScreen, arguments: selectedIds);
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.label_outline,
                  size: 25,
                ),
              ),
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.archive_outlined,
                  size: 25,
                ),
              ),
              onTap: () {
                List<Note> notes =
                    DataManager().favoriteNotes.where((element) => selectedIds.contains(element.id)).toList();
                for (Note note in notes) {
                  note.isArchive = true;
                  NotesDb.addNote(NotesDb.archivedNotesKey, note);
                  NotesDb.removeNote(NotesDb.favoriteNotesKey, note.id);
                }

                List<ListModel> listModels =
                    DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isArchive = true;
                  ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, listModel);
                  ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, listModel.id);
                }
                selectedIds.clear();
                onSelectedIdsCleared?.call();
              },
            ),
            InkWell(
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.delete_outline,
                  size: 25,
                ),
              ),
              onTap: () {
                debugPrint("SelectedFavoriteAppBar build: ");

                List<Note> notes =
                    DataManager().favoriteNotes.where((element) => selectedIds.contains(element.id)).toList();
                for (Note note in notes) {
                  note.isDeleted = true;
                }
                debugPrint("SelectedFavoriteAppBar build: ${notes.map((e) => e.json)}");
                if (notes.isNotEmpty) {
                  NotesDb.addNotes(NotesDb.deletedNotesKey, notes);
                  NotesDb.removeNotes(NotesDb.favoriteNotesKey, selectedIds);
                }

                List<ListModel> listModels =
                    DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isDeleted = true;
                }
                if (listModels.isNotEmpty) {
                  ListModelsDb.removeListModels(ListModelsDb.favoriteListModelKey, selectedIds);
                  ListModelsDb.addListModels(ListModelsDb.deletedListModelKey, listModels);
                }

                selectedIds.clear();
                debugPrint("SelectedFavoriteAppBar build: end1");
                onSelectedIdsCleared?.call();
                debugPrint("SelectedFavoriteAppBar build: end2");
              },
            ),
          ],
        ),
      ),
    );
  }

  onPinned() {
    List<Note> notes = DataManager().favoriteNotes.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isPinned = true;
    }
    if (notes.isNotEmpty) {
      NotesDb.removeNotes(NotesDb.favoriteNotesKey, selectedIds);
      NotesDb.addNotes(NotesDb.favoriteNotesKey, notes);
    }

    List<ListModel> listModels =
        DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();

    for (ListModel listModel in listModels) {
      listModel.isPinned = true;
    }
    if (listModels.isNotEmpty) {
      ListModelsDb.removeListModels(ListModelsDb.favoriteListModelKey, selectedIds);
      ListModelsDb.addListModels(ListModelsDb.favoriteListModelKey, listModels);
    }

    selectedIds.clear();
    onSelectedIdsCleared?.call();
    debugPrint("SelectedFavoriteAppBar onPinned: pinned");
  }
}
