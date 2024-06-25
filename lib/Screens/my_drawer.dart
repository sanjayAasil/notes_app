import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/providers/home_screen_provider.dart';
import 'package:sanjay_notes/routes.dart';

enum HomeDrawerEnum {
  notes,
  favourites,
  remainder,
  archive,
  deleted,
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.selectedTab});

  final HomeDrawerEnum selectedTab;

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.read<HomeScreenProvider>();
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 25,
                    bottom: 25,
                  ),
                  child: const Text(
                    'Keep',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 25,
                  ),
                  child: const Text(
                    ' Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                homeScreenProvider.selectedDrawer = HomeDrawerEnum.notes;
                Navigator.of(context).pop();
              },
              child: DrawerTile(
                  name: 'Notes',
                  icon: Icons.lightbulb_outline_rounded,
                  isSelected: selectedTab == HomeDrawerEnum.notes),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                homeScreenProvider.selectedDrawer = HomeDrawerEnum.favourites;
              },
              child: DrawerTile(
                  name: 'Favorites', icon: Icons.favorite_border, isSelected: selectedTab == HomeDrawerEnum.favourites),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                homeScreenProvider.selectedDrawer = HomeDrawerEnum.remainder;
              },
              child: DrawerTile(
                name: 'Remainder',
                icon: Icons.timer_outlined,
                isSelected: selectedTab == HomeDrawerEnum.remainder,
              ),
            ),
            if (DataManager().labels.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('     Labels'),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).popAndPushNamed(Routes.createNewLabelScreen),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          child: Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = DataManager().labels.length - 1; i >= 0; i--)
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              child: Icon(Icons.label_outline_rounded),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  DataManager().labels[i],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      InkWell(
                        onTap: () => Navigator.of(context).popAndPushNamed(Routes.createNewLabelScreen),
                        child: const DrawerTile(
                          name: 'Create new label',
                          icon: Icons.add,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              )
            else
              InkWell(
                onTap: () => Navigator.of(context).popAndPushNamed(Routes.createNewLabelScreen),
                child: const DrawerTile(
                  name: 'Create new label',
                  icon: Icons.add,
                ),
              ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                homeScreenProvider.selectedDrawer = HomeDrawerEnum.archive;
              },
              child: DrawerTile(
                  name: 'Archive', icon: Icons.archive_outlined, isSelected: selectedTab == HomeDrawerEnum.archive),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                homeScreenProvider.selectedDrawer = HomeDrawerEnum.deleted;
              },
              child: DrawerTile(
                  name: 'Deleted', icon: CupertinoIcons.delete, isSelected: selectedTab == HomeDrawerEnum.deleted),
            ),
            InkWell(
              onTap: () => Navigator.of(context).popAndPushNamed(Routes.settingsScreen),
              child: const DrawerTile(name: 'Settings', icon: Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;

  const DrawerTile({
    super.key,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: isSelected ? Colors.blue.shade100 : null,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              icon,
              size: 25,
              color: isSelected ? CupertinoColors.activeBlue : Colors.grey.shade800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 15, color: isSelected ? CupertinoColors.activeBlue : null),
            ),
          ),
        ],
      ),
    );
  }
}
