import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:restaurantapp_api/provider/search_restaurant_provider.dart';
import 'package:restaurantapp_api/ui/details.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';
  static const String searchName = 'Search';

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  String query = '';

  Widget _buildList(context) {
    return Consumer<SearchRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var resto = state.result.restaurants;
              return _searchRestaurant(resto[index], index, context);
            },
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Text(state.message),
          );
        } else if (state.state == ResultState.error) {
          return Center(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                const Icon(
                  Icons.wifi_off,
                  size: 50,
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

  Widget _buildSearch(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (_) =>
          SearchRestaurantProvider(apiService: RestaurantApiService()),
      child: Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: TextField(
                          autofocus: true,
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Search restaurant....',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                            state.fetchAllRestaurant(query);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 100, left: 32, right: 32, bottom: 50),
                  child: query.isEmpty
                      ? const Center(child: Text(''))
                      : _buildList(context),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _searchRestaurant(
      RestaurantItems restaurantItems, int index, BuildContext context) {
    return Material(
      child: ListTile(
        leading: Hero(
          tag: restaurantItems.pictureId,
          child: Image.network(
            'https://restaurant-api.dicoding.dev/images/large/' +
                restaurantItems.pictureId,
            scale: 3,
            width: 100,
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(
            top: 10,
            left: 2,
            bottom: 4,
          ),
          child: Text(restaurantItems.name!),
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 15),
                    Text(restaurantItems.city!),
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
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
          alignment: Alignment.center,
          child: Text(
            'Search Restaurant',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.justify,
          ),
        )),
        body: _buildSearch(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Search Restaurant'),
        transitionBetweenRoutes: false,
      ),
      child: _buildSearch(context),
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
