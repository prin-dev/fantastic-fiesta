import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final _format = DateFormat.yMEd().add_Hm();
String dateTimeString(DateTime dateTime) => _format.format(dateTime);

// Uses a standard web-safe space before the AM/PM marker
final _timeDayMonthDateYearFormat = DateFormat().addPattern(
  'h:mm a EEE, MMM d, yyyy',
);
String timeDateString(DateTime dateTime) =>
    _timeDayMonthDateYearFormat.format(dateTime);

final _timeDayMonthDateFormat = DateFormat().addPattern('h:mm a EEE, MMM d');
String orderDateTimeString(DateTime dateTime) =>
    _timeDayMonthDateFormat.format(dateTime);

final _timeFormat = DateFormat().addPattern('h:mm a');
String timeString(DateTime dateTime) => _timeFormat.format(dateTime);

final _dayMonthDateFormat = DateFormat().addPattern('EEE, MMM d');
String dayMonthDateString(DateTime dateTime) =>
    _dayMonthDateFormat.format(dateTime);

String timeAgoString(DateTime dateTime) => _timeAgoFormat(dateTime);

String _timeAgoFormat(DateTime dateTime) {
  return timeago.format(dateTime);
}

String _dayFromDateString(DateTime dateTime) {
  return DateFormat('EEE').format(dateTime);
}

String dayFromDateString(DateTime dateTime) => _dayFromDateString(dateTime);

String _monthFromDateString(DateTime dateTime) {
  return DateFormat('MMM').format(dateTime);
}

String monthFromDateString(DateTime dateTime) => _monthFromDateString(dateTime);

String _stringToTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' ');
}

String stringToTitleCase(String text) {
  return _stringToTitleCase(text);
}
