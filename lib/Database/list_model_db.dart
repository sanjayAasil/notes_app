import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/firestore/firestore_service.dart';
import 'package:sanjay_notes/models/list_model.dart';

class ListModelsDb {
  ListModelsDb._();

  static const listModelKey = 'listModelKey';
  static const archivedListModelKey = 'archivedListModelKey';
  static const favoriteListModelKey = 'favoriteListModelKey';
  static const pinnedListModelKey = 'pinnedListModelKey';
  static const deletedListModelKey = 'deletedListModelKey';
  static const remainderListModelKey = 'remainderListModelKey';

  static addListModel(String key, ListModel listModel) {
    FirestoreService().addListModel(listModel.json);

    if (key == listModelKey) {
      DataManager().listModels.add(listModel);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.add(listModel);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.add(listModel);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModels.add(listModel);
    } else if (key == remainderListModelKey) {
      DataManager().remainderListModels.add(listModel);
    } else {
      DataManager().pinnedListModels.add(listModel);
    }
  }

  static addListModels(String key, List<ListModel> listModels) {
    for (ListModel listModel in listModels) {
      FirestoreService().addListModel(listModel.json);
    }
    if (key == listModelKey) {
      DataManager().listModels.addAll(listModels);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.addAll(listModels);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.addAll(listModels);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModels.addAll(listModels);
    } else if (key == remainderListModelKey) {
      DataManager().remainderListModels.addAll(listModels);
    } else {
      DataManager().pinnedListModels.addAll(listModels);
    }
  }

  static removeListModel(String key, String listModelId, {bool permanentDelete = false}) {
    if (permanentDelete) {
      FirestoreService().deleteListModel(listModelId);
    }
    if (key == listModelKey) {
      DataManager().listModels.removeWhere((element) => element.id == listModelId);
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.removeWhere((element) => element.id == listModelId);
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.removeWhere((element) => element.id == listModelId);
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModels.removeWhere((element) => element.id == listModelId);
    } else if (key == remainderListModelKey) {
      DataManager().remainderListModels.removeWhere((element) => element.id == listModelId);
    } else {
      DataManager().pinnedListModels.removeWhere((element) => element.id == listModelId);
    }
  }

  static removeListModels(String key, List<String> listModelIds, {bool permanentDelete = false}) {
    if (permanentDelete) {
      for (String id in listModelIds) {
        FirestoreService().deleteListModel(id);
      }
    }
    if (key == listModelKey) {
      DataManager().listModels.removeWhere((element) => listModelIds.contains(element.id));
    } else if (key == archivedListModelKey) {
      DataManager().archivedListModels.removeWhere((element) => listModelIds.contains(element.id));
    } else if (key == favoriteListModelKey) {
      DataManager().favoriteListModels.removeWhere((element) => listModelIds.contains(element.id));
    } else if (key == deletedListModelKey) {
      DataManager().deletedListModels.removeWhere((element) => listModelIds.contains(element.id));
    } else if (key == remainderListModelKey) {
      DataManager().remainderListModels.removeWhere((element) => listModelIds.contains(element.id));
    } else {
      DataManager().pinnedListModels.removeWhere((element) => listModelIds.contains(element.id));
    }
  }
}
