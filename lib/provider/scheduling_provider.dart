import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:restaurantapp_api/utilities/background_service.dart';
import 'package:restaurantapp_api/utilities/date_time_helper.dart';
import 'package:restaurantapp_api/data/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

class SchedulingProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  SchedulingProvider({
    required this.preferencesHelper,
  }) {
    _getDailyRestaurantsPreferences();
  }

  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  void _getDailyRestaurantsPreferences() async {
    _isScheduled = await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyRestaurants(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    scheduledRestaurants(value);
    _getDailyRestaurantsPreferences();
  }

  Future<bool> scheduledRestaurants(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling Restaurant Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling Restaurant Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
