import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import 'main.dart';

class Utils {
  Utils._();

  static String getFormattedDateTime(DateTime date) {
    String format;
    bool isToday = false;
    bool isYesterday = false;
    DateTime now = DateTime.now();
    if (date.day != now.day) {
      if (date.day + 1 == now.day) {
        isYesterday = true;
        format = 'HH:mm';
      } else if (date.year == now.year) {
        format = 'dd-MMMM, HH:mm';
      } else {
        format = 'dd-MM-yy, HH:mm';
      }
    } else {
      isToday = true;
      format = 'HH:mm';
    }
    if (isToday) {
      return "Today, ${DateFormat(format).format(date)}";
    } else if (isYesterday) {
      return "Yesterday, ${DateFormat(format).format(date)}";
    }
    return DateFormat(format).format(date);
  }

  static commonDialog({
    required context,
    required Function function,
    required String content,
    required String snackBarMessage,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          shadowColor: Colors.black,
          elevation: 20,
          backgroundColor: Colors.grey.shade100,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                function();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 20,
                    content: Text(snackBarMessage),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                content,
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          title: Text(content),
          contentPadding: const EdgeInsets.all(20),
          content: Text('Do you want to $content?')),
    );
  }

  static refresh(BuildContext context) async {
    if (context.mounted) {
      LoadingDialog loadingDialog = LoadingDialog(message: 'Syncing', progressbarColor: Colors.blue)..show(context);
      await initializeDb();
      loadingDialog.dismiss(context);
    }
  }
}
