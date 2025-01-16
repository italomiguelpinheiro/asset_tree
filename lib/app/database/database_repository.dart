import 'package:asset_tree/app/database/migrations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/models/location.dart';
import 'package:asset_tree/app/models/asset.dart';

import 'package:flutter/foundation.dart';

class DatabaseRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'asset_tree.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await Migrations.createTables(db);
  }

  Future<void> insertCompany(Company company) async {
    final db = await database;
    await db.insert('Company', company.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  List<Map<String, dynamic>> _prepareLocationInsertData(
      Map<String, dynamic> args) {
    final locations = args['locations'] as List<Location>;
    final companyId = args['companyId'] as String;

    return locations.map((location) {
      return {
        'id': location.id,
        'name': location.name,
        'parentId': location.parentId,
        'companyId': companyId,
      };
    }).toList();
  }

  Future<void> insertLocations(
      List<Location> locations, String companyId) async {
    final db = await database;

    final entries = await compute(
      _prepareLocationInsertData,
      {'locations': locations, 'companyId': companyId},
    );

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var entry in entries) {
        batch.insert(
          'Location',
          entry,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true, continueOnError: true);
    });
  }

  List<Map<String, dynamic>> _prepareAssetInsertData(
      Map<String, dynamic> args) {
    final assets = args['assets'] as List<Asset>;
    final companyId = args['companyId'] as String;

    return assets.map((asset) {
      return {
        'id': asset.id,
        'name': asset.name,
        'locationId': asset.locationId,
        'parentId': asset.parentId,
        'sensorType': asset.sensorType,
        'status': asset.status,
        'companyId': companyId,
      };
    }).toList();
  }

  Future<void> insertAssets(List<Asset> assets, String companyId) async {
    final db = await database;

    final entries = await compute(
      _prepareAssetInsertData,
      {'assets': assets, 'companyId': companyId},
    );

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var entry in entries) {
        batch.insert(
          'Asset',
          entry,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true, continueOnError: true);
    });
  }

  Future<List<Company>> getCompanies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Company');
    return List.generate(maps.length, (i) {
      return Company.fromJson(maps[i]);
    });
  }

  Future<List<Location>> getLocations(String companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Location',
      where: 'companyId = ?',
      whereArgs: [companyId],
    );

    return List.generate(maps.length, (i) {
      return Location(
        id: maps[i]['id'],
        name: maps[i]['name'],
        parentId: maps[i]['parentId'],
      );
    });
  }

  Future<List<Asset>> getAssets(String companyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Asset',
      where: 'companyId = ?',
      whereArgs: [companyId],
    );

    return List.generate(maps.length, (i) {
      return Asset(
        id: maps[i]['id'],
        name: maps[i]['name'],
        locationId: maps[i]['locationId'],
        parentId: maps[i]['parentId'],
        sensorType: maps[i]['sensorType'],
        status: maps[i]['status'],
      );
    });
  }
}
