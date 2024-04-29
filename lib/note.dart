import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Note {
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

  Note._({
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
  }) : labels = labels ?? [];

  factory Note.create({
    required String title,
    required String note,
  }) =>
      Note._(
        id: const Uuid().v4(),
        title: title,
        note: note,
        createdAt: DateTime.now(),
      );

  factory Note.fromJson(Map<String, dynamic> json) {
    debugPrint("Note fromJson: $json");
    return Note._(
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
    );
  }

  Map<String, dynamic> get json => {
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
      };
}
