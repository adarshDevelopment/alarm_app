import 'package:alarm_clock_self/routes/routes.dart';
import 'package:alarm_clock_self/services/alarm_service.dart';
import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  void initState() {
    super.initState();
    context.read<AlarmService>().getAllAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlarmService>(
      builder: (context, value, child) {
        return ListView.builder(
            itemCount: value.alarms.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () {
                  context
                      .read<AlarmService>()
                      .changeIsSelected(value.alarms[index]);
                  context.read<AlarmService>().selectItems(value.alarms[index]);
                  // Navigator.pop(context);
                },
                onTap: () {
                  if (context.read<AlarmService>().selectedList.isNotEmpty) {
                    context
                        .read<AlarmService>()
                        .changeIsSelected(value.alarms[index]);
                    context
                        .read<AlarmService>()
                        .selectItems(value.alarms[index]);
                  } else {
                    editable = true;
                    context
                        .read<ClockService>()
                        .editAlarmUI(value.alarms[index]);
                        context.read<ClockService>().setAlarmInText();
                    Navigator.pushNamed(context, RouteManager.addAlarmPage);
                  }
                },
                child: Card(
                  child: ListTile(
                    // title: Text(value.alarms[index].alarmDate.toString()),
                    title: Text(
                        DateFormat.jm().format(value.alarms[index].alarmDate)),
                    // title: Text('id: ${value.alarms[index].alarmId}'),
                    subtitle: Text(
                        // '${!value.alarms[index].isActive || !value.alarms[index].onRepeat == true ? 'Custom' : 'Once'} | ${value.alarms[index].description}'),
                        '${value.alarms[index].onRepeat == true ? 'Custom' : 'Once'} | ${value.alarms[index].description}'),
                    trailing: context.read<AlarmService>().selectedList.isEmpty
                        ? Switch(
                            value: value.alarms[index].isActive,
                            onChanged: (boolValue) {
                              value.alarms[index].isActive =
                                  !value.alarms[index].isActive;
                              context
                                  .read<AlarmService>()
                                  .toggleActiveAlarm(value.alarms[index]);
                            },
                          )
                        : Checkbox(
                            value: value.alarms[index].isSelected,
                            onChanged: (boolValue) {},
                          ),
                  ),

                  /*
                    Container(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(value.alarms[index].alarmDate.toString()),
                          Text(!value.alarms[index].isActive &&
                                  !value.alarms[index].onRepeat
                              ? 'Once'
                              : 'Weekly')
                        ],
                      )
                    ],
                  ),
                )
                */
                ),
              );
            });
      },
    );
  }
}

List entries = ['first', 'second', 'third', 'forth'];
/*
Card(
            child: ListTile(
              title: Text(entries[index]),
              subtitle: const Text('Description of the alarm'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          )

          */


/**
 * 
 *showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.white),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () async {
                            value.selectItems(value.alarms[index]);
                            value.changeIsSelected(value.alarms[index]);
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  );
 * 
 */