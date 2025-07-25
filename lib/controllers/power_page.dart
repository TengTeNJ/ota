import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:ota/utils/service_util.dart';
import 'package:ota/utils/system_util.dart';
import 'package:ota/views/power_view.dart';
import '../constants.dart';
import '../utils/audio_player_util.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../views/show_speed_view.dart';

import 'package:flutter_tts/flutter_tts.dart';


class PowerPage extends StatefulWidget {
  const PowerPage({super.key});

  @override
  State<PowerPage> createState() => _PowerPageState();
}

class _PowerPageState extends State<PowerPage> {
  List<bool> lights = [false, false, false, true, true, true, false, false];
  int maxSpeed = 0;
  int speedIndexs = 0;
  int gameIndex = 0; // 0 测试力量 1 训练 2位置训练
  bool _startFlag = false;
  String endPrompt = '';// 一轮结束提示语
  String greatJobPrompt = '';// GreatJob 提示语

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
    print('进入到力量训练');

    // playLocalAudio('blueMonday.MP3',isAlwaysplay: true);

    // Future.delayed(Duration(milliseconds: 2000), () {
    //   endPrompt = "Shot in ${calculatePercentage(CommStatusManager().currentSpeed, maxSpeed)}";
    //   Future.delayed(Duration(milliseconds: 2000), () {
    //     endPrompt = "Great Job !";
    //     playOnceLocalAudio("greatjob.mp3");
    //     setState(() {});
    //   });
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
        // 显示速度
        SpeedPopup.show(context, speed: CommStatusManager().currentSpeed);
        if (CommStatusManager().currentSpeed > 70) {
          greatJobPrompt = "Great Job !";
          setState(() {});
          playOnceLocalAudio("greatjob.mp3");
        }

        if (CommStatusManager().currentSpeed < 70 ) {
          _speakNumber(CommStatusManager().currentSpeed);
        }


        // 监测到的速度数据变量递增
        speedIndexs++;

        /// 一轮结束显示Shot in
        if (speedIndexs == 30) {
          endPrompt = "Shot in ${calculatePercentage(CommStatusManager().currentSpeed, maxSpeed)}";
          setState(() {});
        }


        if (speedIndexs <=10) {
          // 力量范围测量结束 进入训练
          maxSpeed = maxSpeed > CommStatusManager().currentSpeed
              ? maxSpeed
              : CommStatusManager().currentSpeed;
        } else if (speedIndexs <=30) {
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
        print('kSpeedValue--speedIndexs=${speedIndexs}');
      } else if (event.data == kStepControlFinishResponse) {
        // 步伐控制结束回复
        if (gameIndex == 0 && speedIndexs < 10) {
          // 开始发球了
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0, 0, 13, 13, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          _startFlag = true;
        }else if(speedIndexs >=10){
          secondProgressGame();
        }else if(speedIndexs >= 30){

        }
        print('kStepControlFinishResponse--speedIndexs=${speedIndexs}');
      } else if(event.data == kTargetIndex) { /// 击中标靶的索引
        print('power界面 击中标靶的索引为${CommStatusManager().targetIndex}');
        if(CommStatusManager().targetIndex[0] == 10) {// 顶部  三角形 10
          lights.fillRange(2, 3, true);
        } else if(CommStatusManager().targetIndex[0] == 9) {//  右侧矩形9
          lights.fillRange(0, 1, true);
          print("右侧  矩形");
        } else if(CommStatusManager().targetIndex[0] == 8) {
          lights.fillRange(1, 2, true);
        }

      }
      setState(() {});
    });
    // 延迟两秒后开始
    Future.delayed(Duration(milliseconds: 2000), () {
      //startGame();
    });
  }

  /*开始*/
  void startGame() {
    if(CommStatusManager().currentConnectedDevice == null){
      print('测速器未连接---');
      return;
    }
    TennisMachineParams params =
        TennisMachineParams.fromState(400, 0, 0, 12, 12, 40, 110, 125, 0);
    CommStatusManager().writerData(stepControlData(params));
  }
  /*力量训练第二阶段*/
  void secondProgressGame(){
    if(speedIndexs < 10){
      print('未进入第二阶段，不处理--${speedIndexs}');
      return;
    }
    TennisMachineParams params =
    TennisMachineParams.fromState(0, 0, (speedIndexs % 2 == 0) ? -13 : 13, 12, 12, 40, 115, 125, 1);
    CommStatusManager().writerData(stepControlData(params));
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
                      gameIndex == 0
                          ? '测试最大力量'
                          : gameIndex == 1
                              ? '力量训练'
                              : '组合训练',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            left: 16,
            right: 16,
            top: 16,
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
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Text(
                        '${speedIndexs}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shot In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Text(
                        '${CommStatusManager().currentSpeed}${gameIndex == 0 ? 'km/h' :
                        '[${calculatePercentage(CommStatusManager().currentSpeed, maxSpeed)}%]'}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Top Speed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Text(
                        '${maxSpeed}km/h',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                ],
              )),
          if(gameIndex !=0)
          Positioned(
              left: 32,
              bottom: 32,
              child: Row(
                children: [
                  Text(
                    ' Power Control',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
              child:
            speedIndexs == 30 || speedIndexs == 50 ?
            Center(
                child:
                Text(
                  '${endPrompt}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white),
                ),
              ) :
              Container()

          ),
         /// Great job 提示语
          Positioned(
              top: 220,
              left: 400,
              child:
              CommStatusManager().currentSpeed > 70 ?
              Center(
                child:
                Text(
                  '${greatJobPrompt}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Colors.white),
                ),
              ) :
              Container()

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
    pause();
    super.dispose();
  }
}
