import 'package:flutter/material.dart';
import 'package:taskeu/widgets/extended/exText.dart';

class WelcomeComponent extends StatefulWidget {
  const WelcomeComponent({
    super.key,
    required this.username,
    required this.avatarLetter,
    required this.scheduledCount,
  });

  final String username;
  final String avatarLetter;
  final int scheduledCount;

  @override
  State<WelcomeComponent> createState() => WelcomeComponentState();
}

class WelcomeComponentState extends State<WelcomeComponent> {
  // DateTime now = Date(date: DateTime.now()).date;
  // String? username;
  // String? avaterLetter;
  // int? scheduledCount;
  // late Database db;

  // Future<void> openDB() async {
  //   db = await openDatabase(
  //     path.join(await getDatabasesPath(), 'official_taskeu_2.db'),
  //   );
  // }

  // Future<void> getUsername() async {
  //   username = (await db.rawQuery('SELECT * FROM user WHERE id=0'))[0]
  //       ['username'] as String;
  // }

  // Future<void> getScheduledTasks() async {
  //   scheduledCount = Sqflite.firstIntValue(await db.rawQuery(
  //       'SELECT COUNT(*) FROM todo WHERE date >= ${now.millisecondsSinceEpoch}'));
  // }

  // Future<void> getAvatarLetter() async {
  //   avaterLetter =
  //       ((await db.rawQuery('SELECT firstName FROM user WHERE id=0'))[0]
  //           ['firstName'] as String)[0];
  //   setState(() {});
  // }

  // Future<void> initStateCallback() async {
  //   await openDB();
  //   await getUsername();
  //   await getScheduledTasks();
  //   await getAvatarLetter();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initStateCallback();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExText(
                text:
                    (widget.username.isNotEmpty) ? 'Hi ${widget.username}' : '',
                size: 24,
                weight: FontWeight.w600,
              ),
              ExText(
                text: '${widget.scheduledCount} Scheduled Tasks',
                size: 12,
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.black87,
            child: ExText(
              text: widget.avatarLetter.toUpperCase(),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
