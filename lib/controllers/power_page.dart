import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/controllers/power_end_page.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:ota/utils/dialog.dart';
import 'package:ota/utils/service_util.dart';
import 'package:ota/utils/system_util.dart';
import 'package:ota/views/power_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants.dart';
import '../model/Battle_user_model.dart';
import '../utils/audio_player_util.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../views/show_speed_view.dart';

import 'package:flutter_tts/flutter_tts.dart';

class PowerPage extends StatefulWidget {
  String type = "p1";

  PowerPage({required this.type});

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  List<bool> lights = [false, false, false, true, true, true, false, false];
  int maxSpeed = 0;
  int speedIndexs = 0;
  int numbersOfHit = 0; // 击中中间三个图形标靶的次数
  int gameIndex = 0; // 0 测试力量 1 训练 2位置训练
  bool _startFlag = false;
  String endPrompt = ''; // 一轮结束提示语
  String greatJobPrompt = ''; // GreatJob 提示语
  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间
  List<int> _TotalSpeeds = [];

  /// 总的速度
  int _ShotInCount = 0;

  /// 击中次数
  bool isMove = false; // 是否是移动 区分发球与移动

  List<int> indexList = [];

  ///
  late StreamSubscription<DataUpdatedEvent> _subscription;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speakNumber(int number) async {
    await flutterTts.setLanguage("en-US"); // 设置语言
    await flutterTts.setPitch(1.0); // 设置语调
    await flutterTts.setSpeechRate(0.5); // 设置语速
    await flutterTts.speak(number.toString()); // 播放数字
  }

  int _counter = 3;
  Timer? _timer;
  double _opacity = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('进入到力量训练${widget.type}');
    playLocalAudio('blueMonday1.MP3', isAlwaysplay: true);
    startCountdown();

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   double rightSum = _TotalSpeeds.fold(0.0, (previousValue, element) => previousValue + element);
    //   int rightcount = _TotalSpeeds.length;
    //   double averagSpeed = rightSum / rightcount;
    //   var rightUserModel1 = BattleUserModel(score: 10, shotInCount: 20,
    //       topSpeed: 123, avgSpeed: 67,isWinner: true);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) =>PowerEndPage(rightUserModel: rightUserModel1,
    //     )), // 结算页面
    //   );
    //   setState(() {});
    // });

    CommStatusManager().isDeviceDeail = true;
    //CommStatusManager().connectToMyspeedzDevice();
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        // 监测到速度数据
        // if (!_startFlag) {
        //   return;
        // }
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

        // 监测到的速度数据变量递增
        if (kBLEDeviceName == "ARtennis_3") {
          speedIndexs++; //3 号场依赖于测速器
          print("3号场");
        }
        if (speedIndexs <= 10) {
          // 力量范围测量结束 进入训练
          maxSpeed = maxSpeed > CommStatusManager().currentSpeed
              ? maxSpeed
              : CommStatusManager().currentSpeed;
        } else if (speedIndexs <= 30) {
          if (speedIndexs == 11) {
            gameIndex++;
            // 进入到力量训练
          }
        } else {
          if (speedIndexs == 31) {
            gameIndex++;
            // 进入到组合训练
          }
        }
        //
        /// 一轮结束显示Shot in
        if (speedIndexs == 30) {
          endPrompt = "Shot in ${numbersOfHit}";
          setState(() {});
        }

        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        indexList.add(0);
        ///
        var type =  CommStatusManager().siteType.toInt();
        if (speedIndexs == 0 && type == 1) {
          TennisMachineParams params = TennisMachineParams.fromState(
              0, 150, 0, 14, 14, 40, 110, 125, 0);
          CommStatusManager().writerData(stepControlData(params));
          speedIndexs++;
          return;
        }

        if (speedIndexs <= 50 && isMove == false) {
          speedIndexs++;
        }

        if (widget.type == "p1") {
          print("p1路径");
          modeOneGame();
        } else if (widget.type == "p3") {
          // modeThreeGame();
          newModeThreeGame();
          print("p3路径");
        }

        if (speedIndexs <= 10) {
          // 力量范围测量结束 进入训练
          maxSpeed = maxSpeed > CommStatusManager().currentSpeed
              ? maxSpeed
              : CommStatusManager().currentSpeed;
        } else if (speedIndexs <= 30) {
          if (speedIndexs == 11) {
            gameIndex++;
            // 进入到力量训练
          }
        } else {
          if (speedIndexs == 31) {
            gameIndex++;
            // 进入到组合训练
          }
        }
        _startFlag = true;
        print('kStepControlFinishResponse--speedIndexs=${speedIndexs}');
      } else if (event.data == kTargetIndex) {
        /// 击中标靶的索引
        if (_updateTime(1) < 1000) {
          return;

          /// 1s内不处理
        }
        print('power界面 击中标靶的索引为${CommStatusManager().targetIndex}');
        if (CommStatusManager().targetIndex[0] == 12) {
          numbersOfHit += 1;
          _ShotInCount += 1; // 顶部  三角形 12
        } else if (CommStatusManager().targetIndex[0] == 11) {
          //  右侧矩形11
          print("右侧  矩形");
          numbersOfHit += 1;
          _ShotInCount += 1;
        } else if (CommStatusManager().targetIndex[0] == 13) {
          numbersOfHit += 1;
          _ShotInCount += 1; // 圆行 13
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
    // 延迟两秒后开始
    Future.delayed(Duration(milliseconds: 2000), () {
      // startGame();
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
    if(CommStatusManager().currentConnectedDevice == null){
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params = TennisMachineParams.fromState(
        0, 310, 0, 14, 14, 40, 110, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
    isMove = true;
  }
  /// P1发球模式
  void modeOneGame() {
    /// 步伐控制指令发球  12  18  20
    if (speedIndexs <= 12) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 120, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 13) {
      /// 往前移动两米
      TennisMachineParams params =
          TennisMachineParams.fromState(200, 0, 0, 13, 13, 40, 120, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (13 < speedIndexs && speedIndexs < 31) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 120, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 31) {
      /// 往前移动两米
      TennisMachineParams params =
          TennisMachineParams.fromState(200, 0, 0, 12, 12, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (speedIndexs > 31 && speedIndexs < 50) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 12, 12, 40, 110, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 50) {
      print('50个球发送完毕');
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 0, 0, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;

      /// 延迟1s 进到结算界面，防止最后一个球的数据记不进去
      Future.delayed(Duration(milliseconds: 1000), () {
        enterEndPage();
      });
    }

    print("发球索引${speedIndexs}");
  }

  /// P3发球模式
  void modeThreeGame() {
    /// 步伐控制指令发球  10 *10*10*10*10
    if (speedIndexs <= 10) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 14, 14, 40, 110, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 11) {
      /// 移动2米
      TennisMachineParams params = TennisMachineParams.fromState(
          0, robotDistanceAdaptation(200), 0, 14, 14, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (speedIndexs > 11 && speedIndexs < 21) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 14, 14, 40, 110, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 21) {
      /// 往前移动2米
      TennisMachineParams params =
          TennisMachineParams.fromState(300, 0, 0, 13, 13, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (speedIndexs > 21 && speedIndexs < 31) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 100, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 31) {
      TennisMachineParams params = TennisMachineParams.fromState(
          0, -robotDistanceAdaptation(200), 0, 13, 13, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (speedIndexs > 31 && speedIndexs < 41) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 100, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 41) {
      /// 移动一米
      TennisMachineParams params = TennisMachineParams.fromState(
          0, -robotDistanceAdaptation(200), 0, 13, 13, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = true;
      speedIndexs++;
    } else if (speedIndexs > 41 && speedIndexs < 50) {
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 110, 125, 1);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
    } else if (speedIndexs == 50) {
      print('50个球发送完毕');
      TennisMachineParams params =
          TennisMachineParams.fromState(0, 0, 0, 0, 0, 40, 110, 125, 0);
      CommStatusManager().writerData(stepControlData(params));
      isMove = false;
      enterEndPage();
    }
    print("发球索引${speedIndexs}");
  }

  ///.布云朝克特 等相关步伐
  void newModeThreeGame() {
    jarmikSinnerRomaTask[indexList.length]?.call();
  }

  void enterEndPage() {
    double rightSum = _TotalSpeeds.fold(
        0.0, (previousValue, element) => previousValue + element);
    int rightcount = _TotalSpeeds.length;
    double averagSpeed = rightSum / rightcount;
    var rightUserModel = BattleUserModel(
        score: 10,
        shotInCount: _ShotInCount,
        topSpeed: maxSpeed,
        avgSpeed: averagSpeed.toInt(),
        isWinner: true);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PowerEndPage(
                rightUserModel: rightUserModel,
              )), // 结算页面
    );
  }

  /*力量训练第二阶段*/
  void secondProgressGame() {
    // if(speedIndexs < 10){
    //   print('未进入第二阶段，不处理--${speedIndexs}');
    //   return;
    // }
    // TennisMachineParams params =
    // TennisMachineParams.fromState(0, 0, (speedIndexs % 2 == 0) ? -13 : 13, 12, 12, 40, 115, 125, 1);
    // CommStatusManager().writerData(stepControlData(params));
  }

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
          _opacity = 0.0;
          startGame();
          // 使蒙层消失
        }
      });
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
                      gameIndex == 0
                          ? '测试最大力量'
                          : gameIndex == 1
                              ? '力量训练'
                              : '组合训练',
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
                        '${speedIndexs}',
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
                        "${numbersOfHit}",
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
                      '${calculateScopePercentage(CommStatusManager().currentSpeed, maxSpeed)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange),
                    ),
                  ],
                )),
          Center(
            child: PowerView(),
          ),

          /// 一轮结束的提示语
          Positioned(
              top: CommStatusManager().currentSpeed > 70 ? 160 : 220,
              left: 400,
              child: speedIndexs == 30 || speedIndexs == 50
                  ? Center(
                      child: Text(
                        '${endPrompt}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white),
                      ),
                    )
                  : Container()),

          /// Great job 提示语
          Positioned(
              top: 220,
              left: 400,
              child: CommStatusManager().currentSpeed > 70
                  ? Center(
                      child: Text(
                        '${greatJobPrompt}',
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
                onTap: () {
                  print("123");
                  TTDialog.gamePauseTaskDialog(context, () {
                    print("弹窗点击");
                  });
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

          _counter == 0
              ? Container(
                  width: 10,
                  height: 10,
                )
              :

              /// 321倒计时 的蒙层
              AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20), // 设置圆角
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Constants.boldWhiteTextWidget("Ready", 40),
                        SizedBox(
                          height: 20,
                        ),
                        new CircularPercentIndicator(
                          radius: 45.0,
                          lineWidth: 4.0,
                          percent: 1.0,
                          center: Text(
                            '${_counter}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                fontFamily: 'tengxun',
                                color: Colors.white),
                          ),
                          // backgroundColor: Color.fromRGBO(255, 0, 0, 1.0),
                          progressColor: Color.fromRGBO(21, 233, 120, 1.0),
                          // fillColor: Color.fromRGBO(255, 0, 0, 1.0),
                        ),
                      ],
                    )
                        // child: Text(
                        //   '$_counter',
                        //   style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                        // ),
                        ),
                  ),
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
    CommStatusManager().isDeviceDeail = false;
    CommStatusManager().currentSpeed = 0;
    pause();
    super.dispose();
  }
}
