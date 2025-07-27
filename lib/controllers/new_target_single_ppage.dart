import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/views/total_power_view.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/system_util.dart';
import '../views/show_speed_view.dart';
class NewTargetSinglePpage extends StatefulWidget {
  const NewTargetSinglePpage({super.key});

  @override
  State<NewTargetSinglePpage> createState() => _NewTargetSinglePpageState();
}

class _NewTargetSinglePpageState extends State<NewTargetSinglePpage> {
  List<bool> lights = [true, true, true, false, false, false, true,true,true];
  int _index = 1;
  int _currentIndex = 0;
  late StreamSubscription<DataUpdatedEvent> _subscription;
  bool _startFlag = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        // 监测到速度数据
        // if (!_startFlag) {
        //   return;
        // }
        // 显示速度
        print('------');
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
      } else if (event.data == kStepControlFinishResponse) {
        // 步伐控制结束回复
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
                Column(
                  children: [
                    Text(
                      '第${_index}轮',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      'Total Shots',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${_currentIndex}/50',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromRGBO(21, 233, 120, 1.0)),
                    ),
                  ],
                )
              ],
            ),
            left: 16,
            right: 16,
            top: 16,
          ),
          Center(
            child: Container(child: TotalPowerView(hideIndex: lights,)),
          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    super.dispose();
  }
}
