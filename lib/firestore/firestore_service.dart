import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../database/data_manager.dart';
import '../models/list_model.dart';
import '../models/note.dart';

class FirestoreService {
  final String uid = 'uid';
  final String isArchive = 'isArchive';
  final String isDeleted = 'isDeleted';
  final String isFavorite = 'isFavorite';
  final String isPinned = 'isPinned';

  static final FirestoreService _instance = FirestoreService._();

  FirestoreService._();

  factory FirestoreService() => _instance;

  ///get collections of notes, lists
  final CollectionReference<Map<String, dynamic>> _notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference<Map<String, dynamic>> _listModelsCollection =
      FirebaseFirestore.instance.collection('listModels');
  final CollectionReference<Map<String, dynamic>> _labelsCollection =
      FirebaseFirestore.instance.collection('labels');

  ///CREATE: adding notes, lists
  Future<void> addNote(Map<String, dynamic> note) async {
    try {
      await _notesCollection.doc(note['id']).set(note);
    } catch (e) {
      debugPrint("addNote error: $e");
    }
  }

  Future<void> addListModel(Map<String, dynamic> listModel) async {
    try {
      await _listModelsCollection.doc(listModel['id']).set(listModel);
    } catch (e) {
      debugPrint("addListModel error: $e");
    }
  }

  Future<void> addLabels(List<String> labels) async {
    try {
      final currentUid = DataManager().user?.uid;
      await _labelsCollection.doc(currentUid ?? 'permanentId').set({
        uid: currentUid,
        'labels': labels,
      });
    } catch (e) {
      debugPrint("addLabels error: $e");
    }
  }

  ///READ: getting notes from firestore

  //NOTES
  Future<List<Note>> getNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isArchive, isEqualTo: false)
          .where(isDeleted, isEqualTo: false)
          .where(isFavorite, isEqualTo: false)
          .where(isPinned, isEqualTo: false)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isArchive, isEqualTo: false)
              .where(isDeleted, isEqualTo: false)
              .where(isFavorite, isEqualTo: false)
              .where(isPinned, isEqualTo: false)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getListModels error: $e");
      return [];
    }
  }

  Future<List<Note>> getArchivedNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isArchive, isEqualTo: true)
          .where(isDeleted, isEqualTo: false)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getArchivedNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getArchivedListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isArchive, isEqualTo: true)
              .where(isDeleted, isEqualTo: false)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getArchivedListModels error: $e");
      return [];
    }
  }

  Future<List<Note>> getFavoriteNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isArchive, isEqualTo: false)
          .where(isDeleted, isEqualTo: false)
          .where(isFavorite, isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getFavoriteNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getFavoriteListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isArchive, isEqualTo: false)
              .where(isDeleted, isEqualTo: false)
              .where(isFavorite, isEqualTo: true)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getFavoriteListModels error: $e");
      return [];
    }
  }

  Future<List<Note>> getPinnedNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isArchive, isEqualTo: false)
          .where(isDeleted, isEqualTo: false)
          .where(isFavorite, isEqualTo: false)
          .where(isPinned, isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getPinnedNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getPinnedListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isArchive, isEqualTo: false)
              .where(isDeleted, isEqualTo: false)
              .where(isFavorite, isEqualTo: false)
              .where(isPinned, isEqualTo: true)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getPinnedListModels error: $e");
      return [];
    }
  }

  Future<List<Note>> getDeletedNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isDeleted, isEqualTo: true)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getDeletedNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getDeletedListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isDeleted, isEqualTo: true)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getDeletedListModels error: $e");
      return [];
    }
  }

  Future<List<Note>> getRemainderNotes() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _notesCollection
          .where(uid, isEqualTo: currentUid)
          .where(isDeleted, isEqualTo: false)
          .where('scheduleTime', isGreaterThan: 0)
          .get();
      return querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint("getRemainderNotes error: $e");
      return [];
    }
  }

  Future<List<ListModel>> getRemainderListModels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _listModelsCollection
              .where(uid, isEqualTo: currentUid)
              .where(isDeleted, isEqualTo: false)
              .where('scheduleTime', isGreaterThan: 0)
              .get();
      return querySnapshot.docs
          .map((doc) => ListModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("getRemainderListModels error: $e");
      return [];
    }
  }

  Future<List<String>> getLabels() async {
    try {
      final currentUid = DataManager().user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _labelsCollection.where(uid, isEqualTo: currentUid).get();
      List<String> list = querySnapshot.docs
          .expand((doc) => List<String>.from(doc['labels'] ?? []))
          .toList();
      debugPrint("FirestoreService getLabels: checkknn   $list");
      return list;
    } catch (e) {
      debugPrint("getLabels error: $e");
      return [];
    }
  }

  ///DELETE:  Deleting notes in firestore
  Future<void> deleteNote(String noteId) async {
    try {
      await _notesCollection.doc(noteId).delete();
    } catch (e) {
      debugPrint("deleteNote error: $e");
    }
  }

  Future<void> deleteListModel(String listModelId) async {
    try {
      await _listModelsCollection.doc(listModelId).delete();
    } catch (e) {
      debugPrint("deleteListModel error: $e");
    }
  }

  Future<void> deleteLabels() async {
    try {
      await _labelsCollection.doc().delete();
    } catch (e) {
      debugPrint("deleteLabels error: $e");
    }
  }
}
