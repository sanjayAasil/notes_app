import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../routes.dart';

class DefaultArchiveAppBar extends StatelessWidget {
  const DefaultArchiveAppBar({Key? key, this.onViewChanged}) : super(key: key);

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
              'Archive',
              style: TextStyle(fontSize: 18),
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
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              DataManager().archiveScreenView = !DataManager().archiveScreenView;
              onViewChanged?.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Icon(
                DataManager().archiveScreenView ? Icons.list : Icons.grid_view_outlined,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedArchiveAppBar extends StatelessWidget {
  const SelectedArchiveAppBar({Key? key, required this.selectedIds, this.onSelectedIdsCleared}) : super(key: key);

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
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
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
                  Icons.unarchive_outlined,
                  size: 25,
                ),
              ),
              onTap: () {
                List<Note> notes =
                    DataManager().archivedNotes.where((element) => selectedIds.contains(element.id)).toList();
                for (Note note in notes) {
                  note.isArchive = false;
                  if (note.isPinned) {
                    DataManager().pinnedNotes.add(note);
                  } else {
                    DataManager().notes.add(note);
                  }
                  DataManager().archivedNotes.removeWhere((element) => element == note);
                }

                List<ListModel> listModels =
                    DataManager().archivedListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isArchive = false;
                  if (listModel.isPinned) {
                    DataManager().pinnedListModels.add(listModel);
                  } else {
                    DataManager().listModels.add(listModel);
                  }
                  DataManager().archivedListModels.removeWhere((element) => element == listModel);
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
                List<Note> notes =
                    DataManager().archivedNotes.where((element) => selectedIds.contains(element.id)).toList();
                for (Note note in notes) {
                  note.isDeleted = true;
                }

                DataManager().archivedNotes.removeWhere((element) => selectedIds.contains(element.id));
                DataManager().deletedNotes.addAll(notes);
                List<ListModel> listModels =
                    DataManager().archivedListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isDeleted = true;
                }
                DataManager().archivedListModels.removeWhere((element) => selectedIds.contains(element.id));
                DataManager().deletedListModel.addAll(listModels);
                selectedIds.clear();
                onSelectedIdsCleared?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  onPinned() {
    List<Note> notes = DataManager().archivedNotes.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isPinned = true;
      DataManager().archivedNotes.remove(note);
      DataManager().archivedNotes.add(note);
    }

    List<ListModel> listModels =
        DataManager().archivedListModels.where((element) => selectedIds.contains(element.id)).toList();

    for (ListModel listModel in listModels) {
      listModel.isPinned = true;
      DataManager().archivedListModels.remove(listModel);
      DataManager().archivedListModels.add(listModel);
    }

    selectedIds.clear();
    onSelectedIdsCleared?.call();
  }
}
