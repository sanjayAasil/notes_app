import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/Screens/create_new_label.dart';
import 'package:sanjay_notes/Screens/deleted_screen.dart';
import 'package:sanjay_notes/Screens/label_screen.dart';
import 'package:sanjay_notes/Screens/login_Screens/phone_number_login.dart';
import 'package:sanjay_notes/Screens/login_Screens/signIn-screen.dart';
import 'package:sanjay_notes/Screens/login_Screens/signUp_Screen.dart';
import 'package:sanjay_notes/Screens/login_Screens/welcome_screen.dart';
import 'package:sanjay_notes/models/list_model.dart';
import 'package:sanjay_notes/Screens/settings_screen.dart';
import 'package:sanjay_notes/Screens/view-or-edit-list-model.dart';
import 'package:sanjay_notes/Screens/manage_note.dart';
import 'package:sanjay_notes/Screens/create_list-model.dart';
import 'package:sanjay_notes/models/note.dart';
import 'package:sanjay_notes/Screens/search_screen.dart';
import 'Screens/archive/archive_screen.dart';
import 'Screens/favorite/favorite_screen.dart';
import 'Screens/home/home_screen.dart';
import 'Screens/remainder/remainder_screen.dart';

class Routes {
  static const String mainScreen = '/';
  static const String signInScreen = '/sign-in-screen';
  static const String signUpScreen = '/sign-out-screen';
  static const String searchScreen = '/search-screen';
  static const String newListScreen = '/new-list-screen';
  static const String createNewNoteScreen = '/create-new-note-screen';
  static const String editOrViewNoteScreen = '/edit-or-view-note-screen';
  static const String archiveScreen = '/archive-screen';
  static const String deletedScreen = '/deleted-screen';
  static const String createNewLabelScreen = '/create-new-label-screen';
  static const String labelScreen = '/label-screen';
  static const String viewOrEditListModel = '/view-or-edit-list-model';
  static const String favoriteScreen = '/favorite-screen';
  static const String settingsScreen = '/settings-screen';
  static const String remainderScreen = '/remainder-screen';
  static const String phoneNumberLoginScreen = '/phoneNumber-login-screen';

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case mainScreen:
        return FirebaseAuth.instance.currentUser == null
            ? MaterialPageRoute(builder: (context) => const WelcomeScreen())
            : MaterialPageRoute(builder: (context) => const HomeScreen());
      case signInScreen:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case phoneNumberLoginScreen:
        return MaterialPageRoute(builder: (context) => const PhoneNumberLoginScreen());
      case searchScreen:
        return MaterialPageRoute(builder: (context) => const SearchScreen());
      case newListScreen:
        return MaterialPageRoute(builder: (context) => const NewListScreen());
      case createNewNoteScreen:
        return MaterialPageRoute(builder: (context) => ManageNotePage.create());
      case editOrViewNoteScreen:
        Note note = settings.arguments as Note;
        return MaterialPageRoute(builder: (context) => ManageNotePage.viewOrEdit(note));
      case archiveScreen:
        return MaterialPageRoute(builder: (context) => const ArchiveScreen());
      case deletedScreen:
        return MaterialPageRoute(builder: (context) => const DeletedScreen());
      case createNewLabelScreen:
        return MaterialPageRoute(builder: (context) => const CreateNewLabelScreen());
      case labelScreen:
        List<String> selectedIds = settings.arguments as List<String>;
        return MaterialPageRoute(builder: (context) => LabelScreen(selectedIds: selectedIds));
      case favoriteScreen:
        return MaterialPageRoute(builder: (context) => const FavoriteScreen());
      case viewOrEditListModel:
        ListModel listModel = settings.arguments as ListModel;
        return MaterialPageRoute(builder: (context) => ViewOrEditListModel(listModel: listModel));
      case settingsScreen:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      case remainderScreen:
        return MaterialPageRoute(builder: (context) => const RemainderScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        );
    }
  }
}
