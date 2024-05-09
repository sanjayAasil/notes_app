import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/favorite/favorite_app_bar.dart';
import 'package:sanjay_notes/favorite/favorite_grid_view.dart';
import 'package:sanjay_notes/providers/favourite_provider.dart';
import 'package:sanjay_notes/my_drawer.dart';
import '../data_manager.dart';
import 'favorite_list_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavouriteProvider favouriteProvider = FavouriteProvider();

  _handlePinned() {
    favouriteProvider.isPinned = DataManager().favoriteNotes.any((element) => element.isPinned);
    favouriteProvider.others = DataManager().favoriteNotes.any((element) => !element.isPinned);

    if (!favouriteProvider.isPinned) {
      favouriteProvider.isPinned = DataManager().favoriteListModels.any((element) => element.isPinned);
    }
    if (!favouriteProvider.others) {
      favouriteProvider.others = DataManager().favoriteListModels.any((element) => !element.isPinned);
    }
  }

  @override
  Widget build(BuildContext context) {
    _handlePinned();
    return ChangeNotifierProvider(
        create: (_) => favouriteProvider,
        builder: (context, child) {
          context.watch<FavouriteProvider>();
          return PopScope(
            child: Scaffold(
              drawer: const MyDrawer(selectedTab: HomeDrawerEnum.favourites),
              body: Column(
                children: [
                  if (favouriteProvider.selectedIds.isEmpty)
                    const DefaultFavoriteAppBar()
                  else
                    const SelectedFavoriteAppBar(),
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
                    DataManager().favoriteScreenView ? const FavoriteListView() : const FavoriteGridView(),
                ],
              ),
            ),
          );
        });
  }
}
