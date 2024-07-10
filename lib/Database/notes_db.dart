import 'package:flutter/cupertino.dart';
import 'package:sanjay_notes/firestore/firestore_service.dart';

import 'data_manager.dart';
import '../models/note.dart';

class NotesDb {
  NotesDb._();

  static const notesKey = 'notes';
  static const archivedNotesKey = 'archivedNotes';
  static const favoriteNotesKey = 'favoriteNotes';
  static const pinnedNotesKey = 'pinnedNotes';
  static const deletedNotesKey = 'deletedNotes';
  static const remainderNotesKey = 'remainderNotes';

  static addNote(String key, Note note) {
    debugPrint("NotesDb addNote: note json ${note.json}");
    FirestoreService().addNote(note.json);

    if (key == notesKey) {
      DataManager().notes.add(note);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.add(note);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.add(note);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.add(note);
    } else if (key == remainderNotesKey) {
      DataManager().remainderNotes.add(note);
    } else {
      DataManager().deletedNotes.add(note);
    }
  }

  static addNotes(String key, List<Note> notes) {
    for (Note note in notes) {
      debugPrint("NotesDb addNotes: ${note.json}");
      FirestoreService().addNote(note.json);
    }

    if (key == notesKey) {
      DataManager().notes.addAll(notes);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.addAll(notes);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.addAll(notes);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.addAll(notes);
    } else if (key == remainderNotesKey) {
      DataManager().remainderNotes.addAll(notes);
    } else {
      DataManager().deletedNotes.addAll(notes);
    }
  }

  static removeNote(String key, String noteId, {bool permanentDelete = false}) async {
    if (permanentDelete) {
      FirestoreService().deleteNote(noteId);
    }
    if (key == notesKey) {
      DataManager().notes.removeWhere((element) => element.id == noteId);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.removeWhere((element) => element.id == noteId);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.removeWhere((element) => element.id == noteId);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.removeWhere((element) => element.id == noteId);
    } else if (key == remainderNotesKey) {
      DataManager().remainderNotes.removeWhere((element) => element.id == noteId);
    } else {
      DataManager().deletedNotes.removeWhere((element) => element.id == noteId);
    }
  }

  static removeNotes(String key, List<String> noteIds, {bool permanentDelete = false}) {
    if (permanentDelete) {
      for (String id in noteIds) {
        FirestoreService().deleteNote(id);
      }
    }
    if (key == notesKey) {
      DataManager().notes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == remainderNotesKey) {
      DataManager().remainderNotes.removeWhere((element) => noteIds.contains(element.id));
    } else {
      DataManager().deletedNotes.removeWhere((element) => noteIds.contains(element.id));
    }
  }
}
