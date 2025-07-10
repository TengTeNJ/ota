import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ota/controllers/speed_page.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/controllers/update_progress.dart';
import 'package:ota/model/ble_model.dart';
import 'package:ota/utils/demo_util.dart';
import 'package:ota/views/hight_low_view.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/language_model.dart';
import '../utils/ota_data.dart';
import '../utils/ota_service_data.dart';
import '../views/empty_view.dart';
import '../views/speed_wheel.dart';
import '../views/tennis_move_view.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
  late StreamSubscription<DataUpdatedEvent> _subscription;
  int _demoIndex = 0;
  int _squreDemoIndex = 0;

  List<DiscoveredDevice> _devices = [];
  DiscoveredDevice? _connectedDevice;
  bool _connected = false;
  DateTime _currentTimer = DateTime.now();
  bool isStep1 = true;

  int stepControlIndex = 0;

  late List<TennisMachineParams> demoDatas;
  late List<TennisMachineParams> squreDatas;

  demoControl() {
    _demoIndex = 0;
    stepControlIndex = 1;
    isStep1 = true;
    demoDatas = DemoUtil.demoStepDatas();
    CommStatusManager().writerData(stepControlData(demoDatas[_demoIndex]));
  }

  squreDemoControl() {
    _squreDemoIndex = 0;
    stepControlIndex = 2;
    isStep1 = false;
    squreDatas = DemoUtil.demoStepDatas();
    CommStatusManager().writerData(stepControlData(squreDatas[_demoIndex]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleNotAllData.clear();
    CommStatusManager().isDeviceDeail = true;
    CommStatusManager().progress = CommProgress.ready;
    // 加载bin文件
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      setState(() {
        if (event.data == kBLEConneted) {
          initData();
        } else if (event.data == kBLEDisconneted) {
          initData();
        } else if (event.data == kModeControlResponse) {
          Future.delayed(Duration(milliseconds: 500), () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('收到模式的控制回复'),
              duration: Duration(milliseconds: 2000),
            ));
          });
        } else if (event.data == kStepControlFinishResponse) {
          if (stepControlIndex == 0) {
            return;
          }
          if (isStep1) {
            _demoIndex++;
            if (_demoIndex < demoDatas.length) {
              CommStatusManager()
                  .writerData(stepControlData(demoDatas[_demoIndex]));
            }
          } else {
            _squreDemoIndex++;
            if (_squreDemoIndex < squreDatas.length) {
              CommStatusManager()
                  .writerData(stepControlData(squreDatas[_squreDemoIndex]));
            }
          }
        } else if (event.data == kPowerValue) {
          setState(() {});
        }
      });
    });
    initData();
    // wwQQQQQQQwwwwww
  }

  initData() {
    if (CommStatusManager().currentConnectedDevice != null) {
      setState(() {
        _connectedDevice = CommStatusManager().currentConnectedDevice!.device;
        _connected = true;
      });
    } else {
      _connectedDevice = null;
      _connected = false;
    }
  }

  /*
  * 连接
  * */
  Future<void> _connectToDevice(BLEModel model) async {
    // 断开连接
    if (CommStatusManager().currentConnectedDevice != null &&
        CommStatusManager().currentConnectedDevice!.device!.id ==
            model.device!.id) {
      // 断开连接
      CommStatusManager().currentConnectedDevice!.bleStream?.cancel();
      BLEModel _device = CommStatusManager()
          .deviceList
          .firstWhere((_element) => _element.device!.id == model.device!.id);
      if (_device != null) {
        setState(() {
          CommStatusManager().currentConnectedDevice = null;
          _connectedDevice = null;
          _connected = false;
        });
      }
      return;
    }

    CommStatusManager().connectToDevice(model);
  }

  Widget _buildDeviceItem(BLEModel model) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(model.device!.name),
      subtitle: Text('${model.device!.id}    RSSI:${model.device!.rssi}'),
      trailing: ElevatedButton(
        onPressed: () => _connectToDevice(model),
          child:  Text( CommStatusManager().currentConnectedDevice != null && CommStatusManager().currentConnectedDevice!.device!.id == model.device!.id ? '${Provider.of<LanguageModel>(context, listen: true).getText('断开连接')}' : '${Provider.of<LanguageModel>(context, listen: true).getText('连接')}'),
      ),
    );
  }

  /*
  * 发送数据
  * */
  void _sendBluetoothData(BuildContext context, String data) {
    CommStatusManager().writerData(changeModeData(int.parse(data)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已发送: $data'),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, String text, String data) {
    return ElevatedButton(
      onPressed: () {
        if (data == '1') {
          demoControl();
          return;
        }
        if (data == '2') {
          demoControl();
          return;
        }

        if (data == '5') {
          // 结束手动模式
          CommStatusManager().writerData(changeModeData(0));
          return;
        }
        if (data == 'speed') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sped()), // 目标页面
          );
          return;
        }

        if (data == 'mode1') {
          CommStatusManager().writerData(changeModeData(1));
          return;
        }
        if (data == 'mode2') {
          CommStatusManager().writerData(changeModeData(2));
          return;
        }
        if (data == 'mode3') {
          CommStatusManager().writerData(changeModeData(3));
          return;
        }
        // 力量训练
        if (data == 'mode5') {
          CommStatusManager().writerData(changeModeData(5));
          return;
        }
        // 标靶训练
        if (data == 'mode6') {
          CommStatusManager().writerData(changeModeData(6));
          return;
        }
        // 结束
        if (data == 'mode7') {
          CommStatusManager().writerData(changeModeData(0xff));
          return;
        }

        if (data == 'reset') {
          CommStatusManager().writerData(resetToPreVersion());
          return;
        }
        if (data == 'statu') {
          CommStatusManager().writerData(systemFeedbackData());
          return;
        }
        if (data == 'position') {
          CommStatusManager().writerData(positionCheckData());
          return;
        }
        if (data == 'adjust') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TennisBallMachineControl()), // 目标页面
          );
          return;
        }

        if (data == 'left') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0, 11, 12, 12, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }

        if (data == 'right') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0, -11, 12, 12, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }
        if (data == 'leftlow') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0,  11, 12, 12, 40, 120, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }

        if (data == 'rightlow') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0,  -11, 12, 12, 40, 120, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }
        if (data == 'adjust') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TennisBallMachineControl()), // 目标页面
          );
          return;
        }

        if (data == 'leftmove') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 100, 0, 11, 11, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }
        if (data == 'rightmove') {
          TennisMachineParams params = TennisMachineParams.fromState(
              0, -100, 0, 11, 11, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }

        if (data == 'frontmove') {
          TennisMachineParams params =
              TennisMachineParams.fromState(100, 0, 0, 10, 10, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }
        if (data == 'backmove') {
          TennisMachineParams params = TennisMachineParams.fromState(
              -100, 0, 0, 11, 11, 40, 110, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }

        if (data == 'lianxu1') {
          TennisMachineParams params =
              TennisMachineParams.fromState(0, 0, 13, 20, 20, 40, 200, 125, 1);
          CommStatusManager().writerData(stepControlData(params));
          return;
        }

        // 在这里调用发送蓝牙数据的逻辑
        _sendBluetoothData(context, data);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color:Color.fromRGBO(100, 200, 200, 1.0),fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(182, 246, 29, 1.0),
          centerTitle: true,
          title: Text(
            '网球训练机器人',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: Container(
        child: CommStatusManager().deviceList.length == 0
            ? EmptyView()
            : Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      if (CommStatusManager().deviceList.length != 0)
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: Row(
                            children: [
                              Text(
                                '${Provider.of<LanguageModel>(context, listen: true).getText('设备列表')}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: CommStatusManager().deviceList.length,
                        itemBuilder: (_, index) => _buildDeviceItem(
                            CommStatusManager().deviceList[index]),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (_connected)
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '设置',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.battery_alert),
                                    Text('${CommStatusManager().powerValue}')
                                  ],
                                ),
                                const Spacer()
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('手动模式')}', '4'),
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('结束手动模式')}', '5'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('位置校准')}', 'position'),
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('请求系统状态')}', 'statu'),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (_connected)
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '调节',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer()
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildModeButton(context, 'Step1', '1'),
                                SizedBox(height: 20),
                                _buildModeButton(context, 'Step2', '2'),
                                SizedBox(height: 20),
                                _buildModeButton(context, 'Adjust your pace', 'adjust'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('左侧高球')}', 'left'),
                                SizedBox(height: 20),
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('右侧高球')}', 'right'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('左侧低球')}', 'leftlow'),
                                SizedBox(height: 20),
                                _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('右侧低球')}', 'rightlow'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  _buildModeButton(context, 'Mode1(Rotation: Left-Right)', 'mode1'),
                                ],),
                                SizedBox(height: 20),
                               Row(
                                 children: [
                                   _buildModeButton(context, 'Mode2(Forward - Backward)', 'mode2'),
                                 ],
                               ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Row(
                              children: [
                                _buildModeButton(context, 'Mode3(Mover: Left - Right)', 'mode3'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  _buildModeButton(context, 'Mode5(Strength Training)', 'mode5'),
                                ],),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    _buildModeButton(context, 'Mode6(Target Training)', 'mode6'),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Row(
                              children: [
                                _buildModeButton(context, 'End(End current mode)', 'mode7'),
                              ],
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${Provider.of<LanguageModel>(context, listen: true).getText('移动发球')}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer()
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          DirectionControlPad(
                              size: 200,
                              onDirectionChanged: (Direction rection) {
                                if (rection == Direction.forward) {
                                  // 前移
                                  TennisMachineParams params =
                                      TennisMachineParams.fromState(
                                          100, 0, 0, 11, 11, 40, 110, 125, 1);
                                  CommStatusManager()
                                      .writerData(stepControlData(params));
                                } else if (rection == Direction.backward) {
                                  // 后移
                                  TennisMachineParams params =
                                      TennisMachineParams.fromState(
                                          -100, -0, 0, 12, 12, 40, 110, 125, 1);
                                  CommStatusManager()
                                      .writerData(stepControlData(params));
                                } else if (rection == Direction.left) {
                                  // 左移
                                  TennisMachineParams params =
                                      TennisMachineParams.fromState(
                                          0, 100, 0, 12, 12, 40, 110, 125, 1);
                                  CommStatusManager()
                                      .writerData(stepControlData(params));
                                } else if (rection == Direction.right) {
                                  // 右移
                                  TennisMachineParams params =
                                      TennisMachineParams.fromState(
                                          0, -100, 0, 12, 12, 40, 110, 125, 1);
                                  CommStatusManager()
                                      .writerData(stepControlData(params));
                                }
                              })
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${Provider.of<LanguageModel>(context, listen: true).getText('调节发球')}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              _buildModeButton(context, '${Provider.of<LanguageModel>(context, listen: true).getText('手动遥控')}', 'speed'),
                              const Spacer()
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    CommStatusManager().isDeviceDeail = false;
    super.dispose();
  }
}
