import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/note.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/routes.dart';

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

  DateTime? _date;
  TimeOfDay? _timeOfDay;

  @override
  void initState() {
    titleController.text = widget.note?.title ?? '';
    noteController.text = widget.note?.note ?? '';
    DataManager().addToFavorite = widget.note == null
        ? false
        : widget.note!.isFavorite
            ? true
            : false;
    DataManager().addToPin = widget.note == null
        ? false
        : widget.note!.isPinned
            ? true
            : false;
    if (widget.note == null) {
      mainColor = Colors.white;
    } else {
      mainColor = widget.note!.color;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.note != null && widget.note!.isDeleted,
      onPopInvoked: (bool value) {
        if (widget.note == null || (widget.note != null && !widget.note!.isDeleted)) {
          onBackPressed();
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
                            onTap: onBackPressed,
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
                                  DataManager().addToFavorite = !DataManager().addToFavorite;
                                  setState(() {});
                                },
                                borderRadius: BorderRadius.circular(40),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DataManager().addToFavorite
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
                                DataManager().addToPin = !DataManager().addToPin;
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DataManager().addToPin
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
                                            ))),
                          // SizedBox(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
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
                            Align(
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
                                          child: Text('  $label  '),
                                        ),
                                      ),
                                ],
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
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(Routes.newListScreen, (route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text('Moved to List page'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_box_outlined,
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
                            lastDate: DateTime(2050),
                            currentDate: DateTime.now())
                        .then((value) => setState(() {
                              _date = value!;
                              localState(() {});
                            }));
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
                    initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                  ).then((value) => {
                        setState(() {
                          _timeOfDay = value!;
                          localState(() {});
                        })
                      });
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
                        Icons.timer,
                        color: Colors.white,
                      ),
                    ),
                    _timeOfDay == null
                        ? const Text(
                            'Select time',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            '${_timeOfDay!.format(context)} ',
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
                    Navigator.of(context).pop();
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
                      }

                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 1,
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
                          timeZone: 'Asia/Kolkata',
                        ),
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
    if (widget.note != null) {
      if (widget.note!.isFavorite) {
        NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
      } else if (widget.note!.isPinned) {
        NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else if (widget.note!.isArchive) {
        NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else {
        NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Note  removed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void onBackPressed() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note.create(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        if(_date != null && _timeOfDay != null){
          note.scheduleTime = DateTime(
            _date!.year,
            _date!.month,
            _date!.day,
            _timeOfDay!.hour,
            _timeOfDay!.minute,
          );
        }
        if (DataManager().addToFavorite) {
          if (DataManager().addToPin) {
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
          if (DataManager().addToPin) {
            note.isPinned = true;
            NotesDb.addNote(NotesDb.pinnedNotesKey, note);
          } else {
            NotesDb.addNote(NotesDb.notesKey, note);
          }
        }

        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        widget.note!.color = mainColor;
        if (widget.note!.isArchive) {
          if (DataManager().addToPin) {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
            widget.note!.isPinned = true;
            NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          } else {
            NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);
            widget.note!.isPinned = false;
            NotesDb.addNote(NotesDb.archivedNotesKey, widget.note!);
          }

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        } else if (widget.note!.isFavorite) {
          if (DataManager().addToFavorite) {
            if (DataManager().addToPin) {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isPinned = true;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);
              widget.note!.isPinned = false;
              NotesDb.addNote(NotesDb.favoriteNotesKey, widget.note!);
            }
          } else {
            if (DataManager().addToPin) {
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

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
        } else if (widget.note!.isPinned) {
          if (DataManager().addToFavorite) {
            if (DataManager().addToPin) {
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
            if (DataManager().addToPin) {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);
              widget.note!.isPinned = false;
              NotesDb.addNote(NotesDb.notesKey, widget.note!);
            }
          }

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        } else {
          if (DataManager().addToFavorite) {
            if (DataManager().addToPin) {
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
            if (DataManager().addToPin) {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              widget.note!.isPinned = true;
              NotesDb.addNote(NotesDb.pinnedNotesKey, widget.note!);
            } else {
              NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);
              NotesDb.addNote(NotesDb.notesKey, widget.note!);
            }
          }

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        }
      }
    } else {
      if (widget.note != null) {
        if (widget.note!.isArchive) {
          NotesDb.removeNote(NotesDb.archivedNotesKey, widget.note!.id);

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        } else if (widget.note!.isFavorite) {
          NotesDb.removeNote(NotesDb.favoriteNotesKey, widget.note!.id);

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);
        } else if (widget.note!.isPinned) {
          NotesDb.removeNote(NotesDb.pinnedNotesKey, widget.note!.id);

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        } else {
          NotesDb.removeNote(NotesDb.notesKey, widget.note!.id);

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    }
  }

  void archiveButton() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note.create(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        if (DataManager().addToFavorite) {
          note.isFavorite = true;
          if (DataManager().addToPin) {
            note.isPinned = true;
          } else {
            if (DataManager().addToPin) {
              note.isPinned = true;
            }
          }
        }
        note.isArchive = true;
        NotesDb.addNote(NotesDb.archivedNotesKey, note);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Note moved to Archive'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
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
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
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

          Navigator.of(context).pushNamedAndRemoveUntil(Routes.favoriteScreen, (route) => false);

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
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);

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
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Note moved to Archive'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
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
                onTap: () {
                  debugPrint("NoteForDeletedScreen build: checkkkkk");
                  Navigator.of(context).pop();
                },
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
                  NotesDb.removeNote(NotesDb.deletedNotesKey, note.id);
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Note deleted permanently'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
