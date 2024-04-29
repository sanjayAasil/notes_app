import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDateTime(DateTime date) {
    String format;
    bool isToday = false;
    bool isYesterday = false;
    DateTime now = DateTime.now();
    if (date.day != now.day) {
      if (date.day + 1 == now.day) {
        isYesterday = true;
        format = 'hh:mm a';
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
}
