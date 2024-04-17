import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/note.dart';
import 'package:sanjay_notes/routes.dart';

class ManageNotePage extends StatefulWidget {
  final Note? note;

  const ManageNotePage._({this.note});

  factory ManageNotePage.create() => ManageNotePage._();

  factory ManageNotePage.viewOrEdit(Note note) => ManageNotePage._(note: note);

  @override
  State<ManageNotePage> createState() => _ManageNotePageState();
}

class _ManageNotePageState extends State<ManageNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.note?.title ?? '';
    noteController.text = widget.note?.note ?? '';
    super.initState();
  }

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
                  onTap: onBackPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      CupertinoIcons.back,
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),

                InkWell(
                  onTap: onPinned,
                  borderRadius: BorderRadius.circular(40),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(CupertinoIcons.pin),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(CupertinoIcons.bell),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.archive_outlined),
                  ),
                  onTap: archiveButton,
                ),
                // SizedBox(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: noteController,
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: 'Note',
                            hintStyle: TextStyle(fontWeight: FontWeight.w300),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              child: Text('  ${label}  '),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onBackPressed() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note(title: titleController.text.trim(), note: noteController.text.trim());

        DataManager().notes.add(note);
      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        if (widget.note!.isArchive) {
          DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
          DataManager().archivedNotes.add(widget.note!);
        } else {
          DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
          DataManager().notes.add(widget.note!);
        }
      }
    } else {
      if (widget.note != null) {
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
        note.isArchive = true;
        DataManager().archivedNotes.add(note);
      } else {
        DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
        DataManager().archivedNotes.add(widget.note!);
      }
    } else {
      return;
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

  void onPinned() {
    if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      if (widget.note == null) {
        Note note = Note(title: titleController.text.trim(), note: noteController.text.trim());
        note.isPinned = true;
        DataManager().pinnedNotes.add(note);

      } else {
        widget.note!.title = titleController.text.trim();
        widget.note!.note = noteController.text.trim();
        if (widget.note!.isArchive) {
          DataManager().archivedNotes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.isPinned = true;
          DataManager().pinnedNotes.add(widget.note!);
        } else {
          DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
          widget.note!.isPinned = true;
          DataManager().pinnedNotes.add(widget.note!);
        }
      }
    } else {
      if (widget.note != null) {
        DataManager().notes.removeWhere((element) => element.id == widget.note!.id);
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
