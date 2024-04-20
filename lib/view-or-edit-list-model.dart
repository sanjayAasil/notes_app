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
  List<ListItem> items = [];
  TextEditingController titleController = TextEditingController();
  List<TextEditingController> itemNameControllers = [];
  List<bool> itemTicked = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.listModel.title;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: 60,
              alignment: AlignmentDirectional.centerStart,
              color: Colors.grey.shade300,
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
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        CupertinoIcons.pin,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      CupertinoIcons.bell,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  InkWell(
                    onTap: onArchived,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
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
            Column(
              children: [
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
                            debugPrint("_NewListScreenState: build ${itemTicked[i]}");
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
              ],
            ),
            Column(
              children: [
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
          ],
        ),
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
