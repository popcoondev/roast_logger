import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/green_bean.dart';
import '../models/roast_bean.dart';
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
        createdAt TEXT,
        updatedAt TEXT,
        name TEXT NOT NULL,
        origin TEXT,
        process TEXT,
        variety TEXT,
        farmName TEXT,
        altitude TEXT,
        description TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE roast_beans (
        id TEXT PRIMARY KEY,
        createdAt TEXT,
        updatedAt TEXT,
        date TEXT ,
        time TEXT,
        roaster TEXT,
        preRoastWeight TEXT,
        postRoastWeight TEXT,
        roastTime TEXT,
        roastLevel TEXT,
        roastLevelName TEXT,
        description TEXT,
        notes TEXT,
        greenBeanId TEXT
      )
    ''');
  }

  // GreenBeanテーブル操作　-----------------------------------------------------

  printBeans() async {
    print('printBeans');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('green_beans');
    print(maps);
  }

  // Beanの取得
  Future<List<GreenBean>> getBeans() async {
    print('getBeans');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('green_beans');
    return List.generate(maps.length, (i) {
      return GreenBean.fromMap(maps[i]);
    });
  }

  Future<GreenBean?> getBeanById(String id) async {
    print('getBeanById');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'green_beans',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GreenBean.fromMap(maps.first);
    } else {
      print('No GreenBean found for id: $id');
      return null;  // データが見つからない場合に null を返す
    }
  }

  // Beanの挿入
  Future<void> insertGreenBean(GreenBean bean) async {
    print('insertGreenBean');
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
  Future<void> updateBeanInfo(GreenBean bean) async {
    print('updateBeanInfo');    
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
    print('deleteBeanInfo');
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

  // green_beansテーブルの削除
  // getDatabasesPath(), 'roast_logger.db'のファイルを削除する
  Future<void> deleteGreenBeansTable() async {
    print('deleteGreenBeansTable');
    final db = await database;
    try {
      await db.execute('DROP TABLE IF EXISTS green_beans');

      // テーブルを再作成する
      await _onCreate(db, 1);  // バージョンに応じて設定
      print('green_beansテーブルを再作成しました。');
    } catch (e) {
      print(e);
    }
  }

  // RoastBeanテーブル操作　-----------------------------------------------------
  printRoastBeans() async {
    print('printRoastBeans');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('roast_beans');
    print(maps);
  }

  // Roastの取得
  Future<List<RoastBean>> getRoastBeans() async {
    print('getRoastBeans');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('roast_beans');
    return List.generate(maps.length, (i) {
      return RoastBean.fromMap(maps[i]);
    });
  }

  Future<RoastBean> getRoastBeanById(String id) {
    print('getRoastBeanById');
    final db = database;
    return db.then((db) async {
      final List<Map<String, dynamic>> maps = await db.query(
        'roast_beans',
        where: 'id = ?',
        whereArgs: [id],
      );
      return RoastBean.fromMap(maps.first);
    });
  }

  // Roastの挿入
  Future<void> insertRoastBean(RoastBean roast) async {
    print('insertRoastBean');
    final db = await database;
    try {
      await db.insert(
        'roast_beans',
        roast.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  // Roastの更新
  Future<void> updateRoastBeanInfo(RoastBean roast) async {
    print('updateRoastBeanInfo');    
    final db = await database;  
    try {
      await db.update(
        'roast_beans',
        roast.toMap(),
        where: 'id = ?',
        whereArgs: [roast.id], 
      );
    } catch (e) {
      print(e);
    }
  }

  // Roastの削除
  Future<void> deleteRoastBeanInfo(String id) async {
    print('deleteRoastBeanInfo');
    final db = await database;
    try {
      await db.delete(
        'roast_beans',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('deleteRoastBeanInfo error');
      print(e);
    }
  }

  // roast_beansテーブルの削除
  // getDatabasesPath(), 'roast_logger.db'のファイルを削除する
  Future<void> deleteRoastBeansTable() async {
    print('deleteRoastBeansTable');
    final db = await database;
    try {
      await db.execute('DROP TABLE IF EXISTS roast_beans');

      // テーブルを再作成する
      await _onCreate(db, 1);  // バージョンに応じて設定
      print('roast_beansテーブルを再作成しました。');
    } catch (e) {
      print('deleteRoastBeansTable error');
      print(e);
    }
  }


}
