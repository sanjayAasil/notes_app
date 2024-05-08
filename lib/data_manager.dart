import 'dart:convert';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/settings_model.dart';
import 'note.dart';
import 'notes_db.dart';

class DataManager {
  final SettingsModel settingsModel;
  static final DataManager _instance = DataManager._();

  DataManager._() : settingsModel = SettingsModel.fromJson(jsonDecode(prefs.getString('settings') ?? '{}'));

  factory DataManager() => _instance;

  List<Note> notes = [];

  List<Note> favoriteNotes = [];

  List<Note> archivedNotes = [];

  List<Note> pinnedNotes = [];

  List<Note> deletedNotes = [];

  List<Note> remainderNotes = [];

  List<ListModel> listModels = [];

  List<ListModel> favoriteListModels = [];

  List<ListModel> archivedListModels = [];

  List<ListModel> pinnedListModels = [];

  List<ListModel> deletedListModels = [];

  List<ListModel> remainderListModels = [];

  List<String> labels = [];

  bool homeScreenView = true;

  bool archiveScreenView = true;

  bool favoriteScreenView = true;

  bool addToFavorite = false;

  bool addToPin = false;

  bool showTimeForNotes = true;

  bool olderNotesFirst = false;
}
