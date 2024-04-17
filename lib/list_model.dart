import 'package:uuid/uuid.dart';

class ListModel {
  String title;
  final List<ListItem> items;
  final String id;
  List<String> labels = [];
  bool isArchive = false;
  bool isPinned = false;

  ListModel({
    required this.title,
    required this.items,
  }) : id = const Uuid().v4();
}

class ListItem {
  String name;
  bool ticked;

  ListItem({required this.name, this.ticked = false});
}
