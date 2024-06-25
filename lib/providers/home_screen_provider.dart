import 'package:flutter/cupertino.dart';
import 'package:sanjay_notes/Screens/my_drawer.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<String> selectedIds = [];
  HomeDrawerEnum _selectedDrawer = HomeDrawerEnum.notes;

  HomeDrawerEnum get selectedDrawer => _selectedDrawer;

  set selectedDrawer(HomeDrawerEnum drawerEnum) {
    _selectedDrawer = drawerEnum;
    notifyListeners();
  }

  notify() => notifyListeners();

  clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }
}
