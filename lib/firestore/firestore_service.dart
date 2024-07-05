import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:sanjay_notes/models/list_model.dart';

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
  final CollectionReference<Map<String, dynamic>> _listModelsCollection =
      FirebaseFirestore.instance.collection('listModels');
  final CollectionReference<Map<String, dynamic>> _labelsCollection = FirebaseFirestore.instance.collection('labels');

  ///CREATE: adding notes, lists
  Future<void> addNote(Map<String, dynamic> note) async {
    await _notesCollection.doc(note['id']).set(note);
  }

  Future<void> addListModel(Map<String, dynamic> listModel) async {
    await _listModelsCollection.doc(listModel['id']).set(listModel);
  }

  Future<void> addLabels(List<String> labels) async {
    await _labelsCollection.doc('permanentId').set({'labels': labels});
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

  Future<List<ListModel>> getListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _listModelsCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: false)
        .where(isPinned, isEqualTo: false)
        .get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getArchivedNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _notesCollection.where(isArchive, isEqualTo: true).where(isDeleted, isEqualTo: false).get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<ListModel>> getArchivedListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _listModelsCollection.where(isArchive, isEqualTo: true).where(isDeleted, isEqualTo: false).get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getFavoriteNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<ListModel>> getFavoriteListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _listModelsCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
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

  Future<List<ListModel>> getPinnedListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _listModelsCollection
        .where(isArchive, isEqualTo: false)
        .where(isDeleted, isEqualTo: false)
        .where(isFavorite, isEqualTo: false)
        .where(isPinned, isEqualTo: true)
        .get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getDeletedNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection.where(isDeleted, isEqualTo: true).get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<ListModel>> getDeletedListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _listModelsCollection.where(isDeleted, isEqualTo: true).get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
  }

  Future<List<Note>> getRemainderNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _notesCollection.where(isDeleted, isEqualTo: false).where('scheduleTime', isGreaterThan: 0).get();
    return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<List<ListModel>> getRemainderListModels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _listModelsCollection.where(isDeleted, isEqualTo: false).where('scheduleTime', isGreaterThan: 0).get();
    return querySnapshot.docs.map((doc) => ListModel.fromJson(doc.data())).toList();
  }

  Future<List<String>> getLabels() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _labelsCollection.get();
    List<String> list = querySnapshot.docs.expand((doc) => List<String>.from(doc['labels'] ?? [])).toList();
    debugPrint("FirestoreService getLabels: checkknn   $list");
    return list;
  }

  /// UPDATE: updating notes in firestore

  ///NO NEED as it can be managed in addNote()...used(set())

  ///DELETE:  Deleting notes in firestore
  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }

  Future<void> deleteListModel(String noteId) async {
    await _listModelsCollection.doc(noteId).delete();
  }

  Future<void> deleteLabels() async {
    await _labelsCollection.doc().delete();
  }
}
