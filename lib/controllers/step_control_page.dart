import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ota/utils/ota_data.dart';

import '../utils/comm_statu_manager.dart';

// 参数模型类
class TennisMachineParams {
  // 位置控制参数
  int xPosition; // 竖向位置，向上为正
  int yPosition; // 横向位置，向左为正
  int zRotation; // 旋转角度，左转为正

  // 发球参数
  int topWheelSpeed; // 上发球轮速度
  int bottomWheelSpeed; // 下发球轮速度
  int turntableSpeed; // 转盘速度
  int ballAngle; // 发球角度

  // 发球模式参数
  double ballInterval; // 发球间隔(秒)
  int ballCount; // 发球数量

  TennisMachineParams({
    required this.xPosition,
    required this.yPosition,
    required this.zRotation,
    required this.topWheelSpeed,
    required this.bottomWheelSpeed,
    required this.turntableSpeed,
    required this.ballAngle,
    required this.ballInterval,
    required this.ballCount,
  });

  // 将参数转换为发送格式
  List<int> toBytes() {
    List<int> data = [];

    // 添加X轴数据（两个字节，高8位在前）
    final xBytes = intToBytes(xPosition);
    data.addAll(xBytes);

    // 添加Y轴数据
    final yBytes = intToBytes(yPosition);
    data.addAll(yBytes);

    // 添加Z轴旋转角度
    final zBytes = intToBytes(zRotation);
    data.addAll(zBytes);

    // 添加其他参数（根据需要调整）
    data.add(topWheelSpeed);
    data.add(bottomWheelSpeed);
    data.add(turntableSpeed);
    data.add(ballAngle + 45); // 转换为0-90范围
    data.add((ballInterval * 10).round()); // 转换为整数（0.5秒 = 5）
    data.add(ballCount);

    return data;
  }

  // 整数转字节的辅助方法
  List<int> intToBytes(int value) {
    final highByte = (value >> 8) & 0xFF;
    final lowByte = value & 0xFF;
    return [highByte, lowByte];
  }

  // 从当前状态创建参数对象
  factory TennisMachineParams.fromState(
      double xPosition, double yPosition, double zRotation,
      double topWheelSpeed, double bottomWheelSpeed, double turntableSpeed,
      double ballAngle, double ballInterval, int ballCount
      ) {
    return TennisMachineParams(
      xPosition: xPosition.round(),
      yPosition: yPosition.round(),
      zRotation: zRotation.round(),
      topWheelSpeed: topWheelSpeed.round(),
      bottomWheelSpeed: bottomWheelSpeed.round(),
      turntableSpeed: turntableSpeed.round(),
      ballAngle: ballAngle.round(),
      ballInterval: ballInterval,
      ballCount: ballCount,
    );
  }

  // 通用步伐参数
  factory TennisMachineParams.fromNewState(
      double xPosition, double yPosition, double zRotation,
      int ballCount,
      double topWheelSpeed, double bottomWheelSpeed, double turntableSpeed,
      double ballAngle, double ballInterval
      ) {
    return TennisMachineParams(
      xPosition: xPosition.round(),
      yPosition: yPosition.round(),
      zRotation: zRotation.round(),
      ballCount: ballCount,
      topWheelSpeed: topWheelSpeed.round(),
      bottomWheelSpeed: bottomWheelSpeed.round(),
      turntableSpeed: turntableSpeed.round(),
      ballAngle: ballAngle.round(),
      ballInterval: ballInterval,
    );
  }



  // 用于调试的toString方法
  @override
  String toString() {
    return 'TennisMachineParams{'
        'xPosition: $xPosition, yPosition: $yPosition, zRotation: $zRotation, '
        'topWheelSpeed: $topWheelSpeed, bottomWheelSpeed: $bottomWheelSpeed, '
        'turntableSpeed: $turntableSpeed, ballAngle: $ballAngle, '
        'ballInterval: $ballInterval, ballCount: $ballCount}';
  }
}

class TennisBallMachineControl extends StatefulWidget {
  const TennisBallMachineControl({Key? key}) : super(key: key);

  @override
  _TennisBallMachineControlState createState() => _TennisBallMachineControlState();
}

class _TennisBallMachineControlState extends State<TennisBallMachineControl> {
  // 位置控制参数
  double xPosition = 0.0; // 竖向位置，向上为正
  double yPosition = 0.0; // 横向位置，向左为正
  double zRotation = 0.0; // 旋转角度，左转为正

  // 发球参数
  double topWheelSpeed = 0.0; // 上发球轮速度
  double bottomWheelSpeed = 0.0; // 下发球轮速度
  double turntableSpeed = 0.0; // 转盘速度
  double ballAngle = 90.0; // 发球角度

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

  @override
  void initState() {
    super.initState();

    CommStatusManager().isStepControlling = false;
    CommStatusManager().isDeviceDeail = true;
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

    // 添加监听器以同步输入框和滑块
    xController.addListener(() {
      updateValueFromController(xController, (value) {
        if (value >= -600 && value <= 600) {
          setState(() {
            xPosition = value.toDouble();
          });
        }
      });
    });

    yController.addListener(() {
      updateValueFromController(yController, (value) {
        if (value >= -600 && value <= 600) {
          setState(() {
            yPosition = value.toDouble();
          });
        }
      });
    });

    zController.addListener(() {
      updateValueFromController(zController, (value) {
        if (value >= -180 && value <= 180) {
          setState(() {
            zRotation = value.toDouble();
          });
        }
      });
    });

    topWheelController.addListener(() {
      updateValueFromController(topWheelController, (value) {
        if (value >= 0 && value <= 100) {
          setState(() {
            topWheelSpeed = value.toDouble();
          });
        }
      });
    });

    bottomWheelController.addListener(() {
      updateValueFromController(bottomWheelController, (value) {
        if (value >= 0 && value <= 100) {
          setState(() {
            bottomWheelSpeed = value.toDouble();
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



  @override
  void dispose() {
    // 释放控制器资源
    xController.dispose();
    yController.dispose();
    zController.dispose();
    topWheelController.dispose();
    bottomWheelController.dispose();
    turntableController.dispose();
    ballAngleController.dispose();
    ballIntervalController.dispose();
    ballCountController.dispose();
    CommStatusManager().isDeviceDeail = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网球发球机控制面板'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 设置按钮功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 位置控制区
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
                      '位置控制',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // X轴控制（竖向）
                    Row(
                      children: [
                        const Text('X (竖向): '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: xPosition,
                            min: -600.0,
                            max: 600.0,
                            divisions: 20,
                            label: xPosition.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                xPosition = value;
                                xController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: xController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
                            ],
                            onFieldSubmitted: (value) {
                              final intValue = int.tryParse(value) ?? 0;
                              if (intValue >= -600 && intValue <= 600) {
                                setState(() {
                                  xPosition = intValue.toDouble();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              border: const OutlineInputBorder(),
                              errorText: xController.text.isNotEmpty &&
                                  (int.tryParse(xController.text) == null ||
                                      int.parse(xController.text) < -600 ||
                                      int.parse(xController.text) > 600)
                                  ? '范围: -100 到 100'
                                  : null,
                            ),
                          ),
                        ),
                        const Text(' cm'),
                      ],
                    ),

                    // Y轴控制（横向）
                    Row(
                      children: [
                        const Text('Y (横向): '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: yPosition,
                            min: -600.0,
                            max: 600.0,
                            divisions: 20,
                            label: yPosition.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                yPosition = value;
                                yController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: yController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
                            ],
                            onFieldSubmitted: (value) {
                              final intValue = int.tryParse(value) ?? 0;
                              if (intValue >= -600 && intValue <= 600) {
                                setState(() {
                                  yPosition = intValue.toDouble();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              border: const OutlineInputBorder(),
                              errorText: yController.text.isNotEmpty &&
                                  (int.tryParse(yController.text) == null ||
                                      int.parse(yController.text) < -600 ||
                                      int.parse(yController.text) > 600)
                                  ? '范围: -100 到 100'
                                  : null,
                            ),
                          ),
                        ),
                        const Text(' cm'),
                      ],
                    ),

                    // Z轴旋转控制
                    Row(
                      children: [
                        const Text('Z (旋转): '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: zRotation,
                            min: -360.0,
                            max: 360.0,
                            divisions: 720,
                            label: zRotation.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                zRotation = value;
                                zController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          child: TextFormField(
                            controller: zController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
                            ],
                            onFieldSubmitted: (value) {
                              final intValue = int.tryParse(value) ?? 0;
                              if (intValue >= -180 && intValue <= 180) {
                                setState(() {
                                  zRotation = intValue.toDouble();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              border: const OutlineInputBorder(),
                              errorText: zController.text.isNotEmpty &&
                                  (int.tryParse(zController.text) == null ||
                                      int.parse(zController.text) < -180 ||
                                      int.parse(zController.text) > 180)
                                  ? '范围: -180 到 180'
                                  : null,
                            ),
                          ),
                        ),
                        const Text(' °'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

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
                            min: 0.0,
                            max: 99.0,
                            divisions: 100,
                            label: topWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                topWheelSpeed = value;
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
                            min: 0.0,
                            max: 99.0,
                            divisions: 100,
                            label: bottomWheelSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                bottomWheelSpeed = value;
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

                    // 转盘速度
                    Row(
                      children: [
                        const Text('转盘速度: '),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Slider(
                            value: turntableSpeed,
                            min: 0.0,
                            max: 40.0,
                            divisions: 40,
                            label: turntableSpeed.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                turntableSpeed = value;
                                turntableController.text = value.round().toString();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${turntableSpeed.round()}'),
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
                            min: 90.0,
                            max: 225.0,
                            divisions: 135,
                            label: ballAngle.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                ballAngle = value;
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
                            divisions: 99,
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
                // 重置按钮
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      xPosition = 0.0;
                      yPosition = 0.0;
                      zRotation = 0.0;
                      topWheelSpeed = 50.0;
                      bottomWheelSpeed = 50.0;
                      turntableSpeed = 30.0;
                      ballAngle = 0.0;
                      ballInterval = 2.0;
                      ballCount = 10;

                      // 重置控制器
                      xController.text = xPosition.round().toString();
                      yController.text = yPosition.round().toString();
                      zController.text = zRotation.round().toString();
                      topWheelController.text = topWheelSpeed.round().toString();
                      bottomWheelController.text = bottomWheelSpeed.round().toString();
                      turntableController.text = turntableSpeed.round().toString();
                      ballAngleController.text = ballAngle.round().toString();
                      ballIntervalController.text = ballInterval.toStringAsFixed(1);
                      ballCountController.text = ballCount.toString();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('重置'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // 启动/停止按钮
                ElevatedButton.icon(
                  onPressed: () {
                    // setState(() {
                    //   isRunning = !isRunning;
                    // });

                    // 创建参数对象
                    final params = TennisMachineParams.fromState(
                        xPosition, yPosition, zRotation,
                        topWheelSpeed, bottomWheelSpeed, turntableSpeed,
                        ballAngle, ballInterval, ballCount
                    );

                    // 发送控制命令
                    sendControlCommand(params);
                  },
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? '停止' : '启动'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 发送控制命令的方法
  void sendControlCommand(TennisMachineParams params) {
    params.ballInterval = params.ballInterval*50;
    // if(CommStatusManager().isStepControlling){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('正在控制中，请稍后'),
    //       duration: Duration(milliseconds:2000 ),
    //     ),
    //   );
    //   return;
    // }
    // 显示参数信息（实际应用中这里会发送到设备）
    print('发送参数: $params');

    // 获取字节数组
    final data = params.toBytes();
    print('字节数据: $data');
    CommStatusManager().writerData(stepControlData(params));
    // 实际发送数据到设备
    // sendToDevice(data);
  }
}
