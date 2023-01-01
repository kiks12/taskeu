import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taskeu/screens/createUserScreen.dart';
import 'package:taskeu/screens/homeScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskeu/widgets/extended/exText.dart';
import 'package:path/path.dart' as path;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void showNextScreen(dynamic nextScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  void timerCallback() async {
    Database db = await openDatabase(
      path.join(await getDatabasesPath(), 'official_taskeu_2.db'),
      version: 10,
    );

    int? count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM user'),
    );

    if (count == 0) return showNextScreen(const UserCreationScreen());
    showNextScreen(const HomeScreen());
  }

  @override
  void initState() {
    Timer(
      const Duration(
        seconds: 2,
      ),
      timerCallback,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ExText(
          text: 'Taskeu.',
          weight: FontWeight.w600,
          size: 40,
        ),
      ),
    );
  }
}
