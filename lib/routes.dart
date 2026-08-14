import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/list_model.dart';
import 'models/note.dart';
import 'ui/archive/archive_screen.dart';
import 'ui/create_list-model.dart';
import 'ui/create_new_label.dart';
import 'ui/deleted_screen.dart';
import 'ui/favorite/favorite_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/label_screen.dart';
import 'ui/login/phone_number_login.dart';
import 'ui/login/signIn-screen.dart';
import 'ui/login/signUp_Screen.dart';
import 'ui/login/welcome_screen.dart';
import 'ui/manage_note.dart';
import 'ui/remainder/remainder_screen.dart';
import 'ui/search_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/view-or-edit-list-model.dart';

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
