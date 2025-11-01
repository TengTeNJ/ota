import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/audio_player_util.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../../utils/service_util.dart';
import '../../utils/system_util.dart';
import '../../views/show_speed_view.dart';
import '../../views/total_power_view.dart';
import '../step_control_page.dart';


/// 正反手训练
class NewForeBackPage extends StatefulWidget {
  const NewForeBackPage({super.key});

  @override
  State<NewForeBackPage> createState() => _NewForeBackPageState();
}

class _NewForeBackPageState extends State<NewForeBackPage> {
  late StreamSubscription<DataUpdatedEvent> _subscription;
  List<bool> lights = [false, false, false, true, true, true, true, true, true];
  List<int> middleTargetIndexs = [11, 12, 13, 1]; // 中间三个标靶的索引(1为中间的新增的标靶)
  List<int> leftTargetIndexs = [14,15,0];// 左侧三个标靶的索引
  List<int> rightTargetIndexs = [8,9,10];// 右侧三个标靶的索引

  int gameIndex = 0;
  int hasSendedCount = 0; // 已发球的个数
  int targetShotCount = 0; //  击中标靶的个数
  int maxSpeed = 0; // 最大速度
  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间

  ///发球机步伐
  final ForeBackTaskMap = {
    /// 正手
    1: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    2: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    3: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    4: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    5: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    6: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    7: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    8: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    9: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    10: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    11: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    12: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    13: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    14: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    15: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    16: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    17: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    18: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    19: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    20: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    21: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    22: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    23: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    24: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),
    25: () => controlRobotMove(0, 0, 20 ,1,8, 11,40, 150, 175),

    // 移动5m
    26: () => controlRobotMove(500, 0, 0, 1,7, 8,40, 120 ,175),

    /// 反手
    27: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    28: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    29: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    30: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    31: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    32: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    33: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    34: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    35: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    36: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    37: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    38: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    39: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    40: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    41: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    42: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    43: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    44: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    45: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    46: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    47: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    48: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    49: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
    50: () => controlRobotMove(0, 0,-20, 1,8, 11,40, 150, 175),
  };
  List<int> indexList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemUtil.lockScreenHorizontalDirection();
    initData();
    dataListen();
  }

  // 初始化数据
  void initData() {
    CommStatusManager().isDeviceDeail = true;

    if (CommStatusManager().currentConnectedDevice == null) {
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params =
    TennisMachineParams.fromState(0, 100, 0, 8, 8, 40, 120 ,125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }

  // 数据监听
  dataListen() {
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        // 收到速度数据
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        print('CommStatusManager().currentSpeed=${CommStatusManager().currentSpeed}');
        setState(() {
          maxSpeed = max(maxSpeed, CommStatusManager().currentSpeed);
        });
      } else if (event.data == kTargetIndex) {
        // 标靶击中
        print('power界面 击中标靶的索引为${CommStatusManager().targetIndex}');
        if (_updateTime(1) < 1000) {
          return;/// 1s内不处理
        };

        if (indexList.length <= 26) {
          if (leftTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            setState(() {
              targetShotCount++;
            });
          }
        }
        if (indexList.length > 26) {
          if (rightTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            setState(() {
              targetShotCount++;
            });
          }
        }
      } else if(event.data == kStepControlFinishResponse) {
        indexList.add(0);
        ForeBackTaskMap[indexList.length]?.call();
        if (indexList.length >= 26) {
          /// 亮右边的标靶
          lights = [true, true, true, true, true, true, false, false, false];
          setState(() {});
        }


      }
    });
  }

  int _updateTime(double timeStamp) {
    // 如果这是第一次调用，记录当前时间
    if (_lastShotInTime == null) {
      _lastShotInTime = DateTime.now();
      return 0;
    }

    // 计算时间差
    final timeDifference =
        DateTime.now().difference(_lastShotInTime).inMilliseconds;
    print('时间差: $timeDifference');
    if (timeDifference > 1000) {
      _lastShotInTime = DateTime.now();
    }
    // 更新最后一次时间
    //   _lastUpdateTime = DateTime.now();
    return timeDifference;
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
                    /// 用户没有玩完游戏直接退出界面 机器人位置校准回到原点
                    // CommStatusManager().writerData(positionCheckData());
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_sharp),
                  color: Colors.white,
                ),
              ],
            ),
            left: 16,
            right: 16,
            top: 16,
          ),

          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   icon: Icon(Icons.arrow_back_ios),
                //   color: Colors.white,
                // ),
                Column(
                  children: [
                    Text(
                      '正反手训练',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "tengxun",
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            left: 16,
            right: 16,
            top: 40,
          ),
          Positioned(
              left: 32,
              top: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Shots',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${hasSendedCount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shot In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        "${targetShotCount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Top Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${maxSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 26,
                  ),
                ],
              )),
          if (gameIndex != 0)
            Positioned(
                right: 32,
                top: 40,
                child: Row(
                  children: [
                    Text(
                      ' Power Control',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "tengxun",
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      '${calculateScopePercentage(CommStatusManager().currentSpeed, 0)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange),
                    ),
                  ],
                )),
          // Center(
          //   child: PowerView(),
          // ),

          Center(
            child: TotalPowerView(
              hideIndex: lights,
            ),
          ),


          /// Great job 提示语
          Positioned(
              top: 220,
              left: 400,
              child: CommStatusManager().currentSpeed > 70
                  ? Center(
                child: Text(
                  '',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white),
                ),
              )
                  : Container()),

          /// stop 暂停按钮
          Positioned(
            bottom: 40,
            left: 40,
            child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/stop.png',
                    width: 16.44,
                    height: 14,
                  ),
                )),
          ),
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
