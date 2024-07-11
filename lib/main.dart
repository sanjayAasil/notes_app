import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/firebase/firebase_auth_manager.dart';
import 'package:sanjay_notes/firestore/firestore_service.dart';
import 'package:sanjay_notes/routes.dart';
import 'firebase/firebase_options.dart';
import 'package:http/http.dart' as http;

void main() async {
  bool isConnectedToInternet = await hasInternetConnection();

  if (isConnectedToInternet) {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    initializeAwesomeNotification();
    User? user = DataManager().user = FirebaseAuth.instance.currentUser;
    if (user != null) await initializeDb();
  }
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

initializeDb() async {
  debugPrint(" initializeDb: start");
  DataManager().notes = await FirestoreService().getNotes();
  DataManager().archivedNotes = await FirestoreService().getArchivedNotes();
  DataManager().favoriteNotes = await FirestoreService().getFavoriteNotes();
  DataManager().pinnedNotes = await FirestoreService().getPinnedNotes();
  DataManager().deletedNotes = await FirestoreService().getDeletedNotes();
  DataManager().remainderNotes = await FirestoreService().getRemainderNotes();

  DataManager().listModels = await FirestoreService().getListModels();
  DataManager().deletedListModels = await FirestoreService().getDeletedListModels();
  DataManager().pinnedListModels = await FirestoreService().getPinnedListModels();
  DataManager().favoriteListModels = await FirestoreService().getFavoriteListModels();
  DataManager().archivedListModels = await FirestoreService().getArchivedListModels();
  DataManager().remainderListModels = await FirestoreService().getRemainderListModels();

  DataManager().labels = await FirestoreService().getLabels();

  debugPrint(" initializeDb: end");
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

Future<bool> hasInternetConnection() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com')).timeout(const Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
