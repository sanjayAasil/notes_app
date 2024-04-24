import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ListModel {
  final String id;
  String title;
  final List<ListItem> items;
  List<String> labels;
  bool isArchive;
  bool isPinned;
  bool isDeleted;
  bool isFavorite;
  Color color;

  ListModel._({
    required this.id,
    required this.title,
    required this.items,
    this.isArchive = false,
    this.isPinned = false,
    this.isDeleted = false,
    this.isFavorite = false,
    this.color = Colors.white,
    this.labels = const [],
  });

  factory ListModel.create({
    required String title,
    required List<ListItem> items,
  }) =>
      ListModel._(id: const Uuid().v4(), title: title, items: items);

  factory ListModel.fromJson(Map<String, dynamic> json) => ListModel._(
        id: json['id'],
        title: json['title'],
        items: List.from(json['items']).map((e) => ListItem.fromJson(e)).toList(),
        color: Color(json['color']),
        isArchive: json['isArchive'],
        isDeleted: json['isDeleted'],
        isPinned: json['isPinned'],
        isFavorite: json['isFavorite'],
        labels: List.from(json['labels']),
      );

  Map<String, dynamic> get json => {
        'id': id,
        'title': title,
        'color': color.value,
        'isArchive': isArchive,
        'isDeleted': isDeleted,
        'isPinned': isPinned,
        'isFavorite': isFavorite,
        'labels': labels,
        'items': items.map((e) => e.json).toList(),
      };
}

class ListItem {
  String name;
  bool ticked;

  ListItem({required this.name, this.ticked = false});

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
        name: json['name'],
        ticked: json['ticked'],
      );

  Map<String, dynamic> get json => {
        'name': name,
        'ticked': ticked,
      };
}
