import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
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
                  DataManager().archivedNotes.add(note);
                  DataManager().favoriteNotes.removeWhere((element) => element == note);
                }

                List<ListModel> listModels =
                    DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isArchive = true;
                  DataManager().archivedListModels.add(listModel);
                  DataManager().favoriteListModels.removeWhere((element) => element == listModel);
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
                    DataManager().favoriteNotes.where((element) => selectedIds.contains(element.id)).toList();
                for (Note note in notes) {
                  note.isDeleted = true;
                }

                DataManager().favoriteNotes.removeWhere((element) => selectedIds.contains(element.id));
                DataManager().deletedNotes.addAll(notes);
                List<ListModel> listModels =
                    DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();
                for (ListModel listModel in listModels) {
                  listModel.isDeleted = true;
                }
                DataManager().favoriteListModels.removeWhere((element) => selectedIds.contains(element.id));
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
    List<Note> notes = DataManager().favoriteNotes.where((element) => selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isPinned = true;
      DataManager().favoriteNotes.remove(note);
      DataManager().favoriteNotes.add(note);
    }

    List<ListModel> listModels =
        DataManager().favoriteListModels.where((element) => selectedIds.contains(element.id)).toList();

    for (ListModel listModel in listModels) {
      listModel.isPinned = true;
      DataManager().favoriteListModels.remove(listModel);
      DataManager().favoriteListModels.add(listModel);
    }

    selectedIds.clear();
    onSelectedIdsCleared?.call();
  }
}
