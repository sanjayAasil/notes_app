import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/list_model_db.dart';
import 'package:sanjay_notes/Database/notes_db.dart';
import 'package:sanjay_notes/firebase/firebase_auth_manager.dart';
import 'package:sanjay_notes/providers/home_screen_provider.dart';
import 'package:sanjay_notes/utils.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import '../../Database/data_manager.dart';
import '../../models/list_model.dart';
import '../../models/note.dart';
import '../../routes.dart';

class DefaultHomeAppBar extends StatelessWidget {
  const DefaultHomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
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
                context.read<HomeScreenProvider>().notify();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Icon(
                  DataManager().homeScreenView ? CupertinoIcons.rectangle_grid_1x2 : CupertinoIcons.rectangle_grid_2x2,
                  size: 25,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Profile'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              try {
                                debugPrint("DefaultHomeAppBar build: ");
                                LoadingDialog loadingDialog = LoadingDialog(progressbarColor: Colors.blue.shade700)
                                  ..show(context);
                                await FirebaseAuthManager().signOut();
                                if (context.mounted) {
                                  debugPrint("DefaultHomeAppBar build: fewferwerv");
                                  loadingDialog.dismiss(context);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(Routes.mainScreen);
                                }
                              } catch (e) {
                                debugPrint("DefaultHomeAppBar build: errorrr $e");
                              }
                            },
                            child: Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
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
  const SelectedHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.read<HomeScreenProvider>();
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
              onTap: () => homeScreenProvider.clearSelectedIds(),
            ),
            Expanded(
              child: Builder(builder: (context) {
                context.watch<HomeScreenProvider>();
                return Text(
                  '${homeScreenProvider.selectedIds.length}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                );
              }),
            ),
            InkWell(
              onTap: () => onPinned(homeScreenProvider),
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
              onTap: () =>
                  Navigator.of(context).pushNamed(Routes.labelScreen, arguments: homeScreenProvider.selectedIds),
            ),
            InkWell(
              onTap: () => Utils.commonDialog(
                context: context,
                function: () => onArchive(homeScreenProvider),
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
                function: () => onDeleted(homeScreenProvider),
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

  onArchive(HomeScreenProvider homeScreenProvider) {
    List<Note> notes =
        DataManager().notes.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<Note> pinnedNotes =
        DataManager().pinnedNotes.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<ListModel> listModels =
        DataManager().listModels.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<ListModel> pinnedListModels =
        DataManager().pinnedListModels.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();

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
      NotesDb.removeNotes(NotesDb.notesKey, homeScreenProvider.selectedIds);
    }
    if (pinnedNotes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.archivedNotesKey, pinnedNotes);
      NotesDb.removeNotes(NotesDb.pinnedNotesKey, homeScreenProvider.selectedIds);
    }
    if (listModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.archivedListModelKey, listModels);
      ListModelsDb.removeListModels(ListModelsDb.listModelKey, homeScreenProvider.selectedIds);
    }
    if (pinnedListModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.archivedListModelKey, pinnedListModels);
      ListModelsDb.removeListModels(ListModelsDb.pinnedListModelKey, homeScreenProvider.selectedIds);
    }

    homeScreenProvider.clearSelectedIds();
  }

  onDeleted(HomeScreenProvider homeScreenProvider) {
    List<Note> notes =
        DataManager().notes.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<Note> pinnedNotes =
        DataManager().pinnedNotes.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<ListModel> listModels =
        DataManager().listModels.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();
    List<ListModel> pinnedListModels =
        DataManager().pinnedListModels.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();

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
      NotesDb.removeNotes(NotesDb.notesKey, homeScreenProvider.selectedIds);
    }
    if (pinnedNotes.isNotEmpty) {
      NotesDb.addNotes(NotesDb.deletedNotesKey, pinnedNotes);
      NotesDb.removeNotes(NotesDb.pinnedNotesKey, homeScreenProvider.selectedIds);
    }
    if (listModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.deletedListModelKey, listModels);
      ListModelsDb.removeListModels(ListModelsDb.listModelKey, homeScreenProvider.selectedIds);
    }
    if (pinnedListModels.isNotEmpty) {
      ListModelsDb.addListModels(ListModelsDb.deletedListModelKey, pinnedListModels);
      ListModelsDb.removeListModels(ListModelsDb.pinnedListModelKey, homeScreenProvider.selectedIds);
    }

    homeScreenProvider.clearSelectedIds();
  }

  onPinned(HomeScreenProvider homeScreenProvider) {
    List<Note> notes =
        DataManager().notes.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();

    for (Note note in notes) {
      note.isPinned = true;
    }

    NotesDb.addNotes(NotesDb.pinnedNotesKey, notes);
    NotesDb.removeNotes(NotesDb.notesKey, homeScreenProvider.selectedIds);

    List<ListModel> listModels =
        DataManager().listModels.where((element) => homeScreenProvider.selectedIds.contains(element.id)).toList();

    for (ListModel listModel in listModels) {
      listModel.isPinned = true;
    }

    ListModelsDb.addListModels(ListModelsDb.pinnedListModelKey, listModels);
    ListModelsDb.removeListModels(ListModelsDb.listModelKey, homeScreenProvider.selectedIds);

    homeScreenProvider.clearSelectedIds();
  }
}
