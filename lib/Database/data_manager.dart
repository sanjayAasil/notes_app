
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/models/list_model.dart';
import 'package:sanjay_notes/models/settings_model.dart';
import '../models/note.dart';


class DataManager extends ChangeNotifier {
  SettingsModel _settingsModel;

  SettingsModel get settingsModel => _settingsModel;

  set settingsModel(SettingsModel settingsModel) {
    _settingsModel = settingsModel;
    notifyListeners();
  }

  static final DataManager _instance = DataManager._();

  DataManager._() : _settingsModel = SettingsModel.fromJson({});

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

  User? user = FirebaseAuth.instance.currentUser;

//User(displayName: Sanjay,
// email: sanjuaasil@gmail.com,
// isEmailVerified: true,
// isAnonymous: false,
// metadata: UserMetadata(creationTime: 2024-07-02 05:49:08.528Z,
// lastSignInTime: 2024-07-03 08:31:02.122Z),
// phoneNumber: null,
// photoURL: https://lh3.googleusercontent.com/a/ACg8ocKGL3vpc2-12PpLUNFfUS33Wco0Y2Qrky7Bxoj7El4fKsfg8Estrw=s96-c,
// providerData, [UserInfo(displayName: Sanjay, email: sanjuaasil@gmail.com,
// phoneNumber: null,
// photoURL: https://lh3.googleusercontent.com/a/ACg8ocKGL3vpc2-12PpLUNFfUS33Wco0Y2Qrky7Bxoj7El4fKsfg8Estrw=s96-c,
// providerId: google.com, uid: 106789429631148152084)], refreshToken: null, tenantId: null, uid: la3bccwjXATtXQEefPb8SdBcrIa2)
// and User(displayName: Sanjay, email: sanjuaasil@gmail.com, isEmailVerified: true, isAnonymous: false,
// metadata: UserMetadata(creationTime: 2024-07-02 05:49:08.528Z, lastSignInTime: 2024-07-03 08:31:02.122Z),
// phoneNumber: null, photoURL: https://lh3.googleusercontent.com/a/ACg8ocKGL3vpc2-12PpLUNFfUS33Wco0Y2Qrky7Bxo
}
