import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ota/controllers/new_battle_target_end_page.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/model/Battle_user_model.dart';
import 'package:ota/views/total_power_view.dart';

import '../constants.dart';
import '../utils/audio_player_util.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../utils/system_util.dart';
import '../views/show_speed_view.dart';

class NewBattleTargetPage extends StatefulWidget {
  const NewBattleTargetPage({super.key});

  @override
  State<NewBattleTargetPage> createState() => _NewBattleTargetPageState();
}

class _NewBattleTargetPageState extends State<NewBattleTargetPage> {
  List<bool> lights = [
    false,
    false,
    false,
    true,
    true,
    true,
    false,
    false,
    false
  ];
  int _index = 1;
  int _currentIndex = 0;
  int _leftIndex = 0;
  int _rightIndex = 0;
  int _leftMaxSpeed = 0;
  int _rightMaxSpeed = 0;
  int _leftScore = 0;
  int _rightScore = 0;
  int _leftCurrentSpeed = 0;
  int _rightCurrentSpeed = 0;
  List<int> _scores = [1, 2, 3];

  int _leftShotInCount = 0; /// 左侧击中次数
  int _rightShotInCount = 0; /// 右侧击中次数

  List<int> _leftTotalSpeeds = []; /// 左侧总的得分
  List<int> _rightTotalSpeeds = []; /// 右侧总的得分
  ///
  DateTime _lastShotInTime = DateTime.now(); // 记录上次击中的时间

  late StreamSubscription<DataUpdatedEvent> _subscription;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speakNumber(int number) async {
    await flutterTts.setLanguage("en-US"); // 设置语言
    await flutterTts.setPitch(1.0); // 设置语调
    await flutterTts.setSpeechRate(0.5); // 设置语速
    await flutterTts.speak(number.toString()); // 播放数字
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("进入到battle 界面");

    playLocalAudio('yangBG2.MP3',isAlwaysplay: true);
    calculateTime(1);
    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kSpeedValue) {
        // 监测到速度数据
        // if (!_startFlag) {
        //   return;
        // }
        // _currentIndex++;


        // 显示速度
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        if (CommStatusManager().currentSpeed > 70) {
          playOnceLocalAudio("greatjob.mp3");
          setState(() {});
        }

        if (CommStatusManager().currentSpeed < 70 ) {
          _speakNumber(CommStatusManager().currentSpeed);
        }

        if (_currentIndex % 2 != 0) {
          _leftMaxSpeed = max(_leftMaxSpeed, CommStatusManager().currentSpeed);
          print('左侧-----');
          _leftCurrentSpeed = CommStatusManager().currentSpeed;
          _leftTotalSpeeds.add(_leftCurrentSpeed);

        } else {
          _rightMaxSpeed =
              max(_rightMaxSpeed, CommStatusManager().currentSpeed);
          print('右侧-----');
          _rightCurrentSpeed = CommStatusManager().currentSpeed;
          _rightTotalSpeeds.add(_rightCurrentSpeed);
        }
      } else if (event.data == kStepControlFinishResponse) {
        // 步伐控制结束回复
        _currentIndex ++;
        // 延迟1秒后开始,防止测速器测速反应不过来（3s以内只能测一次速度）
        // Future.delayed(Duration(milliseconds: 1000), () {
        //   if(_currentIndex <=50) {
        //     leftRightLoopGame();
        //   }
        // });
         modeTwoGame();

         /// 50轮 一局结束  跳转到结算界面
        if (_currentIndex == 50) {
          double leftSum = _leftTotalSpeeds.fold(0.0, (previousValue, element) => previousValue + element);
          int count = _leftTotalSpeeds.length;
          double leftAverage = leftSum / count;

          double rightSum = _rightTotalSpeeds.fold(0.0, (previousValue, element) => previousValue + element);
          int rightcount = _rightTotalSpeeds.length;
          double rightAverage = rightSum / rightcount;

          SystemUtil.lockScreenHorizontalDirection();
          Future.delayed(Duration(milliseconds: 500),(){
            var leftUserModel = BattleUserModel(score: _leftScore,shotInCount: _leftShotInCount,
                topSpeed: _leftMaxSpeed, avgSpeed: leftAverage.toInt(),isWinner: _leftScore > _rightScore ?true:false);
            var rightUserModel = BattleUserModel(score: _rightScore, shotInCount: _rightShotInCount,
                topSpeed: _rightMaxSpeed, avgSpeed: rightAverage.toInt(),isWinner: _leftScore > _rightScore ?false:true);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>NewBattleTargetEndPage( leftUserModel: leftUserModel,
                rightUserModel: rightUserModel,
              )), // 结算页面
            );
          });
          return;
        }



      } else if(event.data == kTargetIndex) { /// 击中标靶的索引
        print('battle 界面击中标靶的索引为${CommStatusManager().targetIndex}');
        if (calculateTime(1) < 1000) {
          return; /// 1s内不处理
        }
        print("哈哈击中了");
          if (_currentIndex % 2 != 0) {  /// 左侧
            if(CommStatusManager().targetIndex[0] == 15) {// 左侧  圆形 15
              lights.fillRange(0, 1, true);
              calculateLeftScore();
              print("左侧  圆形");
            } else if(CommStatusManager().targetIndex[0] == 0) { // 左侧  三角0
              lights.fillRange(1, 2, true);
              calculateLeftScore();
              print("左侧  三角");
            } else if(CommStatusManager().targetIndex[0] == 14) {// 左侧  六边形 14
              lights.fillRange(2, 3, true);
              calculateLeftScore();
              print("左侧  六边形");
            }
            _leftShotInCount +=1 ;

          } else { // 右侧
            _rightShotInCount +=1 ;
            if(CommStatusManager().targetIndex[0] == 9) { // 右侧六边形  9
              lights.fillRange(6, 7, true);
              calculateRightScore();
            } else if(CommStatusManager().targetIndex[0] == 10){ //右侧 三角  10
              lights.fillRange(7, 8, true);
              calculateRightScore();
            } else if(CommStatusManager().targetIndex[0] == 8) {  //右侧 矩形右边  8
              lights.fillRange(8, 9, true);
              calculateRightScore();
            }
          }

        /// 如果右侧全部打中，重置右侧三灯高亮
        var rightReset = lights.skip(lights.length - 3).every((element) => element == true);
        if(rightReset) {
          lights.fillRange(6, 9,false);
        }

        /// 如果左侧侧全部打中，重置左侧三灯高亮
        var leftReset = lights.take(3).every((element) => element == true);
        if(leftReset) {
          lights.fillRange(0, 3,false);
        }

      }
      setState(() {});
    });

    // 延迟两秒后开始
    Future.delayed(Duration(milliseconds: 2000), () {
      startGame();
    });
  }

  /// 计算左侧分数
  void calculateLeftScore() {
    // 计算前三个元素中有多少个是 true ,进而计算左侧此次得分
    int leftTrueCount =
    lights.take(3).fold(0, (count, element) => count + (element ? 1 : 0));
    if (leftTrueCount == 1) {
      _leftScore += _scores[0]; // 加一分
    } else if(leftTrueCount == 2) {
      _leftScore += _scores[1]; // 加两分
    } else if(leftTrueCount == 3) {
      _leftScore += _scores[2]; // 加三分
    }
  }

  int calculateTime( double timeStamp) {
    // 如果这是第一次调用，记录当前时间
    if (_lastShotInTime == null) {
      _lastShotInTime = DateTime.now();
      return 0;
    }
    // 计算时间差
    final timeDifference = DateTime.now().difference(_lastShotInTime).inMilliseconds;
    print('时间差: $timeDifference');
    if (timeDifference > 1000) {
      _lastShotInTime = DateTime.now();
    }
    // 更新最后一次时间
    //   _lastUpdateTime = DateTime.now();
    return timeDifference;
  }


  /// 计算右侧得分
  void calculateRightScore() {
    // 计算最后三个元素中有多少个是 true
    int rightTrueCount =
    lights.sublist(lights.length - 3).fold(0, (count, element) => count + (element ? 1 : 0));
    if (rightTrueCount == 1) {
      _rightScore += _scores[0];
    } else if(rightTrueCount == 2){
      _rightScore += _scores[1];
    } else if(rightTrueCount == 3){
      _rightScore += _scores[2];
    }


  }

  /*开始*/
  void startGame() {
    if(CommStatusManager().currentConnectedDevice == null){
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params =
    TennisMachineParams.fromState(0, 310, 0, 14, 14, 40, 110, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
    _currentIndex --;

  }

  /// P2 发球模式
  void modeTwoGame( ) {
    /// 步伐控制指令发球  12  18  20
    if (_currentIndex <=12) {
      TennisMachineParams params =
      TennisMachineParams.fromState(0, 0, (_currentIndex % 2 == 0) ? -13 : 13, 14, 14, 40, 110, 175, 1);
      CommStatusManager().writerData(stepControlData(params));
    }
    /// 往前移动一米
    if(_currentIndex == 13 ) {
      TennisMachineParams params =
      TennisMachineParams.fromState(200, 0, 0, 13, 13, 40, 110, 175, 0);
      CommStatusManager().writerData(stepControlData(params));
    }

    if(_currentIndex > 13 && _currentIndex <31) {
      TennisMachineParams params =
      TennisMachineParams.fromState(0, 0, (_currentIndex % 2 == 0) ? -13 : 13, 14, 14, 40, 110, 175, 1);
      CommStatusManager().writerData(stepControlData(params));
    }

    /// 往前移动一米
    if(_currentIndex == 31 ) {
      TennisMachineParams params =
      TennisMachineParams.fromState(200, 0, 0, 12, 12, 40, 110, 175, 0);
      CommStatusManager().writerData(stepControlData(params));
    }

    if(_currentIndex > 31  &&_currentIndex < 51) {
      TennisMachineParams params =
      TennisMachineParams.fromState(0, 0, (_currentIndex % 2 == 0) ? -13 : 13, 13, 13, 40, 100, 175, 1);
      CommStatusManager().writerData(stepControlData(params));
    }

    if (_currentIndex == 51) {
      TennisMachineParams params =
      TennisMachineParams.fromState(0, 0,0, 0, 0, 40, 100, 175, 1);
      CommStatusManager().writerData(stepControlData(params));
    }



    print("发球索引${_currentIndex}");
  }

  /*左右循环发球*/
  void leftRightLoopGame() {
    TennisMachineParams params =
    TennisMachineParams.fromState(0, 0, (_currentIndex % 2 == 0) ? -13 : 13, 12, 12, 40, 115, 125, 1);
    CommStatusManager().writerData(stepControlData(params));
  }

  void secondProgressGame(){

  }

  @override
  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          /// 左侧击打数据
          Positioned(
            left: 51,
            top: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Scores
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Scores',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${_leftScore}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 40,
                ),
                /// Shots In
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Shots In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      Text(
                        '${_leftShotInCount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),


                const SizedBox(
                  width: 40,
                ),

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${_leftCurrentSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 40,
                ),
                // Top Speed
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Top Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      Text(
                        '${_leftMaxSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
          /// 右侧击打数据
          Positioned(
            right: 51,
            top: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scores
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Scores',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${_rightScore}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 40,
                ),

                /// Shots In
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Shots In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      Text(
                        '${_rightShotInCount}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${_rightCurrentSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 40,
                ),
                // top speed
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Top Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: "SanFranciscoDisplay",
                            color: Colors.white),
                      ),
                      Text(
                        '${_rightMaxSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "tengxun",
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
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
          Center(
            child: Container(
                child: TotalPowerView(
              hideIndex: lights,
            )),
          ),

          /// 中间的竖的分割线
          Positioned(
              left: Constants.screenWidth(context)/2,
              top: 0,
              child: Container(
                color: Color.fromRGBO(93, 148, 212, 1.0),
                width: 1,
                height: Constants.screenHeight(context),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    _subscription.cancel();
    pause();
    super.dispose();
  }
}
