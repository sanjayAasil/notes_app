import 'dart:convert';

import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/notes_db.dart';

class LabelsDb {
  LabelsDb._();

  static const labelsKey = 'labelsKey';

  static List<String> getAllLabels(String key) {
    String? data = prefs.getString(key);

    if (data == null) return [];

    List decoded = jsonDecode(data);

    return decoded.map((e) => e.toString()).toList();
  }

  static addLabel(String key, String label) {
    List<String> labels = getAllLabels(key);

    labels.add(label);

    jsonEncode(labels);

    prefs.setString(key, jsonEncode(labels));

    DataManager().labels.add(label);
  }
}
