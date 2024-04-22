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

  Note({
    required this.title,
    required this.note,
    this.isArchive = false,
    this.isPinned = false,
    this.isDeleted = false,
    this.color = Colors.white,
    this.isFavorite = false,
  })  : id = const Uuid().v4(),
        labels = [];
}
