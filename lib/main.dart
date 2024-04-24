import 'package:flutter/material.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  DataManager().notes = NotesDb.getAllNotes(NotesDb.notesKey);
  DataManager().archivedNotes = NotesDb.getAllNotes(NotesDb.archivedNotesKey);
  DataManager().favoriteNotes = NotesDb.getAllNotes(NotesDb.favoriteNotesKey);
  DataManager().pinnedNotes = NotesDb.getAllNotes(NotesDb.pinnedNotesKey);
  DataManager().deletedNotes = NotesDb.getAllNotes(NotesDb.deletedNotesKey);

  DataManager().listModels = ListModelsDb.getAllListModels(ListModelsDb.listModelKey);
  DataManager().deletedListModel = ListModelsDb.getAllListModels(ListModelsDb.deletedListModelKey);
  DataManager().pinnedListModels = ListModelsDb.getAllListModels(ListModelsDb.pinnedListModelKey);
  DataManager().favoriteListModels = ListModelsDb.getAllListModels(ListModelsDb.favoriteListModelKey);
  DataManager().archivedListModels = ListModelsDb.getAllListModels(ListModelsDb.archivedListModelKey);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerate,
    );
  }
}
