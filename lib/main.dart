import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/models/todo.dart';
import 'package:taskeu/screens/createUserScreen.dart';
import 'package:taskeu/screens/homeScreen.dart';
import 'package:taskeu/screens/splashScreen.dart';
import 'package:path/path.dart';
import 'package:taskeu/utils/date.dart';
import 'package:workmanager/workmanager.dart';

const String DB_NAME = 'official_taskeu_2.db';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(
      await getDatabasesPath(),
      DB_NAME,
    ),
    onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE user (
          id INTEGER PRIMARY KEY,
          firstName TEXT,
          middleName TEXT,
          lastName TEXT,
          username TEXT
        );
      """);
      print('Created User Table');
      await db.execute("""
        CREATE TABLE todo (
          id INTEGER PRIMARY KEY,
          title TEXT,
          date INTEGER,
          start TEXT,
          end TEXT,
          task TEXT,
          status TEXT
        );
      """);
      print('Created Todo Table');
      await db.close();
    },
    version: 1,
  );

  Workmanager().initialize(
    // The top level function, aka callbackDispatcher
    callbackDispatcher,

    // If enabled it will post a notification whenever
    // the task is running. Handy for debugging tasks
    // isInDebugMode: true,
  );
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "1",
    "simplePeriodicTask",
    frequency: const Duration(hours: 1),
  );

  await getNextTask();

  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    List<Todo> tasks = await getNextTask();
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // // app_icon needs to be a added as a drawable
    // // resource to the Android head project.
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // // initialise settings for both Android and iOS device.
    const InitializationSettings settings =
        InitializationSettings(android: android);

    flip.initialize(settings);

    tasks.forEach(
      (element) => showNotificationWithDefaultSound(flip, element),
    );
    // showNotificationWithDefaultSound(flip);
    // print('Notif');
    return Future.value(true);
  });
}

Future<List<Todo>> getNextTask() async {
  DateTime dateToday = Date(date: DateTime.now()).date;
  TimeOfDay n = TimeOfDay.now();
  TimeOfDay now = TimeOfDay.now().replacing(hour: n.hour - 1);

  String nowString = '${now.hour}:00';
  if (now.hour == -1) nowString = '24:00';

  TimeOfDay oneHourAfterNow = now.replacing(hour: now.hour - 1 + 1);
  String oneHourAfterNowString = '${oneHourAfterNow.hour + 1}:00';
  if (oneHourAfterNow.hour == 23) oneHourAfterNowString = '24:00';

  Database db = await openDatabase(
    join(await getDatabasesPath(), DB_NAME),
  );

  List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM todo WHERE date=${dateToday.millisecondsSinceEpoch} AND start >= "$nowString" AND end <= "$oneHourAfterNowString" AND status="Scheduled"');

  List<Todo> listOfTodo = list.map(
    (e) {
      return Todo(
        id: e['id'] as int,
        title: e['title'] as String,
        date: e['date'] as int,
        start: e['start'] as String,
        end: e['end'] as String,
        task: e['task'] as String,
        status: e['task'] as String,
      );
    },
  ).toList();

  return listOfTodo;
}

Future showNotificationWithDefaultSound(flip, Todo task) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '0',
    'Taskeu',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flip.show(
    0,
    'Taskeu',
    '${task.title} at ${task.start}',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      title: 'Taskeu',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromARGB(255, 236, 236, 236),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.3,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
