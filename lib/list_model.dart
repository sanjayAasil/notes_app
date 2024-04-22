import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ListModel {
  String title;
  final List<ListItem> items;
  final String id;
  List<String> labels = [];
  bool isArchive = false;
  bool isPinned = false;
  bool isDeleted = false;
  bool isFavorite = false;
  Color color;

  ListModel({
    required this.title,
    required this.items,
    this.color = Colors.white,
  }) : id = const Uuid().v4();
}

class ListItem {
  String name;
  bool ticked;

  ListItem({required this.name, this.ticked = false});
}
