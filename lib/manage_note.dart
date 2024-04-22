import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/note.dart';
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

  @override
  void initState() {
    titleController.text = widget.note?.title ?? '';
    noteController.text = widget.note?.note ?? '';
    if (widget.note == null) {
      mainColor = Colors.white;
    } else {
      mainColor = widget.note!.color;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainColor,
        child: Column(
          children: [
            if (widget.note != null && widget.note!.isDeleted)
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 60,
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(Routes.deletedScreen, (route) => false),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ), // SizedBox(),
                  ],
                ),
              )
            else
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
                          CupertinoIcons.back,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),

                    InkWell(
                      onTap: onPinned,
                      borderRadius: BorderRadius.circular(40),
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
                      onTap: archiveButton,
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: noteController,
                          maxLines: null,
                          // keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Note',
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            border: InputBorder.none,
                          ),
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
    );
  }

  _pickAColor() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => setState(() {
                            mainColor = Colors.white;
                          }),
                          child: Container(
                            child: Icon(
                              Icons.format_color_reset_outlined,
                              size: 50,
                              color: Colors.grey.shade800,
                            ),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
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

  void onBackPressed() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        DataManager().notes.add(note);
      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        widget.note!.color = mainColor;
        if (widget.note!.isArchive) {
          DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
          DataManager().archivedNotes.add(widget.note!);
        } else if (widget.note!.isPinned) {
          DataManager().pinnedNotes.removeWhere((element) => element.id == widget.note!.id);
          DataManager().pinnedNotes.add(widget.note!);
        } else {
          DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
          DataManager().notes.add(widget.note!);
        }
      }
    } else {
      if (widget.note != null) {
        DataManager().pinnedNotes.removeWhere((element) => element.id == widget.note!.id);
        DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
        DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
      }
    }

    if (widget.note != null) {
      if (widget.note!.isArchive) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
    }
  }

  void archiveButton() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        note.isArchive = true;
        DataManager().archivedNotes.add(note);
      } else {
        if (widget.note!.isArchive && widget.note!.isPinned) {
          DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.color = mainColor;
          widget.note!.isArchive = false;
          DataManager().pinnedNotes.add(widget.note!);
        } else if (widget.note!.isArchive && !widget.note!.isPinned) {
          DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.color = mainColor;
          widget.note!.isArchive = false;
          DataManager().notes.add(widget.note!);
        } else if (!widget.note!.isArchive && widget.note!.isPinned) {
          DataManager().pinnedNotes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.color = mainColor;
          widget.note!.isArchive = true;
          DataManager().archivedNotes.add(widget.note!);
        } else {
          DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.color = mainColor;
          widget.note!.isArchive = true;
          DataManager().archivedNotes.add(widget.note!);
        }
      }
    } else {
      return;
    }

    if (widget.note != null) {
      if (widget.note!.isArchive && widget.note!.isPinned) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        debugPrint("_ManageNotePageState archiveButton: check1");
      } else if (widget.note!.isArchive && !widget.note!.isPinned) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
        debugPrint("_ManageNotePageState archiveButton: check2");
      } else if (!widget.note!.isArchive && widget.note!.isPinned) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        debugPrint("_ManageNotePageState archiveButton: check3");
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
        debugPrint("_ManageNotePageState archiveButton: check4");
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      debugPrint("_ManageNotePageState archiveButton: check5");
    }
  }

  void onPinned() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note(title: titleController.text.trim(), note: noteController.text.trim());
        note.color = mainColor;
        note.isPinned = true;
        DataManager().pinnedNotes.add(note);
      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        widget.note!.color = mainColor;
        if (widget.note!.isArchive) {
          if (widget.note!.isPinned) {
            widget.note!.isPinned = false;
            widget.note!.color = mainColor;
            DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
            DataManager().archivedNotes.add(widget.note!);
          } else {
            widget.note!.isPinned = true;
            widget.note!.color = mainColor;
            DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
            DataManager().archivedNotes.add(widget.note!);
          }
        } else if (widget.note!.isPinned) {
          DataManager().pinnedNotes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.isPinned = false;
          widget.note!.color = mainColor;
          DataManager().notes.add(widget.note!);
        } else {
          DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.isPinned = true;
          widget.note!.color = mainColor;
          DataManager().pinnedNotes.add(widget.note!);
        }
      }
    } else {
      if (widget.note != null) {
        DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
        DataManager().pinnedNotes.removeWhere((element) => element.id == widget.note!.id);
        DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
      } else {
        return;
      }
    }

    if (widget.note != null) {
      if (widget.note!.isArchive) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.archiveScreen, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
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
