import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/views/total_power_view.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/system_util.dart';
import '../views/show_speed_view.dart';
class NewBattleTargetPage extends StatefulWidget {
  const NewBattleTargetPage({super.key});

  @override
  State<NewBattleTargetPage> createState() => _NewBattleTargetPageState();
}

class _NewBattleTargetPageState extends State<NewBattleTargetPage> {
  List<bool> lights = [false, false, false, true, true, true, false, false, false];
  int _index = 1;
  int _currentIndex = 0;
  int _leftIndex = 0;
  int _rightIndex = 0;
  late StreamSubscription<DataUpdatedEvent> _subscription;
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
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        _currentIndex ++;
        if(_currentIndex % 2 != 0){
          print('左侧-----');
          //  左侧
          _leftIndex ++;
          lights.fillRange(0, _leftIndex, true); // 熄灭左侧
          if(_leftIndex == 3){
            _leftIndex = 0;
          }
        }else{
          print('右侧-----');
          // 右侧
          _rightIndex ++;
          lights.fillRange(6, 6 + _rightIndex, true); // 熄灭右侧
          if(_rightIndex == 3){
            _rightIndex = 0;
            lights.fillRange(0, 3, false); // 重置左侧
            lights.fillRange(6, 9, false); // 重置右侧
          }
        }

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
    _subscription.cancel();
    super.dispose();
  }
}
