import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.selectedTab});

  final String selectedTab;

  @override
  Widget build(BuildContext context) {
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
              onTap: selectedTab != 'homeScreen'
                  ? () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false)
                  : null,
              child: DrawerTile(
                name: 'Notes',
                icon: Icons.lightbulb_outline_rounded,
                isSelected: selectedTab == 'homeScreen',
              ),
            ),
            InkWell(
              onTap: selectedTab != 'favoriteScreen'
                  ? () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false)
                  : null,
              child: DrawerTile(
                name: 'Favorites',
                icon: Icons.favorite_border,
                isSelected: selectedTab == 'favoriteScreen',
              ),
            ),
            InkWell(
              onTap: () {},
              child: const DrawerTile(
                name: 'Remainder',
                icon: Icons.timer_outlined,
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
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(Routes.createNewLabelScreen, (route) => false);
                        },
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
                        InkWell(
                          onTap: () {},
                          child: Row(
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
                              InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                    child: Icon(CupertinoIcons.pen),
                                  )),
                            ],
                          ),
                        ),
                      InkWell(
                        onTap: selectedTab != 'createNewLabelScreen'
                            ? () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(Routes.createNewLabelScreen, (route) => false)
                            : null,
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
                onTap: selectedTab != 'createNewLabelScreen'
                    ? () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.createNewLabelScreen, (route) => false)
                    : null,
                child: const DrawerTile(
                  name: 'Create new label',
                  icon: Icons.add,
                ),
              ),
            InkWell(
              onTap: selectedTab != 'archiveScreen'
                  ? () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false)
                  : null,
              child: DrawerTile(
                name: 'Archive',
                icon: Icons.archive_outlined,
                isSelected: selectedTab == 'archiveScreen',
              ),
            ),
            InkWell(
              onTap: selectedTab != 'deletedScreen'
                  ? () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false)
                  : null,
              child: DrawerTile(
                name: 'Deleted',
                icon: CupertinoIcons.delete,
                isSelected: selectedTab == 'deletedScreen',
              ),
            ),
            const DrawerTile(
              name: 'Settings',
              icon: Icons.settings,
            ),
            const DrawerTile(
              name: 'Help & feedback',
              icon: Icons.help_outline_rounded,
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
