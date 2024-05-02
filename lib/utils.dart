import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanjay_notes/deleted_screen.dart';

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
        format = 'dd-MMMM \n HH:mm';
      } else {
        format = 'dd-MM-yy \n HH:mm';
      }
    } else {
      isToday = true;
      format = 'HH:mm';
    }
    if (isToday) {
      return "Today \n ${DateFormat(format).format(date)}";
    } else if (isYesterday) {
      return "Yesterday \n ${DateFormat(format).format(date)}";
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
          backgroundColor: Colors.grey.shade100,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
              child: Text(content),
            ),
          ],
          title: Text(content),
          contentPadding: const EdgeInsets.all(20),
          content: Text('Do you want to $content?')),
    );
  }
}
