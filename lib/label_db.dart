import 'dart:convert';

import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/notes_db.dart';

class LabelsDb {
  LabelsDb._();

  static const labelsKey = 'labelsKey';

  static List<String> getAllLabels() {
    String? data = prefs.getString(LabelsDb.labelsKey);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.map((e) => e.toString()).toList();
  }

  static addLabels(List<String> labels) {
    List<String> labelS = getAllLabels();

    labelS.addAll(labels);

    prefs.setString(LabelsDb.labelsKey, jsonEncode(labelS));

    DataManager().labels.addAll(labels);
  }

  static removeAllLabels() {
    List<String> labelS = getAllLabels();

    labelS.clear();

    prefs.setString(LabelsDb.labelsKey, jsonEncode(labelS));

    DataManager().labels.clear();
  }
}
