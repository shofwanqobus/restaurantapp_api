import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurantapp_api/data/model/detail_restaurant_model.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/data/model/search_restaurant_model.dart';

class RestaurantApiService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev/';

  // API untuk List Restaurant
  Future<Restaurant> topHeadlines(http.Client client) async {
    final response = await client.get(Uri.parse(baseUrl + 'list'));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Mohon maaf data restaurant tidak dapat ditampilkan');
    }
  }

  //API untuk Detail Restaurant
  Future<RestaurantDetails> detailRestaurantId(String id) async {
    final response = await http.get(Uri.parse(baseUrl + 'detail/' + id));
    if (response.statusCode == 200) {
      return RestaurantDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menampilkan data restaurant');
    }
  }

  //API untuk Search Restaurant
  Future<RestaurantSearch> searchRestaurantQuery(String query) async {
    final response = await http.get(Uri.parse(baseUrl + 'search?q=' + query));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Gagal melakukan pencarian. Silahkan coba kembali nanti...');
    }
  }
}
