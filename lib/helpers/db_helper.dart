import 'dart:ffi';

import 'package:my_notes/models/note_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DBHelper {
  static String noteStatment =
      "CREATE TABLE notes (id	INTEGER,content TEXT,	date	TEXT,	time	TEXT,	img	BLOB,color	TEXT,favorite 	INTEGER, imgdata 	TEXT, parm1 	TEXT, parm2 	TEXT, parm3 	TEXT,PRIMARY KEY( id  AUTOINCREMENT))";

  static String dbName = 'path.db';

  static int dbVERSION = 1;
  static String tbNotes = 'notes';

  static var databaseFactory = databaseFactoryFfi;
  // static var database = null;
  //static String dbPath=getDatabasesPath();

  static Future<int> createDB() async {
    try {
      sqfliteFfiInit();
      var path = await databaseFactory.getDatabasesPath();
      var fullDBPath = p.join(path, dbName);
      var db = await databaseFactory.openDatabase(fullDBPath,
          options: OpenDatabaseOptions(
            version: dbVERSION,
            onCreate: (db, version) {
              db.execute(noteStatment).then((value) => {value});
            },
          ));

      return 1;
    } catch (error) {
      return 0;
    }
  } //end creat db function

  static Future<int> insertNote(NoteModele note) async {
    sqfliteFfiInit();
    var path = await databaseFactory.getDatabasesPath();
    var fullDBPath = p.join(path, dbName);
    var db = await databaseFactory.openDatabase(
      fullDBPath,
      options: OpenDatabaseOptions(
        version: dbVERSION,
        onCreate: (db, version) {
          db.execute(noteStatment).then((value) => {value});
        },
      ),
    );
    return await db.rawInsert(
        "INSERT INTO notes (content,date,color,favorite)VALUES ('${note.content}','${note.date}','${note.color}',${note.isLiked});");
  }

  //function excutes query
  static Future<List<Map<String, dynamic>>> getNotes() async {
    sqfliteFfiInit();
    var path = await databaseFactory.getDatabasesPath();
    var fullDBPath = p.join(path, dbName);
    var db = await databaseFactory.openDatabase(
      fullDBPath,
      options: OpenDatabaseOptions(
        version: dbVERSION,
        onCreate: (db, version) {
          db.execute(noteStatment).then((value) => {value});
        },
      ),
    );
    return await db.rawQuery(
        "SELECT id,content,img,imgdata,favorite,color,date as dt FROM notes ORDER BY dt Desc; ");
  }
}


/*

CREATE TABLE notes (id	INTEGER,	date	TEXT,	time	TEXT,	img	BLOB,color	TEXT,favorite 	INTEGER, imgdata 	TEXT, parm1 	TEXT, parm2 	TEXT, parm3 	TEXT,PRIMARY KEY( id  AUTOINCREMENT)

*/