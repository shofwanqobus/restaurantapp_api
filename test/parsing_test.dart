import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:restaurantapp_api/data/api/api_service.dart';
import 'package:restaurantapp_api/data/model/restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'parse_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  RestaurantApiService apiService = RestaurantApiService();
  MockClient mockClient = MockClient();

  group('Fetch restaurant API', () {
    final testRestaurant = {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [
        {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
        },
      ]
    };
    test('Melakukan testing parsing json pada Project jika API berhasil',
        () async {
      when(
        mockClient.get(Uri.parse(RestaurantApiService.baseUrl + 'list')),
      ).thenAnswer((_) async => http.Response(jsonEncode(testRestaurant), 200));

      expect(await apiService.topHeadlines(mockClient), isA<Restaurant>());
    });

    test('Perlu mengandung data list dari restaurant disaat terjadi API gagal',
        () {
      when(
        mockClient.get(
          Uri.parse(RestaurantApiService.baseUrl + 'list'),
        ),
      ).thenAnswer((_) async =>
          http.Response('Gagal mendapatkan list restaurant dari API', 404));

      var restaurant = apiService.topHeadlines(mockClient);
      expect(restaurant, throwsException);
    });

    test('Perlu mengandung data list dari restaurant disaat tidak ada Internet',
        () {
      when(
        mockClient.get(
          Uri.parse(RestaurantApiService.baseUrl + 'list'),
        ),
      ).thenAnswer((_) async =>
          throw const SocketException('Tidak ada Koneksi Internet'));

      var restaurant = apiService.topHeadlines(mockClient);
      expect(restaurant, throwsException);
    });
  });
}
