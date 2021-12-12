
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:heart_rate_monitor/models/Chart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:heart_rate_monitor/models/Chart.dart';

// database table and column names
final String tableMeasurements = 'measurements';
final String columnId = 'id';
final String columnResults = 'result';
final String columnDate = 'date';
final String columnImg = 'img';
final String columnGraph = 'graph';

class Measure {
  int? id;
  String result;
  String date;
  String img;
  //TODO GRAPH MUSI BYC TABLICA Z WYNIKAMI
  Uint8List graph;

  Measure({
    this.id,
    required this.result,
    required this.date,
    required this.img,
    required this.graph
  });

  //Convert Measure into a Map. The keys must correspond to the names of the
  // column in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'result': result,
      'date': date,
      'img': img,
      'graph': graph,
    };
  }
}


class DatabaseHelper {

  //Member
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await getDatabase();
    return _database;
  }

  // Open DB Connection, returns a Database instance.
  //
  Future<Database?> getDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "HeartRateMonitorDB.db"),

      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE $tableMeasurements (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnResults TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnImg TEXT NOT NULL,
            $columnGraph BLOB NOT NULL
          )
          '''
        );
      },
      version: 1,
    );
    return _database;
  }


  // Database helper methods:

  // Define a function that inserts measurements into the database
  Future<void> insertMeasure(Measure measure) async {
    final db = await getDatabase();

    await db!.insert(
      tableMeasurements,
      measure.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the measurements from the measurements table.
  Future<List<Measure>> queryAllMeasures() async {
    final db = await getDatabase();
    // Query the table for all The Measurements.
    final List<Map<dynamic, dynamic>> maps = await db!.query(tableMeasurements);

    // Convert the List<Map<String, dynamic> into a List<Measure>.
    return List.generate(maps.length, (i) {
      return Measure(
        id: maps[i][columnId],
        result: maps[i][columnResults],
        date: maps[i][columnDate],
        img: maps[i][columnImg],
        graph: maps[i][columnGraph]
      );
    });
  }


  Future<void> update(Measure measure) async {
    final db = await getDatabase();

    //Update the given measure
    await db!.update(
        tableMeasurements,
        measure.toMap(),
        // Ensure that the Measure has a matching id.
        where: '$columnId = ?',
        // Pass the Measure's id as a whereArg to prevent SQL injection.
        whereArgs: [measure.id]
    );
  }


  Future<void> deleteMeasure(int id) async {
    final db = await getDatabase();

    //Remove all the Measurement from the database
    await db!.delete(
      tableMeasurements,
      // Use a `where` clause to delete a specific measurement.
      where: '$columnId = ?',
      // Pass the Measure's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

}
