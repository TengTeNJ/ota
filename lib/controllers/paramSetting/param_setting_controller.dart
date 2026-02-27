import 'dart:async';

import 'package:any_loading/any_loading.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ota/constants.dart';
import 'package:ota/utils/data_base.dart';
import 'package:ota/utils/i18n_ext.dart';

import '../../utils/audio_player_util.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/ota_data.dart';
import '../step_control_page.dart';

class ParamSettingController extends StatefulWidget {
  const ParamSettingController({super.key});

  @override
  State<ParamSettingController> createState() => _ParamSettingControllerState();
}

class _ParamSettingControllerState extends State<ParamSettingController> {
  // 位置控制参数
  double xPosition = 0.0; // 竖向位置，向上为正
  double yPosition = 0.0; // 横向位置，向左为正
  double zRotation = 0.0; // 旋转角度，左转为正

  // 发球参数
  double topWheelSpeed = 4.0; // 上发球轮速度
  double bottomWheelSpeed = 4.0; // 下发球轮速度
  double turntableSpeed = 40.0; // 转盘速度（默认40）
  double ballAngle = 130; // 发球角度

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


  Future<void> getStoreData() async{
    topWheelSpeed = await DataBaseHelper().fetchTopWheelSpeedData();
    bottomWheelSpeed = await DataBaseHelper().fetchBottomWheelSpeedData();
    ballAngle = await DataBaseHelper().fetchBallAngleData();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommStatusManager().isStepControlling = false;
    CommStatusManager().isDeviceDeail = true;
     getStoreData();

    CommStatusManager().isDeviceDeail = true;
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kStepControlFinishResponse) {
        print("发球机开始发球了");
        indexList.add(0);
        speedIndexs++;
        // 开始发球测试
        // newTaskMapss[indexList.length]?.call();
        // modeOneGame();
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
        title: const Text('网球发球机控制面板'),
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
                            min: 4,
                            max: 15,
                            divisions: 12,
                            label: topWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                topWheelSpeed = value;
                                print("上发球轮${topWheelSpeed}");
                                DataBaseHelper().saveTopWheelSpeedData(value.roundToDouble());
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
                            min: 4,
                            max: 15,
                            divisions: 12,
                            label: bottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomWheelSpeed = value;
                                DataBaseHelper().saveBottomWheelSpeedData(value.roundToDouble());
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
                            min: 120,
                            max: 200.0,
                            divisions: 16,
                            label: ballAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                ballAngle = value;
                                DataBaseHelper().saveBallAngleData(ballAngle.roundToDouble());
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
                            min: 0.0,
                            max: 100.0,
                            divisions: 101,
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
                // 停止训练按钮
                ElevatedButton.icon(
                  onPressed: () async{
                    final params = TennisMachineParams.fromState(
                      xPosition,
                      yPosition,
                      zRotation,
                      0,
                      0,
                      0,
                      ballAngle,
                      ballInterval,
                      0,
                    );
                    sendControlCommand(params);
                    AnyLoading.showLoading(maskType: AnyLoadingMaskType.black);
                    await Future.delayed(const Duration(seconds: 5));
                    AnyLoading.dismiss();
                  },
                  // icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(context.i18n('停止训练'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // 加粗
                      fontSize: 16,                // 可选
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(236, 189, 88, 1.0),
                    foregroundColor: Colors.white, // ← 文字/图标颜色
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // 启动/停止按钮
                ElevatedButton.icon(
                  onPressed: () async{

                      isRunning = !isRunning;
                      print("状态${isRunning}");

                    // 创建参数对象
                    final params = TennisMachineParams.fromState(
                        xPosition, yPosition, zRotation,
                        topWheelSpeed, bottomWheelSpeed, turntableSpeed,
                        ballAngle, ballInterval, ballCount
                    );
                    // 发送控制命令
                    sendControlCommand(params);
                      AnyLoading.showLoading(maskType: AnyLoadingMaskType.black);
                      await Future.delayed(const Duration(seconds: 5));
                      AnyLoading.dismiss();
                  },
                  // icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(context.i18n('开始训练'),
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

            // 交叉循环发球
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 交叉循环按钮
                // ElevatedButton.icon(
                //   onPressed: () {
                //
                //     },
                //   label: Text('交叉循环',
                //     style: const TextStyle(
                //       fontWeight: FontWeight.bold, // 加粗
                //       fontSize: 16,                // 可选
                //     ),
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     foregroundColor: Colors.white, // ← 文字/图标颜色
                //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}
