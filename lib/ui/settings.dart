import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp_api/widgets/platform_widget.dart';
import 'package:restaurantapp_api/provider/preferences_provider.dart';
import 'package:restaurantapp_api/provider/scheduling_provider.dart';
import 'package:restaurantapp_api/widgets/custom_dialog.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting_page';
  static const String settingTitle = 'Setting';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
          alignment: Alignment.center,
          child: Text(
            settingTitle,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        )),
        body: _buildList(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) {
                    provider.enableDarkTheme(value);
                  },
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Scheduling Restaurant'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: scheduled.isScheduled,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.enableDailyRestaurants(value);
                          scheduled.scheduledRestaurants(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
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
