import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/routes.dart';

class ViewOrEditListModel extends StatefulWidget {
  final ListModel listModel;

  const ViewOrEditListModel({required this.listModel});

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
      debugPrint("_ViewOrEditListModelState: initState ${itemNameControllers}");
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
                    onTap: () {
                      for (int i = 0; i < itemNameControllers.length; i++) {
                        ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
                        items.add(item);
                      }
                      debugPrint("_ViewOrEditListModelState build: checkkkkkkkkk  ${titleController.text.trim()}");
                      if (items.isEmpty && titleController.text.trim().isEmpty) {
                        DataManager().listModels.removeWhere((element) => element.id == widget.listModel.id);
                        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                        return;
                      }
                      for (int i = 0; i < DataManager().listModels.length; i++) {
                        if (DataManager().listModels[i].id == widget.listModel.id) {
                          DataManager().listModels[i].title = titleController.text.trim();
                          DataManager().listModels[i].items.clear();
                          DataManager().listModels[i].items.addAll(items);
                        }
                      }

                      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        CupertinoIcons.back,
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),

                  InkWell(
                    onTap: () {
                      if (itemNameControllers.isEmpty && titleController.text.isEmpty) {
                        return;
                      }
                      for (int i = 0; i < itemNameControllers.length; i++) {
                        print('Item name : ${itemNameControllers}');
                        ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
                        items.add(item);
                      }

                      for (int i = 0; i < DataManager().pinnedListModels.length; i++) {
                        if (DataManager().pinnedListModels[i].id == widget.listModel.id) {
                          DataManager().pinnedListModels[i].title = titleController.text.trim();
                          DataManager().pinnedListModels[i].items.clear();
                          DataManager().pinnedListModels[i].items.addAll(items);
                        }
                      }
                      for (int i = 0; i < DataManager().listModels.length; i++) {
                        if (DataManager().listModels[i].id == widget.listModel.id) {
                          DataManager().listModels[i].title = titleController.text.trim();
                          DataManager().listModels[i].items.clear();
                          DataManager().listModels[i].items.addAll(items);
                          DataManager().pinnedListModels.add(DataManager().listModels[i]);
                          DataManager().listModels.remove(DataManager().listModels[i]);
                        }
                      }

                      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(CupertinoIcons.pin),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(CupertinoIcons.bell),
                  ),

                  InkWell(
                    onTap: () {
                      if (itemNameControllers.isEmpty && titleController.text.isEmpty) {
                        return;
                      }
                      for (int i = 0; i < itemNameControllers.length; i++) {
                        print('Item name : ${itemNameControllers}');
                        ListItem item = ListItem(name: itemNameControllers[i].text.trim(), ticked: itemTicked[i]);
                        items.add(item);
                      }

                      for (int i = 0; i < DataManager().pinnedListModels.length; i++) {
                        if (DataManager().pinnedListModels[i].id == widget.listModel.id) {
                          DataManager().pinnedListModels[i].title = titleController.text.trim();
                          DataManager().pinnedListModels[i].items.clear();
                          DataManager().pinnedListModels[i].items.addAll(items);
                          DataManager().archivedListModels.add(DataManager().pinnedListModels[i]);
                          DataManager().archivedListModels[i].isArchive = true;
                          DataManager().pinnedListModels[i].isPinned = false;
                          DataManager().pinnedListModels.remove(DataManager().pinnedListModels[i]);
                        }
                      }
                      for (int i = 0; i < DataManager().listModels.length; i++) {
                        if (DataManager().listModels[i].id == widget.listModel.id) {
                          DataManager().listModels[i].title = titleController.text.trim();
                          DataManager().listModels[i].items.clear();
                          DataManager().listModels[i].items.addAll(items);
                          DataManager().archivedListModels.add(DataManager().listModels[i]);
                          DataManager().listModels[i].isArchive = true;
                          DataManager().listModels.remove(DataManager().listModels[i]);
                        }
                      }

                      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.archive_outlined),
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
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.more_vert_rounded),
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
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 65.0),
                          child: Icon(CupertinoIcons.plus),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
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
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10),
                          child: Icon(Icons.drag_indicator_sharp),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: itemTicked[i] ? Icon(Icons.check_box_outlined) : Icon(Icons.check_box_outline_blank),
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(40),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(CupertinoIcons.xmark),
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
                              child: Text('  ${label}  '),
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
}
