import 'package:flutter_app/models/recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'recipes.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database;

  Future<void> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        ingredients TEXT,
        directions TEXT,
        time INTEGER,
        servings INTEGER
      )
    ''');
  }

  Future<List<Recipe>> getRecipes() async {
    final List<Map<String, dynamic>> maps = await _database.query('recipes');
    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id']! as int,
        name: maps[i]['name'] as String,
        ingredients: maps[i]['ingredients'] as String,
        directions: maps[i]['directions'] as String,
        time: maps[i]['time'] as int,
        servings: maps[i]['servings'] as int,
      );
    });
  }

  Future<int> insertRecipe(Recipe recipe) async {
    return await _database.insert('recipes', recipe.toMap());
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _database.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int recipeId) async {
    await _database.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }
}
