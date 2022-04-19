import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/provider/database_provider.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:restaurantapp_api/ui/details.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  static const String routeName = '/favorites_page';
  static const String favoritesTitle = 'Favorites';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
          alignment: Alignment.center,
          child: Text(
            favoritesTitle,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.justify,
          ),
        )),
        body: _buildList(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(favoritesTitle),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return _favorites(
                provider.favorites[index],
              );
            },
          );
        } else if (provider.state == ResultState.noData) {
          return Center(child: Text(provider.message));
        } else if (provider.state == ResultState.error) {
          return Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 250),
                  child: Icon(Icons.wifi_off, size: 50),
                ),
                Text(
                  provider.message,
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

  Widget _favorites(RestaurantItems restaurantItems) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavorited(restaurantItems.id),
          builder: (context, snapshot) {
            return Material(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: restaurantItems.pictureId,
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/large/' +
                        restaurantItems.pictureId,
                    width: 100,
                  ),
                ),
                title: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 2,
                    bottom: 4,
                  ),
                  child: Text(restaurantItems.name),
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 15,
                            ),
                            Text(restaurantItems.city),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 15),
                            Text('${restaurantItems.rating}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, DetailRestaurant.routeName,
                      arguments: restaurantItems);
                },
              ),
            );
          },
        );
      },
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
