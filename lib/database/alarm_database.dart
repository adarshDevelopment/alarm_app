import 'package:alarm_clock_self/models/alarm_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AlarmDatabase {
  static final AlarmDatabase instance = AlarmDatabase._initialize();
  AlarmDatabase._initialize();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initialize();
      return _database!;
    }
  }

  Future<String> get fullPath async {
    const name = 'alarmDraft5.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _create,
      onConfigure: _onConfigure,
    );
    return database;
  }

  Future _create(Database database, int version) async {
    const standardTextNotNull = 'TEXT NOT NULL';
    const standardText = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    try {
      await database.execute('''CREATE TABLE $alarmTable (
        ${AlarmFields.id} INTEGER PRIMARY KEY,
        ${AlarmFields.isActive} $boolType,
        ${AlarmFields.description} $standardText,
        ${AlarmFields.alarmDate} $standardText,
        ${AlarmFields.onRepeat} $boolType,
        ${AlarmFields.deleteAfterOnce} $boolType,
        ${AlarmFields.vibrate} $boolType
      );
    ''');

      await database.execute('''
        CREATE TABLE $repeatingDaysTable (
          ${AlarmFields.id} INTEGER PRIMARY KEY,
          ${RepeatingDaysFields.sunday} $boolType,
          ${RepeatingDaysFields.monday} $boolType,
          ${RepeatingDaysFields.tuesday} $boolType,
          ${RepeatingDaysFields.wednesday} $boolType,
          ${RepeatingDaysFields.thursday} $boolType,
          ${RepeatingDaysFields.friday} $boolType,
          ${RepeatingDaysFields.saturday} $boolType,
          FOREIGN KEY (${RepeatingDaysFields.id}) references $alarmTable (id)
        );
      ''');
    } catch (e) {
      print('create table exception: ${e.toString()}');
    }
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future createAlarm(AlarmModel alarmModel) async {
    print('alarm id in createAlarm: ${alarmModel.id}');
    try {
      final db = await instance.database;
      var result = await db!.insert(alarmTable, alarmModel.toJson());
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  Future getAllAlarms() async {
    try {
      final db = await instance.database;
      var result = await db!.query(alarmTable,
          columns: AlarmFields.alarmFieldsList, orderBy: AlarmFields.alarmDate);
      return result.map((e) => AlarmModel.fromJson(e)).toList();
    } catch (e) {
      return e.toString();
    }
  }

  Future updateAlarm(AlarmModel alarmModel) async {
    try {
      final db = await instance.database;
      await db!.update(alarmTable, alarmModel.toJson(),
          where: '${AlarmFields.id} = ?', whereArgs: [alarmModel.id]);
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteAlarm(AlarmModel alarmModel) async {
    print('alarm ID from deltet database: ${alarmModel.id} ');
    try {
      final db = await instance.database;
      // var result = await db!.delete(alarmTable);
      var result = await db!.delete(alarmTable,
          where: '${AlarmFields.id} = ?', whereArgs: [alarmModel.id]);
      print('result inside detletAlarm: $result');
    } catch (e) {
      return e.toString();
    }
  }

  Future createRepeatingDays(RepeatingDays repeatingDays) async {
    try {
      final db = await instance.database;
      var result = await db!.insert(repeatingDaysTable, repeatingDays.toJson());
      return ('repeating days workd, result: $result');
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteRepeatingDays(AlarmModel alarmModel) async {
    print('alarmModel id: ${alarmModel.id}');
    try {
      print('inisde deleteRepeatingDays');
      final db = await instance.database;
      var result = await db!.delete(
        repeatingDaysTable,
        where: '${AlarmFields.id} = ?',
        whereArgs: [alarmModel.id],
      );
    } catch (e) {
      return e.toString();
    }
  }

  Future getRepeatingDays(int id) async {
    try {
      final db = instance._database;
      var result = await db!.query(repeatingDaysTable,
          columns: RepeatingDaysFields.repeatingDaysFieldsList,
          where: '${RepeatingDaysFields.id} = ?',
          whereArgs: [id]);
      return result.isNotEmpty ? RepeatingDays.fromJson(result.first) : false;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateRepeatingDays(RepeatingDays repeatingDays) async {
    print('inside update repeating days');
    try {
      final db = await instance.database;
      var result = await db!.update(repeatingDaysTable, repeatingDays.toJson(),
          where: '${RepeatingDaysFields.id} = ?',
          whereArgs: [repeatingDays.id]);
      print('repeating days toJson: ${repeatingDays.toJson()}');
      print('update result: $result');
    } catch (e) {
      return e.toString();
    }
  }
}
