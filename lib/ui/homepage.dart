import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';
import 'package:restaurantapp_api/data/db/database_helper.dart';
import 'package:restaurantapp_api/data/model/detail_restaurant_model.dart';
import 'package:restaurantapp_api/provider/database_provider.dart';
import 'package:restaurantapp_api/provider/restaurant_provider.dart';
import 'package:restaurantapp_api/provider/scheduling_provider.dart';
import 'package:restaurantapp_api/provider/search_restaurant_provider.dart';
import 'package:restaurantapp_api/ui/details.dart';
import 'package:restaurantapp_api/ui/favorites_page.dart';
import 'package:restaurantapp_api/ui/list_restaurant.dart';
import 'package:restaurantapp_api/ui/search_restaurant.dart';
import 'package:restaurantapp_api/ui/settings.dart';
import 'package:restaurantapp_api/utilities/notification_helper.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  int _bottomNavIndex = 0;
  static const String _homeText = 'Home';

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<Widget> _listWidget = [
    ChangeNotifierProvider<RestaurantProvider>(
      create: (_) => RestaurantProvider(apiService: RestaurantApiService()),
      child: RestaurantList(),
    ),
    ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) =>
          SearchRestaurantProvider(apiService: RestaurantApiService()),
      child: SearchPage(),
    ),
    ChangeNotifierProvider<DatabaseProvider>(
      create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
      child: FavoritesPage(),
    ),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: SettingPage(),
    ),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.home : Icons.home_outlined),
      label: _homeText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.search : Icons.search),
      label: SearchPage.searchName,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list),
      label: FavoritesPage.favoritesTitle,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: SettingPage.settingTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: _bottomNavBarItems),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailRestaurant.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
