import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:sanjay_notes/utils.dart';

class ViewOrEditListModel extends StatefulWidget {
  final ListModel listModel;

  const ViewOrEditListModel({super.key, required this.listModel});

  @override
  State<ViewOrEditListModel> createState() => _ViewOrEditListModelState();
}

class _ViewOrEditListModelState extends State<ViewOrEditListModel> {
  Color mainColor = Colors.white;
  List<ListItem> items = [];
  TextEditingController titleController = TextEditingController();
  List<TextEditingController> itemNameControllers = [];
  List<bool> itemTicked = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.listModel.title;
    mainColor = widget.listModel.color;

    for (ListItem listItem in widget.listModel.items) {
      itemNameControllers.add(TextEditingController(text: listItem.name));
      itemTicked.add(listItem.ticked);
    }
    DataManager().addToFavorite = widget.listModel.isFavorite ? true : false;
    DataManager().addToPin = widget.listModel.isPinned ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.listModel.isDeleted,
      onPopInvoked: (bool value) {
        if (!widget.listModel.isDeleted) {
          onBackPressed();
        }
      },
      child: Scaffold(
        body: Container(
          color: mainColor,
          child: widget.listModel.isDeleted
              ? ListModelForDeletedScreen(listModel: widget.listModel)
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      height: 60,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: onBackPressed,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          if (!widget.listModel.isArchive)
                            StatefulBuilder(
                              builder: (context, setState) {
                                return InkWell(
                                  onTap: () {
                                    DataManager().addToFavorite = !DataManager().addToFavorite;
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DataManager().addToFavorite
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red.shade800,
                                          )
                                        : Icon(Icons.favorite_border),
                                  ),
                                );
                              },
                            ),
                          StatefulBuilder(builder: (context, setState) {
                            return InkWell(
                              onTap: () {
                                DataManager().addToPin = !DataManager().addToPin;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DataManager().addToPin
                                    ? Icon(
                                        CupertinoIcons.pin_fill,
                                        color: Colors.grey.shade800,
                                      )
                                    : Icon(
                                        CupertinoIcons.pin,
                                        color: Colors.grey.shade800,
                                      ),
                              ),
                            );
                          }),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              CupertinoIcons.bell,
                              color: Colors.grey.shade800,
                            ),
                          ),

                          InkWell(
                            onTap: onArchived,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.listModel.isArchive
                                  ? Icon(
                                      Icons.unarchive_outlined,
                                      color: Colors.grey.shade800,
                                    )
                                  : Icon(
                                      Icons.archive_outlined,
                                      color: Colors.grey.shade800,
                                    ),
                            ),
                          ),
                          // SizedBox(),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              controller: titleController,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        itemNameControllers.add(TextEditingController());
                        itemTicked.add(false);
                        setState(() {});
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 65.0),
                              child: Icon(
                                CupertinoIcons.plus,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                'List item',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0; i < itemNameControllers.length; i++)
                              SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                                      child: Icon(
                                        Icons.drag_indicator_sharp,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                                        child: itemTicked[i]
                                            ? Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.grey.shade800,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: Colors.grey.shade800,
                                              ),
                                      ),
                                      onTap: () {
                                        itemTicked[i] = !itemTicked[i];
                                        setState(() {});
                                      },
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: itemNameControllers[i],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(
                                          CupertinoIcons.xmark,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      onTap: () {
                                        itemNameControllers.removeAt(i);
                                        itemTicked.removeAt(i);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Wrap(
                                  children: [
                                    for (String label in widget.listModel.labels)
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text('  $label  '),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add_box_outlined,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _pickAColor,
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.color_lens_outlined,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                Utils.getFormattedDateTime(widget.listModel.createdAt),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'deleted',
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) => popUpDelete(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _pickAColor() => showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setLocalState) {
          return Container(
            color: Colors.grey.shade300,
            height: const MediaQueryData().padding.bottom + 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Colours',
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ColorsTile(
                          color: Colors.white,
                          isSelected: mainColor == Colors.white,
                          icon: Icon(
                            Icons.format_color_reset_outlined,
                            size: 50,
                            color: Colors.grey.shade800,
                          ),
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.white);
                          },
                        ),
                        ColorsTile(
                          color: Colors.yellow.shade200,
                          isSelected: mainColor == Colors.yellow.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.yellow.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.green.shade200,
                          isSelected: mainColor == Colors.green.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.green.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.blue.shade200,
                          isSelected: mainColor == Colors.blue.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.blue.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.pink.shade200,
                          isSelected: mainColor == Colors.pink.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.pink.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.deepOrange,
                          isSelected: mainColor == Colors.deepOrange.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.deepOrange.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.brown.shade200,
                          isSelected: mainColor == Colors.brown.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.brown.shade200);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      );

  void popUpDelete() {
    if (widget.listModel.isFavorite) {
      ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
    } else if (widget.listModel.isPinned) {
      ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    } else if (widget.listModel.isArchive) {
      ListModelsDb.removeListModel(ListModelsDb.archivedListModelKey, widget.listModel.id);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
    } else {
      ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('List removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  onBackPressed() {
    for (int i = 0; i < itemNameControllers.length; i++) {
      ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
      items.add(item);
    }
    widget.listModel.title = titleController.text.trim();
    widget.listModel.items.clear();
    widget.listModel.items.addAll(items);
    widget.listModel.color = mainColor;

    if (items.isNotEmpty || titleController.text.trim().isNotEmpty) {
      if (widget.listModel.isArchive) {
        if (DataManager().addToPin) {
          ListModelsDb.removeListModel(ListModelsDb.archivedListModelKey, widget.listModel.id);
          widget.listModel.isPinned = true;
          ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, widget.listModel);
        } else {
          ListModelsDb.removeListModel(ListModelsDb.archivedListModelKey, widget.listModel.id);
          widget.listModel.isPinned = false;
          ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, widget.listModel);
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else if (widget.listModel.isFavorite) {
        if (DataManager().addToFavorite) {
          if (DataManager().addToPin) {
            ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
            widget.listModel.isPinned = true;
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('List moved to Favorites'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          widget.listModel.isFavorite = false;
          if (DataManager().addToPin) {
            ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
            widget.listModel.isPinned = true;
            ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.listModelKey, widget.listModel);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('List removed from Favorites'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
      } else if (widget.listModel.isPinned) {
        if (DataManager().addToFavorite) {
          widget.listModel.isFavorite = true;
          if (DataManager().addToPin) {
            widget.listModel.isPinned = true;
            ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('List added to Favorites'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          if (DataManager().addToPin) {
            widget.listModel.isPinned = true;
            ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.listModelKey, widget.listModel);
          }
        }
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else {
        if (DataManager().addToFavorite) {
          widget.listModel.isFavorite = true;
          if (DataManager().addToPin) {
            ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
            widget.listModel.isPinned = true;
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('List added to Favorites'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          if (DataManager().addToPin) {
            ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
            widget.listModel.isPinned = true;
            ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, widget.listModel);
          } else {
            ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
            ListModelsDb.addListModel(ListModelsDb.listModelKey, widget.listModel);
          }
        }

        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
      ListModelsDb.removeListModel(ListModelsDb.archivedListModelKey, widget.listModel.id);
      ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
      ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);

      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    }
  }

  onArchived() {
    for (int i = 0; i < itemNameControllers.length; i++) {
      ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
      items.add(item);
    }
    widget.listModel.title = titleController.text.trim();
    widget.listModel.items.clear();
    widget.listModel.items.addAll(items);

    if (items.isNotEmpty || titleController.text.trim().isNotEmpty) {
      if (widget.listModel.isArchive) {
        ListModelsDb.removeListModel(ListModelsDb.archivedListModelKey, widget.listModel.id);
        widget.listModel.isArchive = false;

        if (DataManager().addToFavorite) {
          ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, widget.listModel);
        } else {
          widget.listModel.isArchive = false;
          widget.listModel.isFavorite = false;
          if (DataManager().addToPin) {
            widget.listModel.isPinned = true;
            ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, widget.listModel);
          } else {
            ListModelsDb.addListModel(ListModelsDb.listModelKey, widget.listModel);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('List removed from Archive'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else if (widget.listModel.isFavorite) {
        if (DataManager().addToFavorite) {
          widget.listModel.isFavorite = true;
          if (DataManager().addToPin) {
            widget.listModel.isPinned = true;
          }
        } else {
          widget.listModel.isFavorite = false;
          if (DataManager().addToPin) {
            widget.listModel.isPinned = true;
          }
        }
        ListModelsDb.removeListModel(ListModelsDb.favoriteListModelKey, widget.listModel.id);
        widget.listModel.isArchive = true;
        ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, widget.listModel);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('List added to Favorites'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
      } else if (widget.listModel.isPinned) {
        ListModelsDb.removeListModel(ListModelsDb.pinnedListModelKey, widget.listModel.id);
        widget.listModel.isArchive = true;
        ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, widget.listModel);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('List moved to Archive'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else {
        ListModelsDb.removeListModel(ListModelsDb.listModelKey, widget.listModel.id);
        widget.listModel.isArchive = true;
        ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, widget.listModel);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('List moved to Archive'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      return;
    }
  }
}

class ColorsTile extends StatelessWidget {
  final Color color;
  final Icon? icon;
  final Function? onColorChanging;
  final bool isSelected;

  const ColorsTile({
    Key? key,
    required this.color,
    this.onColorChanging,
    this.icon,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onColorChanging?.call(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(
              width: isSelected ? 3 : 0,
              color: isSelected ? Colors.blue.shade900 : Colors.transparent,
            ),
            color: color,
            borderRadius: BorderRadius.circular(40),
          ),
          child: isSelected
              ? Icon(
                  CupertinoIcons.checkmark_alt,
                  size: 40,
                  color: Colors.blue.shade900,
                )
              : null,
        ),
      ),
    );
  }
}

class ListModelForDeletedScreen extends StatelessWidget {
  final ListModel listModel;

  const ListModelForDeletedScreen({Key? key, required this.listModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: 60,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.restore_outlined,
                    color: Colors.grey.shade800,
                  ),
                ),
                onTap: () {
                  listModel.isDeleted = false;
                  if (listModel.isArchive) {
                    ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, listModel);
                    ListModelsDb.removeListModel(ListModelsDb.deletedListModelKey, listModel.id);
                  } else if (listModel.isFavorite) {
                    ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
                    ListModelsDb.removeListModel(ListModelsDb.deletedListModelKey, listModel.id);
                  } else if (listModel.isPinned) {
                    ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, listModel);
                    ListModelsDb.removeListModel(ListModelsDb.deletedListModelKey, listModel.id);
                  } else {
                    ListModelsDb.addListModel(ListModelsDb.listModelKey, listModel);
                    ListModelsDb.removeListModel(ListModelsDb.deletedListModelKey, listModel.id);
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false);
                },
              ),
              InkWell(
                borderRadius: BorderRadius.circular(40),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.grey.shade800,
                  ),
                ),
                onTap: () {
                  ListModelsDb.removeListModel(ListModelsDb.deletedListModelKey, listModel.id);
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false);
                },
              ), // SizedBox(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            listModel.title,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < listModel.items.length; i++)
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: listModel.items[i].ticked
                              ? Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.grey.shade800,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey.shade800,
                                ),
                        ),
                        Text(listModel.items[i].name),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      children: [
                        for (String label in listModel.labels)
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('  $label  '),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
