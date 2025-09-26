import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/utils/system_util.dart';

import '../../constants.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../../utils/service_util.dart';
import '../../views/show_speed_view.dart';
import '../../views/total_power_view.dart';
import 'controller/fire_controller.dart';
import 'controller/horizontal_move_tasks.dart';

class HorizontalMovePage extends StatefulWidget {
  const HorizontalMovePage({super.key});

  @override
  State<HorizontalMovePage> createState() => _HorizontalMovePageState();
}

class _HorizontalMovePageState extends State<HorizontalMovePage> {
  late StreamSubscription<DataUpdatedEvent> _subscription;
  List<bool> lights = [true, true, true, false, false, false, true, true, true];
  List<int> middleTargetIndexs = [11, 12, 13, 1]; // 中间三个标靶的索引(1为中间的新增的标靶)
  int gameIndex = 0;
  int hasSendedCount = 0; // 已发球的个数
  int targetShotCount = 0; //  击中标靶的个数
  int maxSpeed = 0; // 最大速度
  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemUtil.lockScreenHorizontalDirection();
    initData();
    fireControll();
    dataListen();
  }

  // 初始化数据
  void initData() {
    CommStatusManager().isDeviceDeail = true;
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
        if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
          if (_updateTime(1) < 1000) {
            return;/// 1s内不处理
          };
          setState(() {
            targetShotCount++;
          });
        }
      }
    });
  }

  // 发球控制
  void fireControll() {
    final plan = FirePlan.leftCenterRight(count: 10);
    final controller = FireController(plan.tasks);
    controller.onProgress = (taskIndex, shotIndex) {
      print("第 $taskIndex 个点位，第 $shotIndex 球完成");
      setState(() {
        hasSendedCount ++;
      });
    };
    controller.onFinished = () {
      print("任务计划完成！");
      CommStatusManager().writerData(changeModeData(0xff));
    };
    controller.start();
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
                      '步伐训练',
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
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Avg.Speed',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 14,
                  //           fontFamily: "SanFranciscoDisplay",
                  //           color: Colors.white),
                  //     ),
                  //     Text(
                  //       '${maxSpeed}km/h',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18,
                  //           fontFamily: "tengxun",
                  //           color: Color.fromRGBO(21, 233, 120, 1.0)),
                  //     ),
                  //   ],
                  // ),
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

          /// 一轮结束的提示语
          // Positioned(
          //     top: CommStatusManager().currentSpeed > 70 ? 160 : 220,
          //     left: 400,
          //     child: speedIndexs == 30 || speedIndexs == 50
          //         ? Center(
          //       child: Text(
          //         '${endPrompt}',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 32,
          //             color: Colors.white),
          //       ),
          //     )
          //         : Container()),

          /// Great job 提示语
          Positioned(
              top: 220,
              left: 400,
              child: CommStatusManager().currentSpeed > 70
                  ? Center(
                      child: Text(
                        'greatJobPrompt}',
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
