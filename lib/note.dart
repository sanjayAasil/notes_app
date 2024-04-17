import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String title;
  String note;
  List<String> labels;
  bool isArchive;
  bool isPinned;

  Note({
    required this.title,
    required this.note,
    this.isArchive = false,
    this.isPinned = false,
  })  : id = const Uuid().v4(),
        labels = [];
}
