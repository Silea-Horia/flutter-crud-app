import 'dart:developer';

import 'package:exam_prep/model/model.dart';
import 'package:exam_prep/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  final ApiService apiService = ApiService();
  ValueNotifier<Map<int, Payment>?> itemsById = ValueNotifier(null);
  late Database database;
  final String tableName = 'Payments';

  Repository() {
    init();
  }

  void init() async {
    await _openDb();
    getAll();
  }

  Future<void> _openDb() async {
    log('Opening db');
    database = await openDatabase(
      join(await getDatabasesPath(), 'exam_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, date TEXT, amount INTEGER, type TEXT, category TEXT, description TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, date TEXT, amount INTEGER, type TEXT, category TEXT, description TEXT)',
          );
        }
      },
      version: 4,
    );
  }

  void getAll() async {
    itemsById.value = null;
    var items = await _fetchAll();
    if (items != null) {
      log('Refreshing db');
      itemsById.value = {for (var t in items) t.id: t};
      await database.delete(tableName);
      for (var t in items) {
        await database.insert(tableName, t.toJson());
      }
    }
  }

  Future<List<Payment>?> _fetchAll() async {
    try {
      var response = await apiService.getAll();
      return response;
    } on Exception {
      log('Failed to fetch data from the server.');
      return null;
    }
  }

  Future<void> create(Payment item) async {
    if (itemsById.value == null) {
      throw Exception("Device is offline. Try again later.");
    }
    try {
      item = await apiService.post(item);
      var temp = Map<int, Payment>.from(itemsById.value ?? {});
      temp[item.id] = item;
      itemsById.value = temp;
      log('Inserting data in db');
      await database.insert(
        tableName,
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception {
      throw Exception("Device is offline. Try again later.");
    }
  }

  Future<Payment> getById(int id) async {
    if (itemsById.value == null) {
      throw Exception("Device is offline. Try again later.");
    }
    if (itemsById.value!.containsKey(id)) {
      return itemsById.value![id]!;
    }
    var item = await apiService.getById(id);
    return item;
  }

  Future<void> delete(int id) async {
    if (itemsById.value == null) {
      throw Exception("Device is offline. Try again later.");
    }

    try {
      await apiService.delete(id);
    } on Exception {
      throw Exception("Device is offline. Try again later.");
    }

    log('Deleting data from db');
    await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
    var temp = Map<int, Payment>.from(itemsById.value!);
    temp.remove(id);
    itemsById.value = temp;
  }
}
