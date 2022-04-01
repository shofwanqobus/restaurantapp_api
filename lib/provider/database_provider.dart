import 'package:flutter/cupertino.dart';
import 'package:restaurantapp_api/data/db/database_helper.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState _resultState = ResultState.loading;
  ResultState get state => _resultState;

  String _message = '';
  String get message => _message;

  List<RestaurantItems> _favorites = [];
  List<RestaurantItems> get favorites => _favorites;

  void _getFavorites() async {
    try {
      _favorites = await databaseHelper.getFavorites();
      if (_favorites.isNotEmpty) {
        _resultState = ResultState.hasData;
      } else {
        _resultState = ResultState.noData;
        _message = 'Data Kosong';
      }
      notifyListeners();
    } catch (e) {
      _resultState = ResultState.error;
      _message = 'Mohon maaf, terjadi error... Silahkan coba sesaat lagi';
      notifyListeners();
    }
  }

  void addFavorite(RestaurantItems restaurantItems) async {
    try {
      await databaseHelper.insertFavorite(restaurantItems);
      _getFavorites();
    } catch (e) {
      _resultState = ResultState.error;
      _message =
          'Gagal menambahkan restaurant ke favorit anda. Silahkan coba kembali!';
      notifyListeners();
    }
  }

  Future<bool> isFavorited(String id) async {
    final favoritedRestaurant = await databaseHelper.getFavoriteById(id);
    return favoritedRestaurant.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _resultState = ResultState.error;
      _message =
          'Gagal menghapus restaurant anda dari favorit. Silahkan coba kembali!';
      notifyListeners();
    }
  }
}
