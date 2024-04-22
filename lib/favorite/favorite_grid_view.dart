import 'package:flutter/material.dart';
import '../data_manager.dart';
import '../list_model.dart';
import '../routes.dart';

class FavoriteGridView extends StatelessWidget {
  final List<String> selectedIds;
  final Function()? onUpdateRequest;
  final bool isPinned, others;

  const FavoriteGridView({
    Key? key,
    required this.selectedIds,
    this.onUpdateRequest,
    required this.isPinned,
    required this.others,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ///PinnedNotes fav
                    for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                      if (DataManager().favoriteNotes[i].isPinned)
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (selectedIds.isEmpty) {
                                Navigator.of(context)
                                    .pushNamed(Routes.editOrViewNoteScreen, arguments: DataManager().favoriteNotes[i]);
                              } else {
                                if (selectedIds.contains(DataManager().favoriteNotes[i].id)) {
                                  selectedIds.remove(DataManager().favoriteNotes[i].id);
                                } else {
                                  selectedIds.add(DataManager().favoriteNotes[i].id);
                                }
                                onUpdateRequest?.call();
                              }
                            },
                            onLongPress: () {
                              debugPrint("_HomeScreenState: build ");
                              if (selectedIds.contains(DataManager().favoriteNotes[i].id)) {
                                selectedIds.remove(DataManager().favoriteNotes[i].id);
                              } else {
                                selectedIds.add(DataManager().favoriteNotes[i].id);
                              }
                              onUpdateRequest?.call();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: DataManager().favoriteNotes[i].color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedIds.contains(DataManager().favoriteNotes[i].id)
                                      ? Colors.blue.shade800
                                      : Colors.grey,
                                  width: selectedIds.contains(DataManager().favoriteNotes[i].id) ? 3.0 : 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DataManager().favoriteNotes[i].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DataManager().favoriteNotes[i].note,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Wrap(
                                      children: [
                                        for (String label in DataManager().favoriteNotes[i].labels)
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                '  $label  ',
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

                    ///Pinned ListModel fAV

                    for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                      if (DataManager().favoriteListModels[i].isPinned)
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (selectedIds.isEmpty) {
                                Navigator.of(context).pushNamed(Routes.viewOrEditListModel,
                                    arguments: DataManager().favoriteListModels[i]);
                              } else {
                                if (selectedIds.contains(DataManager().favoriteListModels[i].id)) {
                                  selectedIds.remove(DataManager().favoriteListModels[i].id);
                                } else {
                                  selectedIds.add(DataManager().favoriteListModels[i].id);
                                }
                                onUpdateRequest?.call();
                              }
                            },
                            onLongPress: () {
                              debugPrint("_HomeScreenState: build ");
                              if (selectedIds.contains(DataManager().favoriteListModels[i].id)) {
                                selectedIds.remove(DataManager().favoriteListModels[i].id);
                              } else {
                                selectedIds.add(DataManager().favoriteListModels[i].id);
                              }
                              onUpdateRequest?.call();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: DataManager().favoriteListModels[i].color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedIds.contains(DataManager().favoriteListModels[i].id)
                                      ? Colors.blue.shade800
                                      : Colors.grey,
                                  width: selectedIds.contains(DataManager().favoriteListModels[i].id) ? 3.0 : 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      DataManager().favoriteListModels[i].title,
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
                                        for (ListItem listItem in DataManager().favoriteListModels[i].items)
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
                                        for (String label in DataManager().labels)
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

                    ///Note Pinned FAV

                    ///Not Pinned FAV ListModel
                  ],
                ),
              ),
            ),
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
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Wrap(
                children: [
                  for (int i = 0; i < DataManager().favoriteNotes.length; i++)
                    if (!DataManager().favoriteNotes[i].isPinned)
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (selectedIds.isEmpty) {
                              Navigator.of(context)
                                  .pushNamed(Routes.editOrViewNoteScreen, arguments: DataManager().favoriteNotes[i]);
                            } else {
                              if (selectedIds.contains(DataManager().favoriteNotes[i].id)) {
                                selectedIds.remove(DataManager().favoriteNotes[i].id);
                              } else {
                                selectedIds.add(DataManager().favoriteNotes[i].id);
                              }
                              onUpdateRequest?.call();
                            }
                          },
                          onLongPress: () {
                            debugPrint("_HomeScreenState: build ");
                            if (selectedIds.contains(DataManager().favoriteNotes[i].id)) {
                              selectedIds.remove(DataManager().favoriteNotes[i].id);
                            } else {
                              selectedIds.add(DataManager().favoriteNotes[i].id);
                            }
                            onUpdateRequest?.call();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: DataManager().favoriteNotes[i].color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedIds.contains(DataManager().favoriteNotes[i].id)
                                    ? Colors.blue.shade800
                                    : Colors.grey,
                                width: selectedIds.contains(DataManager().favoriteNotes[i].id) ? 3.0 : 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DataManager().favoriteNotes[i].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  DataManager().favoriteNotes[i].note,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Wrap(
                                    children: [
                                      for (String label in DataManager().favoriteNotes[i].labels)
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '  $label  ',
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

                  ///listModel notPinned

                  for (int i = 0; i < DataManager().favoriteListModels.length; i++)
                    if (!DataManager().favoriteListModels[i].isPinned)
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 15,
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (selectedIds.isEmpty) {
                              Navigator.of(context).pushNamed(Routes.viewOrEditListModel,
                                  arguments: DataManager().favoriteListModels[i]);
                            } else {
                              if (selectedIds.contains(DataManager().favoriteListModels[i].id)) {
                                selectedIds.remove(DataManager().favoriteListModels[i].id);
                              } else {
                                selectedIds.add(DataManager().favoriteListModels[i].id);
                              }
                              onUpdateRequest?.call();
                            }
                          },
                          onLongPress: () {
                            debugPrint("_HomeScreenState: build ");
                            if (selectedIds.contains(DataManager().favoriteListModels[i].id)) {
                              selectedIds.remove(DataManager().favoriteListModels[i].id);
                            } else {
                              selectedIds.add(DataManager().favoriteListModels[i].id);
                            }
                            onUpdateRequest?.call();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: DataManager().favoriteListModels[i].color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedIds.contains(DataManager().favoriteListModels[i].id)
                                    ? Colors.blue.shade800
                                    : Colors.grey,
                                width: selectedIds.contains(DataManager().favoriteListModels[i].id) ? 3.0 : 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DataManager().favoriteListModels[i].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Wrap(
                                    children: [
                                      for (ListItem listItem in DataManager().favoriteListModels[i].items)
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
                                      for (String label in DataManager().favoriteListModels[i].labels)
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
            ),
          ],
        ),
      ),
    );
  }
}
