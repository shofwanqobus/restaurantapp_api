import 'dart:convert';
import 'dart:math';

import 'package:restaurantapp_api/design/navigation.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    int random = Random().nextInt(restaurant.count - 1) + 1;
    var _channelId = "1";
    var _channelName = "restaurant_01";
    var _channelDescription = "restaurant app channel";

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            _channelId, _channelName, _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Restaurant App</b>";
    var restaurantPayload = restaurant.restaurants[random];
    var titleRestaurant =
        restaurant.restaurants[random].name + " Sudah dibuka!";

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleRestaurant,
      platformChannelSpecifics,
      payload: json.encode(restaurantPayload.toJson()),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var restaurant = json.decode(payload);
        Navigation.intentWithData(route, RestaurantItems.fromJson(restaurant));
      },
    );
  }
}
