import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bean_info.dart';
import '../models/roast_info.dart';
import '../models/cupping_result.dart';
// import '../models/drink.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // 初回アクセス時にデータベースを初期化
    _database = await _initDatabase();
    return _database!;
  }

  // データベースの初期化
  Future<Database> _initDatabase() async {
    // データベースファイルのパスを取得
    String path = join(await getDatabasesPath(), 'roast_logger.db');
    // データベースを開く
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // テーブルの作成
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE green_beans (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        origin TEXT,
        process TEXT
      )
    ''');
  }

  printBeans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('green_beans');
    print(maps);
  }

  // Beanの取得
  Future<List<BeanInfo>> getBeans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('green_beans');
    return List.generate(maps.length, (i) {
      return BeanInfo.fromMap(maps[i]);
    });
  }

  // Beanの挿入
  Future<void> insertGreenBean(BeanInfo bean) async {
    final db = await database;
    try {
      await db.insert(
        'green_beans',
        bean.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  // Beanの更新
  Future<void> updateBeanInfo(BeanInfo bean) async {
    final db = await database;
    try {
      await db.update(
        'green_beans',
        bean.toMap(),
        where: 'id = ?',
        whereArgs: [bean.id], 
      );
    } catch (e) {
      print(e);
    }
  }

  // Beanの削除
  Future<void> deleteBeanInfo(String id) async {
    final db = await database;
    try {
      await db.delete(
        'green_beans',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }

}
