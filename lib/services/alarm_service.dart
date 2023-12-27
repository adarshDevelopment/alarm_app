import 'package:alarm_clock_self/database/alarm_database.dart';
import 'package:alarm_clock_self/models/alarm_model.dart';
import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';

class AlarmService with ChangeNotifier {
  List<AlarmModel> _alarms = [];
  List<AlarmModel> get alarms => _alarms;
  List<AlarmModel> _selectedList = [];

  List<AlarmModel> get selectedList => _selectedList;

  Future createALarm(AlarmModel alarmModel, Set<String> repeatingDays) async {
    print(('create alarm alarmDate: ${alarmModel.alarmDate}'));
    var result = await AlarmDatabase.instance.createAlarm(alarmModel);
    if (repeatingDays.isNotEmpty) {
      RepeatingDays createRepeatingDays =
          createRepeatingDaysObj(repeatingDays, alarmModel.id);
      AlarmDatabase.instance.createRepeatingDays(createRepeatingDays);
    }
    getAllAlarms();
    return result;
  }

  Future updateAlarm(AlarmModel alarmModel, Set<String> repeatingDays) async {
    print('udpate repeating days: $repeatingDays');
    try {
      // print(
      //     'update alarm check: description: ${alarmModel.description} || time: ${alarmModel.alarmDate} || repeat: ${alarmModel.onRepeat} || vibrate: ${alarmModel.vibrate} || deleteAfterOnce: ${alarmModel.deleteAfterOnce}');
      if (repeatingDays.isEmpty) {
        RepeatingDays deleteRepeatingDays =
            createRepeatingDaysObj(repeatingDays, alarmModel.id);
        await AlarmDatabase.instance.deleteRepeatingDays(alarmModel);
      } else {
        RepeatingDays updateRepeatingDays =
            createRepeatingDaysObj(repeatingDays, alarmModel.id);
        var result = await AlarmDatabase.instance
            .getRepeatingDays(updateRepeatingDays.id);
        if (result == false) {
          await AlarmDatabase.instance.createRepeatingDays(updateRepeatingDays);
        } else {
          await AlarmDatabase.instance.updateRepeatingDays(updateRepeatingDays);
        }
      }
      /*
      if (repeatingDays.isNotEmpty) {
        RepeatingDays updateRepeatingDays =
            createRepeatingDaysObj(repeatingDays, alarmModel.id);
        //create repeatingDays table when inserting first field for the record
        var result = await AlarmDatabase.instance
            .getRepeatingDays(updateRepeatingDays.id);
        if (result == false) {
          await AlarmDatabase.instance.createRepeatingDays(updateRepeatingDays);
        } else {
          await AlarmDatabase.instance.updateRepeatingDays(updateRepeatingDays);
        }
      }
      */
      // await AlarmDatabase.instance.deleteRepeatingDays(alarmModel);
      // await AlarmDatabase.instance.updateAlarm(alarmModel);
    } catch (e) {
      return e.toString();
    }
    editable = false;
    notifyListeners();
  }

  RepeatingDays createRepeatingDaysObj(Set<String> repeatingDaysSet, int id) {
    Map<String, dynamic> map = {
      'Sunday': false,
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
      'Saturday': false,
    };
    print('repeating days set: $repeatingDaysSet');
    for (var item in repeatingDaysSet) {
      if (map.containsKey(item)) {
        map[item] = true;
      }
    }
    RepeatingDays repeatingDays = RepeatingDays(
      id: id,
      sunday: map['Sunday'],
      monday: map['Monday'],
      tuesday: map['Tuesday'],
      wednesday: map['Wednesday'],
      thrusday: map['Thursday'],
      firday: map['Friday'],
      saturday: map['Saturday'],
    );
    return repeatingDays;
  }

  Future getAllAlarms() async {
    int hour = DateTime.now().hour > 11
        ? DateTime.now().hour - 12
        : DateTime.now().hour;
    print('init hour: $hour');
    var currentTime = DateTime.now();
    var date = currentTime.copyWith(
      hour: 14,
      minute: 30,
      second: 0,
    );
    try {
      var list = await AlarmDatabase.instance.getAllAlarms();
      // print('list from getAllAlarms service: ${list[0].id}');
      _alarms = await AlarmDatabase.instance.getAllAlarms();
      // print('list from getAllAlarms service ${_alarms[0].id}');
    } catch (e) {
      return e.toString();
    }
    notifyListeners();
  }

  Future toggleActiveAlarm(AlarmModel alarmModel) async {
    try {
      AlarmDatabase.instance.updateAlarm(alarmModel);
    } catch (e) {
      return e.toString();
    }
    notifyListeners();
  }

  Future deleteAlarm(List<AlarmModel> list) async {
    try {
      for (var item in list) {
        if (item.onRepeat == true) {
          var result = await AlarmDatabase.instance.deleteRepeatingDays(item);
          print('repeatingdays result: $result');
        }
        await AlarmDatabase.instance.deleteAlarm(item);
      }
    } catch (e) {
      return e.toString();
    }
    _selectedList = [];
    getAllAlarms();
  }

  late AlarmModel _currentAlarmModel;
  AlarmModel get currentAlarmModel => _currentAlarmModel;

  void selectItems(AlarmModel alarmModel) {
    alarmModel.isActive ? false : true;
    if (_selectedList.contains(alarmModel)) {
      _selectedList.remove(alarmModel);
    } else {
      _selectedList.add(alarmModel);
    }
    notifyListeners();
  }

  void changeIsSelected(AlarmModel alarmModel) {
    alarmModel.isSelected = !alarmModel.isSelected;
    notifyListeners();
  }
}
