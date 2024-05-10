import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/settings_model.dart';
import 'note.dart';
import 'notes_db.dart';

class DataManager extends ChangeNotifier {
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

  bool _homeScreenView = true;

  bool get homeScreenView => _homeScreenView;

  set homeScreenView(bool value) {
    _homeScreenView = value;
    notifyListeners();
  }

  bool _archiveScreenView = true;

  bool get archiveScreenView => _archiveScreenView;

  set archiveScreenView(bool value) {
    _archiveScreenView = value;
    notifyListeners();
  }

  bool _favoriteScreenView = true;

  bool get favoriteScreenView => _favoriteScreenView;

  set favoriteScreenView(bool value) {
    _favoriteScreenView = value;
    notifyListeners();
  }



  bool showTimeForNotes = true;

  bool olderNotesFirst = false;
}
