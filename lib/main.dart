import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/data_manager.dart';
import 'package:sanjay_notes/label_db.dart';
import 'package:sanjay_notes/list_model_db.dart';
import 'package:sanjay_notes/notes_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        ledColor: Colors.white,
      ),
    ],
  );
  DataManager().notes = NotesDb.getAllNotes(NotesDb.notesKey);
  DataManager().archivedNotes = NotesDb.getAllNotes(NotesDb.archivedNotesKey);
  DataManager().favoriteNotes = NotesDb.getAllNotes(NotesDb.favoriteNotesKey);
  DataManager().pinnedNotes = NotesDb.getAllNotes(NotesDb.pinnedNotesKey);
  DataManager().deletedNotes = NotesDb.getAllNotes(NotesDb.deletedNotesKey);
  DataManager().remainderNotes = NotesDb.getAllNotes(NotesDb.remainderNotesKey);

  DataManager().listModels = ListModelsDb.getAllListModels(ListModelsDb.listModelKey);
  DataManager().deletedListModels = ListModelsDb.getAllListModels(ListModelsDb.deletedListModelKey);
  DataManager().pinnedListModels = ListModelsDb.getAllListModels(ListModelsDb.pinnedListModelKey);
  DataManager().favoriteListModels = ListModelsDb.getAllListModels(ListModelsDb.favoriteListModelKey);
  DataManager().archivedListModels = ListModelsDb.getAllListModels(ListModelsDb.archivedListModelKey);
  DataManager().remainderListModels = ListModelsDb.getAllListModels(ListModelsDb.remainderListModelKey);

  DataManager().labels = LabelsDb.getAllLabels();

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
    return ChangeNotifierProvider(
      create: (_) => DataManager(),
      builder: (context, child) {
        context.watch<DataManager>();
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerate,
        );
      },
    );
  }
}
