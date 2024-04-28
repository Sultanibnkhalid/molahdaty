import 'dart:ffi';
import 'dart:io';

import 'package:my_notes/models/note_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DBHelper {
  static String noteStatment =
      "CREATE TABLE notes (id	INTEGER,content TEXT,	date	DATETIME,	time	TEXT,	img	BLOB,color	TEXT,favorite 	INTEGER, imgdata 	TEXT, parm1 	TEXT, parm2 	TEXT, parm3 	TEXT,PRIMARY KEY( id  AUTOINCREMENT))";

  static String dbName = 'path.db';

  static int dbVERSION = 1;
  static String tbNotes = 'notes';

  static var databaseFactory = databaseFactoryFfi;
  // static var database = null;
  //static String dbPath=getDatabasesPath();

  static Future<int> createDB() async {
    try {
      var path = '';
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        path = await databaseFactory.getDatabasesPath();
        var fullDBPath = p.join(path, dbName);
        var db = await databaseFactory.openDatabase(fullDBPath,
            options: OpenDatabaseOptions(
              version: dbVERSION,
              onCreate: (db, version) {
                db.execute(noteStatment).then((value) => {value});
              },
            ));
      }
      if (Platform.isAndroid) {
        path = await getDatabasesPath();
        var fullDBPath = p.join(path, dbName);
        var db = await openDatabase(
          fullDBPath,
          version: dbVERSION,
          onCreate: (db, version) {
            db.execute(noteStatment).then((value) => {value});
          },
        );
      }

      return 1;
    } catch (error) {
      return 0;
    }
  } //end creat db function

  static Future<Database?> openDB() async {
    Database? db;
    var path = '';
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      path = await databaseFactory.getDatabasesPath();
      var fullDBPath = p.join(path, dbName);
      db = await databaseFactory.openDatabase(fullDBPath,
          options: OpenDatabaseOptions(
            version: dbVERSION,
            onCreate: (db, version) {
              db.execute(noteStatment).then((value) => {value});
            },
          ));
    } else if (Platform.isAndroid) {
      path = await getDatabasesPath();
      var fullDBPath = p.join(path, dbName);
      db = await openDatabase(
        fullDBPath,
        version: dbVERSION,
        onCreate: (db, version) {
          db.execute(noteStatment).then((value) => {value});
        },
      );
    }
    return db;
  }

  static Future<int> insertNote(NoteModele note) async {
    var db = await openDB().then((value) => value);

    return await db!.rawInsert(
        "INSERT INTO notes (content,date,color,favorite)VALUES ('${note.content}','${note.date}','${note.color}',${note.isLiked});");
  }

  //function excutes query
  static Future<List<Map<String, dynamic>>> getNotes() async {
    var db = await openDB().then((value) => value);
    // var db = await openDatabase();
    return await db!.rawQuery(
        "SELECT id,content,img,imgdata,favorite,color,date,strftime('%Y-%m-%d %H:%M',date) as ti FROM notes ORDER BY date Desc; ");
  }

  //delete note
  static Future<int> deleteNote(int id) async {
    var db = await openDB().then((value) => value);
    return await db!.delete(tbNotes, where: 'id=?', whereArgs: [id]);
  }

  static Future<int> updateNote(NoteModele noteModele) async {
    var db = await openDB().then((value) => value);
    return db!.update(tbNotes, noteModele.toMap(),
        where: 'id=?', whereArgs: [noteModele.id]);
  }
}


/*

CREATE TABLE notes (id	INTEGER,	date	TEXT,	time	TEXT,	img	BLOB,color	TEXT,favorite 	INTEGER, imgdata 	TEXT, parm1 	TEXT, parm2 	TEXT, parm3 	TEXT,PRIMARY KEY( id  AUTOINCREMENT)

*/