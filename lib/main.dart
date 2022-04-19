import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';
import 'package:restaurantapp_api/data/db/database_helper.dart';
import 'package:restaurantapp_api/data/model/detail_restaurant_model.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/data/preferences/preferences_helper.dart';
import 'package:restaurantapp_api/design/navigation.dart';
import 'package:restaurantapp_api/provider/database_provider.dart';
import 'package:restaurantapp_api/provider/preferences_provider.dart';
import 'package:restaurantapp_api/provider/restaurant_provider.dart';
import 'package:restaurantapp_api/provider/scheduling_provider.dart';
import 'package:restaurantapp_api/provider/search_restaurant_provider.dart';
import 'package:restaurantapp_api/ui/details.dart';
import 'package:restaurantapp_api/ui/favorites_page.dart';
import 'package:restaurantapp_api/ui/search_restaurant.dart';
import 'package:restaurantapp_api/ui/settings.dart';
import 'package:restaurantapp_api/ui/splash_screen.dart';
import 'package:restaurantapp_api/utilities/background_service.dart';
import 'package:restaurantapp_api/utilities/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(
            apiService: RestaurantApiService(),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider(
                    preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance(),
                ))),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchRestaurantProvider(
            apiService: RestaurantApiService(),
          ),
        ),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
      ],
      child: Consumer<PreferencesProvider>(builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.themeData,
          builder: (context, child) {
            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness:
                    provider.isDarkTheme ? Brightness.dark : Brightness.light,
              ),
              child: Material(
                child: child,
              ),
            );
          },
          navigatorKey: navigatorKey,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(),
            DetailRestaurant.routeName: (context) => DetailRestaurant(
                restaurantItems: ModalRoute.of(context)?.settings.arguments
                    as RestaurantItems),
            SearchPage.routeName: (context) => SearchPage(),
            FavoritesPage.routeName: (context) => FavoritesPage(),
            SettingPage.routeName: (context) => SettingPage(),
          },
        );
      }),
    );
  }
}
