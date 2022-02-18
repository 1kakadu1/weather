import 'dart:developer';
import 'dart:io';

import 'package:demo/model/city.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  String cityTable = 'City';
  String columnId = 'id';
  String columnName = 'name';
  String lat = "lat";
  String lon = "lon";

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'Student.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $cityTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT , $lat DOUBLE, $lon DOUBLE)',
    );
  }

  // READ
  Future<List<City>> getCity() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> cityMapList = await db.query(cityTable);
    final List<City> cityList = [];
    cityMapList.forEach((cityMap) {
      cityList.add(City.fromMap(cityMap));
    });
    log(cityList.toString());
    return cityList;
  }

  // INSERT
  Future<City> insertCity(City student) async {
    Database db = await this.database;
    student.id = await db.insert(cityTable, student.toMap());
    return student;
  }

  // UPDATE
  Future<int> updateStudent(City student) async {
    Database db = await this.database;
    return await db.update(
      cityTable,
      student.toMap(),
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    Database db = await this.database;
    return await db.delete(
      cityTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
