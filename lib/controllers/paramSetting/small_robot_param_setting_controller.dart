import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ota/constants.dart';

import '../../utils/audio_player_util.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../step/controller/fire_controller.dart';
import '../step/controller/horizontal_move_tasks.dart';
import '../step_control_page.dart';
/// 小型发球机发球参数设置
class SmallRobotParamSettingController extends StatefulWidget {
  const SmallRobotParamSettingController({super.key});

  @override
  State<SmallRobotParamSettingController> createState() => _SmallRobotParamSettingControllerState();
}

class _SmallRobotParamSettingControllerState extends State<SmallRobotParamSettingController> {
  // 位置控制参数
  double xPosition = 0.0; // 竖向位置，向上为正
  double yPosition = 0.0; // 横向位置，向左为正
  double zRotation = 0.0; // 旋转角度，左转为正

  // 发球参数
  double topWheelSpeed = 4.0; // 上发球轮速度（区间问0---99）
  double bottomWheelSpeed = 4.0; // 下发球轮速度（区间问0---99）
  double turntableSpeed = 40.0; // 转盘速度（默认40）（区间为0--40）
  double ballAngle = 130; // 发球角度（区间为90---225）

  // 发球模式参数
  double ballInterval = 2.0; // 发球间隔(秒)
  int ballCount = 10; // 发球数量

  // 控制按钮状态
  bool isRunning = false;

  // 文本控制器
  late TextEditingController xController;
  late TextEditingController yController;
  late TextEditingController zController;
  late TextEditingController topWheelController;
  late TextEditingController bottomWheelController;
  late TextEditingController turntableController;
  late TextEditingController ballAngleController;
  late TextEditingController ballIntervalController;
  late TextEditingController ballCountController;

  late StreamSubscription<DataUpdatedEvent> _subscription;

  ///发球机步伐
  final NtrpPressureTaskMaps = {
    for (int i = 1; i <= 50; i++)
      i: () => controlRobotMove(
        0, 0, (i % 2 == 1) ? 13 : -13, 1, CommStatusManager().topCommonWheelSpeed, CommStatusManager().bottoCommonmWheelSpeed, 40, CommStatusManager().ballCommonAngle, 150,
      ),
  };


  List<int> indexList = [];
  int speedIndexs = 0;

  TennisMachineParams farData = TennisMachineParams.fromState(0, 0, 0, 32, 32, 40, 242, 300, 1);
  TennisMachineParams nearData = TennisMachineParams.fromState(0, 0, 0, 28, 28, 40, 222, 300, 1);
  TennisMachineParams interceptionData = TennisMachineParams.fromState(0, 0, 0, 25, 25, 40, 262, 300, 1);

  final newTaskMaps = {
    for (int i = 1; i <= 30; i++)
      i: () => controlRobotMove(
        0, 0, 0, 1,
        i <= 10 ? 32 : (i <= 20 ? 28 : 25),
        i <= 10 ? 32 : (i <= 20 ? 28 : 25),
        40,
        i <= 10 ? 220 : (i <= 20 ? 225 : 225),
        150,
      ),
  };

  final newTaskMapss = {
    1: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    2: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    3: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    4: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    5: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    6: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    7: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    8: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    9: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),
    10: () => controlRobotMove(0, 0, 0, 1,highWheel,highWheel,40, kHighAngle,150),

    11: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    12: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    13: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    14: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    15: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    16: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    17: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    18: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    19: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),
    20: () => controlRobotMove(0, 0, 0, 1,bottomWheel,bottomWheel,40, kBottomAngle,150),

    21: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    22: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    23: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    24: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    25: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    26: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    27: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    28: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    29: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
    30: () => controlRobotMove(0, 0, 0, 1,nearWheel,nearWheel,40, kNearAngle,150),
  };


  void modeOneGame() {
    if (speedIndexs <= 11) {
      CommStatusManager().writerData(stepControlData(farData));
    }  else if (11 < speedIndexs && speedIndexs <= 21) {
      CommStatusManager().writerData(stepControlData(nearData));
    }  else if (speedIndexs > 21 && speedIndexs < 31) {
      CommStatusManager().writerData(stepControlData(interceptionData));
    }
  }

// 10个远球  10个 近球发球控制
  void fireControll() {
    final plan = FirePlan.nearAndFar(count: 10);
    final controller = FireController(plan.tasks);
    controller.onProgress = (taskIndex, shotIndex) {
      print("第 $taskIndex 个点位，第 $shotIndex 球完成");
      setState(() {

      });
    };
    controller.onFinished = () {
      print("任务计划完成！");
      CommStatusManager().writerData(changeModeData(0xff));
    };
    controller.start();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommStatusManager().isStepControlling = false;
    CommStatusManager().isDeviceDeail = true;
    topWheelSpeed = CommStatusManager().topCommonWheelSpeed;
    bottomWheelSpeed = CommStatusManager().bottoCommonmWheelSpeed;
    ballAngle = CommStatusManager().ballCommonAngle;


    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kStepControlFinishResponse) {
        print("发球机开始发球了");
        indexList.add(0);
        speedIndexs++;
        // 开始发球测试
        // newTaskMapss[indexList.length]?.call();
        modeOneGame();
        if (mounted) {
          setState(() {});
        }
      }
    });




    // 初始化控制器并设置初始值
    xController = TextEditingController(text: xPosition.round().toString());
    yController = TextEditingController(text: yPosition.round().toString());
    zController = TextEditingController(text: zRotation.round().toString());
    topWheelController = TextEditingController(text: topWheelSpeed.round().toString());
    bottomWheelController = TextEditingController(text: bottomWheelSpeed.round().toString());
    turntableController = TextEditingController(text: turntableSpeed.round().toString());
    ballAngleController = TextEditingController(text: ballAngle.round().toString());
    ballIntervalController = TextEditingController(text: ballInterval.toStringAsFixed(1));
    ballCountController = TextEditingController(text: ballCount.toString());

    topWheelController.addListener(() {
      updateValueFromController(topWheelController, (value) {
        if (value >= 0 && value <= 100) {
          setState(() {
            topWheelSpeed = value.toDouble();
            CommStatusManager().topCommonWheelSpeed = topWheelSpeed;
          });
        }
      });
    });

    bottomWheelController.addListener(() {
      updateValueFromController(bottomWheelController, (value) {
        if (value >= 0 && value <= 100) {
          setState(() {
            bottomWheelSpeed = value.toDouble();
            CommStatusManager().bottoCommonmWheelSpeed = bottomWheelSpeed;

          });
        }
      });
    });

    turntableController.addListener(() {
      updateValueFromController(turntableController, (value) {
        if (value >= 0 && value <= 100) {
          setState(() {
            turntableSpeed = value.toDouble();
          });
        }
      });
    });

    ballAngleController.addListener(() {
      updateValueFromController(ballAngleController, (value) {
        if (value >= -45 && value <= 45) {
          setState(() {
            ballAngle = value.toDouble();
          });
        }
      });
    });

    ballIntervalController.addListener(() {
      final text = ballIntervalController.text;
      if (text.isNotEmpty) {
        final value = double.tryParse(text);
        if (value != null && value >= 0.5 && value <= 5.0) {
          setState(() {
            ballInterval = value;
          });
        }
      }
    });

    ballCountController.addListener(() {
      updateValueFromController(ballCountController, (value) {
        if (value >= 1 && value <= 100) {
          setState(() {
            ballCount = value;
          });
        }
      });
    });

  }

  // 辅助方法：从控制器更新值
  void updateValueFromController(TextEditingController controller, Function(int) updateFunction) {
    final text = controller.text;
    if (text.isNotEmpty) {
      final value = int.tryParse(text);
      if (value != null) {
        updateFunction(value);
      }
    }
  }



  // 发送控制命令的方法
  void sendControlCommand(TennisMachineParams params) {
    params.ballInterval = params.ballInterval*50;
    // 显示参数信息（实际应用中这里会发送到设备）
    print('发送参数: $params');

    // 获取字节数组
    final data = params.toBytes();
    print('字节数据: $data');
    CommStatusManager().writerData(stepControlData(params));
    // 实际发送数据到设备
    // sendToDevice(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小型网球发球机控制面板'),
        backgroundColor: Colors.green[700],
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // 设置按钮功能
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),

            // 发球参数控制区
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '发球参数',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 上发球轮速度
                    Row(
                      children: [
                        const Text('上发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: topWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: topWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                topWheelSpeed = value;
                                CommStatusManager().topCommonWheelSpeed = topWheelSpeed;
                                topWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${topWheelSpeed.round()}'),
                      ],
                    ),

                    // 下发球轮速度
                    Row(
                      children: [
                        const Text('下发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: bottomWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: bottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomWheelSpeed = value;
                                CommStatusManager().bottoCommonmWheelSpeed = bottomWheelSpeed;
                                bottomWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${bottomWheelSpeed.round()}'),
                      ],
                    ),

                    // 发球角度
                    Row(
                      children: [
                        const Text('发球角度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: ballAngle,
                            min: 90,
                            max: 225.0,
                            divisions: 16,
                            label: ballAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                ballAngle = value;
                                CommStatusManager().ballCommonAngle = ballAngle;
                                print("mengheng${CommStatusManager().ballCommonAngle}");
                                ballAngleController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${ballAngle.round()} °'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 发球模式控制区
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '发球模式',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 发球间隔
                    Row(
                      children: [
                        const Text('发球间隔: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: ballInterval,
                            min: 1,
                            max: 10.0,
                            divisions: 9,
                            label: ballInterval.toStringAsFixed(1),
                            onChanged: (double value) {
                              setState(() {
                                ballInterval = value;
                                ballIntervalController.text = value.toStringAsFixed(1);
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${ballInterval.toStringAsFixed(1)} 秒'),
                      ],
                    ),

                    // 发球数量
                    Row(
                      children: [
                        const Text('发球数量: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: ballCount.toDouble(),
                            min: 0,
                            max: 50.0,
                            divisions: 10,
                            label: ballCount.toString(),
                            onChanged: (double value) {
                              setState(() {
                                ballCount = value.round();
                                ballCountController.text = ballCount.toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('$ballCount 个'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 控制按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 保存设定按钮
                ElevatedButton.icon(
                  onPressed: () {


                  },
                  // icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text('保存设定',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // 加粗
                      fontSize: 16,                // 可选
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // ← 文字/图标颜色
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // 启动/停止按钮
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                      print("状态${isRunning}");
                      if (isRunning == false) {
                        print("停止发球了");
                        /// 停止发球
                        final params = TennisMachineParams.fromState(
                            xPosition, yPosition, zRotation,
                            0, 0, 0,
                            ballAngle, ballInterval, 0
                        );
                        // 发送控制命令
                        sendControlCommand(params);
                      }
                    });

                    // 创建参数对象
                    final params = TennisMachineParams.fromState(
                        xPosition, yPosition, zRotation,
                        topWheelSpeed, bottomWheelSpeed, turntableSpeed,
                        ballAngle, ballInterval, ballCount
                    );
                    // 发送控制命令
                    sendControlCommand(params);
                  },
                  // icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? '停止训练' : '开始训练',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // 加粗
                      fontSize: 16,                // 可选
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Color.fromRGBO(236, 189, 88, 1.0) : Colors.green,
                    foregroundColor: Colors.white, // ← 文字/图标颜色
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 24),

            // 发球
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 远近球训练按钮
                ElevatedButton.icon(
                  onPressed: () {
                    fireControll();
                  },
                  label: Text('远近球训练',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // 加粗
                      fontSize: 16,                // 可选
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // ← 文字/图标颜色
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),



          ],
        ),
      ),
    );
  }
}
