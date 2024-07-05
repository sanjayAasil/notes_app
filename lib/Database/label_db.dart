import 'package:sanjay_notes/Database/data_manager.dart';

import 'package:sanjay_notes/firestore/firestore_service.dart';

class LabelsDb {
  LabelsDb._();

  static const labelsKey = 'labelsKey';

  static addLabels(List<String> labels) {
    FirestoreService().addLabels(labels);
    DataManager().labels.addAll(labels);
  }

  static removeAllLabels() {
    FirestoreService().deleteLabels();
    DataManager().labels.clear();
  }
}
