import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/widget_helper.dart';
import 'note.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Note> _notes = [];
  List<ListModel> _listModels = [];
  List combinedData = [];
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: 60,
            alignment: AlignmentDirectional.centerStart,
            color: Colors.grey.shade300,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) => _foundResult(value),
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Search your notes',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // SizedBox(),
              ],
            ),
          ),
          if (combinedData.isEmpty)
            Expanded(
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Column(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 140,
                        color: Colors.yellow.shade800,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Search your notes'),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: combinedData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (combinedData[index] is Note) {
                    return NoteTileListView(
                      note: combinedData[index],
                      selectedIds: const [],
                    );
                  } else {
                    return ListModelTileListView(
                      selectedIds: const [],
                      listModel: combinedData[index],
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  void _foundResult(String search) {
    List<Note> noteResult = [];
    List<ListModel> listModelResult = [];
    if (search.isEmpty) {
      noteResult.clear();
      listModelResult.clear();
    } else {
      noteResult = [
        ...DataManager().notes.where((element) => element.title.toLowerCase().contains(search.toLowerCase())).toList(),
        ...DataManager().notes.where((element) => element.note.toLowerCase().contains(search.toLowerCase())).toList(),
        ...DataManager()
            .favoriteNotes
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .favoriteNotes
            .where((element) => element.note.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .archivedNotes
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .archivedNotes
            .where((element) => element.note.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .pinnedNotes
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .pinnedNotes
            .where((element) => element.note.toLowerCase().contains(search.toLowerCase()))
            .toList(),
      ];

      listModelResult = [
        ...DataManager()
            .listModels
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .pinnedListModels
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .archivedListModels
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        ...DataManager()
            .favoriteListModels
            .where((element) => element.title.toLowerCase().contains(search.toLowerCase()))
            .toList(),
      ];
    }
    setState(() {
      _notes = noteResult;
      _listModels = listModelResult;
      combinedData = [..._notes, ..._listModels];
    });
  }
}
