import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';
import 'data_manager.dart';
import 'note.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        selectedTab: 'archiveScreen',
      ),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: MediaQueryData().padding.top + 40, left: 15),
              child: Row(
                children: [
                  Builder(
                      builder: (context) => InkWell(
                            onTap: () {
                              Scaffold.of(context).openDrawer();

                              debugPrint("_ArchiveScreenState: build ");
                            },
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                              ),
                            ),
                          )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      'Archive',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Icon(
                        Icons.search,
                        size: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      DataManager().homeScreenView = !DataManager().homeScreenView;
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Icon(
                        DataManager().homeScreenView ? Icons.list : Icons.grid_view_outlined,
                        size: 30,
                      ),
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
              height: 90,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQueryData().padding.top + 20),
                child: Row(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          CupertinoIcons.xmark,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
                        setState(() {});
                      },
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
                          CupertinoIcons.pin,
                          size: 25,
                        ),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: Padding(
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
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.label_outline,
                          size: 25,
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.unarchive_outlined,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        for (int i = 0; i < selectedIds.length; i++) {
                          for (Note note in DataManager().archivedNotes) {
                            if (note.id == selectedIds[i]) {
                              DataManager().notes.add(note);
                              DataManager().archivedNotes.remove(note);
                            }
                          }
                          for (ListModel listModel in DataManager().archivedListModels) {
                            if (listModel.id == selectedIds[i]) {
                              DataManager().listModels.add(listModel);
                              DataManager().archivedListModels.remove(listModel);
                            }
                          }
                        }
                        selectedIds.clear();
                        setState(() {});
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.delete_outline,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        for (int i = 0; i < selectedIds.length; i++) {
                          for (Note note in DataManager().archivedNotes) {
                            if (note.id == selectedIds[i]) {
                              DataManager().deletedNotes.add(note);
                              DataManager().archivedNotes.remove(note);
                            }
                          }
                        }
                        selectedIds.clear();
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          if (DataManager().archivedNotes.isEmpty && DataManager().archivedListModels.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 140,
                    color: Colors.yellow.shade800,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Your archived notes appear here'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: DataManager().homeScreenView
                    ?

                    ///ListView of Notes
                    Column(
                        children: [
                          SizedBox(height: 20),
                          for (Note note in DataManager().archivedNotes)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                      color: selectedIds.contains(note.id) ? Colors.blue : Colors.black,
                                      width: selectedIds.contains(note.id) ? 2.0 : 1.0,
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
                                      Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: Wrap(
                                          children: [
                                            for (String label in note.labels)
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

                          ///List view listItem
                          for (ListModel listModel in DataManager().archivedListModels)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      if (selectedIds.isEmpty) {
                                        Navigator.of(context)
                                            .pushNamed(Routes.viewOrEditListModel, arguments: listModel);
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey.shade800),
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
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            children: [
                              for (int i = 0; i < DataManager().archivedNotes.length; i++)
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  padding: EdgeInsets.only(
                                      right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      if (selectedIds.isEmpty) {
                                        Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen,
                                            arguments: DataManager().archivedNotes[i]);
                                      } else {
                                        if (selectedIds.contains(DataManager().archivedNotes[i].id)) {
                                          selectedIds.remove(DataManager().archivedNotes[i].id);
                                        } else {
                                          selectedIds.add(DataManager().archivedNotes[i].id);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    onLongPress: () {
                                      debugPrint("_HomeScreenState: build ");
                                      if (selectedIds.contains(DataManager().archivedNotes[i].id)) {
                                        selectedIds.remove(DataManager().archivedNotes[i].id);
                                      } else {
                                        selectedIds.add(DataManager().archivedNotes[i].id);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedIds.contains(DataManager().archivedNotes[i].id)
                                              ? Colors.blue
                                              : Colors.black,
                                          width: selectedIds.contains(DataManager().archivedNotes[i].id) ? 3.0 : 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DataManager().archivedNotes[i].title}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            DataManager().archivedNotes[i].note,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: Wrap(
                                              children: [
                                                for (String label in DataManager().archivedNotes[i].labels)
                                                  Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.shade300,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Text(
                                                        '  ${label}  ',
                                                      ),
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
                              for (int i = 0; i < DataManager().archivedListModels.length; i++)
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  padding: EdgeInsets.only(
                                      right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      if (selectedIds.isEmpty) {
                                        Navigator.of(context).pushNamed(Routes.viewOrEditListModel,
                                            arguments: DataManager().archivedListModels[i]);
                                      } else {
                                        if (selectedIds.contains(DataManager().archivedListModels[i].id)) {
                                          selectedIds.remove(DataManager().archivedListModels[i].id);
                                        } else {
                                          selectedIds.add(DataManager().archivedListModels[i].id);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    onLongPress: () {
                                      debugPrint("_HomeScreenState: build ");
                                      if (selectedIds.contains(DataManager().archivedListModels[i].id)) {
                                        selectedIds.remove(DataManager().archivedListModels[i].id);
                                      } else {
                                        selectedIds.add(DataManager().archivedListModels[i].id);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedIds.contains(DataManager().archivedListModels[i].id)
                                              ? Colors.blue
                                              : Colors.black,
                                          width:
                                              selectedIds.contains(DataManager().archivedListModels[i].id) ? 2.0 : 1.0,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DataManager().archivedListModels[i].title}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.topStart,
                                            child: Wrap(
                                              children: [
                                                for (ListItem listItem in DataManager().archivedListModels[i].items)
                                                  Row(
                                                    children: [
                                                      listItem.ticked
                                                          ? Icon(
                                                              Icons.check_box_outlined,
                                                              color: Colors.grey.shade500,
                                                            )
                                                          : Icon(Icons.check_box_outline_blank,
                                                              color: Colors.grey.shade500),
                                                      Text(listItem.name),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.centerStart,
                                            child: Wrap(
                                              children: [
                                                for (String label in DataManager().labels)
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
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
