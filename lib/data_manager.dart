import 'package:sanjay_notes/list_model.dart';

import 'note.dart';

class DataManager {
  static final DataManager _instance = DataManager._();

  DataManager._();

  factory DataManager() => _instance;

  List<Note> notes = [];

  List<Note> archivedNotes = [];

  List<Note> pinnedNotes = [];

  List<Note> deletedNotes = [];

  List<ListModel> listModels = [];

  List<ListModel> archivedListModels = [];

  List<ListModel> pinnedListModels = [];

  List<ListModel> deletedListModel = [];

  List<String> labels = [];

  bool homeScreenView = true;

  bool archiveScreenView = true;
}
