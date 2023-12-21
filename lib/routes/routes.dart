import 'package:alarm_clock_self/pages/add_alarm_page.dart';
import 'package:alarm_clock_self/pages/homepage.dart';
import 'package:flutter/material.dart';

class RouteManager {
  // defining string routes
  static const String homePage = '/';
  static const addAlarmPage = '/addAlarmPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.homePage:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case RouteManager.addAlarmPage:
        return MaterialPageRoute(
          builder: (context) => const AddAlarmPage(),
        );
      default:
        throw Exception('Route not found!');
    }
  }
}
