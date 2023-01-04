import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/screens/createScheduleScreen.dart';
import 'package:taskeu/utils/date.dart';
import 'package:taskeu/utils/taskUtils.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:path/path.dart' as path;
import 'package:taskeu/widgets/home/createScheduleButton.dart';
import 'package:taskeu/widgets/home/searchBar.dart';
import 'package:taskeu/widgets/home/welcomeComponent.dart';
import 'package:taskeu/widgets/tasks/taskSchedule.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final searchBarController = TextEditingController();
  Database? db;
  List<DateTime> sevenDays = [];
  DateTime? now = Date(date: DateTime.now()).date;
  String username = '';
  int scheduledCount = 0;

  Future<void> getThreeDaysBeforeToday() async {
    for (int i = 3; i >= 1; i--) {
      DateTime threeDay = now!.subtract(Duration(days: i));
      Date threeDayNormalized = Date(date: threeDay);
      sevenDays.add(threeDayNormalized.date);
    }
  }

  Future<void> addDateTodayToSevenDayList() async {
    sevenDays.add(now!);
  }

  Future<void> getThreeFaysAfterToday() async {
    for (int i = 1; i <= 3; i++) {
      DateTime threeDay = now!.add(Duration(days: i));
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

  void chooseDate() async {
    now = await showDatePicker(
      context: context,
      initialDate: now!,
      firstDate: DateTime(1800),
      lastDate: DateTime(2050),
    );
    sevenDays = [];
    createSevenDaysList();
    await openDB();
    setState(() {});
  }

  void changeDate(DateTime date) async {
    now = date;
    sevenDays = [];
    createSevenDaysList();
    setState(() {});
    await openDB();
  }

  Future<void> openDB() async {
    db = await openDatabase(
        path.join(await getDatabasesPath(), 'official_taskeu_2.db'));
    await queryTasksOfDate();
    await getUsername();
    await getCountOfScheduledTasks();
  }

  Future<void> getUsername() async {
    username = (await db!.rawQuery('SELECT username FROM user WHERE id=0'))[0]
        ['username'] as String;
    setState(() {});
  }

  Future<void> getCountOfScheduledTasks() async {
    scheduledCount = Sqflite.firstIntValue(await db!.rawQuery(
        "SELECT COUNT(*) FROM todo WHERE date >= ${now!.millisecondsSinceEpoch} AND status='Scheduled'"))!;
    setState(() {});
  }

  Future<void> queryTasksOfDate() async {
    final List<dynamic> tasks = await db!.rawQuery(
        'SELECT * FROM todo WHERE date=${now!.millisecondsSinceEpoch} ORDER BY start ASC');

    if (tasks.isNotEmpty) {
      todos = tasks.map(((e) {
        return Todo(
          id: e['id'],
          title: e['title'],
          date: e['date'],
          start: e['start'],
          end: e['end'],
          task: e['task'],
          status: e['status'],
        );
      })).toList();
      todos = TaskUtils(todos: todos).todos;
    } else {
      todos = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    createSevenDaysList();
    openDB();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const Header(),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return WelcomeComponent(
                avatarLetter: (username.isNotEmpty) ? username[0] : "",
                scheduledCount: scheduledCount,
                username: username,
              );
            }

            if (index == 1) {
              return SearchBar(
                searchTodo: () {},
                controller: searchBarController,
              );
            }

            return TaskSchedule(
              todos: todos,
              changeDate: changeDate,
              chooseDate: chooseDate,
              dates: sevenDays,
              now: now!,
            );
          },
        ),
      ),
      bottomNavigationBar: const CreateScheduleButton(),
    );
  }
}
