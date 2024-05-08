import 'package:flutter/material.dart';

import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:sanjay_notes/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> _notesAndListModels = [];

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
          Expanded(
            child: ListView.builder(
              itemCount: _notesAndListModels.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.editOrViewNoteScreen, arguments: _notesAndListModels[index], (route) => false),
                  onLongPress: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _notesAndListModels[index].color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _notesAndListModels[index].color == Colors.white ? Colors.grey : Colors.transparent,
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
                                  _notesAndListModels[index].title,
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
                                      Utils.getFormattedDateTime(_notesAndListModels[index].createdAt),
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
                            _notesAndListModels[index].note,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_notesAndListModels[index].scheduleTime != null)
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
                                    _notesAndListModels[index].scheduleTime!.year,
                                    _notesAndListModels[index].scheduleTime!.month,
                                    _notesAndListModels[index].scheduleTime!.day,
                                    _notesAndListModels[index].scheduleTime!.hour,
                                    _notesAndListModels[index].scheduleTime!.minute,
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
                                      for (int i = 0; i < _notesAndListModels[index].labels.length; i++)
                                        i < 3
                                            ? Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                                    child: Text(
                                                      '  ${_notesAndListModels[index].labels[i]}  ',
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
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3),
                                                        child: Text(
                                                          '  +${_notesAndListModels[index].labels.length - 3}  ',
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
            ),
          ),
        ],
      ),
    );
  }

  void _foundResult(String search) {
    List<dynamic> result = [];
    if (search.isEmpty) {
      result = DataManager().notes;
    } else {
      result =
          DataManager().notes.where((element) => element.title.toLowerCase().contains(search.toLowerCase())).toList();
    }
    setState(() {
      _notesAndListModels = result;
    });
  }
}
