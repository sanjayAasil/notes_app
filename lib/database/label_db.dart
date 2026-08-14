import 'package:flutter/cupertino.dart';

import '../firestore/firestore_service.dart';
import 'data_manager.dart';

class LabelsDb {
  LabelsDb._();

  static const labelsKey = 'labelsKey';

  static addLabels(List<String> labels) {
    try {
      FirestoreService().addLabels(labels);
      DataManager().labels.addAll(labels);
    } catch (e) {
      debugPrint("LabelsDb addLabels error: $e");
    }
  }

  static removeAllLabels() {
    try {
      FirestoreService().deleteLabels();
      DataManager().labels.clear();
    } catch (e) {
      debugPrint("LabelsDb removeAllLabels error: $e");
    }
  }
}
