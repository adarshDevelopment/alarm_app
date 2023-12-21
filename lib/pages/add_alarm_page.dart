import 'package:alarm_clock_self/models/alarm_model.dart';
import 'package:alarm_clock_self/pages/alarm_page_slider/slider.dart';
import 'package:alarm_clock_self/services/alarm_service.dart';
import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({super.key});

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _amPMController;
  late FixedExtentScrollController _minuteController;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    super.initState();
    if (editable == false) {
      _descriptionController = TextEditingController();
      _descriptionController.text = '';
    } else {
      _descriptionController = TextEditingController();
      _descriptionController.text =
          context.read<ClockService>().currentAlarmModel.description;
      print(
          'description from init: ${context.read<ClockService>().currentAlarmModel.description}');
    }
    print('am pm value from initState: $amPm');
    _hourController = FixedExtentScrollController(initialItem: hour);
    _amPMController = FixedExtentScrollController(initialItem: amPm);
    _minuteController = FixedExtentScrollController(initialItem: minute);
    // _descriptionController.text = 'demo description';
  }

  @override
  void dispose() {
    _hourController.dispose();
    _amPMController.dispose();
    _minuteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            (Icons.close),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Add alarm',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Text(context.read<ClockService>().alarmInText),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            context
                                .read<ClockService>()
                                .setSelectedItemIndexAmPm(
                                    _amPMController.selectedItem);
                            context
                                .read<ClockService>()
                                .setSelectedItemIndexHour(
                                    _hourController.selectedItem);
                            context
                                .read<ClockService>()
                                .setSelectedItemIndexMinute(
                                    _minuteController.selectedItem);
                            var amPm = context
                                .read<ClockService>()
                                .selectedItemIndexAmPm;
                            var hour = context
                                .read<ClockService>()
                                .selectedItemIndexHour;
                            var mins = context
                                .read<ClockService>()
                                .selectedItemIndexMinute;
                            var repeatingDays =
                                context.read<ClockService>().repeatingDaysSet;
                            bool vibrate = context.read<ClockService>().vibrate;
                            bool deleteAfterOnce =
                                context.read<ClockService>().deleteAfterOnce;
                            String description =
                                context.read<ClockService>().description;

                            print(
                                'selected am pm:${context.read<ClockService>().selectedItemIndexAmPm}');
                            // hour slider builder takes 0-11 while method returns 1-12, hence it is required
                            hour = hour + 1;
                            print(
                                'ampm check hour = $hour || ampm: ${context.read<ClockService>().selectedItemIndexAmPm}');
                            if (amPm == 1) {
                              hour = hour + 12;
                            }

                            var currentTime = DateTime.now();
                            var alarmDate = currentTime.copyWith(
                              hour: hour,
                              minute: mins,
                              second: 0,
                            );

                            print('save date: $alarmDate');

                            List<AlarmModel> alarmList =
                                context.read<AlarmService>().alarms;

                            List<int> idList = [];
                            int id = 1;

                            for (var i in alarmList) {
                              idList.add(i.id);
                            }
                            bool found = true;
                            while (found == true) {
                              if (idList.contains(id)) {
                                found = true;
                                id++;
                              } else {
                                found = false;
                              }
                            }
                            print('new id: $id');

                            if (editable == true) {
                              AlarmModel editingAlarm = context
                                  .read<ClockService>()
                                  .currentAlarmModel;
                              editingAlarm.description = description;
                              editingAlarm.alarmDate = alarmDate;
                              editingAlarm.onRepeat =
                                  repeatingDays.isEmpty ? false : true;
                              editingAlarm.deleteAfterOnce = deleteAfterOnce;
                              editingAlarm.vibrate = vibrate;
                              context.read<AlarmService>().updateAlarm(
                                  editingAlarm,
                                  context
                                      .read<ClockService>()
                                      .repeatingDaysSet);
                            } else {
                              AlarmModel alarmModel = AlarmModel(
                                  id: id,
                                  isActive: true,
                                  description: description,
                                  alarmDate: alarmDate,
                                  onRepeat:
                                      repeatingDays.isEmpty ? false : true,
                                  deleteAfterOnce: deleteAfterOnce,
                                  vibrate: vibrate);

                              var result = await context
                                  .read<AlarmService>()
                                  .createALarm(
                                      alarmModel,
                                      context
                                          .read<ClockService>()
                                          .repeatingDaysSet);
                            }

                            Navigator.pop(context);
                            // if (result is String) {
                            //   final snackBar = SnackBar(content: Text(result));
                            // }
                            print(
                                'ammPm: $amPm| hour: $hour| mins: $mins| reepat: | vibrate: $vibrate| deleteAfterOnce: $deleteAfterOnce| labelText: $description');
                          },
                          icon: const Icon(
                            (Icons.check),
                            size: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 200,
                      child: ListWheelScrollView.useDelegate(
                        controller: _amPMController,
                        onSelectedItemChanged: (value) {
                          context
                              .read<ClockService>()
                              .setSelectedItemIndexAmPm(value);
                          context.read<ClockService>().setAlarmInText();
                        },
                        itemExtent: 50,
                        perspective: 0.00000000000001,
                        diameterRatio: 2,
                        physics: const FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 2,
                          builder: (context, index) {
                            return displayAmPm(index, context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 200,
                      child: ListWheelScrollView.useDelegate(
                        controller: _hourController,
                        onSelectedItemChanged: (value) {
                          int selectedItemIdex = context
                              .read<ClockService>()
                              .selectedItemIndexHour;
                          print(
                              'hour selected itme: ${_hourController.selectedItem} || selectedHour service: $selectedItemIdex ');
                          context
                              .read<ClockService>()
                              .setSelectedItemIndexHour(value);
                          context.read<ClockService>().setAlarmInText();
                        },
                        itemExtent: 50,
                        perspective: 0.00000000000001,
                        diameterRatio: 2,
                        physics: const FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List<Widget>.generate(
                            12,
                            (index) => displayHourSlider(index, context),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(color: Colors.red, thickness: 2),
                    SizedBox(
                      width: 100,
                      height: 200,
                      child: ListWheelScrollView.useDelegate(
                        controller: _minuteController,
                        onSelectedItemChanged: (value) {
                          // set the changeSelectedValue to provider
                          context
                              .read<ClockService>()
                              .setSelectedItemIndexMinute(value);
                          context.read<ClockService>().setAlarmInText();
                        },
                        itemExtent: 50,
                        perspective: 0.00000000000001,
                        diameterRatio: 2,
                        physics: const FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List<Widget>.generate(
                            60,
                            (index) => displayMinuteSlider(index, context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AddAlarmTexts('Ringtone'),
                      Row(
                        children: [
                          const OptionText(
                            text: 'Default Ringtone',
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade400,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SizedBox(
                                  height: 240,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      children: repeatStatus
                                          .map((e) => RepeatInkWell(text: e))
                                          .toList()
                                      // repeatStatus.map((e) { return
                                      //   RepeatInkWell(text: e)
                                      // }).toList()

                                      // [
                                      //   RepeatInkWell(text: 'Once'),
                                      //   RepeatInkWell(text: 'Daily'),
                                      //   RepeatInkWell(text: 'Mon to Fri'),
                                      //   RepeatInkWell(text: 'Custom'),
                                      // ]

                                      ,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AddAlarmTexts('Repeat'),
                        Row(
                          children: [
                            Consumer<ClockService>(
                              builder: (context, value, child) {
                                return Text(
                                    context.read<ClockService>().repeatChoice);
                              },
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AddAlarmTexts('Vibrate when alarm sounds'),
                      Row(
                        children: [
                          Switch(
                            value: context.read<ClockService>().vibrate,
                            onChanged: (value) {
                              context.read<ClockService>().setVibration();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AddAlarmTexts('Delete after goes off'),
                      Row(
                        children: [
                          const OptionText(
                            text: '',
                          ),
                          Switch(
                            value: context.read<ClockService>().deleteAfterOnce,
                            onChanged: (value) {
                              value:
                              context.read<ClockService>().setDeleteAfterOnce();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          contentPadding: const EdgeInsets.all(15),
                          iconPadding: const EdgeInsets.all(0),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  context.read<ClockService>().setLabelText(
                                      _descriptionController.text.trim());
                                  Navigator.pop(context);
                                },
                                child: const Text('Add')),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ],
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Text(
                            'Add alarm label',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                          content: TextField(
                            controller: _descriptionController,
                            maxLines: 3,
                            minLines: 1,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10),
                                filled: false,
                                border: OutlineInputBorder()),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AddAlarmTexts('Label'),
                          Row(
                            children: [
                              Text(
                                context.read<ClockService>().description.isEmpty
                                    ? 'Enter label'
                                    : context.read<ClockService>().description,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RepeatInkWell extends StatelessWidget {
  const RepeatInkWell({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    var repeatChoiceCheckMark =
        context.watch<ClockService>().repeatChoiceCheckMark;
    return Container(
      color: text == repeatChoiceCheckMark
          ? Colors.blue.shade100
          : Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (text == 'Custom') {
            await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        // height: 1000,
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(0),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Repeat',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ],
                                ),
                              ),
                              const RepeatingDays(day: 'Sunday'),
                              const RepeatingDays(day: 'Monday'),
                              const RepeatingDays(day: 'Tuesday'),
                              const RepeatingDays(day: 'Wednesday'),
                              const RepeatingDays(day: 'Thursday'),
                              const RepeatingDays(day: 'Friday'),
                              const RepeatingDays(day: 'Saturday'),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /*
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: SizedBox(
                                        width: 100,
                                        // height: 75,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              foregroundColor: Colors.black),
                                          onPressed: () {},
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                    ),
                                    */
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
            context.read<ClockService>().setRepeat(text);
            Navigator.pop(context);
          } else {
            context.read<ClockService>().setRepeat(text);
            Navigator.pop(context);
          }
        },
        child: ListTile(
          title: Text(text),
          trailing: text == repeatChoiceCheckMark
              ? const Icon(
                  Icons.check,
                  color: Colors.blue,
                )
              : const Text(''),
        ),
      ),
    );
  }
}

class RepeatingDays extends StatelessWidget {
  const RepeatingDays({super.key, required this.day});

  final String day;

  @override
  Widget build(BuildContext context) {
    Set repeatingDaysList = context.watch<ClockService>().repeatingDaysSet;
    // print('reepating days inisde ')
    return InkWell(
      child: Container(
        color: repeatingDaysList.contains(day)
            ? Colors.grey.shade300
            : Colors.transparent,
        child: ListTile(
          title: Text(day),
          trailing: repeatingDaysList.contains(day)
              ? const Icon(
                  Icons.check_box_rounded,
                  color: Colors.blue,
                )
              : const Icon(
                  Icons.check_box_outline_blank_rounded,
                ),
        ),
      ),
      onTap: () {
        context.read<ClockService>().setRepeatingDays(day);
      },
    );
  }
}

class OptionText extends StatelessWidget {
  const OptionText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey.shade700),
    );
  }
}

class AddAlarmTexts extends StatelessWidget {
  const AddAlarmTexts(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}

class MyTile extends StatelessWidget {
  const MyTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: const Center(child: Text('first item')),
    );
  }
}

/*

 itemExtent: 50,
        perspective:0.0000001 ,

        */
