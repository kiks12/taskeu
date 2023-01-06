import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskeu/main.dart';
import 'package:taskeu/screens/homeScreen.dart';

class Todos {
  final List<Todo> todos;

  const Todos({required this.todos});

  Future insertTodosToDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
    );

    Batch batch = db.batch();
    for (Todo todo in todos) {
      if (todo.status != 'Free') {
        batch.insert(
          'todo',
          todo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
        print(todo);
      }
    }
    await batch.commit(noResult: true);
    await db.close();
  }
}

class Todo {
  final int id;
  final String title;
  final int date;
  final int start;
  final int end;
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
