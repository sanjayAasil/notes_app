import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_manager.dart';
import 'note.dart';

late SharedPreferences prefs;

class NotesDb {
  NotesDb._();

  static const notesKey = 'notes';
  static const archivedNotesKey = 'archivedNotes';
  static const favoriteNotesKey = 'favoriteNotes';
  static const pinnedNotesKey = 'pinnedNotes';
  static const deletedNotesKey = 'deletedNotes';

  static List<Note> getAllNotes(String key) {
    String? data = prefs.getString(key);

    log('$key - $data');

    if (data == null) return [];

    List decoded = jsonDecode(data);
    debugPrint("NotesDb getAllNotes: checkzzz $key = ${data}");

    return decoded.map((e) => Note.fromJson(e)).toList();
  }

  static addNote(String key, Note note) {
    List<Note> notes = getAllNotes(key);

    notes.add(note);

    List<Map<String, dynamic>> jsonList = notes.map((e) => e.json).toList();

    String encoded = jsonEncode(jsonList);

    prefs.setString(key, encoded);

    if (key == notesKey) {
      DataManager().notes.add(note);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.add(note);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.add(note);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.add(note);
    } else {
      DataManager().deletedNotes.add(note);
    }
  }

  static addNotes(String key, List<Note> notes) {
    List<Note> noteS = getAllNotes(key);

    noteS.addAll(notes);

    List<Map<String, dynamic>> jsonList = noteS.map((e) => e.json).toList();

    String encoded = jsonEncode(jsonList);

    prefs.setString(key, encoded);

    if (key == notesKey) {
      DataManager().notes.addAll(notes);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.addAll(notes);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.addAll(notes);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.addAll(notes);
    } else {
      DataManager().deletedNotes.addAll(notes);
    }
  }

  static removeNote(String key, String noteId) {
    List<Note> notes = getAllNotes(key);

    notes.removeWhere((element) => element.id == noteId);

    List<Map<String, dynamic>> jsonList = notes.map((e) => e.json).toList();

    prefs.setString(key, jsonEncode(jsonList));
    if (key == notesKey) {
      DataManager().notes.removeWhere((element) => element.id == noteId);
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.removeWhere((element) => element.id == noteId);
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.removeWhere((element) => element.id == noteId);
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.removeWhere((element) => element.id == noteId);
    } else {
      DataManager().deletedNotes.removeWhere((element) => element.id == noteId);
    }
  }

  static removeNotes(String key, List<String> noteIds) {
    List<Note> notes = getAllNotes(key);

    notes.removeWhere((element) => noteIds.contains(element.id));

    List<Map<String, dynamic>> jsonList = notes.map((e) => e.json).toList();

    prefs.setString(key, jsonEncode(jsonList));
    if (key == notesKey) {
      DataManager().notes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == favoriteNotesKey) {
      DataManager().favoriteNotes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == archivedNotesKey) {
      DataManager().archivedNotes.removeWhere((element) => noteIds.contains(element.id));
    } else if (key == pinnedNotesKey) {
      DataManager().pinnedNotes.removeWhere((element) => noteIds.contains(element.id));
    } else {
      DataManager().deletedNotes.removeWhere((element) => noteIds.contains(element.id));
    }
  }
}
