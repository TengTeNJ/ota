import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ota/controllers/paramSetting/small_robot_task.dart';

import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../step/controller/fire_controller.dart';

/// 小型发球机课程训练
class SmallRobotCourseController extends StatefulWidget {
  const SmallRobotCourseController({super.key});

  @override
  State<SmallRobotCourseController> createState() => _SmallRobotCourseControllerState();
}

class _SmallRobotCourseControllerState extends State<SmallRobotCourseController> {
  // 发球参数
  double bottomLineTopWheelSpeed = 4.0; // 底线球上发球轮速度（区间问0---99）
  double bottomLineBottomWheelSpeed = 4.0; // 底线球下发球轮速度（区间问0---99）
  double bottomLineBallAngle = 15; // 底线球发球角度（区间为90---225）


  double netPlayTopWheelSpeed = 4.0; // 近网球上发球轮速度（区间问0---99）
  double netPlayBottomWheelSpeed = 4.0; // 近网球下发球轮速度（区间问0---99）
  double netPlayBallAngle = 15; // 近网球发球角度（区间为90---225）

  double volleyAtNetTopWheelSpeed = 4.0; // 网前截击上发球轮速度（区间问0---99）
  double volleyAtNetBottomWheelSpeed = 4.0; // 网前截击球下发球轮速度（区间问0---99）
  double volleyAtNetBallAngle = 15; // 网前截击球发球角度（区间为90---225）


  // 发球模式参数
  double ballInterval = 2.0; // 发球间隔(秒)
  int ballCount = 10; // 发球数量

  // 控制按钮状态
  bool isRunning = false;

  // 文本控制器
  late TextEditingController topWheelController;
  late TextEditingController bottomWheelController;
  late TextEditingController turntableController;
  late TextEditingController ballAngleController;
  late TextEditingController ballIntervalController;
  late TextEditingController ballCountController;

  late StreamSubscription<DataUpdatedEvent> _subscription;

  // 小型发球机步伐训练
  void fireControll() {
    print("${bottomLineTopWheelSpeed.truncateToDouble()}--${bottomLineBottomWheelSpeed.truncateToDouble()} --${bottomLineBallAngle.truncateToDouble()}--"
        "${netPlayTopWheelSpeed.truncateToDouble()} --${netPlayBottomWheelSpeed.truncateToDouble()}--${netPlayBallAngle.truncateToDouble()}--"
        "${volleyAtNetTopWheelSpeed.truncateToDouble()}--${volleyAtNetBottomWheelSpeed.truncateToDouble()}--${volleyAtNetBallAngle.truncateToDouble()}");

    final plan = SmallRobotTask.cycleStep(bottomLineTopSpeed: bottomLineTopWheelSpeed.truncateToDouble(),
                                         bottomLineBottomSpeed: bottomLineBottomWheelSpeed.truncateToDouble(),
                                         bottomLineAngle: bottomLineBallAngle.truncateToDouble(),
                                         netPlayTopSpeed: netPlayTopWheelSpeed.truncateToDouble(),
                                         netPlayBottomSpeed: netPlayBottomWheelSpeed.truncateToDouble(),
                                         netPlayAngle: netPlayBallAngle.truncateToDouble(),
                                         volleyTopSpeed: volleyAtNetTopWheelSpeed.truncateToDouble(),
                                         volleyBottomSpeed: volleyAtNetBottomWheelSpeed.truncateToDouble(),
                                         volleyAngle: volleyAtNetBallAngle.truncateToDouble(),
    );
    final controller = FireController(plan.tasks);
    controller.onProgress = (taskIndex, shotIndex) {
      print("第 $taskIndex 个点位，第 $shotIndex 球完成");
      setState(() {
      });
    };
    controller.onFinished = () {
      print("任务计划完成！");
    };
    controller.start();
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    CommStatusManager().isStepControlling = false;
    CommStatusManager().isDeviceDeail = true;
    // 初始化控制器并设置初始值
    topWheelController = TextEditingController(text: bottomLineTopWheelSpeed.round().toString());
    bottomWheelController = TextEditingController(text: bottomLineBottomWheelSpeed.round().toString());
    ballAngleController = TextEditingController(text:bottomLineBallAngle.round().toString());

    ballIntervalController = TextEditingController(text: ballInterval.toStringAsFixed(1));
    ballCountController = TextEditingController(text: ballCount.toString());

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小型网球发球机课程训练'),
        backgroundColor: Colors.green[700],
        actions: [

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

                    // 底线球上发球轮速度
                    Row(
                      children: [
                        const Text('底线球上发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: bottomLineTopWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: bottomLineTopWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomLineTopWheelSpeed = value;
                                topWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${bottomLineTopWheelSpeed.round()}'),
                      ],
                    ),

                    // 底线球下发球轮速度
                    Row(
                      children: [
                        const Text('底线球下发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: bottomLineBottomWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: bottomLineBottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomLineBottomWheelSpeed = value;
                                bottomWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${bottomLineBottomWheelSpeed.round()}'),
                      ],
                    ),

                    //底线球 发球角度
                    Row(
                      children: [
                        const Text('底线球发球角度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: bottomLineBallAngle,
                            min: 15.0,
                            max: 40.0,
                            divisions: 25,
                            label: bottomLineBallAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomLineBallAngle = value;
                                ballAngleController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${bottomLineBallAngle.round()} °'),
                      ],
                    ),


                    // 近网 上发球轮速度
                    Row(
                      children: [
                        const Text('近网上发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: netPlayTopWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: netPlayTopWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                netPlayTopWheelSpeed = value;
                                topWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${netPlayTopWheelSpeed.round()}'),
                      ],
                    ),

                    // 近网 下发球轮速度
                    Row(
                      children: [
                        const Text('近网下发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: netPlayBottomWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: netPlayBottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                netPlayBottomWheelSpeed = value;
                                bottomWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${netPlayBottomWheelSpeed.round()}'),
                      ],
                    ),

                    //近网 发球角度
                    Row(
                      children: [
                        const Text('近网发球角度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: netPlayBallAngle,
                            min: 15.0,
                            max: 40.0,
                            divisions: 25,
                            label: netPlayBallAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                netPlayBallAngle = value;
                                ballAngleController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${netPlayBallAngle.round()} °'),
                      ],
                    ),


                    // 网前截击 上发球轮速度
                    Row(
                      children: [
                        const Text('网前截击上发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: volleyAtNetTopWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: volleyAtNetTopWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                volleyAtNetTopWheelSpeed = value;
                                topWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${volleyAtNetTopWheelSpeed.round()}'),
                      ],
                    ),

                    // 网前截击 下发球轮速度
                    Row(
                      children: [
                        const Text('网前截击发球轮速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: volleyAtNetBottomWheelSpeed,
                            min: 1,
                            max: 99,
                            divisions: 20,
                            label: volleyAtNetBottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                volleyAtNetBottomWheelSpeed = value;
                                bottomWheelController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${volleyAtNetBottomWheelSpeed.round()}'),
                      ],
                    ),

                    //网前截击 发球角度
                    Row(
                      children: [
                        const Text('网前截击发球角度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: volleyAtNetBallAngle,
                            min: 15.0,
                            max: 40.0,
                            divisions: 25,
                            label: volleyAtNetBallAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                volleyAtNetBallAngle = value;
                                ballAngleController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${volleyAtNetBallAngle.round()} °'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 24),



            const SizedBox(height: 24),

            // 发球
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 训练按钮
                ElevatedButton.icon(
                  onPressed: () {
                    fireControll();
                  },
                  label: Text('开始训练',
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
