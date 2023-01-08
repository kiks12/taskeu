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

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();

  const AndroidInitializationSettings android =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // // initialise settings for both Android and iOS device.
  const InitializationSettings settings =
      InitializationSettings(android: android);

  flutterLocalNotificationsPlugin.initialize(settings);

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
      // print('Created User Table');
      await db.execute("""
        CREATE TABLE todo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          date INTEGER,
          start INTEGER,
          end INTEGER,
          task TEXT,
          status TEXT
        );
      """);
      // print('Created Todo Table');
      await db.close();
    },
    version: 1,
  );

  Workmanager().initialize(
    // The top level function, aka callbackDispatcher
    callbackDispatcher,

    // If enabled it will post a notification whenever
    // the task is running. Handy for debugging tasks
    isInDebugMode: true,
  );
  // Periodic task registration
  Workmanager().registerPeriodicTask(
    "1",
    "Taskeu",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresCharging: false,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
    ),
  );

  // List<Todo> todos = await getNextTask();
  // for (Todo todo in todos) {
  //   showNotificationWithDefaultSound(flutterLocalNotificationsPlugin, todo);
  // }

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    List<Todo> tasks = await getNextTask();
    // // app_icon needs to be a added as a drawable
    // // resource to the Android head project.
    // const AndroidInitializationSettings android =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // // // initialise settings for both Android and iOS device.
    // const InitializationSettings settings =
    //     InitializationSettings(android: android);

    // flutterLocalNotificationsPlugin.initialize(settings);

    for (Todo todo in tasks) {
      showNotificationWithDefaultSound(
        flutterLocalNotificationsPlugin,
        todo,
      );
    }
    // showNotificationWithDefaultSound(flip);
    // print('Notif');
    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future<List<Todo>> getNextTask() async {
  DateTime dateToday = Date(date: DateTime.now()).date;
  TimeOfDay n = TimeOfDay.now();
  TimeOfDay now = TimeOfDay.now().replacing(minute: n.minute - 15);

  int nowInt = int.parse('${now.hour}${now.minute}');
  if (now.minute.toString().length == 1) {
    nowInt = int.parse('${now.hour}0${now.minute}');
  }
  if (now.hour == -1) nowInt = 2400;

  TimeOfDay oneHourAfterNow = n.replacing(hour: n.hour + 1);
  int oneHourAfterNowInt =
      int.parse('${oneHourAfterNow.hour + 1}${oneHourAfterNow.minute}');
  if (oneHourAfterNow.minute.toString().length == 1) {
    oneHourAfterNowInt =
        int.parse('${oneHourAfterNow.hour}0${oneHourAfterNow.minute}');
  }
  if (oneHourAfterNow.hour == 23) oneHourAfterNowInt = 2400;

  Database db = await openDatabase(
    join(await getDatabasesPath(), DB_NAME),
  );

  List<Map<String, Object?>> list = await db.rawQuery(
      'SELECT * FROM todo WHERE date=${dateToday.millisecondsSinceEpoch} AND start >= $nowInt AND end <= $oneHourAfterNowInt AND status="Scheduled"');

  List<Todo> listOfTodo = list.map(
    (e) {
      return Todo(
        id: e['id'] as int,
        title: e['title'] as String,
        date: e['date'] as int,
        start: e['start'] as int,
        end: e['end'] as int,
        task: e['task'] as String,
        status: e['task'] as String,
      );
    },
  ).toList();

  return listOfTodo;
}

@pragma('vm:entry-point')
Future showNotificationWithDefaultSound(flip, Todo task) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '1',
    'Taskeu',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flip.show(
    1,
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
