import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/Database/label_db.dart';
import 'package:sanjay_notes/Database/list_model_db.dart';
import 'package:sanjay_notes/Database/notes_db.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  debugPrint(" main: init");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  initializeAwesomeNotification();
  initializeDb();
  runApp(const MyApp());
  debugPrint(" main: check main");

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
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerate,
        );
      },
    );
  }
}

initializeDb() {
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
}

initializeAwesomeNotification() {
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
}
