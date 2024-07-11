import 'package:flutter/material.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:uuid/uuid.dart';

class Note {
  final String? uid;
  final String id;
  String title;
  String note;
  List<String> labels;
  bool isArchive;
  bool isPinned;
  bool isDeleted;
  Color color;
  bool isFavorite;
  DateTime createdAt;
  DateTime? scheduleTime;

  Note._({
    required this.uid,
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
    this.isArchive = false,
    this.isPinned = false,
    this.isDeleted = false,
    this.color = Colors.white,
    this.isFavorite = false,
    List<String>? labels,
    this.scheduleTime,
  }) : labels = labels ?? [];

  factory Note.create({
    required String title,
    required String note,
  }) =>
      Note._(
        uid: DataManager().user?.uid,
        id: const Uuid().v4(),
        title: title,
        note: note,
        createdAt: DateTime.now(),
      );

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note._(
      uid: json['uid'],
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isArchive: json['isArchive'],
      isPinned: json['isPinned'],
      isDeleted: json['isDeleted'],
      color: Color(json['color']),
      isFavorite: json['isFavorite'],
      labels: List.from(json['labels']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      scheduleTime: json['scheduleTime'] != null ? DateTime.fromMillisecondsSinceEpoch(json['scheduleTime']) : null,
    );
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'id': id,
        'title': title,
        'note': note,
        'isArchive': isArchive,
        'isPinned': isPinned,
        'isDeleted': isDeleted,
        'color': color.value,
        'isFavorite': isFavorite,
        'labels': labels,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'scheduleTime': scheduleTime?.millisecondsSinceEpoch,
      };
}
