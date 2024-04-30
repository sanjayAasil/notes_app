import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/routes.dart';

class NewListScreen extends StatefulWidget {
  const NewListScreen({super.key});

  @override
  State<NewListScreen> createState() => _NewListScreenState();
}

class _NewListScreenState extends State<NewListScreen> {
  Color mainColor = Colors.white;
  List<TextEditingController> itemControllers = [];
  TextEditingController titleController = TextEditingController();
  List<ListItem> items = [];

  @override
  void initState() {
    super.initState();
    DataManager().addToFavorite = false;
    DataManager().addToPin = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) {
        onBackPressed();
      },
      child: Scaffold(
        body: Container(
          color: mainColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 60,
                alignment: AlignmentDirectional.centerStart,
                // color: Colors.grey.shade300,
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
                    StatefulBuilder(builder: (context, stateful) {
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
                    }),
                    InkWell(
                      borderRadius: BorderRadius.circular(40),
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
                            : Icon(CupertinoIcons.pin),
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
              InkWell(
                onTap: () {
                  itemControllers.add(TextEditingController());
                  ListItem item = ListItem(name: '');
                  items.add(item);
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
                      for (int i = 0; i < itemControllers.length; i++)
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
                                    child: items[i].ticked
                                        ? const Icon(Icons.check_box_outlined)
                                        : const Icon(Icons.check_box_outline_blank),
                                  ),
                                  onTap: () {
                                    items[i].ticked = !items[i].ticked;
                                    debugPrint("_NewListScreenState: build ${items[i].ticked}");
                                    setState(() {});
                                  }),
                              Expanded(
                                child: TextField(
                                  controller: itemControllers[i],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.grey.shade800,
                                  ),
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
              Container(
                height: 45,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.list,
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
                    Expanded(child: SizedBox()),
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
      ),
    );
  }

  _pickAColor() => showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setLocalState) {
            return Container(
              color: Colors.grey.shade300,
              height: MediaQueryData().padding.bottom + 150,
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
                              setState(() {
                                mainColor = Colors.white;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.yellow.shade200,
                            isSelected: mainColor == Colors.yellow.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.yellow.shade200;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.green.shade200,
                            isSelected: mainColor == Colors.green.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.green.shade200;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.blue.shade200,
                            isSelected: mainColor == Colors.blue.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.blue.shade200;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.pink.shade200,
                            isSelected: mainColor == Colors.pink.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.pink.shade200;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.deepOrange,
                            isSelected: mainColor == Colors.deepOrange.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.deepOrange.shade200;
                              });
                            },
                          ),
                          ColorsTile(
                            color: Colors.brown.shade200,
                            isSelected: mainColor == Colors.brown.shade200,
                            onColorChanging: () {
                              setLocalState(() {});
                              setState(() {
                                mainColor = Colors.brown.shade200;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      );

  onBackPressed() {
    for (int i = 0; i < itemControllers.length; i++) {
      if (itemControllers.isNotEmpty) items[i].name = itemControllers[i].text.trim();
    }

    ListModel listModel = ListModel.create(title: titleController.text.trim(), items: items);
    listModel.color = mainColor;
    if (listModel.items.isEmpty || titleController.text.trim().isEmpty) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      return;
    }
    if (DataManager().addToFavorite) {
      if (DataManager().addToPin) {
        listModel.isPinned = true;
        ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
      } else {
        ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
      }
    } else {
      if (DataManager().addToPin) {
        listModel.isPinned = true;
        ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, listModel);
      } else {
        ListModelsDb.addListModel(ListModelsDb.listModelKey, listModel);
      }
    }

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
  }

  onArchived() {
    for (int i = 0; i < itemControllers.length; i++) {
      if (itemControllers.isNotEmpty) items[i].name = itemControllers[i].text.trim();
    }

    ListModel listModel = ListModel.create(title: titleController.text.trim(), items: items);
    listModel.color = mainColor;
    if (listModel.items.isEmpty && titleController.text.trim().isEmpty) {
      return;
    }
    listModel.isArchive = true;
    ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, listModel);

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
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
