import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:restaurantapp_api/provider/restaurant_provider.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';
import 'package:restaurantapp_api/data/state_enum.dart';
import 'package:restaurantapp_api/widgets/card_restaurant.dart';

class RestaurantList extends StatelessWidget {
  Widget _buildList(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 32.0, left: 24.0),
                child: Text(
                  'Restfood',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 4.0, left: 24.0),
                child: Text(
                  'Recommendation restaurant for you!',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 16),
                child: Consumer<RestaurantProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == ResultState.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.result.restaurants.length,
                        itemBuilder: (context, index) {
                          var resto = state.result.restaurants[index];
                          return CardRestaurant(restaurantItems: resto);
                        },
                      );
                    } else if (state.state == ResultState.noData) {
                      return Center(child: Text(state.message));
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
                      return const Center(child: Text(''));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
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
