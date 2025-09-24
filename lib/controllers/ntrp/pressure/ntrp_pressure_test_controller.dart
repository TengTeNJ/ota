import 'dart:async';
import 'dart:ffi';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../utils/audio_player_util.dart';
import '../../../utils/comm_statu_manager.dart';
import '../../../utils/event_manager.dart';
import '../../../utils/ota_data.dart';
import '../../../utils/system_util.dart';
import '../../../views/total_power_view.dart';
// import '../../pressure/ntrp_pressure_end_controller.dart';
// import '../../pressure/ntrp_pressure_progress_view.dart';
import 'ntrp_pressure_end_controller.dart';
import 'ntrp_pressure_progress_view.dart';


import '../../step_control_page.dart';


/// 压力测试
class NtrpPressureTestController extends StatefulWidget {
  bool isNtrp = true; // 是否是Ntrp

  NtrpPressureTestController({ this.isNtrp = true});

  @override
  State<NtrpPressureTestController> createState() => _NtrpPressureTestControllerState();
}

class _NtrpPressureTestControllerState extends State<NtrpPressureTestController> {
  // 初始化隐藏所有的标靶 游戏开始后才正式显示
  List<bool> lights = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  int maxSpeed = 0; // 正手的最大速度
  int backhandMaxSpeed = 0; // 反手的最大速度
  int speedIndexs = 0;
  bool _startFlag = false;

  late StreamSubscription<DataUpdatedEvent> _subscription;
  List<int> indexList = [];

  List<int> middleTargetIndexs = [11,12, 13,1];// 中间三个标靶的索引(1为中间的新增的标靶)
  List<int> leftTargetIndexs = [14,15,0];// 左侧三个标靶的索引
  List<int> rightTargetIndexs = [8,9,10];// 右侧三个标靶的索引
  bool gameEnd = false; /// 游戏结束


  /*开始*/
  void startGame() {
    TennisMachineParams params =
    TennisMachineParams.fromState(0, 310, 0, 7, 8, 40, 100, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }

  ///发球机步伐
  final NtrpPressureTaskMap = {
    1: () => controlRobotMove(300, 0, 13, 1,7,8,40, 130,150),
    2: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    3: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    4: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    5: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    6: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    7: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    8: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    9: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    10: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),

    11: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    12: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    13: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    14: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    15: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    16: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    17: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    18: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),
    19: () => controlRobotMove(0, 0, 13, 1,7,8,40, 130,150),
    20: () => controlRobotMove(0, 0, -13, 1,7,8,40, 130,150),

    21: () => controlRobotMove(0, 0, -13, 0,7,8,40, 130,150),

  };

  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间
  /// 倒计时相关
  static const int _totalDurationMs = 60 * 1000; // 60 秒
  int _remainingMs = _totalDurationMs;
  Timer? _timer;

  /// 压力测试的得分
  int pressureScore = 0;

  String getDisplayTime() {
    final seconds = (_remainingMs / 1000).floor();
    final ms = _remainingMs % 1000;
    return '${seconds.toString().padLeft(2, '0')}:${ms.toString().padLeft(2, '0')}';
  }
  ///NtrpTest 步伐
  void NtrpPressureTestGame() {
    NtrpPressureTaskMap[indexList.length]?.call();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    startGame();
    // 播放音效
    playLocalAudio('countDown.MP3', isAlwaysplay: true);
    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        if (gameEnd) {
          return;
        }
        indexList.add(0);
        speedIndexs++;
        // 开始压力测试
        NtrpPressureTestGame();
        // 前两次的移动 不现实标靶 正式发球后才两标靶
        if (speedIndexs >= 2 && speedIndexs % 2 == 0) {
          _startCountdown();
          lights = [
             false, false, false, true, true, true, true, true, true]; // 左侧标靶亮
        } else {
           lights = [true, true, true, true, true, true, false, false, false];  // 右侧标靶亮
         }
         _startFlag = true;
        print('nTRP Test  kStepControlFinishResponse--=${speedIndexs}');
      } else if (event.data == kTargetIndex) {
        if (_updateTime(1) < 1000) {
          return;/// 1s内不处理
        }

        if (speedIndexs % 2 == 0) {
          if (leftTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
             pressureScore ++ ;
          }
        } else {
          if (rightTargetIndexs.contains(CommStatusManager().targetIndex[0])) {
            pressureScore ++ ;
          }
        }
      }
      if (mounted) {
        setState(() {});
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

  void _startCountdown() {
    _remainingMs = _totalDurationMs;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) async{
      if (!mounted) return;  // 1️⃣ 保险丝
      if (_remainingMs <= 0) {
        timer.cancel();
        setState(() {});
        Future.delayed(Duration(milliseconds: 2000), () {
          /// 机器人位置校准回到原点
          CommStatusManager().writerData(positionCheckData());
          if (pressureScore >=8) {
            CommStatusManager().ntrpPressureTestResult = true;
          }


          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>NtrpPressureEndController(score: pressureScore,isNtrp: widget.isNtrp,)
            ), // 结算页面
          );
          setState(() {});
        });
        return;
      }
      if (_remainingMs <= 1000) {
       gameEnd = true;

      }
      _remainingMs -= 10;
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          /// 中间测试标题
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: "SanFranciscoDisplay",
                          color: Colors.white),
                    ),
                    SizedBox(height: 8,),

                    Text(
                      '${getDisplayTime()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60,
                          fontFamily: "tengxun",
                          color: Colors.white),
                    ),
                    SizedBox(height: 16,),
                    NtrpPressureProgressView(count: pressureScore,),
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
                        'PRESSURE TEST',
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

  @override
  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    _subscription.cancel();
    CommStatusManager().isDeviceDeail = false;
    CommStatusManager().currentSpeed = 0;
    _timer?.cancel();
    pause();
    super.dispose();
  }
}
