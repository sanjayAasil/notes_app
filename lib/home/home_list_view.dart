import 'package:flutter/material.dart';

import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../routes.dart';

class HomeScreenListView extends StatelessWidget {
  const HomeScreenListView({Key? key, required this.selectedIds, this.onUpdateRequest}) : super(key: key);

  final List<String> selectedIds;
  final Function()? onUpdateRequest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Pinned',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              for (Note note in DataManager().pinnedNotes)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        onUpdateRequest?.call();
                      }
                    },
                    onLongPress: () {
                      if (selectedIds.contains(note.id)) {
                        selectedIds.remove(note.id);
                      } else {
                        selectedIds.add(note.id);
                      }
                      onUpdateRequest?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIds.contains(note.id) ? Colors.blue.shade800 : Colors.grey,
                          width: selectedIds.contains(note.id) ? 3.0 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              note.note,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                        child: Text(
                                          '  $label  ',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
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

              ///ListView pinned ListModel
              for (ListModel listModel in DataManager().pinnedListModels)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        onUpdateRequest?.call();
                      }
                    },
                    onLongPress: () {
                      if (selectedIds.contains(listModel.id)) {
                        selectedIds.remove(listModel.id);
                      } else {
                        selectedIds.add(listModel.id);
                      }
                      onUpdateRequest?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIds.contains(listModel.id) ? Colors.blue.shade800 : Colors.grey,
                          width: selectedIds.contains(listModel.id) ? 3.0 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              listModel.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          for (ListItem item in listModel.items)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  item.ticked
                                      ? Icon(
                                          Icons.check_box_outlined,
                                          color: Colors.grey.shade500,
                                          size: 20,
                                        )
                                      : Icon(Icons.check_box_outline_blank, size: 20, color: Colors.grey.shade500),
                                  Text(
                                    item.name,
                                    style: TextStyle(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                        child: Text(
                                          '  $label  ',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
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
            ],
          ),

        ///ListView Notes

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (DataManager().pinnedNotes.isNotEmpty && DataManager().notes.isNotEmpty ||
                DataManager().pinnedNotes.isNotEmpty && DataManager().listModels.isNotEmpty ||
                DataManager().pinnedListModels.isNotEmpty && DataManager().listModels.isNotEmpty ||
                DataManager().pinnedListModels.isNotEmpty && DataManager().notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Others',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            for (Note note in DataManager().notes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      onUpdateRequest?.call();
                    }
                  },
                  onLongPress: () {
                    if (selectedIds.contains(note.id)) {
                      selectedIds.remove(note.id);
                    } else {
                      selectedIds.add(note.id);
                    }
                    onUpdateRequest?.call();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedIds.contains(note.id) ? Colors.blue.shade800 : Colors.grey,
                        width: selectedIds.contains(note.id) ? 3.0 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                      child: Text(
                                        '  $label  ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
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
          ],
        ),

        ///List view listModel
        for (ListModel listModel in DataManager().listModels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  onUpdateRequest?.call();
                }
              },
              onLongPress: () {
                if (selectedIds.contains(listModel.id)) {
                  selectedIds.remove(listModel.id);
                } else {
                  selectedIds.add(listModel.id);
                }
                onUpdateRequest?.call();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedIds.contains(listModel.id) ? Colors.blue.shade800 : Colors.grey,
                    width: selectedIds.contains(listModel.id) ? 3.0 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Text(
                        listModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    for (ListItem item in listModel.items)
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            item.ticked
                                ? Icon(
                                    Icons.check_box_outlined,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                            Text(item.name),
                          ],
                        ),
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                  child: Text(
                                    '  $label  ',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
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
      ],
    );
  }
}
