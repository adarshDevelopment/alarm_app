import 'package:alarm_clock_self/routes/routes.dart';
import 'package:alarm_clock_self/services/alarm_service.dart';
import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ClockService(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlarmService(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: HomePage(),
        initialRoute: RouteManager.homePage,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
