import 'dart:convert';

import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/notes_db.dart';

class ListModelsDb {
  ListModelsDb._();

  static const listModelKey = 'listModelKey';
  static const archivedListModelKey = 'archivedListModelKey';
  static const favoriteListModelKey = 'favoriteListModelKey';
  static const pinnedListModelKey = 'pinnedListModelKey';
  static const deletedListModelKey = 'deletedListModelKey';

  static List<ListModel> getAllListModels(String key) {
    String? data = prefs.getString(key);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.map((e) => ListModel.fromJson(e)).toList();
  }

  static addListModel(String key, ListModel listModel) {
    List<ListModel> listModels = getAllListModels(key);

    listModels.add(listModel);

    List<Map<String, dynamic>> jsonList = listModels.map((e) => e.json).toList();

    String encoded = jsonEncode(jsonList);

    prefs.setString(key, encoded);

    if (key == listModelKey) {
      DataManager().listModels.add(listModel);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.add(listModel);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.add(listModel);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModel.add(listModel);
    } else {
      DataManager().pinnedListModels.add(listModel);
    }
  }

  static addListModels(String key, List<ListModel> listModels) {
    List<ListModel> listModelS = getAllListModels(key);

    listModelS.addAll(listModels);

    List<Map<String, dynamic>> jsonList = listModelS.map((e) => e.json).toList();

    String encoded = jsonEncode(jsonList);

    prefs.setString(key, encoded);

    if (key == listModelKey) {
      DataManager().listModels.addAll(listModels);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.addAll(listModels);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.addAll(listModels);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModel.addAll(listModels);
    } else {
      DataManager().pinnedListModels.addAll(listModels);
    }
  }

  static removeListModel(String key, String listModelId) {
    List<ListModel> listModels = getAllListModels(key);

    listModels.removeWhere((element) => element.id == listModelId);

    List<Map<String, dynamic>> jsonList = listModels.map((e) => e.json).toList();

    prefs.setString(key, jsonEncode(jsonList));

    if (key == listModelKey) {
      DataManager().listModels.removeWhere((element) => element.id == listModelId);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.removeWhere((element) => element.id == listModelId);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.removeWhere((element) => element.id == listModelId);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModel.removeWhere((element) => element.id == listModelId);
    } else {
      DataManager().pinnedListModels.removeWhere((element) => element.id == listModelId);
    }
  }

  static removeListModels(String key, List<String> listModelIds) {
    List<ListModel> listModels = getAllListModels(key);

    listModels.removeWhere((element) => listModelIds.contains(element.id));

    List<Map<String, dynamic>> jsonList = listModels.map((e) => e.json).toList();

    prefs.setString(key, jsonEncode(jsonList));

    if (key == listModelKey) {
      DataManager().listModels.removeWhere((element) => listModels.contains(element.id));
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.removeWhere((element) => listModels.contains(element.id));
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.removeWhere((element) => listModels.contains(element.id));
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModel.removeWhere((element) => listModels.contains(element.id));
    } else {
      DataManager().pinnedListModels.removeWhere((element) => listModels.contains(element.id));
    }
  }
}
