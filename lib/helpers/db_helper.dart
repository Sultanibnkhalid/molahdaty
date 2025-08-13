import 'dart:io';
import 'package:molahdaty/models/note_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DBHelper {
  static const String _noteTable = 'notes';
  static const String _dbName = 'path.db';
  static const int _dbVersion = 1;

  static const String _createNoteTable = '''
    CREATE TABLE $_noteTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT,
      date DATETIME,
      time TEXT,
      img BLOB,
      color TEXT,
      favorite INTEGER,
      imgdata TEXT,
      parm1 TEXT,
      parm2 TEXT,
      parm3 TEXT
    )
  ''';

  static final DatabaseFactory _databaseFactory = databaseFactoryFfi;
  static Database? _database; // Singleton database instance

  // Initialize the database (call this once at app startup)
  static Future<void> initialize() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    _database = await _openDatabase();
  }

  static Future<Database> _openDatabase() async {
    final databasesPath = await _getDatabasesPath();
    final path = p.join(databasesPath, _dbName);

    return await (Platform.isWindows || Platform.isLinux
        ? _databaseFactory.openDatabase(
            path,
            options: OpenDatabaseOptions(
              version: _dbVersion,
              onCreate: _onCreate,
            ),
          )
        : openDatabase(
            path,
            version: _dbVersion,
            onCreate: _onCreate,
          ));
  }

  static Future<String> _getDatabasesPath() async {
    return Platform.isWindows || Platform.isLinux
        ? await _databaseFactory.getDatabasesPath()
        : await getDatabasesPath();
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createNoteTable);
  }

  // Get the database instance (uses singleton pattern)
  static Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  // Note CRUD operations
  static Future<int> insertNote(NoteModele note) async {
    final db = await _db;
    return await db.insert(
      _noteTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await _db;
    return await db.rawQuery('''
      SELECT 
        id, content, img, imgdata, favorite, color, date, 
        strftime('%Y-%m-%d %H:%M', date) as ti 
      FROM $_noteTable 
      ORDER BY date DESC
    ''');
  }

  static Future<int> deleteNote(int id) async {
    final db = await _db;
    return await db.delete(
      _noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> updateNote(NoteModele note) async {
    final db = await _db;
    return await db.update(
      _noteTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Close the database when no longer needed
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

// import 'dart:io';

// import 'package:molahdaty/models/note_model.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:path/path.dart' as p;

// class DBHelper {
//   static String noteStatment =
//       "CREATE TABLE notes (id	INTEGER,content TEXT,	date	DATETIME,	time	TEXT,	img	BLOB,color	TEXT,favorite 	INTEGER, imgdata 	TEXT, parm1 	TEXT, parm2 	TEXT, parm3 	TEXT,PRIMARY KEY( id  AUTOINCREMENT))";

//   static String dbName = 'path.db';

//   static int dbVERSION = 1;
//   static String tbNotes = 'notes';

//   static var databaseFactory = databaseFactoryFfi;
//   // static var database = null;
//   //static String dbPath=getDatabasesPath();

//   static Future<int> createDB() async {
//     try {
//       var path = '';
//       if (Platform.isAndroid) {
//         path = await getDatabasesPath();
//         var fullDBPath = p.join(path, dbName);
//         var db = await openDatabase(
//           fullDBPath,
//           version: dbVERSION,
//           onCreate: (db, version) {
//             db.execute(noteStatment).then((value) => {value});
//           },
//         );
//       }
//       if (Platform.isWindows || Platform.isLinux) {
//         sqfliteFfiInit();
//         path = await databaseFactory.getDatabasesPath();
//         var fullDBPath = p.join(path, dbName);
//         var db = await databaseFactory.openDatabase(fullDBPath,
//             options: OpenDatabaseOptions(
//               version: dbVERSION,
//               onCreate: (db, version) {
//                 db.execute(noteStatment).then((value) => {value});
//               },
//             ));
//       }

//       return 1;
//     } catch (error) {
//       return 0;
//     }
//   } //end creat db function

//   static Future<Database?> openDB() async {
//     Database? db;
//     var path = '';
//     if (Platform.isWindows || Platform.isLinux) {
//       sqfliteFfiInit();
//       path = await databaseFactory.getDatabasesPath();
//       var fullDBPath = p.join(path, dbName);
//       db = await databaseFactory.openDatabase(fullDBPath,
//           options: OpenDatabaseOptions(
//             version: dbVERSION,
//             onCreate: (db, version) {
//               db.execute(noteStatment).then((value) => {value});
//             },
//           ));
//     } else if (Platform.isAndroid) {
//       path = await getDatabasesPath();
//       var fullDBPath = p.join(path, dbName);
//       db = await openDatabase(
//         fullDBPath,
//         version: dbVERSION,
//         onCreate: (db, version) {
//           db.execute(noteStatment).then((value) => {value});
//         },
//       );
//     }
//     return db;
//   }

//   static Future<int> insertNote(NoteModele note) async {
//     var db = await openDB().then((value) => value);

//     return await db!.rawInsert(
//         "INSERT INTO notes (content,date,color,favorite)VALUES ('${note.content}','${note.date}','${note.color}',${note.isLiked});");
//   }

//   //function excutes query
//   static Future<List<Map<String, dynamic>>> getNotes() async {
//     var db = await openDB().then((value) => value);
//     // var db = await openDatabase();
//     return await db!.rawQuery(
//         "SELECT id,content,img,imgdata,favorite,color,date,strftime('%Y-%m-%d %H:%M',date) as ti FROM notes ORDER BY date Desc; ");
//   }

//   //delete note
//   static Future<int> deleteNote(int id) async {
//     var db = await openDB().then((value) => value);
//     return await db!.delete(tbNotes, where: 'id=?', whereArgs: [id]);
//   }

//   static Future<int> updateNote(NoteModele noteModele) async {
//     var db = await openDB().then((value) => value);
//     return db!.update(tbNotes, noteModele.toMap(),
//         where: 'id=?', whereArgs: [noteModele.id]);
//   }
// }
