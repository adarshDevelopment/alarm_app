import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Text displayHourSlider(int index, BuildContext context) {
  print(
      'selectedIndex from hourSlider ${context.watch<ClockService>().selectedItemIndexHour}');
  return Text(index + 1 < 10 ? '0${index + 1}' : '${index + 1}',
      style: TextStyle(
        fontSize: 42,
        color: context.watch<ClockService>().selectedItemIndexHour == index
            ? Colors.blue
            : Colors.grey.shade400,
      ));
}

Text displayMinuteSlider(int index, BuildContext context) {
  print('minute value inside dispaly Minute: $index ');
  return Text(index < 10 ? '0$index' : '$index',
      // return Text(index.toString(),
      style: TextStyle(
        fontSize: 42,
        color: context.watch<ClockService>().selectedItemIndexMinute == index
            ? Colors.blue
            : Colors.grey.shade400,
        /* 
        color: context.watch<ClockService>().selectedItemIndexMinute == index 
            ? Colors.blue
            : Colors.grey.shade400,
            */
      ));
}

Text displayAmPm(int index, BuildContext context) {
  return Text(
    index == 0 ? 'AM' : 'PM',
    style: TextStyle(
      fontSize: 42,
      color: context.read<ClockService>().selectedItemIndexAmPm == index
          ? Colors.blue
          : Colors.black,
    ),
  );
}
