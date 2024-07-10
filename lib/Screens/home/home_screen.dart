import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/Screens/deleted_screen.dart';
import 'package:sanjay_notes/Screens/my_drawer.dart';

import 'package:sanjay_notes/providers/home_screen_provider.dart';
import 'package:sanjay_notes/routes.dart';

import '../archive/archive_screen.dart';
import '../favorite/favorite_screen.dart';
import '../remainder/remainder_screen.dart';
import 'home_app_bar.dart';
import 'home_grid_view.dart';
import 'home_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenProvider homeScreenProvider = HomeScreenProvider();

  @override
  Widget build(BuildContext context) {
    context.watch<DataManager>();

    return ChangeNotifierProvider(
      create: (_) => homeScreenProvider,
      builder: (context, child) {
        context.watch<HomeScreenProvider>();
        return PopScope(
          canPop: homeScreenProvider.selectedDrawer == HomeDrawerEnum.notes,
          onPopInvoked: (value) => homeScreenProvider.selectedDrawer = HomeDrawerEnum.notes,
          child: body,
        );
      },
    );
  }

  Widget get body {
    switch (homeScreenProvider.selectedDrawer) {
      case HomeDrawerEnum.notes:
        return const NotesScreen();
      case HomeDrawerEnum.favourites:
        return const FavoriteScreen();
      case HomeDrawerEnum.remainder:
        return const RemainderScreen();
      case HomeDrawerEnum.archive:
        return const ArchiveScreen();
      case HomeDrawerEnum.deleted:
        return const DeletedScreen();
    }
  }
}

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<HomeScreenProvider>();
    context.watch<DataManager>();
    return Scaffold(
      drawer: const MyDrawer(selectedTab: HomeDrawerEnum.notes),
      body: Column(
        children: [
          if (context.read<HomeScreenProvider>().selectedIds.isEmpty)
            const DefaultHomeAppBar()
          else
            const SelectedHomeAppBar(),

          if (DataManager().notes.isEmpty &&
              DataManager().listModels.isEmpty &&
              DataManager().pinnedNotes.isEmpty &&
              DataManager().pinnedListModels.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Icon(
                    Icons.sticky_note_2_outlined,
                    color: Colors.yellow.shade800,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text('Notes you add appear here'),
                  const Expanded(child: SizedBox()),
                ],
              ),
            )
          else
            Expanded(
              child: DataManager().homeScreenView ? const HomeScreenListView() : const HomeScreenGridView(),
            ),

          Container(
            color: Colors.grey.shade200,
            height: 45,
            child: Row(
              children: [
                Tooltip(
                  message: 'List',
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(Routes.newListScreen),
                    borderRadius: BorderRadius.circular(40),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.check_box_outlined, color: Colors.grey.shade800),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.draw_outlined, color: Colors.grey.shade800),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.mic_none_rounded, color: Colors.grey.shade800),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.photo_outlined, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
          //Expanded(child: SizedBox()),
        ],
      ),
      floatingActionButton: Tooltip(
        message: 'Note',
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed(Routes.createNewNoteScreen),
          backgroundColor: Colors.grey.shade200,
          elevation: 20,
          child: const Icon(Icons.add, size: 40, color: CupertinoColors.activeBlue),
        ),
      ),
    );
  }
}
