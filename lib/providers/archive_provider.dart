import 'package:flutter/material.dart';

class ArchiveProvider extends ChangeNotifier {
  List<String> selectedIds = [];
  bool isPinned = false;
  bool others = false;

  clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }

  notify() => notifyListeners();
}
