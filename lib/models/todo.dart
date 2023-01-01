import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Todo {
  final int id;
  final String title;
  final int date;
  final String start;
  final String end;
  final String task;
  final String status;

  const Todo({
    required this.id,
    required this.title,
    required this.date,
    required this.start,
    required this.end,
    required this.task,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'start': start,
      'end': end,
      'task': task,
      'status': status,
    };
  }

  void insertUserToDB() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'official_taskeu_2.db'),
    );

    await db.insert('todo', toMap(), conflictAlgorithm: ConflictAlgorithm.fail);

    await db.close();
  }
}
