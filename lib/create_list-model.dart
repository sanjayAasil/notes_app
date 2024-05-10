import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/list_model_db.dart';

import 'package:sanjay_notes/utils.dart';

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
  DateTime? _date;
  TimeOfDay? _timeOfDay;
  bool isBackPressed = false;

  @override
  void initState() {
    super.initState();
    DataManager().addToFavorite = false;
    DataManager().addToPin = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool value) {
        if (isBackPressed) return;

        onBackPressed(true);
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
                      onTap: () => onBackPressed(false),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    StatefulBuilder(
                      builder: (context, stateful) {
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
                      );
                    }),
                    InkWell(
                      onTap: () => remainder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          CupertinoIcons.bell,
                          color: Colors.grey.shade800,
                        ),
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
                      _date != null && _timeOfDay != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 20),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Icon(
                                      Icons.alarm,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  Text(
                                    Utils.getFormattedDateTime(
                                      DateTime(
                                        _date!.year,
                                        _date!.month,
                                        _date!.day,
                                        _timeOfDay!.hour,
                                        _timeOfDay!.minute,
                                      ),
                                    ),
                                    style: TextStyle(color: Colors.blue.shade700),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                child: Row(
                  children: [
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
                    const Expanded(child: SizedBox()),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'deleted',
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
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
        }),
      );

  void remainder() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, localState) {
        return SimpleDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text('Remainder'),
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDatePicker(
                          builder: (context, child) => Theme(
                                data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    surface: Colors.grey.shade50,
                                  ),
                                ),
                                child: child!,
                              ),
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime(
                            _date?.year ?? DateTime.now().year,
                            _date?.month ?? DateTime.now().month,
                            _date?.day ?? DateTime.now().day,
                          ),
                          lastDate: DateTime(2050),
                          currentDate: DateTime.now())
                      .then((value) => localState(() => _date = value!));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                    ),
                    _date == null
                        ? const Text(
                            'Select date',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            '${_date!.day}/${_date!.month}/${_date!.year}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: _timeOfDay?.hour == null ? DateTime.now().hour : _timeOfDay!.hour,
                      minute: _timeOfDay?.minute == null ? DateTime.now().minute + 1 : _timeOfDay!.minute,
                    ),
                  ).then((value) => localState(() => _timeOfDay = value!));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.only(right: 7), child: Icon(Icons.timer, color: Colors.white)),
                    _timeOfDay == null
                        ? const Text(
                            'Select time',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _timeOfDay!.format(context).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {
                    _date = null;
                    _timeOfDay = null;

                    setState(() {});
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        elevation: 20,
                        content: Text("The note's reminder is Cancelled"),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                if (_date != null && _timeOfDay != null)
                  TextButton(
                    onPressed: () {
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 1,
                          channelKey: 'basic_channel',
                          title: titleController.text.trim(),
                          body: itemControllers.map((e) => e.text.trim()).toString(),
                        ),
                        schedule: NotificationCalendar(
                          year: _date!.year,
                          month: _date!.month,
                          day: _date!.day,
                          hour: _timeOfDay!.hour,
                          minute: _timeOfDay!.minute,
                          second: 0,
                          //timeZone: 'Asia/Kolkata',
                        ),
                        actionButtons: [
                          NotificationActionButton(
                            key: 'label key',
                            label: 'Cancel',
                            color: Colors.blue,
                          ),
                          NotificationActionButton(
                            key: 'label key',
                            label: 'Mark as Done',
                            color: Colors.blue,
                          ),
                        ],
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          elevation: 20,
                          content: Text("The note's reminder is Scheduled"),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Navigator.of(context).pop();

                      setState(() {});
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                      ),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  void popUpDelete() {
    isBackPressed = true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('List  removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  onBackPressed(bool skipPop) {
    isBackPressed = true;
    for (int i = 0; i < itemControllers.length; i++) {
      if (itemControllers.isNotEmpty) items[i].name = itemControllers[i].text.trim();
    }

    ListModel listModel = ListModel.create(title: titleController.text.trim(), items: items);
    listModel.color = mainColor;
    if (_date != null && _timeOfDay != null) {
      listModel.scheduleTime = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _timeOfDay!.hour,
        _timeOfDay!.minute,
      );
      ListModelsDb.addListModel(ListModelsDb.remainderListModelKey, listModel);
    }

    if (listModel.items.isEmpty || titleController.text.trim().isEmpty) {
      if (!skipPop) Navigator.of(context).pop();
      return;
    }
    if (DataManager().addToFavorite) {
      listModel.isFavorite = true;
      if (DataManager().addToPin) {
        listModel.isPinned = true;
        ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
      } else {
        ListModelsDb.addListModel(ListModelsDb.favoriteListModelKey, listModel);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('List added to Favorites'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      if (DataManager().addToPin) {
        listModel.isPinned = true;
        ListModelsDb.addListModel(ListModelsDb.pinnedListModelKey, listModel);
      } else {
        ListModelsDb.addListModel(ListModelsDb.listModelKey, listModel);
      }
    }

    if (!skipPop) Navigator.of(context).pop();
  }

  onArchived() {
    isBackPressed = true;
    for (int i = 0; i < itemControllers.length; i++) {
      if (itemControllers.isNotEmpty) items[i].name = itemControllers[i].text.trim();
    }

    ListModel listModel = ListModel.create(title: titleController.text.trim(), items: items);
    listModel.color = mainColor;
    if (_date != null && _timeOfDay != null) {
      listModel.scheduleTime = DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _timeOfDay!.hour,
        _timeOfDay!.minute,
      );
      ListModelsDb.addListModel(ListModelsDb.remainderListModelKey, listModel);
    }
    if (listModel.items.isEmpty && titleController.text.trim().isEmpty) {
      return;
    }
    if (DataManager().addToFavorite) {
      listModel.isFavorite = true;
      if (DataManager().addToPin) {
        listModel.isPinned = true;
      }
    } else {
      if (DataManager().addToPin) {
        listModel.isPinned = true;
      }
    }
    listModel.isArchive = true;
    ListModelsDb.addListModel(ListModelsDb.archivedListModelKey, listModel);

   Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('List moved to Archive'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
