import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ota/controllers/ntrp/ntrp_result_controller.dart';
import 'package:ota/model/ntrp_data_model.dart';

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
  List<bool> lights = [false, false, false, true, true, true, false, false];
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

  ///
  late StreamSubscription<DataUpdatedEvent> _subscription;

  String rightTypeTitle = "Forehand Test";

  int continuousNumberOfShots = 0; // 连续拍数
  int forehandNumberOfShots = 0; // 正手的有效拍数
  int backhandNumberOfShots = 0; // 反手的有效拍数
  int volleyNumberOfShots = 0; // 截击击中中间靶子的有效拍数
  List<int> forehandSpeeds = []; // 正手的速度值的集合
  List<int> backhandSpeeds = []; // 反手的速度值的集合
  List<int> volleySpeeds = []; // 截击的速度值的集合


  int powerControlCount = 0; // 力量控制成功的count

  List<int> middleTargetIndexs = [11,12,13];// 中间三个标靶的索引

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
    1: () => controlRobotMove(200, 0, 13, 1, 13, 13, 40, 120, 175),
    2: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    3: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    4: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    5: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    6: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    7: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    8: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    9: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    10: () => controlRobotMove(0, 0, 13, 1, 13, 13, 40, 120, 175),
    /// 反手
    11: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    12: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    13: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    14: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    15: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    16: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    17: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    18: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    19: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    20: () => controlRobotMove(0, 0, -13, 1, 13, 13, 40, 120, 175),
    /// 截击球
    21: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    22: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    23: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    24: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    25: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    26: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    27: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    28: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    29: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    30: () => controlRobotMove(0, 0, 0, 1, 14, 12, 40, 90, 175),
    // 向前走60 不发球
    // 31: () => controlRobotMove(60, 0, 0, 0, 16, 12, 40, 90, 175),
  };

  /*开始*/
  void startGame() {
    // if(CommStatusManager().currentConnectedDevice == null){
    //   print('测速器未连接---');
    //   return;
    // }
    TennisMachineParams params = TennisMachineParams.fromState(
        0, 310, 0, 14, 14, 40, 120, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startGame();
    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        _TotalSpeeds.add(CommStatusManager().currentSpeed);
        // 显示速度
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        if (CommStatusManager().currentSpeed > 70) {
          greatJobPrompt = "Great Job !";
          setState(() {});
          playOnceLocalAudio("greatjob.mp3");
        }

        if (CommStatusManager().currentSpeed < 70) {
          _speakNumber(CommStatusManager().currentSpeed);
        }

        continuousNumberOfShots ++;

        if(speedIndexs <=11 ){ // 正手测试
          forehandNumberOfShots ++;
          forehandSpeeds.add(CommStatusManager().currentSpeed);
        } else if(speedIndexs >=12 && speedIndexs <= 21) {  // 反手测试
          backhandNumberOfShots ++;
          backhandSpeeds.add(CommStatusManager().currentSpeed);
        } else if (speedIndexs >=22) { // 截击测试
          // volleyNumberOfShots ++;
          volleySpeeds.add(CommStatusManager().currentSpeed);
        }
        /// 正手反手的力量控制逻辑
        if (speedIndexs >=9 && speedIndexs <= 11) {
          var rate =  (CommStatusManager().currentSpeed / maxSpeed).toDouble();
          if(rate >= 55.0 && rate <= 65.0) {
            powerControlCount ++;
          }
        }

        if (speedIndexs >=19 && speedIndexs <= 21) {
          var rate =  (CommStatusManager().currentSpeed / backhandMaxSpeed).toDouble();
          if(rate >= 55.0 && rate <= 65.0) {
            powerControlCount ++;
          }
        }
        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        indexList.add(0);
        speedIndexs++;
        NtrpTestGame();
        if (speedIndexs <= 11) {
          // 正手控制力量测试
           if (speedIndexs >= 9) {
             rightTypeTitle = 'Please Use 60% power';
           } else {
             // 正手最大速度获取
             maxSpeed = maxSpeed > CommStatusManager().currentSpeed
                 ? maxSpeed
                 : CommStatusManager().currentSpeed;
           }
        } else if (speedIndexs > 12 && speedIndexs <= 21) {
          if (speedIndexs == 11) {
            gameIndex++;
            // 进入到反手训练
          }
          // 反手控制力量测试
          if (speedIndexs >= 19) {
            rightTypeTitle = 'Please Use 60% power';
          } else {
            // 反手最大速度测试
            backhandMaxSpeed = backhandMaxSpeed > CommStatusManager().currentSpeed
                ? backhandMaxSpeed
                : CommStatusManager().currentSpeed;
            rightTypeTitle = 'Backhand Test';
          }

        } else {
          if (speedIndexs == 22) {
            rightTypeTitle = 'Volley Test';
            gameIndex++;
            // 进入到截击训练
          }
        }
        if (speedIndexs == 31) {
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
          return;
          /// 1s内不处理
        }
        if (middleTargetIndexs.contains(CommStatusManager().targetIndex[0]) && speedIndexs >=22) {
          /// 击中了中间的标靶
          volleyNumberOfShots ++;
        }

      }
      if (mounted) {
        setState(() {});
      }
    });

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   var model = NtrpDataModel(longRally: 5, forehand: 5, backhand: 8, volley: 9,
    //       powerControllerCount: 2,
    //       isWinner: true);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) =>NtrpResultController(rightUserModel: model,
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
   //  正手击球成功率 > 50%  平均球速 >60km/h
   var forehandRate = (forehandNumberOfShots / 10).toDouble() * 100;

   double rightSum = forehandSpeeds.fold(
       0.0, (previousValue, element) => previousValue + element);
   int rightcount = forehandSpeeds.length;
   double foreaveragSpeed = rightSum / rightcount;

   //  反手击球成功率 > 40%  平均球速 >50km/h
   var  backRate = (backhandNumberOfShots / 10).toDouble() * 100;

   double backSum = backhandSpeeds.fold(
       0.0, (previousValue, element) => previousValue + element);
   int backcount = backhandSpeeds.length;
   double backaveragSpeed = backSum / backcount;

   //  网前击球成功率 > 30%
   var  volleyRate = (volleyNumberOfShots / 10).toDouble() * 100;

   var isSuccess = forehandRate >= 50 &&  foreaveragSpeed >= 60
                  && backRate >= 40 && backaveragSpeed >= 50
                  && volleyRate >= 30;

   var model = NtrpDataModel(longRally: continuousNumberOfShots, forehand: forehandNumberOfShots,
       backhand: backhandNumberOfShots,
       volley: volleyNumberOfShots,
       powerControllerCount: powerControlCount,
       isWinner: isSuccess);
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) =>NtrpResultController(rightUserModel: model,
     )), // 结算页面
   );
   setState(() {});
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'NTRP TEST',
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
              top: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Long Rally
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Long Rally',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${continuousNumberOfShots}',
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
                        "${forehandNumberOfShots}/10",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),

                      Text(
                        forehandSpeeds.length > 0 ?
                        "${forehandSpeeds.last}km/h":
                        "0km/h",
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
                        speedIndexs >= 10 ?
                        '${backhandNumberOfShots}/10' :
                        '${0}/10'    ,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                      Text(
                        backhandSpeeds.length > 0 ?
                        "${backhandSpeeds.last}km/h":
                        "0km/h",
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
                        '${volleyNumberOfShots}/10',
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
          /// 右上角测试标题
          Positioned(
                right: 32,
                top: 40,
                child: Row(
                  children: [
                    Text(
                      '${rightTypeTitle}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "tengxun",
                          color: Colors.orange),
                    ),
                  ],
                )),
          Center(
            child: PowerView(),
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

