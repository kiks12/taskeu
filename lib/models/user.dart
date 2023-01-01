import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;

  const User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'username': username,
    };
  }

  void insertUserToDB() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'official_taskeu_2.db'),
    );

    await db.insert('user', toMap(), conflictAlgorithm: ConflictAlgorithm.fail);

    await db.close();
  }
}
