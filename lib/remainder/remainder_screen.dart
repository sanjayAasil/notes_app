import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/widget_helper.dart';
import '../list_model.dart';
import '../my_drawer.dart';
import '../note.dart';
import '../routes.dart';
import '../utils.dart';

class RemainderScreen extends StatefulWidget {
  const RemainderScreen({Key? key}) : super(key: key);

  @override
  State<RemainderScreen> createState() => _RemainderState();
}

class _RemainderState extends State<RemainderScreen> {
  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();
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
    return Scaffold(
      drawer: const MyDrawer(selectedTab: HomeDrawerEnum.remainder),
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
                  onTap: () => Navigator.of(context).pushNamed(Routes.searchScreen),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: Icon(
                      Icons.search,
                      size: 25,
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

                          NoteTileListView(note: note, selectedIds: const []),

                        for (ListModel listModel in DataManager().remainderListModels)

                          ListModelTileListView(selectedIds: const [], listModel: listModel),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
