import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data_manager.dart';
import '../list_model.dart';
import '../routes.dart';

class HomeScreenGridView extends StatelessWidget {
  final List<String> selectedIds;
  final Function? onUpdateRequest;

  const HomeScreenGridView({Key? key, required this.selectedIds, this.onUpdateRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              'Pinned',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),

        Align(
          child: Wrap(
            children: [
              for (int i = 0; i < DataManager().pinnedNotes.length; i++)
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 5,
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (selectedIds.isEmpty) {
                        Navigator.of(context)
                            .pushNamed(Routes.editOrViewNoteScreen, arguments: DataManager().pinnedNotes[i]);
                      } else {
                        if (selectedIds.contains(DataManager().pinnedNotes[i].id)) {
                          selectedIds.remove(DataManager().pinnedNotes[i].id);
                        } else {
                          selectedIds.add(DataManager().pinnedNotes[i].id);
                        }
                        onUpdateRequest?.call();
                      }
                    },
                    onLongPress: () {
                      debugPrint("_HomeScreenState: build ");
                      if (selectedIds.contains(DataManager().pinnedNotes[i].id)) {
                        selectedIds.remove(DataManager().pinnedNotes[i].id);
                      } else {
                        selectedIds.add(DataManager().pinnedNotes[i].id);
                      }
                      onUpdateRequest?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIds.contains(DataManager().pinnedNotes[i].id)
                              ? Colors.blue.shade800
                              : Colors.grey,
                          width: selectedIds.contains(DataManager().pinnedNotes[i].id) ? 2.0 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DataManager().pinnedNotes[i].title}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DataManager().pinnedNotes[i].note,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
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
              for (int i = 0; i < DataManager().pinnedListModels.length; i++)
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 5,
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (selectedIds.isEmpty) {
                        Navigator.of(context)
                            .pushNamed(Routes.viewOrEditListModel, arguments: DataManager().pinnedListModels[i]);
                      } else {
                        if (selectedIds.contains(DataManager().pinnedListModels[i].id)) {
                          selectedIds.remove(DataManager().pinnedListModels[i].id);
                        } else {
                          selectedIds.add(DataManager().pinnedListModels[i].id);
                        }
                        onUpdateRequest?.call();
                      }
                    },
                    onLongPress: () {
                      debugPrint("_HomeScreenState: build ");
                      if (selectedIds.contains(DataManager().pinnedListModels[i].id)) {
                        selectedIds.remove(DataManager().pinnedListModels[i].id);
                      } else {
                        selectedIds.add(DataManager().pinnedListModels[i].id);
                      }
                      onUpdateRequest?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIds.contains(DataManager().pinnedListModels[i].id)
                              ? Colors.blue.shade800
                              : Colors.grey,
                          width: selectedIds.contains(DataManager().pinnedListModels[i].id) ? 2.0 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              '${DataManager().pinnedListModels[i].title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Wrap(
                              children: [
                                for (ListItem listItem in DataManager().pinnedListModels[i].items)
                                  Row(
                                    children: [
                                      listItem.ticked
                                          ? Icon(
                                              Icons.check_box_outlined,
                                              color: Colors.grey.shade500,
                                              size: 20,

                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                              color: Colors.grey.shade500,
                                              size: 20,
                                            ),
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
                                for (String label in DataManager().pinnedListModels[i].labels)
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



        ///GridView notes

        if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              'Others',
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
                    padding: EdgeInsets.only(right: i.isEven ? 10 : 0, left: i.isOdd ? 10 : 0, top: 10, bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (selectedIds.isEmpty) {
                          Navigator.of(context)
                              .pushNamed(Routes.editOrViewNoteScreen, arguments: DataManager().notes[i]);
                        } else {
                          if (selectedIds.contains(DataManager().notes[i].id)) {
                            selectedIds.remove(DataManager().notes[i].id);
                          } else {
                            selectedIds.add(DataManager().notes[i].id);
                          }
                          onUpdateRequest?.call();
                        }
                      },
                      onLongPress: () {
                        debugPrint("_HomeScreenState: build ");
                        if (selectedIds.contains(DataManager().notes[i].id)) {
                          selectedIds.remove(DataManager().notes[i].id);
                        } else {
                          selectedIds.add(DataManager().notes[i].id);
                        }
                        onUpdateRequest?.call();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedIds.contains(DataManager().notes[i].id) ? Colors.blue.shade800 : Colors.grey,
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
                for (int i = 0; i < DataManager().listModels.length; i++)
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 5,
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        if (selectedIds.isEmpty) {
                          Navigator.of(context)
                              .pushNamed(Routes.viewOrEditListModel, arguments: DataManager().listModels[i]);
                        } else {
                          if (selectedIds.contains(DataManager().listModels[i].id)) {
                            selectedIds.remove(DataManager().listModels[i].id);
                          } else {
                            selectedIds.add(DataManager().listModels[i].id);
                          }
                          onUpdateRequest?.call();
                        }
                      },
                      onLongPress: () {
                        debugPrint("_HomeScreenState: build ");
                        if (selectedIds.contains(DataManager().listModels[i].id)) {
                          selectedIds.remove(DataManager().listModels[i].id);
                        } else {
                          selectedIds.add(DataManager().listModels[i].id);
                        }
                        onUpdateRequest?.call();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedIds.contains(DataManager().listModels[i].id)
                                ? Colors.blue.shade800
                                : Colors.grey,
                            width: selectedIds.contains(DataManager().listModels[i].id) ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                '${DataManager().listModels[i].title}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
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
                                          size: 20,

                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.grey.shade500,
                                          size: 20,
                                        ),
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

                ///Grid view listModel
              ],
            ),
          ),
        ),
      ],
    );
  }
}
