import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/widgets/dateToday.dart';
import 'package:taskeu/widgets/sevenDatesScroll.dart';
import 'package:taskeu/widgets/tasks.dart';

class TaskSchedule extends StatefulWidget {
  const TaskSchedule({super.key});

  @override
  State<TaskSchedule> createState() => _TaskScheduleState();
}

class _TaskScheduleState extends State<TaskSchedule> {
  List<DateTime> sevenDays = [];
  DateTime now = Date(date: DateTime.now()).date;

  Future<void> getThreeDaysBeforeToday() async {
    for (int i = 3; i >= 1; i--) {
      DateTime threeDay = now.subtract(Duration(days: i));
      Date threeDayNormalized = Date(date: threeDay);
      sevenDays.add(threeDayNormalized.date);
    }
  }

  Future<void> addDateTodayToSevenDayList() async {
    sevenDays.add(now);
  }

  Future<void> getThreeFaysAfterToday() async {
    for (int i = 1; i <= 3; i++) {
      DateTime threeDay = now.add(Duration(days: i));
      Date threeDayNormalized = Date(date: threeDay);
      sevenDays.add(threeDayNormalized.date);
    }
  }

  Future<void> createSevenDaysList() async {
    await getThreeDaysBeforeToday();
    await addDateTodayToSevenDayList();
    await getThreeFaysAfterToday();
    setState(() {});
  }

  void changeDate(DateTime date) {
    now = date;
    setState(() {});
    sevenDays = [];
    createSevenDaysList();
  }

  @override
  void initState() {
    super.initState();
    createSevenDaysList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DateToday(now: now),
          SevenDatesScroll(
            dates: sevenDays,
            now: now,
            changeDate: changeDate,
          ),
          Tasks(day: now.millisecondsSinceEpoch),
        ],
      ),
    );
  }
}
