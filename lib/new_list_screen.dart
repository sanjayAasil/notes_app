import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/routes.dart';

class NewListScreen extends StatefulWidget {
  NewListScreen({super.key});

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  List<TextEditingController> itemControllers = [];
  TextEditingController titleController = TextEditingController();
  List<ListItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    for (int i = 0; i < itemControllers.length; i++) {
                      if (itemControllers.isNotEmpty) items[i].name = itemControllers[i].text.trim();
                    }

                    ListModel listModel = ListModel(title: titleController.text.trim(), items: items);
                    if (listModel.items.isEmpty && titleController.text.trim().isEmpty) {
                      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                      return;
                    }
                    DataManager().listModels.add(listModel);

                    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      CupertinoIcons.back,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),

                InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    for (int i = 0; i < itemControllers.length; i++) {
                      if (itemControllers.isNotEmpty) {
                        items[i].name = itemControllers[i].text.trim();
                      }
                    }
                    ListModel listModel = ListModel(title: titleController.text.trim(), items: items);
                    if (listModel.items.isEmpty && titleController.text.trim().isEmpty) {
                      return;
                    }
                    listModel.isPinned = true;
                    DataManager().pinnedListModels.add(listModel);
                    debugPrint("_NewListScreenState build: ${DataManager().pinnedListModels.length}");

                    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(CupertinoIcons.pin),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(CupertinoIcons.bell),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.archive_outlined),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      itemControllers.add(TextEditingController());
                      ListItem item = ListItem(name: '');
                      items.add(item);
                      debugPrint("_NewListScreenState: build ${items}");
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
                  for (int i = 0; i < itemControllers.length; i++)
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
                                child: items[i].ticked
                                    ? Icon(Icons.check_box_outlined)
                                    : Icon(Icons.check_box_outline_blank),
                              ),
                              onTap: () {
                                items[i].ticked = !items[i].ticked;
                                debugPrint("_NewListScreenState: build ${items[i].ticked}");
                                setState(() {});
                              }),
                          Expanded(
                            child: TextField(
                              controller: itemControllers[i],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: Icon(CupertinoIcons.xmark),
                            ),
                            onTap: () {
                              itemControllers.removeAt(i);
                              items.removeAt(i);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
