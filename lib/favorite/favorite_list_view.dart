import 'package:flutter/material.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../note.dart';
import '../routes.dart';

class FavoriteListView extends StatelessWidget {
  const FavoriteListView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.isPinned,
    required this.others,
  }) : super(key: key);

  final List<String> selectedIds;
  final Function()? onUpdateRequest;
  final bool isPinned, others;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPinned)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Pinned',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                ///FavNote Pinned

                for (Note note in DataManager().favoriteNotes)
                  if (note.isPinned)
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
                            color: note.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selectedIds.contains(note.id)
                                    ? Colors.blue.shade800
                                    : note.color == Colors.white
                                    ? Colors.grey
                                    : Colors.transparent,
                                width: selectedIds.contains(note.id) ? 3.0 : 0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                note.note,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
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
                                          child: Text('  $label  '),
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

                ///FavNote ListModel Pinned

                for (ListModel listModel in DataManager().favoriteListModels)
                  if (listModel.isPinned)
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
                            color: listModel.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selectedIds.contains(listModel.id)
                                    ? Colors.blue.shade800
                                    : listModel.color == Colors.white
                                    ? Colors.grey
                                    : Colors.transparent,
                                width: selectedIds.contains(listModel.id) ? 3.0 : 0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listModel.title,
                                style:
                                    TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey.shade800),
                              ),
                              for (ListItem item in listModel.items)
                                Row(
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
                                          child: Text('  $label  '),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPinned && others)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Others',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                ///FavNote Notes IsNotePinned

                for (Note note in DataManager().favoriteNotes)
                  if (!note.isPinned)
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
                            color: note.color,
                            border: Border.all(
                                color: selectedIds.contains(note.id)
                                    ? Colors.blue.shade800
                                    : note.color == Colors.white
                                    ? Colors.grey
                                    : Colors.transparent,
                                width: selectedIds.contains(note.id) ? 3.0 : 0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
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
                                          child: Text('  $label  '),
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

                ///FavNotearc ListModel isNotePinned

                for (ListModel listModel in DataManager().favoriteListModels)
                  if (!listModel.isPinned)
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
                            color: listModel.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selectedIds.contains(listModel.id)
                                    ? Colors.blue.shade800
                                    : listModel.color == Colors.white
                                    ? Colors.grey
                                    : Colors.transparent,
                                width: selectedIds.contains(listModel.id) ? 3.0 : 0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listModel.title,
                                style:
                                    TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.grey.shade800),
                              ),
                              for (ListItem item in listModel.items)
                                Row(
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
                                          child: Text('  $label  '),
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
        ),
      ),
    );
  }
}
