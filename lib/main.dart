import 'dart:io';

import 'package:corona_mobile_app/providers/corona-historical-records.dart';
import 'package:corona_mobile_app/providers/settings.dart';
import 'package:corona_mobile_app/screens/country-details.dart';
import 'package:corona_mobile_app/screens/login.dart';
import 'package:corona_mobile_app/screens/settings.dart';
import 'package:corona_mobile_app/screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'client/client.dart';
import 'providers/auth.dart';
import 'screens/admin-panel.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

final globalNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => CoronaHistoricalRecords(),
        ),
        ChangeNotifierProvider(
          create: (_) => Settings(),
        )
      ],
      child: Consumer<Settings>(
        builder: (ctx, value, _) => MaterialApp(
            navigatorKey: globalNavigatorKey,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.amberAccent,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: value.darkMode ? Brightness.dark : Brightness.light,
            ),
            home: StaticticsScreen(title: 'Flutter Demo Home Page'),
            routes: {
              LoginScreen.routeName: (ctx) => LoginScreen(),
              AdminPanelScreen.routeName: (ctx) => AdminPanelScreen(),
              CounrtyDetails.routeName: (ctx) => CounrtyDetails(),
              SettingsScreen.routeName: (ctx) => SettingsScreen(),
            }),
      ),
    );
  }
}
