import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/screens/createScheduleScreen.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/home/dateToday.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:taskeu/widgets/home/sevenDatesScroll.dart';
import 'package:taskeu/widgets/tasks/task.dart';
import 'package:taskeu/widgets/tasks/tasks.dart';

class TaskSchedule extends StatefulWidget {
  const TaskSchedule({
    super.key,
    required this.todos,
    required this.dates,
    required this.now,
    required this.changeDate,
    required this.chooseDate,
  });

  final List<Todo> todos;
  final List<DateTime> dates;
  final DateTime now;
  final void Function(DateTime date) changeDate;
  final void Function() chooseDate;

  @override
  State<TaskSchedule> createState() => _TaskScheduleState();
}

class _TaskScheduleState extends State<TaskSchedule> {
  // List<DateTime> sevenDays = [];
  // DateTime now = Date(date: DateTime.now()).date;

  // Future<void> getThreeDaysBeforeToday() async {
  //   for (int i = 3; i >= 1; i--) {
  //     DateTime threeDay = now.subtract(Duration(days: i));
  //     Date threeDayNormalized = Date(date: threeDay);
  //     sevenDays.add(threeDayNormalized.date);
  //   }
  // }

  // Future<void> addDateTodayToSevenDayList() async {
  //   sevenDays.add(now);
  // }

  // Future<void> getThreeFaysAfterToday() async {
  //   for (int i = 1; i <= 3; i++) {
  //     DateTime threeDay = now.add(Duration(days: i));
  //     Date threeDayNormalized = Date(date: threeDay);
  //     sevenDays.add(threeDayNormalized.date);
  //   }
  // }

  // Future<void> createSevenDaysList() async {
  //   await getThreeDaysBeforeToday();
  //   await addDateTodayToSevenDayList();
  //   await getThreeFaysAfterToday();
  //   setState(() {});
  // }

  // void changeDate(DateTime date) {
  //   now = date;
  //   setState(() {});
  //   sevenDays = [];
  //   createSevenDaysList();
  // }

  @override
  void initState() {
    super.initState();
    // createSevenDaysList();
  }

  List<Widget> getList() {
    List<Widget> wids = [];
    wids.add(DateToday(
      now: widget.now,
      chooseDate: widget.chooseDate,
    ));
    wids.add(
      SevenDatesScroll(
        dates: widget.dates,
        now: widget.now,
        changeDate: widget.changeDate,
      ),
    );
    if (widget.todos.isEmpty) {
      wids.add(
        const Center(
          child: ExText(text: 'No Tasks'),
        ),
      );
    } else {
      for (var element in TaskUtils(todos: widget.todos).todos) {
        wids.add(Task(task: element));
      }
    }
    return wids;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getList(),
          ),
        ),
      ],
    );
  }
}
