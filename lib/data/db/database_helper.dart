import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _favRestaurant = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db =
        openDatabase('$path/restaurantapp.db', onCreate: (db, version) async {
      await db.execute(''' CREATE TABLE $_favRestaurant (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating DOUBLE
        )''');
    }, version: 1);

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavorite(RestaurantItems restaurantItems) async {
    final db = await database;
    await db!.insert(_favRestaurant, restaurantItems.toJson());
  }

  Future<List<RestaurantItems>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_favRestaurant);

    return results.map((res) => RestaurantItems.fromJson(res)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _favRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _favRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
