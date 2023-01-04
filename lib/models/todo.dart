import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskeu/main.dart';
import 'package:taskeu/screens/homeScreen.dart';

class Todo {
  final int id;
  final String title;
  final int date;
  final String start;
  final String end;
  final String task;
  String status;

  Todo({
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

  void changeStatus(String newStatus) async {
    if (newStatus == SCHEDULED_TASK) status = 'Scheduled';
    if (newStatus == CANCELLED_TASK) status = 'Cancelled';
    if (newStatus == COMPLETED_TASK) status = 'Completed';

    final db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
    );

    await db.update(
      'todo',
      toMap(),
      where: 'id=$id',
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await db.close();
  }

  void insertTodoToDB() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
    );

    await db.insert('todo', toMap(), conflictAlgorithm: ConflictAlgorithm.fail);

    await db.close();
  }

  void deleteTodo() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
    );

    await db.delete('todo', where: 'id=$id');

    await db.close();
  }
}
