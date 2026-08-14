import 'package:flutter/cupertino.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> selectedIds = [];
  bool isPinned = false;
  bool others = false;

  clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }

  notify() => notifyListeners();
}
