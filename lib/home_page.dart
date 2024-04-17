import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';
import 'note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(
        selectedTab: 'homeScreen',
      ),
      body: Column(
        children: [
          if (selectedIds.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10, right: 10),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: Row(
                    children: [
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.menu),
                          ),
                        );
                      }),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.searchScreen);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
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
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 20,
                          ),
                          child: Icon(
                            DataManager().homeScreenView ? Icons.list : Icons.grid_view_outlined,
                            size: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 25,
                            )),
                      ),
                    ],
                  ),
                ),
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
                        selectedIds.clear();
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
                      onTap: () {
                        for (int i = 0; i < selectedIds.length; i++) {
                          for (Note note in DataManager().notes) {
                            if (note.id == selectedIds[i]) {
                              DataManager().notes.remove(note);
                              DataManager().pinnedNotes.add(note);
                            }
                          }
                          for (ListModel listModel in DataManager().listModels) {
                            if (listModel.id == selectedIds[i]) {
                              DataManager().listModels.remove(listModel);
                              DataManager().pinnedListModels.add(listModel);
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
                          CupertinoIcons.bell,
                          size: 25,
                        ),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.label_outline_rounded,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.labelScreen, arguments: selectedIds);
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.archive_outlined,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        for (int i = 0; i < selectedIds.length; i++) {
                          for (Note note in DataManager().notes) {
                            if (note.id == selectedIds[i]) {
                              note.isArchive = true;
                              DataManager().archivedNotes.add(note);
                              DataManager().notes.remove(note);
                            }
                          }
                          for (ListModel listModel in DataManager().listModels) {
                            if (listModel.id == selectedIds[i]) {
                              listModel.isArchive = true;
                              DataManager().archivedListModels.add(listModel);
                              DataManager().listModels.remove(listModel);
                              debugPrint("_HomeScreenState: build check ${listModel.labels}");
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
                          for (Note note in DataManager().notes) {
                            if (note.id == selectedIds[i]) {
                              DataManager().deletedNotes.add(note);
                              DataManager().notes.remove(note);
                            }
                          }
                          for (ListModel listModel in DataManager().listModels) {
                            if (listModel.id == selectedIds[i]) {
                              DataManager().deletedListModel.add(listModel);
                              DataManager().listModels.remove(listModel);
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
          if (DataManager().notes.isEmpty &&
              DataManager().listModels.isEmpty &&
              DataManager().pinnedNotes.isEmpty &&
              DataManager().pinnedListModels.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.yellow.shade800,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Notes you add appear here'),
                  Expanded(child: SizedBox()),
                ],
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: DataManager().homeScreenView
                    ?

                    ///ListView Pinned notes
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                                  child: Text(
                                    'PINNED',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                for (Note note in DataManager().pinnedNotes)
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

                                ///ListView pinned ListModel
                                for (ListModel listModel in DataManager().pinnedListModels)
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
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                  color: Colors.grey.shade800),
                                            ),
                                            for (ListItem item in listModel.items)
                                              Row(
                                                children: [
                                                  item.ticked
                                                      ? Icon(
                                                          Icons.check_box_outlined,
                                                          color: Colors.grey.shade500,
                                                        )
                                                      : Icon(Icons.check_box_outline_blank,
                                                          color: Colors.grey.shade500),
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

                          ///ListView Notes

                          Column(
                            children: [
                              if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty ||
                                  DataManager().pinnedListModels.isNotEmpty && DataManager().listModels.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                                  child: Text(
                                    'OTHERS',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              for (Note note in DataManager().notes)
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
                            ],
                          ),

                          ///List view listItem
                          for (ListModel listModel in DataManager().listModels)
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
                      )

                    ///Grid View pinnednotes
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (DataManager().pinnedNotes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'PINNED',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          for (int i = 0; i < DataManager().pinnedNotes.length; i++)
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              padding: EdgeInsets.only(
                                  right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  if (selectedIds.isEmpty) {
                                    Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen,
                                        arguments: DataManager().pinnedNotes[i]);
                                  } else {
                                    if (selectedIds.contains(DataManager().pinnedNotes[i].id)) {
                                      selectedIds.remove(DataManager().pinnedNotes[i].id);
                                    } else {
                                      selectedIds.add(DataManager().pinnedNotes[i].id);
                                    }
                                    setState(() {});
                                  }
                                },
                                onLongPress: () {
                                  debugPrint("_HomeScreenState: build ");
                                  if (selectedIds.contains(DataManager().pinnedNotes[i].id)) {
                                    selectedIds.remove(DataManager().pinnedNotes[i].id);
                                  } else {
                                    selectedIds.add(DataManager().pinnedNotes[i].id);
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedIds.contains(DataManager().pinnedNotes[i].id)
                                          ? Colors.blue
                                          : Colors.black,
                                      width: selectedIds.contains(DataManager().pinnedNotes[i].id) ? 2.0 : 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${DataManager().pinnedNotes[i].title}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        DataManager().pinnedNotes[i].note,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Wrap(
                                          children: [
                                            for (String label in DataManager().pinnedNotes[i].labels)
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
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

                          ///GridView notes

                          if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                              child: Text(
                                'OTHERS',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                children: [
                                  for (int i = 0; i < DataManager().notes.length; i++)
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 20,
                                      padding: EdgeInsets.only(
                                          right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          if (selectedIds.isEmpty) {
                                            Navigator.of(context).pushNamed(Routes.editOrViewNoteScreen,
                                                arguments: DataManager().notes[i]);
                                          } else {
                                            if (selectedIds.contains(DataManager().notes[i].id)) {
                                              selectedIds.remove(DataManager().notes[i].id);
                                            } else {
                                              selectedIds.add(DataManager().notes[i].id);
                                            }
                                            setState(() {});
                                          }
                                        },
                                        onLongPress: () {
                                          debugPrint("_HomeScreenState: build ");
                                          if (selectedIds.contains(DataManager().notes[i].id)) {
                                            selectedIds.remove(DataManager().notes[i].id);
                                          } else {
                                            selectedIds.add(DataManager().notes[i].id);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: selectedIds.contains(DataManager().notes[i].id)
                                                  ? Colors.blue
                                                  : Colors.black,
                                              width: selectedIds.contains(DataManager().notes[i].id) ? 2.0 : 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DataManager().notes[i].title}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                DataManager().notes[i].note,
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topStart,
                                                child: Wrap(
                                                  children: [
                                                    for (String label in DataManager().notes[i].labels)
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
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

                                  ///Grid view listItem
                                  for (int i = 0; i < DataManager().listModels.length; i++)
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2 - 20,
                                      padding: EdgeInsets.only(
                                          right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          if (selectedIds.isEmpty) {
                                            Navigator.of(context).pushNamed(Routes.viewOrEditListModel,
                                                arguments: DataManager().listModels[i]);
                                          } else {
                                            if (selectedIds.contains(DataManager().listModels[i].id)) {
                                              selectedIds.remove(DataManager().listModels[i].id);
                                            } else {
                                              selectedIds.add(DataManager().listModels[i].id);
                                            }
                                            setState(() {});
                                          }
                                        },
                                        onLongPress: () {
                                          debugPrint("_HomeScreenState: build ");
                                          if (selectedIds.contains(DataManager().listModels[i].id)) {
                                            selectedIds.remove(DataManager().listModels[i].id);
                                          } else {
                                            selectedIds.add(DataManager().listModels[i].id);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: selectedIds.contains(DataManager().listModels[i].id)
                                                  ? Colors.blue
                                                  : Colors.black,
                                              width: selectedIds.contains(DataManager().listModels[i].id) ? 2.0 : 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${DataManager().listModels[i].title}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional.topStart,
                                                child: Wrap(
                                                  children: [
                                                    for (ListItem listItem in DataManager().listModels[i].items)
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
                                                    for (String label in DataManager().listModels[i].labels)
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
                        ],
                      ),
              ),
            ),
          Container(
            color: Colors.grey.shade300,
            height: 45,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    debugPrint("_HomeScreenState: build  ");
                    Navigator.of(context).pushNamed(Routes.newListScreen);
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.check_box_outlined),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.draw_outlined),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.mic_none_rounded),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.photo_outlined),
                  ),
                ),
              ],
            ),
          ),
          //Expanded(child: SizedBox()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.createNewNoteScreen);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey.shade300,
      ),
    );
  }
}
