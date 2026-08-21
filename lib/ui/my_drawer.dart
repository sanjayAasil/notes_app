import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versatile_dialogs/loading_dialog.dart';
import '../common/utils.dart';
import '../database/data_manager.dart';
import '../firebase/firebase_auth_manager.dart';
import '../providers/home_screen_provider.dart';
import '../routes.dart';

enum HomeDrawerEnum { notes, favourites, remainder, archive, deleted }

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.selectedTab, this.isPermanent = false});

  final HomeDrawerEnum selectedTab;
  final bool isPermanent;

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.read<HomeScreenProvider>();
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: isPermanent ? 40 : MediaQuery.of(context).padding.top + 20,
                    left: 25,
                    bottom: 25),
                child: GradientText(
                  'Keep Notes',
                  gradient: LinearGradient(
                    colors: [Colors.yellow.shade900, Colors.yellow.shade600, Colors.yellow.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              homeScreenProvider.selectedDrawer = HomeDrawerEnum.notes;
              if (!isPermanent) Navigator.of(context).pop();
            },
            child: DrawerTile(
              name: 'Notes',
              icon: Icons.lightbulb_outline_rounded,
              isSelected: selectedTab == HomeDrawerEnum.notes,
            ),
          ),
          InkWell(
            onTap: () {
              homeScreenProvider.selectedDrawer = HomeDrawerEnum.favourites;
              if (!isPermanent) Navigator.of(context).pop();
            },
            child: DrawerTile(
              name: 'Favorites',
              icon: Icons.favorite_border,
              isSelected: selectedTab == HomeDrawerEnum.favourites,
            ),
          ),
          InkWell(
            onTap: () {
              homeScreenProvider.selectedDrawer = HomeDrawerEnum.remainder;
              if (!isPermanent) Navigator.of(context).pop();
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
                    const Expanded(child: Padding(padding: EdgeInsets.all(10.0), child: Text('     Labels'))),
                    InkWell(
                      onTap: () {
                        if (!isPermanent) Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(Routes.createNewLabelScreen);
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
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            child: Icon(Icons.label_outline_rounded),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(DataManager().labels[i], maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    InkWell(
                      onTap: () {
                        if (!isPermanent) Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(Routes.createNewLabelScreen);
                      },
                      child: const DrawerTile(name: 'Create new label', icon: Icons.add),
                    ),
                  ],
                ),
                const Divider(),
              ],
            )
          else
            InkWell(
              onTap: () {
                if (!isPermanent) Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Routes.createNewLabelScreen);
              },
              child: const DrawerTile(name: 'Create new label', icon: Icons.add),
            ),
          InkWell(
            onTap: () {
              homeScreenProvider.selectedDrawer = HomeDrawerEnum.archive;
              if (!isPermanent) Navigator.of(context).pop();
            },
            child: DrawerTile(
              name: 'Archive',
              icon: Icons.archive_outlined,
              isSelected: selectedTab == HomeDrawerEnum.archive,
            ),
          ),
          InkWell(
            onTap: () {
              homeScreenProvider.selectedDrawer = HomeDrawerEnum.deleted;
              if (!isPermanent) Navigator.of(context).pop();
            },
            child: DrawerTile(
              name: 'Deleted',
              icon: CupertinoIcons.delete,
              isSelected: selectedTab == HomeDrawerEnum.deleted,
            ),
          ),
          InkWell(
            onTap: () {
              if (!isPermanent) Navigator.of(context).pop();
              Navigator.of(context).pushNamed(Routes.settingsScreen);
            },
            child: const DrawerTile(name: 'Settings', icon: Icons.settings),
          ),
          InkWell(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder:
                    (context) => AlertDialog(
                      content: const Text('Are you sure want to Logout?'),
                      title: const Text("Log Out"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async {
                            LoadingDialog loadingDialog = LoadingDialog()..show(context);
                            await FirebaseAuthManager().signOut();
                            DataManager().user = null;
                            Utils.clearDataManagerData();
                            if (context.mounted) {
                              loadingDialog.dismiss(context);
                              Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
                            }
                          },
                          child: const Text('Yes', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
              );
            },
            child: const DrawerTile(name: 'Log Out', icon: Icons.logout),
          ),
          const Spacer(),
          const Align(alignment: Alignment.center, child: Text("Made with ❤️ by Sanjaykumar Aasil")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;

  const DrawerTile({super.key, required this.name, required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: isSelected ? Colors.yellow.shade100 : null,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Icon(icon, size: 25, color: isSelected ? Colors.yellow.shade700 : Colors.grey.shade800),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
                color: isSelected ? Colors.yellow.shade700 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.gradient, this.style});

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white)),
    );
  }
}
