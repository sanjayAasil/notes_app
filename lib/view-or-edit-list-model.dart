import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/routes.dart';

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
      debugPrint("_ViewOrEditListModelState: initState $itemNameControllers");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_ViewOrEditListModelState: build check ${itemNameControllers.length}");
    return Scaffold(
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

                        InkWell(
                          onTap: onPinned,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.listModel.isPinned
                                ? Icon(
                                    CupertinoIcons.pin_fill,
                                    color: Colors.grey.shade800,
                                  )
                                : Icon(
                                    CupertinoIcons.pin,
                                    color: Colors.grey.shade800,
                                  ),
                          ),
                        ),

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
                              CupertinoIcons.paintbrush,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.more_vert_rounded,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _pickAColor() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => setState(() {
                            mainColor = Colors.white;
                          }),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.format_color_reset_outlined,
                              size: 50,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                      ColorsTile(
                        color: Colors.yellow.shade200,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.yellow.shade200;
                        }),
                      ),
                      ColorsTile(
                        color: Colors.green.shade200,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.green.shade200;
                        }),
                      ),
                      ColorsTile(
                        color: Colors.blue.shade200,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.blue.shade200;
                        }),
                      ),
                      ColorsTile(
                        color: Colors.pink.shade200,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.pink.shade200;
                        }),
                      ),
                      ColorsTile(
                        color: Colors.deepOrange,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.deepOrange.shade200;
                        }),
                      ),
                      ColorsTile(
                        color: Colors.brown.shade200,
                        onColorChanging: () => setState(() {
                          mainColor = Colors.brown.shade200;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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
        DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
        DataManager().archivedListModels.add(widget.listModel);
      } else if (widget.listModel.isPinned) {
        DataManager().pinnedListModels.removeWhere((element) => element.id == widget.listModel.id);
        DataManager().pinnedListModels.add(widget.listModel);
      } else {
        DataManager().listModels.removeWhere((element) => element.id == widget.listModel.id);
        DataManager().listModels.add(widget.listModel);
      }
    } else {
      DataManager().pinnedListModels.removeWhere((element) => element.id == widget.listModel.id);
      DataManager().listModels.removeWhere((element) => element.id == widget.listModel.id);
      DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
    }

    if (items.isNotEmpty || titleController.text.trim().isNotEmpty) {
      if (widget.listModel.isArchive) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      if (widget.listModel.isArchive) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    }
  }

  onPinned() {
    for (int i = 0; i < itemNameControllers.length; i++) {
      ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
      items.add(item);
    }
    widget.listModel.title = titleController.text.trim();
    widget.listModel.items.clear();
    widget.listModel.items.addAll(items);

    if (titleController.text.isNotEmpty || itemNameControllers.isNotEmpty) {
      if (widget.listModel.isArchive) {
        if (widget.listModel.isPinned) {
          DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
          widget.listModel.isPinned = false;
          DataManager().archivedListModels.add(widget.listModel);
        } else {
          DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
          widget.listModel.isPinned = true;
          DataManager().archivedListModels.add(widget.listModel);
        }
      } else if (widget.listModel.isPinned) {
        DataManager().pinnedListModels.removeWhere((element) => element.id == widget.listModel.id);
        widget.listModel.isPinned = false;
        DataManager().listModels.add(widget.listModel);
      } else {
        DataManager().listModels.removeWhere((element) => element.id == widget.listModel.id);
        widget.listModel.isPinned = true;
        DataManager().pinnedListModels.add(widget.listModel);
      }
    } else {
      return;
    }

    if (titleController.text.isNotEmpty || itemNameControllers.isNotEmpty) {
      if (widget.listModel.isArchive) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else if (widget.listModel.isPinned) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      return;
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
        if (widget.listModel.isPinned) {
          DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
          widget.listModel.isArchive = false;
          DataManager().pinnedListModels.add(widget.listModel);
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        } else {
          DataManager().archivedListModels.removeWhere((element) => element.id == widget.listModel.id);
          widget.listModel.isArchive = false;
          DataManager().listModels.add(widget.listModel);
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        }
      } else if (widget.listModel.isPinned) {
        DataManager().pinnedListModels.removeWhere((element) => element.id == widget.listModel.id);
        widget.listModel.isArchive = true;
        DataManager().archivedListModels.add(widget.listModel);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else {
        DataManager().listModels.removeWhere((element) => element.id == widget.listModel.id);
        widget.listModel.isArchive = true;
        DataManager().archivedListModels.add(widget.listModel);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      return;
    }
  }
}

class ColorsTile extends StatelessWidget {
  final Color color;

  final Function? onColorChanging;

  const ColorsTile({Key? key, required this.color, this.onColorChanging}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onColorChanging?.call();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
          ),
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
