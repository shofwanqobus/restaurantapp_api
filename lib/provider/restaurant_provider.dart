import 'dart:async';

import 'package:http/http.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantApiService apiService;

  RestaurantProvider({
    required this.apiService,
  }) {
    _fetchAllRestaurant();
  }

  late Restaurant _restaurant;
  late ResultState _state;
  String _message = '';

  Restaurant get result => _restaurant;
  String get message => _message;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.topHeadlines(Client());
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Data Kosong';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurant = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message =
          'Sayang sekali. \nCoba hubungkan internet kamu kembali!';
    }
  }
}
