import 'package:sqflite/sqflite.dart';

class Migrations {
  static Future<void> createTables(Database db) async {
    await db.execute('''
        CREATE TABLE Company(
          id TEXT PRIMARY KEY,
          name TEXT
        );
      ''');

    await db.execute('''
        CREATE TABLE Location(
          id TEXT PRIMARY KEY,
          name TEXT,
          parentId TEXT,
          companyId TEXT
        );
      ''');

    await db.execute('''
        CREATE TABLE Asset(
          id TEXT PRIMARY KEY,
          name TEXT,
          locationId TEXT,
          parentId TEXT,
          sensorType TEXT,
          status TEXT,
          companyId TEXT
        );
      ''');
  }
}
