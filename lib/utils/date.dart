import 'package:intl/intl.dart';

class Date {
  DateTime date;

  Date({required this.date}) {
    date = normalize();
  }

  DateTime normalize() {
    return DateTime.parse(DateFormat("yyyy-MM-dd").format(date));
  }
}
