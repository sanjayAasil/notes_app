import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/models/list_model.dart';
import 'package:sanjay_notes/models/settings_model.dart';
import '../models/note.dart';
import 'notes_db.dart';

class DataManager extends ChangeNotifier {
  SettingsModel _settingsModel;

  SettingsModel get settingsModel => _settingsModel;

  set settingsModel(SettingsModel settingsModel) {
    _settingsModel = settingsModel;
    notifyListeners();
  }

  static final DataManager _instance = DataManager._();

  DataManager._() : _settingsModel = SettingsModel.fromJson(jsonDecode(prefs.getString('settings') ?? '{}'));

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

  void notify() => notifyListeners();

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
}
