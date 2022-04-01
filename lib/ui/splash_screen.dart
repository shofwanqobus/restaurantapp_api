import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurantapp_api/ui/homepage.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash_screen';

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(
        seconds: 10,
      ),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 250),
            child: Image.asset('images/restaurant1.webp'),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              'Restfood',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              'The Restaurant App only for you',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
