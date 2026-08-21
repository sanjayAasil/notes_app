import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/responsive.dart';
import '../../common/widget_helper.dart';
import '../../database/data_manager.dart';
import '../../providers/home_screen_provider.dart';

class HomeScreenGridView extends StatefulWidget {
  const HomeScreenGridView({super.key});

  @override
  State<HomeScreenGridView> createState() => _HomeScreenGridViewState();
}

class _HomeScreenGridViewState extends State<HomeScreenGridView> {
  late HomeScreenProvider homeScreenProvider;

  @override
  void initState() {
    homeScreenProvider = context.read<HomeScreenProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HomeScreenProvider>();
    context.watch<DataManager>();

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (Responsive.isDesktop(context)) {
          crossAxisCount = 4;
        } else if (Responsive.isTablet(context)) {
          crossAxisCount = 3;
        }
        
        double spacing = 10;
        double itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount + 1))) / crossAxisCount;

        return SingleChildScrollView(
          padding: EdgeInsets.all(spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text('Pinned', style: TextStyle(color: Colors.grey.shade700)),
                ),

              Align(
                alignment: AlignmentDirectional.topStart,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (int i = 0; i < DataManager().pinnedNotes.length; i++)
                      NoteTileGridView(
                        selectedIds: homeScreenProvider.selectedIds,
                        note: DataManager().pinnedNotes[i],
                        onUpdateRequest: () => homeScreenProvider.notify(),
                        width: itemWidth,
                      ),
                    for (int i = 0; i < DataManager().pinnedListModels.length; i++)
                      ListModelTileGridView(
                        selectedIds: homeScreenProvider.selectedIds,
                        listModel: DataManager().pinnedListModels[i],
                        onUpdateRequest: () => homeScreenProvider.notify(),
                        width: itemWidth,
                      ),
                  ],
                ),
              ),

              ///GridView notes
              if ((DataManager().pinnedNotes.isNotEmpty || DataManager().pinnedListModels.isNotEmpty) &&
                  (DataManager().notes.isNotEmpty || DataManager().listModels.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text('Others', style: TextStyle(color: Colors.grey.shade700)),
                ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (int i = 0; i < DataManager().notes.length; i++)
                      NoteTileGridView(
                        selectedIds: homeScreenProvider.selectedIds,
                        onUpdateRequest: () => homeScreenProvider.notify(),
                        note: DataManager().notes[i],
                        width: itemWidth,
                      ),
                    for (int i = 0; i < DataManager().listModels.length; i++)
                      ListModelTileGridView(
                        selectedIds: homeScreenProvider.selectedIds,
                        listModel: DataManager().listModels[i],
                        onUpdateRequest: () => homeScreenProvider.notify(),
                        width: itemWidth,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
