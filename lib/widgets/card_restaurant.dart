import 'package:flutter/material.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:restaurantapp_api/ui/details.dart';

class CardRestaurant extends StatelessWidget {
  final RestaurantItems restaurantItems;

  const CardRestaurant({
    required this.restaurantItems,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    const Icon(
                      Icons.location_on,
                      size: 15,
                    ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailRestaurant(restaurantItems: restaurantItems);
          }));
        },
      ),
    );
  }
}
