import 'package:flutter/material.dart';
import 'package:sanjay_notes/favorite/favorite_app_bar.dart';
import 'package:sanjay_notes/favorite/favorite_grid_view.dart';
import 'package:sanjay_notes/my_drawer.dart';
import 'package:sanjay_notes/routes.dart';
import '../data_manager.dart';
import 'favorite_list_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> selectedIds = [];
  bool isPinned = false;
  bool others = false;

  _handlePinned() {
    isPinned = DataManager().favoriteNotes.any((element) => element.isPinned);
    others = DataManager().favoriteNotes.any((element) => !element.isPinned);

    if (!isPinned) {
      isPinned = DataManager().favoriteListModels.any((element) => element.isPinned);
    }
    if (!others) {
      others = DataManager().favoriteListModels.any((element) => !element.isPinned);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handlePinned();
    return PopScope(
      canPop: false,
      onPopInvoked: (value) => Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false),
      child: Scaffold(
        drawer: const MyDrawer(
          selectedTab: 'favoriteScreen',
        ),
        body: Column(
          children: [
            if (selectedIds.isEmpty)
              DefaultFavoriteAppBar(onViewChanged: () {
                setState(() {});
              })
            else
              SelectedFavoriteAppBar(
                selectedIds: selectedIds,
                onSelectedIdsCleared: () {
                  debugPrint("_FavoriteScreenState build: call check");
                  setState(() {});
                },
              ),
            if (DataManager().favoriteNotes.isEmpty && DataManager().favoriteListModels.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 140,
                      color: Colors.yellow.shade800,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Your favorite notes appear here'),
                    ),
                  ],
                ),
              )
            else
              DataManager().favoriteScreenView
                  ? FavoriteListView(
                      selectedIds: selectedIds,
                      isPinned: isPinned,
                      others: others,
                      onUpdateRequest: () => setState(() {}))
                  : FavoriteGridView(
                      selectedIds: selectedIds,
                      isPinned: isPinned,
                      others: others,
                      onUpdateRequest: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}
