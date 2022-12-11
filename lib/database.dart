import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/lat_long_model.dart';
import 'utils/utils.dart';

class DatabaseRepository {
  Database? _database;
  static final DatabaseRepository instance = DatabaseRepository._init();
  DatabaseRepository._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('localization.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    await db.execute('''
create table ${AppConsts.tableName} ( 
  ${AppConsts.id} integer primary key autoincrement, 
  ${AppConsts.latitude} real not null,
   ${AppConsts.longitude} real not null)
''');
  }

  Future<void> addLatLngs({required LatLongModel latLng}) async {
    try {
      final db = await database;
      db.insert(AppConsts.tableName, latLng.toMap());
    } catch (e) {
      logger(e.toString());
    }
  }

  Future<List<LatLongModel>> getAllLatLngs() async {
    final db = await instance.database;

    final result = await db.query(AppConsts.tableName);

    return result.map((json) => LatLongModel.fromMap(json)).toList();
  }
}
