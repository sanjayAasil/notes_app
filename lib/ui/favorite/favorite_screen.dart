import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/responsive.dart';
import '../../database/data_manager.dart';
import '../../providers/favourite_provider.dart';
import '../my_drawer.dart';
import 'favorite_app_bar.dart';
import 'favorite_grid_view.dart';
import 'favorite_list_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavouriteProvider favouriteProvider = FavouriteProvider();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    
    return ChangeNotifierProvider(
      create: (_) => favouriteProvider,
      builder: (context, child) {
        context.watch<FavouriteProvider>();

        return Scaffold(
          drawer: isDesktop ? null : const MyDrawer(selectedTab: HomeDrawerEnum.favourites),
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
                Expanded(
                  child: DataManager().favoriteScreenView ? const FavoriteListView() : const FavoriteGridView(),
                ),
            ],
          ),
        );
      },
    );
  }
}
