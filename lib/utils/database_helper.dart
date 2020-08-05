import 'dart:io';
import 'dart:async';

import 'package:notes/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton Database Helper
  static sqflite.Database _database; //Singleton Database

  String noteTable = 'note_table';
  String noteId = 'id';
  String noteTitle = 'title';
  String noteDate = 'date';
  String notePriority = 'priority';
  String noteDescription = 'description';

  DatabaseHelper._createInstance(); //Named constructor to create instance of Database Helper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); //This is to be executed only once, Singleton Object
    }
    return _databaseHelper;
  }

  Future<sqflite.Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<sqflite.Database> initializeDatabase() async {
    //Get Directory Path iOS and Android
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/ Create the Database
    var notesDatabase =
        await sqflite.openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(sqflite.Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($noteId INTEGER PRIMARY KEY AUTOINCREMENT, $noteTitle TEXT, $noteDescription TEXT, $notePriority INTEGER, $noteDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    sqflite.Database db = await this.database;

    var result = await db.query(noteTable, orderBy: '$notePriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    sqflite.Database db = await this.database;

    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    sqflite.Database db = await this.database;

    var result = await db.update(noteTable, note.toMap(),
        where: '$noteId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;

    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $noteId = $id');
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = sqflite.Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {

    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    for(int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

}
