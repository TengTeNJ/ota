import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../model/ntrp_data_model.dart';
import '../../utils/audio_player_util.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../../views/show_speed_view.dart';
import '../../views/total_power_view.dart';
import '../step_control_page.dart';
import 'ntrp_result_controller.dart';

/// 综合测试 （一共50个球）
/// 综合测试-力量60%控制正手10球、反手10球、移动打靶击球30球
class NtrpIntegrateTestController extends StatefulWidget {
  const NtrpIntegrateTestController({super.key});

  @override
  State<NtrpIntegrateTestController> createState() =>
      _NtrpIntegrateTestControllerState();
}

class _NtrpIntegrateTestControllerState
    extends State<NtrpIntegrateTestController> {
  List<bool> lights = [true, true, true, false, false, false, true, true, true];

  int powerControlShots = 0; //力量控制的有效拍数
  int moveShots = 0; // 移动标靶的有效拍数
  List<int> powerControlSpeeds = []; // 力量控制速度值的集合
  List<int> moveSpeeds = []; // 移动标靶速度值的集合
  int powerControlAvgSpeed = 0; //力量控制的平均速度
  int moveAvgSpeed = 0; //移动标靶的平均速度


  String middleTitle = "";
  bool _startFlag = false;

  /// 屏幕中间提示语
  int speedIndexs = 0;

  late StreamSubscription<DataUpdatedEvent> _subscription;

  List<int> middleTargetIndexs = [11,12, 13,1];// 中间三个标靶的索引(1为中间的新增的标靶)
  List<int> leftTargetIndexs = [14,15,0];// 左侧三个标靶的索引
  List<int> rightTargetIndexs = [8,9,10];// 右侧三个标靶的索引


  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间

  ///发球机步伐
  ///综合测试-力量60%控制正手10球、反手10球、 移动打靶击球30球（先亮右边三个灯5  中间三个灯5个球 左边5个球）
  final NtrpIntegrateTaskMap = {
    /// 正手
    1: () => controlRobotMove(300, 0, 13, 1,8, 9,40, 100, 175),
    2: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    3: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    4: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    5: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    6: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    7: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    8: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    9: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    10: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),

    /// 反手
    11: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    12: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    13: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    14: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    15: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    16: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    17: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    18: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    19: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    20: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),

    ///  移动打靶30 个球 （5正手  5中间 5反手  5正手  5中间 5反手）
    // 正手
    21: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    22: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    23: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    24: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    25: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    // 中间
    26: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    27: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    28: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    29: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    30: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),

    // 反手
    31: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    32: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    33: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    34: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    35: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),

    // 正手
    36: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    37: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    38: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    39: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),
    40: () => controlRobotMove(0, 0, 13, 1,8, 9,40, 100, 175),

    // 中间
    41: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    42: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    43: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    44: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),
    45: () => controlRobotMove(0, 0, 0, 1,8, 9,40, 100, 175),

    // 反手
    46: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    47: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    48: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    49: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),
    50: () => controlRobotMove(0, 0, -13, 1,8, 9,40, 100, 175),

    // 向前走60 不发球
    // 31: () => controlRobotMove(60, 0, 0, 0, 16, 12, 40, 90, 175),
  };

  List<int> indexList = [];

  ///NtrpTest 步伐
  void NtrpTestGame() {
    NtrpIntegrateTaskMap[indexList.length]?.call();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(milliseconds: 2000), () {
    //     lights = [true, true, true, true, true, true, false, false, false];
    //     setState(() {});
    //     Future.delayed(Duration(milliseconds: 2000),(){
    //       lights = [true, true, true, false, false, false, true, true, true];
    //       setState(() {});
    //
    //         Future.delayed(Duration(milliseconds: 2000),() {
    //           lights = [false, false, false, true, true, true, true, true, true];
    //           setState(() {});
    //
    //         });
    //     });
    // });


    startGame();
    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        // _TotalSpeeds.add(CommStatusManager().currentSpeed);
        // 显示速度
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        if (CommStatusManager().currentSpeed > 70) {
          setState(() {});
          playOnceLocalAudio("greatjob.mp3");
        }

        if (CommStatusManager().currentSpeed < 70) {
          (CommStatusManager().currentSpeed);
        }
        if (speedIndexs <= 21) {
          // 力量控制
          powerControlSpeeds.add(CommStatusManager().currentSpeed);
          // 计算平均速度
          double rightSum = powerControlSpeeds.fold(
              0.0, (previousValue, element) => previousValue + element);
          powerControlAvgSpeed  = (rightSum / powerControlSpeeds.length).toInt();
        } else if (speedIndexs > 21 && speedIndexs <= 51) {
          // 随机标靶
          moveSpeeds.add(CommStatusManager().currentSpeed);
          // 计算平均速度
          double rightSum = moveSpeeds.fold(
              0.0, (previousValue, element) => previousValue + element);
          moveAvgSpeed  = (rightSum / moveSpeeds.length).toInt();
        }
        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        indexList.add(0);
        speedIndexs++;
        NtrpTestGame();
        middleTitle = "";
        if (speedIndexs <= 21) {
          middleTitle = "Please Use 60% power";
          /// 只亮中间标靶
          lights = [true, true, true, false, false, false, true, true, true];
        } else if (speedIndexs > 21 && speedIndexs <= 26) {
          /// 只亮右边三个标靶标靶
          lights = [true, true, true, true, true, true, false, false, false];
        } else if (speedIndexs >26 && speedIndexs <= 31) {
          /// 只亮中间标靶
          lights = [true, true, true, false, false, false, true, true, true];
        } else if (speedIndexs >31 && speedIndexs <= 36) {
          /// 只亮左边标靶
          lights = [false, false, false, true, true, true, true, true, true];
        } else if (speedIndexs > 37 && speedIndexs <= 41) {
          /// 只亮右边三个标靶标靶
          lights = [true, true, true, true, true, true, false, false, false];
        } else if (speedIndexs >41 && speedIndexs <= 46) {
          /// 只亮中间标靶
          lights = [true, true, true, false, false, false, true, true, true];
        } else if (speedIndexs >46 && speedIndexs <= 51) {
          /// 只亮左边标靶
          lights = [false, false, false, true, true, true, true, true, true];
        }

        if (speedIndexs == 51) {
          gotoEndPage();
        }
        _startFlag = true;
        print('nTRP Test  kStepControlFinishResponse--=${speedIndexs}');
      } else if (event.data == kTargetIndex) {
        /// 击中标靶的索引
        if (_updateTime(1) < 1000) {
          return;/// 1s内不处理
        }

        if (speedIndexs <= 21) {
          /// 只亮中间标靶
          if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0]) ) {
            powerControlShots ++;
          }
        } else if (speedIndexs > 21 && speedIndexs <= 26) {
          /// 只亮右边三个标靶标靶
          if (rightTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        } else if (speedIndexs >26 && speedIndexs <= 31) {
          /// 只亮中间标靶
          if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        } else if (speedIndexs >31 && speedIndexs <= 36) {
          /// 只亮左边标靶
          if (leftTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        } else if (speedIndexs > 37 && speedIndexs <= 41) {
          /// 只亮右边三个标靶标靶
          if (rightTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        } else if (speedIndexs >41 && speedIndexs <= 46) {
          /// 只亮中间标靶
          if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        } else if (speedIndexs >46 && speedIndexs <= 51) {
          /// 只亮左边标靶
          if (leftTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            moveShots ++;
          }
        }


      }
      if (mounted) {
        setState(() {});
      }
    });

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   var powerControlRate = (1 / 6.toDouble() * 100).toStringAsFixed(0);
    //   var model = NtrpDataModel(
    //       powerControlCount: 10,
    //       powerControlAvgSpeed: 45,
    //       moveShotsIn: 1,
    //       moveShotsInAvgSpeed: 59);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => NtrpResultController(
    //               rightUserModel: model,
    //               type: resultType.multiDimensionalResult,
    //             )), // 结算页面
    //   );
    //   setState(() {});
    // });
  }

  void gotoEndPage() {
    Future.delayed(Duration(milliseconds: 2000), () {
      var powerControlRate = (1 / 6.toDouble() * 100).toStringAsFixed(0);
        var model = NtrpDataModel(
            powerControlCount: powerControlShots,
            powerControlAvgSpeed: powerControlAvgSpeed,
            moveShotsIn: moveShots,
            moveShotsInAvgSpeed: moveAvgSpeed);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NtrpResultController(
                  rightUserModel: model,
                  type: resultType.multiDimensionalResult,
                )), // 结算页面
      );


      // 第二阶段
      // powerControl的击中率 >= 50%
      // 正手的平均速度>= 50Km/h
      // 反手手的平均速度>= 40Km/h
      // 移动靶的击中率 >=30%.
      if (powerControlShots >= 10
          && moveShots >= 9
          && powerControlAvgSpeed >= 50
          && moveAvgSpeed >= 40 ) {
        CommStatusManager().ntrpMultiDimensionalResult = true;
      }
      print("第二阶段测评结果为${CommStatusManager().ntrpMultiDimensionalResult}");

      setState(() {});
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

  /*开始*/
  void startGame() {
    if (CommStatusManager().currentConnectedDevice == null) {
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params =
        TennisMachineParams.fromState(0, 310, 0, 8, 9, 40, 120, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }

  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          Positioned(
              left: 32,
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// powerControlS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Power Control shots',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        "${powerControlShots}/20",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                      Text(
                       "${powerControlAvgSpeed}km/h",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 46,
                  ),

                  /// move shot
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Move shots',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        "${moveShots}/30",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                      Text(
                        "${moveAvgSpeed}km/h",
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

          /// 中间测试标题
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${middleTitle}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "tengxun",
                          fontSize: 18,
                          color: Colors.orange),
                    ),
                  ],
                )
              ],
            ),
            left: 16,
            right: 16,
            top: 200,
          ),

          Center(
            child: Container(
                child: TotalPowerView(
              hideIndex: lights,
            )),
          ),

          /// stop 暂停按钮
          Positioned(
            bottom: 40,
            left: 40,
            child: GestureDetector(
                onTap: () {
                  print("123");
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/stop.png',
                        width: 16.44,
                        height: 14,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'NTRP TEST',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "tengxun",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
