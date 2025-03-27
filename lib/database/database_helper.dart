import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/transaction.dart' as app_models;
import '../models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'salary_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        isDefault INTEGER NOT NULL
      )
    ''');

    // Add default categories
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final List<Category> defaultCategories = [
      Category(name: 'Salary', emoji: '💵'),
      Category(name: 'Food', emoji: '🍔'),
      Category(name: 'Transport', emoji: '🚗'),
      Category(name: 'Entertainment', emoji: '🎮'),
      Category(name: 'Utilities', emoji: '💡'),
      Category(name: 'Rent', emoji: '🏠'),
      Category(name: 'Healthcare', emoji: '🏥'),
      Category(name: 'Shopping', emoji: '🛍️'),
      Category(name: 'Taxes', emoji: '💸'),
      Category(name: 'Bonus', emoji: '🎁'),
    ];

    for (var category in defaultCategories) {
      await db.insert('categories',
          {'name': category.name, 'icon': category.emoji, 'isDefault': 1});
    }
  }

  // Transaction operations
  Future<int> insertTransaction(app_models.Transaction transaction) async {
    Database db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateTransaction(app_models.Transaction transaction) async {
    Database db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<app_models.Transaction>> getTransactions() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) {
      return app_models.Transaction.fromMap(maps[i]);
    });
  }

  Future<List<app_models.Transaction>> getTransactionsByType(
      app_models.TransactionType type) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type.toString()],
    );
    return List.generate(maps.length, (i) {
      return app_models.Transaction.fromMap(maps[i]);
    });
  }

  Future<List<app_models.Transaction>> getTransactionsByDate(
      DateTime date) async {
    Database db = await database;
    String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}%';

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date LIKE ?',
      whereArgs: [formattedDate],
    );
    return List.generate(maps.length, (i) {
      return app_models.Transaction.fromMap(maps[i]);
    });
  }

  Future<List<app_models.Transaction>> getTransactionsByMonth(
      int year, int month) async {
    Database db = await database;
    String datePattern = '$year-${month.toString().padLeft(2, '0')}%';

    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date LIKE ?',
      whereArgs: [datePattern],
    );
    return List.generate(maps.length, (i) {
      return app_models.Transaction.fromMap(maps[i]);
    });
  }

  // Category operations
  Future<int> insertCategory(Category category) async {
    Database db = await database;
    return await db.insert('categories',
        {'name': category.name, 'icon': category.emoji, 'isDefault': 1});
  }

  Future<int> updateCategory(Category category) async {
    Database db = await database;
    return await db.update(
      'categories',
      {'name': category.name, 'icon': category.emoji, 'isDefault': 1},
      where: 'name = ?',
      whereArgs: [category.name],
    );
  }

  Future<int> deleteCategory(String name) async {
    Database db = await database;
    return await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Category>> getCategories() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Category(
        name: maps[i]['name'],
        emoji: maps[i]['icon'],
      );
    });
  }
}
