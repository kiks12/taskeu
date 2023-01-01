import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/screens/createUserScreen.dart';
import 'package:taskeu/screens/homeScreen.dart';
import 'package:taskeu/screens/splashScreen.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(
      await getDatabasesPath(),
      'official_taskeu_2.db',
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
