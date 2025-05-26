import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/controllers/factory_log_show.dart';
import 'package:ota/controllers/log_show.dart';
import 'package:ota/utils/ota_service_data.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
class FactoryProgress extends StatefulWidget {
  const FactoryProgress({super.key});

  @override
  State<FactoryProgress> createState() => _UpdateProgressState();
}

class _UpdateProgressState extends State<FactoryProgress> {
  int _currentStep = 0;
  // 模拟升级步骤
  final List<String> _steps = [
    '发送Ping',
    '发送eraseAll',
    '发送开始写',
    '开始发送升级包数据',
    '重启设备',
    '完成'
  ];
  late StreamSubscription<DataUpdatedEvent> _subscription;
  final List<CommProgress> progressDatas = [
    CommProgress.ping,
    CommProgress.eraseAll,
    CommProgress.begainWrite,
    CommProgress.sendingData,
    CommProgress.reset,
    CommProgress.finished,
  ];
  // 模拟每一步的完成状态
  final List<bool> _stepStates = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      begainUpdate();
    });
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      setState(() {
        if (event.data == kOTAProgress) {
          // 更新升级进度
          int _progress =  progressDatas.indexOf(CommStatusManager().progress);
          print('_progress=${_progress}');
          setState(() {
            _currentStep = _progress;
          });
        }else if(event.data == kOTATextProgress){
          print('CommStatusManager().factoryStrings=${CommStatusManager().factoryStrings}');
          // setState(() {
          //
          // });
        }
      });
    });
  }

  /*开始升级*/
  begainUpdate(){
    bleNotAllData.clear();
    print('bleNotAllData=${bleNotAllData.length}');
    CommStatusManager().progress = CommProgress.ping;
    CommStatusManager().factoryStrings.clear();
    CommStatusManager().factoryStrings = ['','','','','','',];

    CommStatusManager().writerData(pingData());
    CommStatusManager().factoryStrings[0] = '已发送Ping';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'OTA进度',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details){
                return SizedBox();
              },
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (int index) {
                setState(() {
                  _currentStep = index;
                });
              },
              steps: _steps.map((String step) {
                int index = _steps.indexOf(step);
                return Step(
                  title: Text(step),
                  content: Text(''),
                  // subtitle: Text(CommStatusManager().otaStrings.isEmpty ? '开始' : CommStatusManager().otaStrings[index]),
                  // content: Text(CommStatusManager().otaStrings.isEmpty ? '开始' : CommStatusManager().otaStrings[index]),
                  // content: Text('888'),
                  isActive: index <= _currentStep,
                  // state: _stepStates[index]
                  //     ? StepState.complete
                  //     : StepState.indexed,
                );
              }).toList(),
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FactoryLogShow()), // 目标页面
              );
            }, child: Text('查看详细日志')),
            if (_currentStep == 3)
              Column(
                children: [
                  Text('${CommStatusManager().hasSendDataLength}/${CommStatusManager().totalDataLength}'),
                  LinearProgressIndicator(
                    value: CommStatusManager().hasSendDataLength/CommStatusManager().totalDataLength,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription.cancel();
  }
}
