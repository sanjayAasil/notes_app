import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import '../list_model.dart';
import '../my_drawer.dart';
import '../note.dart';
import '../utils.dart';

class RemainderScreen extends StatefulWidget {
  const RemainderScreen({Key? key}) : super(key: key);

  @override
  State<RemainderScreen> createState() => _RemainderState();
}

class _RemainderState extends State<RemainderScreen> {
  @override
  Widget build(BuildContext context) {
    List<Note> notes = DataManager().remainderNotes.where((element) => true).toList();
    for (Note note in notes) {
      if (note.scheduleTime != null && DateTime.now().isAfter(note.scheduleTime!)) {
        NotesDb.removeNote(NotesDb.remainderNotesKey, note.id);
      }
    }
    List<ListModel> listModels = DataManager().remainderListModels.where((element) => true).toList();
    for (ListModel listModel in listModels) {
      if (listModel.scheduleTime != null && DateTime.now().isAfter(listModel.scheduleTime!)) {
        ListModelsDb.removeListModel(ListModelsDb.remainderListModelKey, listModel.id);
      }
    }
    return PopScope(
      child: Scaffold(
        drawer: const MyDrawer(
          selectedTab: 'remainder',
        ),
        body: Column(
          children: [
            Padding(
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
                      'Remainder',
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
                ],
              ),
            ),
            if (DataManager().remainderNotes.isEmpty && DataManager().remainderListModels.isEmpty)
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        Icon(
                          Icons.alarm,
                          size: 140,
                          color: Colors.yellow.shade800,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Your Remainder notes appear here'),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (Note note in DataManager().remainderNotes)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onLongPress: () {},
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: note.color,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: note.color == Colors.white ? Colors.grey : Colors.transparent,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                note.title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataManager().settingsModel.showTimeChecked
                                              ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    Utils.getFormattedDateTime(note.createdAt),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey.shade800,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0, left: 5),
                                        child: Text(
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                          note.note,
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (note.scheduleTime != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.alarm,
                                                  size: 20,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ),
                                              Text(
                                                Utils.getFormattedDateTime(DateTime(
                                                  note.scheduleTime!.year,
                                                  note.scheduleTime!.month,
                                                  note.scheduleTime!.day,
                                                  note.scheduleTime!.hour,
                                                  note.scheduleTime!.minute,
                                                )),
                                                style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      DataManager().settingsModel.showLabelsOnHomeScreen
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Align(
                                                alignment: AlignmentDirectional.centerStart,
                                                child: Wrap(
                                                  children: [
                                                    for (int i = 0; i < note.labels.length; i++)
                                                      i < 3
                                                          ? Padding(
                                                              padding: const EdgeInsets.all(5.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey.shade300,
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 4.0, vertical: 3),
                                                                  child: Text(
                                                                    '  ${note.labels[i]}  ',
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: const TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.w300,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : i == 4
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey.shade300,
                                                                      borderRadius: BorderRadius.circular(5),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                          horizontal: 4.0, vertical: 3),
                                                                      child: Text(
                                                                        '  +${note.labels.length - 3}  ',
                                                                        style: const TextStyle(
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w300,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox()
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          for (ListModel listModel in DataManager().remainderListModels)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {},
                                onLongPress: () {},
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: listModel.color,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: listModel.color == Colors.white ? Colors.grey : Colors.transparent,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text(
                                                listModel.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataManager().settingsModel.showTimeChecked
                                              ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    Utils.getFormattedDateTime(listModel.createdAt),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey.shade800,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0, left: 5, bottom: 10),
                                        child: Column(
                                          children: [
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
                                                        : Icon(Icons.check_box_outline_blank,
                                                            size: 20, color: Colors.grey.shade500),
                                                    Text(
                                                      item.name,
                                                      style: TextStyle(color: Colors.grey.shade600),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (listModel.scheduleTime != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.alarm,
                                                  size: 20,
                                                  color: Colors.blue.shade700,
                                                ),
                                              ),
                                              Text(
                                                Utils.getFormattedDateTime(
                                                  DateTime(
                                                    listModel.scheduleTime!.year,
                                                    listModel.scheduleTime!.month,
                                                    listModel.scheduleTime!.day,
                                                    listModel.scheduleTime!.hour,
                                                    listModel.scheduleTime!.minute,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      DataManager().settingsModel.showLabelsOnHomeScreen
                                          ? Align(
                                              alignment: AlignmentDirectional.centerStart,
                                              child: Wrap(
                                                children: [
                                                  for (int i = 0; i < listModel.labels.length; i++)
                                                    i < 3
                                                        ? Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Colors.grey.shade300,
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 4.0, vertical: 3),
                                                                child: Text(
                                                                  '  ${listModel.labels[i]}  ',
                                                                  style: const TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w300,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : i == 4
                                                            ? Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.grey.shade300,
                                                                    borderRadius: BorderRadius.circular(5),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal: 4.0, vertical: 3),
                                                                    child: Text(
                                                                      '  +${listModel.labels.length - 3}  ',
                                                                      style: const TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w300,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
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
              ),
          ],
        ),
      ),
    );
  }
}
