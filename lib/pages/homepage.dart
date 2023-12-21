import 'package:alarm_clock_self/pages/alarm_page.dart';
import 'package:alarm_clock_self/routes/routes.dart';
import 'package:alarm_clock_self/services/alarm_service.dart';
import 'package:alarm_clock_self/services/clock_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.alarm),
                    ),
                    Tab(
                      icon: Icon(Icons.lock_clock),
                    ),
                    Tab(
                      icon: Icon(Icons.timer),
                    ),
                    Tab(
                      icon: Icon(Icons.hourglass_bottom),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 8),
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      const AlarmPage(),
                      Container(
                        color: Colors.blue,
                      ),
                      Container(
                        color: Colors.blueGrey,
                      ),
                      Container(
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: context.watch<AlarmService>().selectedList.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                if (tabController.index == 0) {
                  Navigator.pushNamed(context, RouteManager.addAlarmPage);
                  // calling this global func to set initial global variables hour/minute indexes
                  setInitialCurrentTime();
                  // this function is to set the text in 'alrm in this many hours'
                  context.read<ClockService>().setAlarmInText();
                  // initial alarm descrition/label to empty text
                  context.read<ClockService>().setLabelText('');
                  context.read<ClockService>().clearRepeatingDays();
                  context.read<ClockService>().setRepeatChoiceText();
                  editable = false;
                }
              },
              shape: const CircleBorder(
                  side: BorderSide(width: 1, color: Colors.transparent)),
              splashColor: Colors.green,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.add,
                size: 50,
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                context
                    .read<AlarmService>()
                    .deleteAlarm(context.read<AlarmService>().selectedList);
              },
              shape: const CircleBorder(
                  side: BorderSide(width: 1, color: Colors.transparent)),
              splashColor: Colors.green,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.delete,
                size: 50,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
