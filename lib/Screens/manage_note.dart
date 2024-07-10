import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/models/note.dart';
import 'package:sanjay_notes/Database/notes_db.dart';
import 'package:sanjay_notes/utils.dart';

class ManageNotePage extends StatefulWidget {
  final Note? note;

  const ManageNotePage._({this.note});

  factory ManageNotePage.create() => const ManageNotePage._();

  factory ManageNotePage.viewOrEdit(Note note) => ManageNotePage._(note: note);

  @override
  State<ManageNotePage> createState() => _ManageNotePageState();
}

class _ManageNotePageState extends State<ManageNotePage> {
  Color mainColor = Colors.white;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isTimePassed = false;
  DateTime? _date;
  TimeOfDay? _timeOfDay;
  bool isBackPressed = false;
  bool addToFavorite = false;
  bool addToPin = false;

  @override
  void initState() {
    titleController.text = widget.note?.title ?? '';
    noteController.text = widget.note?.note ?? '';
    addToFavorite = widget.note == null
        ? false
        : widget.note!.isFavorite
            ? true
            : false;
    addToPin = widget.note == null
        ? false
        : widget.note!.isPinned
            ? true
            : false;
    if (widget.note == null) {
      mainColor = Colors.white;
    } else {
      mainColor = widget.note!.color;
    }

    if (widget.note != null && widget.note!.scheduleTime != null) {
      isTimePassed = DateTime.now().isAfter(widget.note!.scheduleTime!);
    }

    if (widget.note != null) {
      if (widget.note!.scheduleTime != null) {
        if (!isTimePassed) {
          _date = DateTime(
            widget.note!.scheduleTime!.year,
            widget.note!.scheduleTime!.month,
            widget.note!.scheduleTime!.day,
          );
          _timeOfDay = TimeOfDay(hour: widget.note!.scheduleTime!.hour, minute: widget.note!.scheduleTime!.minute);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool value) {
        if (isBackPressed) return;

        if (widget.note == null || (widget.note != null && !widget.note!.isDeleted)) {
          onBackPressed(true);
        }
      },
      child: Scaffold(
        body: Container(
          color: mainColor,
          child: widget.note != null && widget.note!.isDeleted
              ? NoteForDeletedScreen(note: widget.note!)
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      height: 60,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => onBackPressed(false),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          if (widget.note == null || !widget.note!.isArchive)
                            StatefulBuilder(builder: (context, setState) {
                              return InkWell(
                                onTap: () {
                                  addToFavorite = !addToFavorite;
                                  setState(() {});
                                },
                                borderRadius: BorderRadius.circular(40),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: addToFavorite
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red.shade800,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: Colors.grey.shade800,
                                          )),
                              );
                            }),
                          StatefulBuilder(builder: (context, setState) {
                            return InkWell(
                              onTap: () {
                                addToPin = !addToPin;
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: addToPin
                                      ? Icon(
                                          CupertinoIcons.pin_fill,
                                          color: Colors.grey.shade800,
                                        )
                                      : const Icon(CupertinoIcons.pin)),
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
                            onTap: archiveButton,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.note == null
                                  ? Icon(
                                      Icons.archive_outlined,
                                      color: Colors.grey.shade800,
                                    )
                                  : widget.note!.isArchive
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                                controller: titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: noteController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Note',
                                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            (_date != null && _timeOfDay != null) && !isTimePassed
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
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Wrap(
                                  children: [
                                    if (widget.note != null)
                                      for (String label in widget.note!.labels)
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Text(
                                                '  $label  ',
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
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
                          if (widget.note != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 70.0),
                              child: Text(
                                Utils.getFormattedDateTime(widget.note!.createdAt),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11,
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
                          color: Colors.purple.shade200,
                          isSelected: mainColor == Colors.purple.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.purple.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.deepOrangeAccent.shade200,
                          isSelected: mainColor == Colors.deepOrangeAccent.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.deepOrangeAccent.shade200);
                          },
                        ),
                        ColorsTile(
                          color: Colors.teal.shade200,
                          isSelected: mainColor == Colors.teal.shade200,
                          onColorChanging: () {
                            setLocalState(() {});
                            setState(() => mainColor = Colors.teal.shade200);
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
                  )),
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
                    AwesomeNotifications().cancel(2);
                    _date = null;
                    _timeOfDay = null;
                    if (widget.note != null) {
                      widget.note!.scheduleTime = null;
                    }
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
                    DataManager().notify();
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
                      if (widget.note != null) {
                        widget.note!.scheduleTime = DateTime(
                          _date!.year,
                          _date!.month,
                          _date!.day,
                          _timeOfDay!.hour,
                          _timeOfDay!.minute,
                        );
                        isTimePassed = false;
                      }

                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 2,
                          channelKey: 'basic_channel',
                          title: titleController.text.trim(),
                          body: noteController.text.trim(),
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
                      DataManager().notify();
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
    if (widget.note != null) {
      widget.note!.color = mainColor;
      widget.note!.isDeleted = true;
      if (widget.note!.isFavorite) {
        NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
      } else if (widget.note!.isPinned) {
        NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
      } else if (widget.note!.isArchive) {
        NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
      } else {
        NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
      }
      NotesDb.addNote(NotesDb.deletedNotesKey, widget.note!);
    } else {
      if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
        Note note = Note.create(title: titleController.text.trim(), note: noteController.text.trim());
        note.isDeleted = true;
        NotesDb.addNote(NotesDb.deletedNotesKey, note);
      }
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Note  removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    DataManager().notify();
  }

  void onBackPressed(bool skipPop) {
    isBackPressed = true;
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note.create(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        if (_date != null && _timeOfDay != null) {
          note.scheduleTime = DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _timeOfDay!.hour,
            _timeOfDay!.minute,
          );
          NotesDb.removeNote(NotesDb.remainderNotesKey, note.id);
          NotesDb.addNote(NotesDb.remainderNotesKey, note);
        }
        if (addToFavorite) {
          if (addToPin) {
            note.isPinned = true;
            note.isFavorite = true;
          } else {
            note.isFavorite = true;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to Favorites'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          NotesDb.addNote(NotesDb.favoriteNotesKey, note);
        } else {
          if (addToPin) {
            note.isPinned = true;
            NotesDb.addNote(NotesDb.pinnedNotesKey, note);
          } else {
            NotesDb.addNote(NotesDb.notesKey, note);
          }
        }
        if (!skipPop) Navigator.of(context).pop();
      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        widget.note!.color = mainColor;
        if (_date != null && _timeOfDay != null) {
          widget.note!.scheduleTime = DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _timeOfDay!.hour,
            _timeOfDay!.minute,
          );
          NotesDb.removeNote(NotesDb.remainderNotesKey, widget.note!.id);
          NotesDb.addNote(NotesDb.remainderNotesKey, widget.note!);
        } else {
          NotesDb.removeNote(NotesDb.remainderNotesKey, widget.note!.id);
          widget.note!.scheduleTime = null;
        }
        if (widget.note!.isArchive) {
          if (addToPin) {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
            widget.note!.isPinned = true;
            NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          } else {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
            widget.note!.isPinned = false;
            NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          }

          if (!skipPop) Navigator.of(context).pop();
        } else if (widget.note!.isFavorite) {
          if (addToFavorite) {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isPinned = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isPinned = false;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            }
          } else {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isPinned = true;
              widget.note!.isFavorite = false;
              NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isFavorite = false;
              widget.note!.isPinned = false;
              NotesDb.addNote(NotesDb.notesKey, widget.note!);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Note removed from Favorites'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (!skipPop) Navigator.of(context).pop();
        } else if (widget.note!.isPinned) {
          if (addToFavorite) {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              widget.note!.isFavorite = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              widget.note!.isFavorite = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Note added to Favorites'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              widget.note!.isPinned = false;
              NotesDb.addNote(NotesDb.notesKey, widget.note!);
            }
          }

          if (!skipPop) Navigator.of(context).pop();
        } else {
          if (addToFavorite) {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              widget.note!.isFavorite = true;
              widget.note!.isPinned = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              widget.note!.isFavorite = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Note added to Favorites'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            if (addToPin) {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              widget.note!.isPinned = true;
              NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              NotesDb.addNote(NotesDb.notesKey, widget.note!);
            }
          }
          if (!skipPop) Navigator.of(context).pop();
        }
      }
    } else {
      if (widget.note != null) {
        if (widget.note!.isArchive) {
          NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);

          if (!skipPop) Navigator.of(context).pop();
        } else if (widget.note!.isFavorite) {
          NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);

          if (!skipPop) Navigator.of(context).pop();
        } else if (widget.note!.isPinned) {
          NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);

          if (!skipPop) Navigator.of(context).pop();
        } else {
          NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);

          if (!skipPop) Navigator.of(context).pop();
        }
      } else {
        if (!skipPop) Navigator.of(context).pop();
      }
    }
    DataManager().notify();
  }

  void archiveButton() {
    isBackPressed = true;
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note.create(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        if (_date != null && _timeOfDay != null) {
          note.scheduleTime = DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _timeOfDay!.hour,
            _timeOfDay!.minute,
          );
          NotesDb.addNote(NotesDb.remainderNotesKey, note);
        }
        if (addToFavorite) {
          note.isFavorite = true;
          if (addToPin) {
            note.isPinned = true;
          } else {
            if (addToPin) {
              note.isPinned = true;
            }
          }
        }
        note.isArchive = true;
        NotesDb.addNote(NotesDb.archivedNotesKey, note);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Note moved to Archive'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        if (_date != null && _timeOfDay != null) {
          widget.note!.scheduleTime = DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _timeOfDay!.hour,
            _timeOfDay!.minute,
          );
          NotesDb.removeNote(NotesDb.remainderNotesKey, widget.note!.id);
          NotesDb.addNote(NotesDb.remainderNotesKey, widget.note!);
        } else {
          NotesDb.removeNote(NotesDb.remainderNotesKey, widget.note!.id);
          widget.note!.scheduleTime = null;
        }
        if (widget.note!.isArchive) {
          if (widget.note!.isFavorite) {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
            widget.note!.isArchive = false;
            NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
          } else if (widget.note!.isPinned) {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);

            widget.note!.isArchive = false;
            NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
          } else {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);

            widget.note!.isArchive = false;
            NotesDb.addNote(NotesDb.notesKey, widget.note!);
          }
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Note removed from Archive'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (widget.note!.isFavorite) {
          NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);

          widget.note!.isArchive = true;
          NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);

          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Note moved to Archive'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (widget.note!.isPinned) {
          NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);

          widget.note!.isArchive = true;
          NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Note moved to Archive'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);

          widget.note!.isArchive = true;
          NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Note moved to Archive'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
      DataManager().notify();
    } else {
      return;
    }
  }
}

class ColorsTile extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Icon? icon;
  final Function? onColorChanging;

  const ColorsTile({
    Key? key,
    required this.color,
    this.onColorChanging,
    this.isSelected = false,
    this.icon,
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
                  Icons.check,
                  color: Colors.blue.shade900,
                  size: 40,
                )
              : null,
        ),
      ),
    );
  }
}

class NoteForDeletedScreen extends StatelessWidget {
  final Note note;

  const NoteForDeletedScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: const MediaQueryData().padding.top + 50, left: const MediaQueryData().padding.left),
          child: Row(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.grey.shade800,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.restore_outlined,
                    color: Colors.grey.shade800,
                  ),
                ),
                onTap: () {
                  note.isDeleted = false;
                  if (note.isArchive) {
                    NotesDb.addNote(NotesDb.archivedNotesKey, note);
                    NotesDb.removeNote(NotesDb.deletedNotesKey, note.id);
                  } else if (note.isPinned) {
                    NotesDb.addNote(NotesDb.pinnedNotesKey, note);
                    NotesDb.removeNote(NotesDb.deletedNotesKey, note.id);
                  } else if (note.isFavorite) {
                    NotesDb.addNote(NotesDb.favoriteNotesKey, note);
                    NotesDb.removeNote(NotesDb.deletedNotesKey, note.id);
                  } else {
                    NotesDb.addNote(NotesDb.notesKey, note);
                    NotesDb.removeNote(NotesDb.deletedNotesKey, note.id);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Note recycled'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.of(context).pop();
                  DataManager().notify();
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
                  NotesDb.removeNote(NotesDb.deletedNotesKey, note.id, permanentDelete: true);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Note deleted permanently'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  DataManager().notify();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    note.note,
                    style: const TextStyle(fontSize: 15),
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
