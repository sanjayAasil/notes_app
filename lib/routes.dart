import 'dart:core';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/archive/archive_screen.dart';
import 'package:sanjay_notes/create_new_label.dart';
import 'package:sanjay_notes/deleted_screen.dart';
import 'package:sanjay_notes/favorite/favorite_screen.dart';
import 'package:sanjay_notes/label_screen.dart';
import 'package:sanjay_notes/list_model.dart';
import 'package:sanjay_notes/view-or-edit-list-model.dart';
import 'package:sanjay_notes/manage_note.dart';
import 'package:sanjay_notes/home/home_screen.dart';
import 'package:sanjay_notes/create_list-model.dart';
import 'package:sanjay_notes/note.dart';
import 'package:sanjay_notes/search_screen.dart';

class Routes {
  static const String homeScreen = '/';
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

  static Route<dynamic>? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
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
        return MaterialPageRoute(builder: (context) =>   const FavoriteScreen());
      case viewOrEditListModel:
        ListModel listModel = settings.arguments as ListModel;
        return MaterialPageRoute(builder: (context) => ViewOrEditListModel(listModel: listModel));
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
