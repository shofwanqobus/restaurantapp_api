import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';

import 'package:restaurantapp_api/data/db/database_helper.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/design/styles.dart';
import 'package:restaurantapp_api/provider/database_provider.dart';
import 'package:restaurantapp_api/provider/detail_restaurant_provider.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';

class DetailRestaurant extends StatelessWidget {
  static const routeName = '/detail_restaurant';
  final RestaurantItems restaurantItems;

  const DetailRestaurant({
    required this.restaurantItems,
  });

  Widget _buildList(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailRestaurantProvider>(
          create: (_) => DetailRestaurantProvider(
              apiService: RestaurantApiService(), id: restaurantItems.id!),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ],
      child: Scaffold(
        body: _details(context),
      ),
    );
  }

  Widget _details(BuildContext context) {
    return Consumer<DetailRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Text(state.message),
          );
        } else if (state.state == ResultState.hasData) {
          return _detailRestaurants(context, state);
        } else if (state.state == ResultState.error) {
          return Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 250),
                  child: Icon(Icons.wifi_off, size: 50),
                ),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text(''),
          );
        }
      },
    );
  }

  Widget _detailRestaurants(
      BuildContext context, DetailRestaurantProvider state) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                SafeArea(
                  child: Hero(
                    tag: state.result.restaurant.pictureId,
                    child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/large/' +
                            state.result.restaurant.pictureId),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white54,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Consumer<DatabaseProvider>(
                          builder: (context, provider, child) {
                            return FutureBuilder<bool>(
                              future: provider.isFavorited(restaurantItems.id!),
                              builder: ((context, snapshot) {
                                var isFavorited = snapshot.data ?? false;
                                return CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  child: isFavorited
                                      ? IconButton(
                                          icon: const Icon(Icons.favorite),
                                          color: Colors.red,
                                          onPressed: () =>
                                              provider.removeFavorite(
                                                  restaurantItems.id!),
                                        )
                                      : IconButton(
                                          icon:
                                              const Icon(Icons.favorite_border),
                                          color: Colors.red,
                                          onPressed: () => provider
                                              .addFavorite(restaurantItems),
                                        ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      state.result.restaurant.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(state.result.restaurant.city),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${state.result.restaurant.rating}',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_city_rounded,
                            size: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(state.result.restaurant.address),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.food_bank_rounded,
                            size: 25,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 8),
                            height: 30,
                            width: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.result.restaurant.categories
                                  .map(
                                    (Category) => Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '${Category.name} ',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 24, left: 4, right: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Deskripsi',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 1),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.result.restaurant.description,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 16, left: 4),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Menu yang tersedia dalam Restaurant ${state.result.restaurant.name}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Makanan',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: 130,
                          width: 300,
                          alignment: Alignment.center,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.result.restaurant.menus.foods
                                .map(
                                  (Foods) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'images/foods.jpg',
                                              height: 75,
                                              width: 75,
                                            ),
                                            Text(Foods.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Minuman',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: 130,
                          width: 300,
                          alignment: Alignment.centerLeft,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.result.restaurant.menus.drinks
                                .map(
                                  (Drinks) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'images/drinks.jpg',
                                              height: 75,
                                              width: 75,
                                            ),
                                            Text(Drinks.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 16, left: 4),
                          child: Text(
                            'Customer Review',
                            style: Theme.of(context).textTheme.subtitle1,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: 130,
                          alignment: Alignment.centerLeft,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: state.result.restaurant.customerReviews
                                .map(
                                  (CustomerReview) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${CustomerReview.name} (${CustomerReview.date}) : \n'
                                                  '${CustomerReview.review}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: primaryColor,
        middle: Text('Restaurant App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
