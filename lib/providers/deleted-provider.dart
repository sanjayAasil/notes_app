import 'package:flutter/material.dart';

class DeletedProvider extends ChangeNotifier {
  List<String> selectedIds = [];

  clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }

  notify() => notifyListeners();
}
