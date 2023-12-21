class AlarmModel {
  bool isActive;
  String description;
  DateTime alarmDate;
  bool onRepeat;
  bool deleteAfterOnce;
  bool vibrate = true;
  int id;
  bool isSelected = false;

  AlarmModel({
    required this.isActive,
    required this.description,
    required this.alarmDate,
    required this.onRepeat,
    required this.deleteAfterOnce,
    required this.vibrate,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    var map = {
      AlarmFields.id: id,
      AlarmFields.isActive: isActive ? 1 : 0,
      AlarmFields.description: description,
      AlarmFields.alarmDate: alarmDate.toIso8601String(),
      AlarmFields.onRepeat: onRepeat ? 1 : 0,
      AlarmFields.deleteAfterOnce: deleteAfterOnce ? 1 : 0,
      AlarmFields.vibrate: vibrate ? 1 : 0,
    };
    return map;
  }

  static AlarmModel fromJson(Map<String, dynamic> map) {
    return AlarmModel(
      id: map[AlarmFields.id],
      isActive: map[AlarmFields.isActive] == 1 ? true : false,
      description: map[AlarmFields.description],
      alarmDate: DateTime.parse(map[AlarmFields.alarmDate] as String),
      onRepeat: map[AlarmFields.onRepeat] == 1 ? true : false,
      deleteAfterOnce: map[AlarmFields.deleteAfterOnce] == 1 ? true : false,
      vibrate: map[AlarmFields.vibrate] == 1 ? true : false,
    );
  }
}

class AlarmFields {
  static const String id = 'id';
  static const String isActive = 'is_active';
  static const String description = 'description';
  static const String alarmDate = 'alarm_date';
  static const String onRepeat = 'on_repeat';
  static const String deleteAfterOnce = 'delete_after_once';
  static const String vibrate = 'vibrate';

  static List<String> alarmFieldsList = [
    id,
    isActive,
    description,
    alarmDate,
    onRepeat,
    deleteAfterOnce,
    vibrate
  ];
}

class RepeatingDays {
  // Map<String, dynamic> repeatingDaysList;
  int id;
  bool sunday;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thrusday;
  bool firday;
  bool saturday;

  RepeatingDays({
    required this.id,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thrusday,
    required this.firday,
    required this.saturday,
  });

  Map<String, dynamic> toJson() => {
        RepeatingDaysFields.sunday: sunday ? 1 : 0,
        RepeatingDaysFields.monday: monday ? 1 : 0,
        RepeatingDaysFields.tuesday: tuesday ? 1 : 0,
        RepeatingDaysFields.wednesday: wednesday ? 1 : 0,
        RepeatingDaysFields.thursday: thrusday ? 1 : 0,
        RepeatingDaysFields.friday: firday ? 1 : 0,
        RepeatingDaysFields.saturday: saturday ? 1 : 0,
        RepeatingDaysFields.id: id,
      };

  static RepeatingDays fromJson(Map<String, dynamic> map) => RepeatingDays(
        id: map[RepeatingDaysFields.id],
        sunday: map[RepeatingDaysFields.sunday] == 1 ? true : false,
        monday: map[RepeatingDaysFields.monday] == 1 ? true : false,
        tuesday: map[RepeatingDaysFields.tuesday] == 1 ? true : false,
        wednesday: map[RepeatingDaysFields.wednesday] == 1 ? true : false,
        thrusday: map[RepeatingDaysFields.thursday] == 1 ? true : false,
        firday: map[RepeatingDaysFields.friday] == 1 ? true : false,
        saturday: map[RepeatingDaysFields.saturday] == 1 ? true : false,
      );
}

class RepeatingDaysFields {
  static const String id = 'id';
  static const String sunday = 'sunday';
  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
  static const String saturday = 'saturday';

  static List<String> repeatingDaysFieldsList = [
    sunday,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    id
  ];
}

const String alarmTable = 'alarm_table';
const String repeatingDaysTable = 'repeating_days';



  /*
  bool sunday;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  int? id;

  Map<String, dynamic> map = {
    'Sunday' : false,
    'Monday' : false,
    'Tuesday' : false,
    'Wednesday' : false,
    'Thursday' : false,
    'Friday' : false,
    'Saturday' : false,

  };

  RepeatingDays({
    this.id,
    this.sunday = false,
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
  });



  Map<String, dynamic> toJson() => {
        RepeatingDaysFields.sunday: sunday,
        RepeatingDaysFields.monday: monday,
        RepeatingDaysFields.tuesday: tuesday,
        RepeatingDaysFields.wednesday: wednesday,
        RepeatingDaysFields.thursday: thursday,
        RepeatingDaysFields.friday: friday,
        RepeatingDaysFields.saturday: saturday,
      };

  static RepeatingDays formJson(Map<String, dynamic> map) => RepeatingDays(
      sunday: map[RepeatingDaysFields.sunday],
      monday: map[RepeatingDaysFields.monday],
      tuesday: map[RepeatingDaysFields.tuesday],
      wednesday: map[RepeatingDaysFields.wednesday],
      thursday: map[RepeatingDaysFields.thursday],
      friday: map[RepeatingDaysFields.friday],
      saturday: map[RepeatingDaysFields.saturday]);
*/