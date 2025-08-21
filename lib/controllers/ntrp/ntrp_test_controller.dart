import 'dart:async';
import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ota/controllers/ntrp/ntrp_integrate_test_controller.dart';
import 'package:ota/controllers/ntrp/ntrp_result_controller.dart';
import 'package:ota/model/ntrp_data_model.dart';
import 'package:ota/views/total_power_view.dart';

import '../../constants.dart';
import '../../utils/audio_player_util.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../../utils/service_util.dart';
import '../../utils/system_util.dart';
import '../../views/power_view.dart';
import '../../views/show_speed_view.dart';
import '../step_control_page.dart';

/// NTRP 测试
class NtrpTestController extends StatefulWidget {
  const NtrpTestController({super.key});

  @override
  State<NtrpTestController> createState() => _NtrpTestControllerState();
}

class _NtrpTestControllerState extends State<NtrpTestController> {
  List<bool> lights = [
    true,
    true,
    true,
    false,
    false,
    false,
    true,
    true,
    true
  ];
  int maxSpeed = 0; // 正手的最大速度
  int backhandMaxSpeed = 0; // 反手的最大速度
  int speedIndexs = 0;
  int numbersOfHit = 0; // 击中中间三个图形标靶的次数
  int gameIndex = 0; // 0 正手测试 1 反手测试 2截击训练
  bool _startFlag = false;
  String greatJobPrompt = ''; // GreatJob 提示语
  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间
  List<int> _TotalSpeeds = [];

  /// 击中次数
  bool isMove = false; // 是否是移动 区分发球与移动

  List<int> indexList = [];

  bool isPlayingGreatJob = false; /// 是否在播放Great Job 音效
  late StreamSubscription<DataUpdatedEvent> _subscription;

  String rightTypeTitle = "Prepare for Forehand Test";

  int continuousNumberOfShots = 0; // 连续拍数
  int forehandNumberOfShots = 0; // 正手的有效拍数
  int backhandNumberOfShots = 0; // 反手的有效拍数
  int volleyNumberOfShots = 0; // 截击击中中间靶子的有效拍数
  List<int> forehandSpeeds = []; // 正手的速度值的集合
  List<int> backhandSpeeds = []; // 反手的速度值的集合
  List<int> volleySpeeds = []; // 截击的速度值的集合

  List<int> middleTargetIndexs = [11, 12, 13,1]; // 中间三个标靶的索引(1为中间的新增的标靶)

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speakNumber(int number) async {
    await flutterTts.setLanguage("en-US"); // 设置语言
    await flutterTts.setPitch(1.0); // 设置语调
    await flutterTts.setSpeechRate(0.5); // 设置语速
    await flutterTts.speak(number.toString()); // 播放数字
  }

  ///布云朝克特步伐
  final NtrpTaskMap = {
    /// 正手
    1: () => controlRobotMove(300, 0, 13, 1,7, 8,40, 120, 175),
    2: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    3: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    4: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    5: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    6: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    7: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    8: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    9: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    10: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),

    11: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    12: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    13: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    14: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    15: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    16: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    17: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    18: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    19: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),
    20: () => controlRobotMove(0, 0, 13, 1,7, 8,40, 120, 175),



    /// 反手
    21: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    22: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    23: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    24: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    25: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    26: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    27: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    28: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    29: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    30: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),

    31: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    32: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    33: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    34: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    35: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    36: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    37: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    38: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    39: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),
    40: () => controlRobotMove(0, 0, -13, 1,7, 8,40, 120, 175),

    /// 截击球
    41: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    42: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    43: () => controlRobotMove(-100, 0, randomRobotAngle[Random().nextInt(5)],
        1, randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    44: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    45: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    46: () => controlRobotMove(100, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    47: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    48: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    49: () => controlRobotMove(-100, 0, randomRobotAngle[Random().nextInt(5)],
        1, randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),
    50: () => controlRobotMove(100, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 8, 40, 100, 175),

    51: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    52: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    53: () => controlRobotMove(-100, 0, randomRobotAngle[Random().nextInt(5)],
        1, randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    54: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    55: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    56: () => controlRobotMove(100, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    57: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    58: () => controlRobotMove(0, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    59: () => controlRobotMove(-100, 0, randomRobotAngle[Random().nextInt(5)],
        1, randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    60: () => controlRobotMove(100, 0, randomRobotAngle[Random().nextInt(5)], 1,
        randomRobotHeight[Random().nextInt(3)], 9, 40, 100, 175),
    // 向前走60 不发球
    // 31: () => controlRobotMove(60, 0, 0, 0, 16, 12, 40, 90, 175),
  };

  /*开始*/
  void startGame() {
    if(CommStatusManager().currentConnectedDevice == null){
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params =
        TennisMachineParams.fromState(0, 310, 0, 7, 8, 40, 100, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }

  /// 击中某个标靶闪灯（熄灭 在出现）
  void flashingLight(int targetIndex) {
    if (targetIndex == 12){  // 顶部三角形
      lights = [ true, true, true, true, false, false, true, true, true];
      setState(() {});
      Future.delayed(Duration(milliseconds: 500),(){
        lights = [ true, true, true, false, false, false, true, true, true];
        setState(() {});
      });
    } else if(targetIndex == 11) { // 右侧图形
      lights = [ true, true, true, false, false, true, true, true, true];
      setState(() {});
      Future.delayed(Duration(milliseconds: 500),(){
        lights = [ true, true, true, false, false, false, true, true, true];
        setState(() {});
      });
    } else if(targetIndex == 13) { // 左侧图形
      lights = [ true, true, true, false, true, false, true, true, true];
      setState(() {});
      Future.delayed(Duration(milliseconds: 500),(){
        lights = [ true, true, true, false, false, false, true, true, true];
        setState(() {});
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // playLocalAudio('blueMonday1.MP3', isAlwaysplay: true);
    startGame();
    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        _TotalSpeeds.add(CommStatusManager().currentSpeed);
        // 显示速度
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        if (CommStatusManager().currentSpeed > 70  && isPlayingGreatJob == false) {
          greatJobPrompt = "Great Job !";
          setState(() {});
          playOnceLocalAudio("greatjob.mp3");
          isPlayingGreatJob = true;
          Future.delayed(Duration(milliseconds: 3000),(){
            isPlayingGreatJob = false;
          });
        }


        if (CommStatusManager().currentSpeed <= 70) {
          _speakNumber(CommStatusManager().currentSpeed);
        }


        // continuousNumberOfShots ++;

        if (speedIndexs <= 11 +10) {
          // 正手测试
          // forehandNumberOfShots ++;
          forehandSpeeds.add(CommStatusManager().currentSpeed);
        } else if (speedIndexs >= 12 + 10 && speedIndexs <= 21 + 20) {
          // 反手测试
          // backhandNumberOfShots ++;
          backhandSpeeds.add(CommStatusManager().currentSpeed);
        } else if (speedIndexs >= 22 + 10) {
          // 截击测试
          // volleyNumberOfShots ++;
          volleySpeeds.add(CommStatusManager().currentSpeed);
        }

        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        indexList.add(0);
        speedIndexs++;
        NtrpTestGame();
        if (speedIndexs <= 11 + 10) {
          // 正手最大速度获取
          maxSpeed = maxSpeed > CommStatusManager().currentSpeed
              ? maxSpeed
              : CommStatusManager().currentSpeed;
        } else if (speedIndexs > 12  + 10 && speedIndexs <= 21 + 20) {
          if (speedIndexs == 11) {
            gameIndex++;
            // 进入到反手训练
          }
          // 反手控制力量测试
          // 反手最大速度测试
          backhandMaxSpeed = backhandMaxSpeed > CommStatusManager().currentSpeed
              ? backhandMaxSpeed
              : CommStatusManager().currentSpeed;
          rightTypeTitle = 'Backhand Test';
        } else {
          if (speedIndexs == 22 + 20) {
            rightTypeTitle = 'Volley Test';
            gameIndex++;
            // 进入到截击训练
          }
        }
        if (speedIndexs == 31 + 30) {
          /// 测评结束
          print("${forehandSpeeds}");
          print("${backhandSpeeds}");
          print("${volleySpeeds}");
          gotoEndPage();
        }
        _startFlag = true;
        print('nTRP Test  kStepControlFinishResponse--=${speedIndexs}');
      } else if (event.data == kTargetIndex) {
        /// 击中标靶的索引
        if (_updateTime(1) < 1000) {
          return;/// 1s内不处理
        }
        if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
          continuousNumberOfShots++;
          if (speedIndexs <= 11 + 10) {
            forehandNumberOfShots++; // 正手的有效击中
          } else if (speedIndexs > 12 + 10 && speedIndexs <= 21 + 20) {
            backhandNumberOfShots++;// 反手手的有效击中
          } else if (speedIndexs >= 22 + 20) {
            /// 击中了中间的标靶
            volleyNumberOfShots++;
          }
          flashingLight(CommStatusManager().targetIndex[0]);
        }
      }
      if (mounted) {
        setState(() {});
      }
    });

   // Future.delayed(Duration(milliseconds: 5000),(){
   //   flashingLight(12);
   //   Future.delayed(Duration(milliseconds: 3000),(){
   //     flashingLight(11);
   //     Future.delayed(Duration(milliseconds: 3000),(){
   //       flashingLight(13);
   //     });
   //   });
   // });



    // Future.delayed(Duration(milliseconds: 2000), () {
    //   var powerControlRate = (1 / 6.toDouble() *100).toStringAsFixed(0);
    //
    //   var model = NtrpDataModel(forehand: 3,
    //       forehandAvgSpeed: 100,
    //       backhand: 5,
    //       backhandAvgSpeed: 90,
    //       volley: 6);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) =>NtrpResultController(
    //       rightUserModel: model,type: resultType.technicalProficiencyResult,
    //     )), // 结算页面
    //   );
    //   setState(() {});
    // });
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

  void gotoEndPage() {
    /// 判断绩点 是否达到2.5的标准

    double rightSum = forehandSpeeds.fold(
        0.0, (previousValue, element) => previousValue + element);
    int rightcount = forehandSpeeds.length;
    double foreaveragSpeed = rightSum / rightcount;

    double backSum = backhandSpeeds.fold(
        0.0, (previousValue, element) => previousValue + element);
    int backcount = backhandSpeeds.length;
    double backaveragSpeed = backSum / backcount;

    var model = NtrpDataModel(
        forehand: forehandNumberOfShots,
        forehandAvgSpeed: foreaveragSpeed.toInt(),
        backhand: backhandNumberOfShots,
        backhandAvgSpeed: backaveragSpeed.toInt(),
        volley: volleyNumberOfShots);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NtrpResultController(
                rightUserModel: model,
              )), // 结算页面
    );
    setState(() {});

    /// 正手 反手击中率 加一起 >=100%
    /// 第一阶段
    // 正手反手的击中率 >= 100%
    // 正手的平均速度>= 50Km/h
    // 反手手的平均速度>= 40Km/h
    // 截击球的击中率 >=30%.
    var shotRate = forehandNumberOfShots + backhandNumberOfShots;
    if (shotRate >= 20
        && volleyNumberOfShots >= 6
        && foreaveragSpeed >= 50
        && backaveragSpeed >= 40 ) {
      CommStatusManager().ntrpTechnicalProficiencyResult = true;
    }
    print("第一阶段测评结果为${CommStatusManager().ntrpTechnicalProficiencyResult}");
    /// 机器人回到原点，为下一阶段做准备
    CommStatusManager().writerData(positionCheckData());
  }

  ///NtrpTest 步伐
  void NtrpTestGame() {
    NtrpTaskMap[indexList.length]?.call();
  }

  @override
  Widget build(BuildContext context) {
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
                  /// Forehand
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Forehand',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        "${forehandNumberOfShots}/20",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                      Text(
                        forehandSpeeds.length > 0
                            ? "${forehandSpeeds.last}km/h"
                            : "0km/h",
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

                  /// Backhand
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Backhand',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        speedIndexs >= 20
                            ? '${backhandNumberOfShots}/20'
                            : '${0}/20',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                      Text(
                        backhandSpeeds.length > 0
                            ? "${backhandSpeeds.last}km/h"
                            : "0km/h",
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

                  /// Volley
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Volley',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${volleyNumberOfShots}/20',
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
                      '${rightTypeTitle}',
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
            child: TotalPowerView(
              hideIndex: lights,
            ),
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

  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    _subscription.cancel();
    CommStatusManager().isDeviceDeail = false;
    CommStatusManager().currentSpeed = 0;
    pause();
    super.dispose();
  }
}
