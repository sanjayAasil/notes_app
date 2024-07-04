import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/note.dart';

class FirestoreService {
  final String isArchive = 'isArchive';
  final String isDeleted = 'isDeleted';
  final String isFavorite = 'isFavorite';
  final String isPinned = 'isPinned';

  static final FirestoreService _instance = FirestoreService._();

  FirestoreService._();

  factory FirestoreService() => _instance;

  ///get collections of notes, lists
  final CollectionReference<Map<String, dynamic>> _notesCollection = FirebaseFirestore.instance.collection('notes');
  final CollectionReference _listModelsCollection = FirebaseFirestore.instance.collection('listModels');

  ///CREATE: adding notes
  Future<void> addNote(Map<String, dynamic> note) async {
    await _notesCollection.add(note);
  }

  Future<void> addListModel(Map<String, dynamic> listModel) async {
    await _listModelsCollection.add(listModel);
  }

  ///READ: getting notes from firestore

  //NOTES
  Future<List<Note>> getNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: false)
        .where(isPinned, isEqualTo: false)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getArchivedNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive, isEqualTo: true)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite)
        .where(isPinned)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getFavoriteNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: true)
        .where(isPinned)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getPinnedNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: false)
        .where(isPinned, isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getDeletedNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive)
        .where(isDeleted, isEqualTo: true)
        .where(isFavorite)
        .where(isPinned)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getRemainderNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite)
        .where(isPinned)
        .where('scheduleTime', isNotEqualTo: null)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  /// UPDATE: updating notes in firestore

  ///DELETE:  Deleting notes in firestore
  Future<void> deleteNote(String docId) async {
    debugPrint("FirestoreService deleteNote: called delete");
    await _notesCollection.doc(docId).delete();
  }
}
