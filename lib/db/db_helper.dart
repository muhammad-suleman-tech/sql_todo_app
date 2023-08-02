import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqlite_todo_app/modals/todo_modal.dart';


class DatabaseHelper {
  // database
  DatabaseHelper._privateConstructor(); // Name constructor to create instance of database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // getter for database

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS
    // to store database

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/student.db';

    // open/ create database at a given path
    var studentsDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return studentsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE tbl_student (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT,
                  age INTEGER )
    
    ''');
  }
  // save data in database

  Future<int> saveStudent(Student student) async {

    Database db = await instance.database;
    int result = await db.insert('tbl_student', student.toMap());
    return result;

  }

  // retrieve data from database
 Future<List<Student>> getAllStudent() async {
    List<Student> students = [];
    Database db = await instance.database;
     List<Map<String, dynamic>> mapValues = await  db.query('tbl_student');
    for( var stdMap in mapValues){
      Student student = Student.fromMap(stdMap);
      students.add(student);
    }
   await Future.delayed(const Duration(seconds: 3));
    return students;
}

// delete the item from database

Future<int> deleteStudent(Student student ) async {
    Database db = await instance.database;
    int result = await db.delete('tbl_student', where: 'id=?', whereArgs: [student.id]);
    return result;
  }



}