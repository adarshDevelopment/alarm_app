import 'package:alarm_clock_self/database/alarm_database.dart';
import 'package:alarm_clock_self/models/alarm_model.dart';
import 'package:flutter/material.dart';

List<String> repeatStatus = ['Once', 'Daily', 'Mon to Fri', 'Custom'];

List<String> weekDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];
List<String> monToFri = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

List<String> weekDaysAbbr = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

late int selectedItemIndexHourVar;
late int selectedItemIndexMinuteVar;
late int selectedItemIndexAmPmVar;
late DateTime currentTime;

bool editable = false;

void setInitialCurrentTime() {
  // hour + 1 because hour slider starts from 1
  currentTime = DateTime.now();
  print('current date time: $currentTime');

  // var formattedTime = DateFormat("h:mma").format(currentTime);
  // print('formatted time: $formattedTime');

  if (currentTime.hour >= 12) {
    amPm = 1;
    hour = currentTime.hour - 13;
    print('substracted hour: $hour');
  } else {
    amPm = 0;
    hour = currentTime.hour;
  }

/*
  if (currentTime.hour == 24 || currentTime.hour < 12) {
    // 12am to 11 am
    hour = currentTime.hour;
    amPm = 0;
  } else {
    // 12pm to 12pm
    hour = currentTime.hour - 13;
    amPm = 1;
  }
  */
  minute = currentTime.minute;
  /*
  hour = (currentTime.hour > 11 ? currentTime.hour - 13 : currentTime.hour);
  amPm = currentTime.hour > 11 ? 1 : 0;
  minute = currentTime.minute;
*/
  // setting top level variable from clock_service class to setIndexes
  selectedItemIndexHourVar = hour;
  selectedItemIndexMinuteVar = minute;
  selectedItemIndexAmPmVar = amPm;
}

late int amPm;
late int hour;
late int minute;

class ClockService with ChangeNotifier {
  // first time user adds alarm
  String _repeatChoice = '';
  bool _vibrate = true;
  bool _deleteAfterOnce = false;
  String _description = '';

  int get selectedItemIndexHour => selectedItemIndexHourVar;
  int get selectedItemIndexMinute => selectedItemIndexMinuteVar;
  int get selectedItemIndexAmPm => selectedItemIndexAmPmVar;
  // String get repeatChoice => _repeatChoice;
  bool get vibrate => _vibrate;
  bool get deleteAfterOnce => _deleteAfterOnce;
  String get description => _description;
  String _repeatChoiceCheckMark = '';
  String get repeatChoiceCheckMark => _repeatChoiceCheckMark;

  void setRepeatChoiceText() {
    String localChoice = '';
    print('inside setRepeatChocie');
    if (_repeatingDays.isEmpty) {
      localChoice = 'Once';
      _repeatChoiceCheckMark = 'Once';
    } else if (_repeatingDays.length == 7) {
      localChoice = 'Daily';
      _repeatChoiceCheckMark = localChoice;
    } else {
      for (int i = 0; i < 7; i++) {
        if (_repeatingDays.contains(weekDays[i])) {
          localChoice = '$localChoice${weekDaysAbbr[i]} ';
        }
      }
      if (localChoice == 'Mon Tue Wed Thu Fri ') {
        localChoice = 'Mon to Fri';
        _repeatChoiceCheckMark = 'Mon to Fri';
      } else {
        _repeatChoiceCheckMark = 'Custom';
      }
    }

    _repeatChoice = localChoice.trim();

    print('local choice: $localChoice');
    // _repeatChoice = choice;
  }

  void setRepeat(String repeatChoice) {
    // _repeatChoice = repeatChoice;
    if (repeatChoice == 'Once') {
      _repeatingDays.clear();
    } else if (repeatChoice == repeatStatus[1]) {
      // daily
      _repeatingDays.addAll(weekDays);
    } else if (repeatChoice == repeatStatus[2]) {
      // mon to fri
      _repeatingDays.clear();
      for (int i = 1; i < 6; i++) {
        _repeatingDays.add(weekDays[i]);
      }
    }
    setRepeatChoiceText();
    notifyListeners();
  }

  String get repeatChoice => _repeatChoice;

  final Set<String> _repeatingDays = {};
  Set<String> get repeatingDaysSet => _repeatingDays;

  void setRepeatingDays(String day) {
    Set<String> localRepeatingDays = _repeatingDays;

    if (_repeatingDays.contains(day)) {
      _repeatingDays.remove(day);
    } else {
      _repeatingDays.add(day);
    }
    setRepeatChoiceText();
    notifyListeners();
    print('repeatingDays: $_repeatingDays');
  }

  void clearRepeatingDays() {
    _repeatingDays.clear();
  }

  void setSelectedItemIndexHour(int value) {
    selectedItemIndexHourVar = value;
    print('selected index hour: $value');
    notifyListeners();
  }

  void setSelectedItemIndexMinute(int value) {
    selectedItemIndexMinuteVar = value;
    notifyListeners();
  }

  void setSelectedItemIndexAmPm(int value) {
    selectedItemIndexAmPmVar = value;
    notifyListeners();
  }

/*
  void changeAmPm() {
    print('selectedItemIndexHour: $_selectedItemIndexHour');
    if (_selectedItemIndexHour > 10 && _selectedItemIndexHour < 1) {
      print('condition satisfied');
      _selectedItemIndexAmPm == 0 ? _selectedItemIndexAmPm = 1 : 0;
    }
    notifyListeners();
  }
*/

  void setVibration() {
    _vibrate = !vibrate;
    notifyListeners();
  }

  void setDeleteAfterOnce() {
    _deleteAfterOnce = !_deleteAfterOnce;
    notifyListeners();
  }

  void setLabelText(String text) {
    _description = text;
    notifyListeners();
  }

  String _alarmInText = '';
  get alarmInText => _alarmInText;

  void setAlarmInText() {
    // for displaying add alarm text
    int hour = selectedItemIndexHour;
    hour++;
    if (selectedItemIndexAmPm == 1) {
      hour = hour + 12;
    }
    print('hour + 12: $hour');
    var currentTime = DateTime.now();
    var alarmTime = currentTime.copyWith(
      hour: hour,
      minute: selectedItemIndexMinute,
      second: 0,
    );

    print('current time: $currentTime || alarmTime: $alarmTime');

    // IMPORTANT
    // IF SELECTED DATE > CURRENT DATE, NEXT DATE AND SUBSTRACT THE DATES AND PRINT THIS MANY
    // HOURS LEFT FOR ALARM

    var substractedTime = alarmTime.subtract(
      Duration(
        hours: currentTime.hour,
        minutes: currentTime.minute + 1,
      ),
    );
    String minuteString = '';
    String hourString = '';
    String localALarmmText = '';
    if (substractedTime.hour == 0 && substractedTime.minute == 0) {
      localALarmmText = 'Alarm in less than 1 minute';
    }
    if (substractedTime.minute == 1) {
      minuteString = 'minute';
    } else if (substractedTime.minute > 1) {
      minuteString = 'minutes';
    }
    if (substractedTime.hour == 1) {
      hourString = 'hour';
    } else if (substractedTime.hour > 1) {
      hourString = 'hours';
    } else {
      hourString = '';
    }

    if (localALarmmText == '') {
      if (substractedTime.hour == 0) {
        _alarmInText = 'Alarm in ${substractedTime.minute} $minuteString';
      } else if (substractedTime.minute == 0) {
        _alarmInText = 'Alarm in ${substractedTime.hour} $hourString';
      } else {
        _alarmInText =
            'Alarm in ${substractedTime.hour} $hourString ${substractedTime.minute} $minuteString';
      }
    } else {
      _alarmInText = localALarmmText;
    }
    notifyListeners();
  }

  late AlarmModel _currentAlarmModel;
  AlarmModel get currentAlarmModel => _currentAlarmModel;

  Future editAlarmUI(AlarmModel alarmModel) async {
    _currentAlarmModel = alarmModel;
    int localHour = alarmModel.alarmDate.hour;
    if (localHour > 11 && localHour < 24) {
      amPm = 1;
      print('am pm value: $amPm');
      hour = localHour - 13;
    } else {
      amPm = 0;
      hour = localHour - 1;
    }
    minute = alarmModel.alarmDate.minute;
    setLabelText(alarmModel.description);

    selectedItemIndexAmPmVar = amPm;
    selectedItemIndexHourVar = hour;
    selectedItemIndexMinuteVar = minute;

    _vibrate = alarmModel.vibrate;
    _deleteAfterOnce = alarmModel.deleteAfterOnce;

    var result;
    if (alarmModel.onRepeat == true) {
      result = await AlarmDatabase.instance.getRepeatingDays(alarmModel.id);
    }
    print('result value edit UI: $result');
    _repeatingDays.clear();
    if (result is RepeatingDays) {
      if (result.sunday == true) _repeatingDays.add(weekDays[0]);
      if (result.monday == true) _repeatingDays.add(weekDays[1]);
      if (result.tuesday == true) _repeatingDays.add(weekDays[2]);
      if (result.wednesday == true) _repeatingDays.add(weekDays[3]);
      if (result.thrusday == true) _repeatingDays.add(weekDays[4]);
      if (result.firday == true) _repeatingDays.add(weekDays[5]);
      if (result.saturday == true) _repeatingDays.add(weekDays[6]);
    }
    setRepeatChoiceText();
    print('repeating days: $_repeatingDays');
    print('currentModel id: ${currentAlarmModel.id}');
    notifyListeners();
  }
}
