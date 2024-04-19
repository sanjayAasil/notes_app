import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 20),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQueryData().padding.top + 100, left: 15),
                  ),
                  Builder(
                      builder: (context) => InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.menu ,color: Colors.grey.shade800,
                                size: 30,
                              ),
                            ),
                          )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
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
              color: Colors.grey.shade300,
              width: double.infinity,
              height: MediaQueryData().padding.top + 100,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQueryData().padding.top + 50),
                child: Row(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          CupertinoIcons.xmark,color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false),
                    ),
                    Expanded(
                        child: Text(
                      '${selectedIds.length}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.recycling_rounded,color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        List<Note> notes =
                            DataManager().deletedNotes.where((element) => selectedIds.contains(element.id)).toList();
                        for (Note note in notes) {
                          if (note.isArchive) {
                            DataManager().archivedNotes.add(note);
                          } else {
                            if (note.isPinned) {
                              DataManager().pinnedNotes.add(note);
                            } else {
                              DataManager().notes.add(note);
                            }
                          }
                          DataManager().deletedNotes.remove(note);
                        }

                        List<ListModel> listModels = DataManager()
                            .deletedListModel
                            .where((element) => selectedIds.contains(element.id))
                            .toList();

                        for (ListModel listModel in listModels) {
                          if (listModel.isArchive) {
                            DataManager().archivedListModels.add(listModel);
                          } else {
                            if (listModel.isPinned) {
                              DataManager().pinnedListModels.add(listModel);
                            } else {
                              DataManager().listModels.add(listModel);
                            }
                          }
                          DataManager().deletedListModel.remove(listModel);
                        }
                        selectedIds.clear();
                        setState(() {});
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.delete_outline,color: Colors.grey.shade800,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        DataManager().deletedNotes.removeWhere((element) => selectedIds.contains(element.id));
                        DataManager().deletedListModel.removeWhere((element) => selectedIds.contains(element.id));
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Your archived notes appear here'),
                  ),
                ],
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(height: 20),
                  for (Note note in DataManager().deletedNotes)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (selectedIds.isEmpty) {
                            Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen, arguments: note);
                          } else {
                            if (selectedIds.contains(note.id)) {
                              selectedIds.remove(note.id);
                            } else {
                              selectedIds.add(note.id);
                            }
                            setState(() {});
                          }
                        },
                        onLongPress: () {
                          if (selectedIds.contains(note.id)) {
                            selectedIds.remove(note.id);
                          } else {
                            selectedIds.add(note.id);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedIds.contains(note.id) ? Colors.blue.shade800 : Colors.grey,
                              width: selectedIds.contains(note.id) ? 3.0 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${note.title}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                note.note,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  for (ListModel listModel in DataManager().deletedListModel)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (selectedIds.isEmpty) {
                            Navigator.of(context).pushNamed(Routes.viewOrEditListModel, arguments: listModel);
                          } else {
                            if (selectedIds.contains(listModel.id)) {
                              selectedIds.remove(listModel.id);
                            } else {
                              selectedIds.add(listModel.id);
                            }
                            setState(() {});
                          }
                        },
                        onLongPress: () {
                          if (selectedIds.contains(listModel.id)) {
                            selectedIds.remove(listModel.id);
                          } else {
                            selectedIds.add(listModel.id);
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedIds.contains(listModel.id) ? Colors.blue : Colors.black,
                              width: selectedIds.contains(listModel.id) ? 2.0 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${listModel.title}',
                                style:
                                    TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey.shade800),
                              ),
                              for (ListItem item in listModel.items)
                                Row(
                                  children: [
                                    item.ticked
                                        ? Icon(
                                            Icons.check_box_outlined,
                                            color: Colors.grey.shade500,
                                          )
                                        : Icon(Icons.check_box_outline_blank, color: Colors.grey.shade500),
                                    Text(item.name),
                                  ],
                                ),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Wrap(
                                  children: [
                                    for (String label in listModel.labels)
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text('  ${label}  '),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
