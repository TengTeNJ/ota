import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/controllers/paramSetting/small_robot_task.dart';

import '../../constants.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/event_manager.dart';
import '../../utils/system_util.dart';
import '../step/controller/fire_controller.dart';
import '../step/controller/horizontal_move_tasks.dart';

class SmallRobotNearFar extends StatefulWidget {
  const SmallRobotNearFar({super.key});

  @override
  State<SmallRobotNearFar> createState() => _SmallRobotNearFarState();
}

class _SmallRobotNearFarState extends State<SmallRobotNearFar> {
  late StreamSubscription<DataUpdatedEvent> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemUtil.lockScreenHorizontalDirection();
    initData();
    fireControll();
    // dataListen();
  }

  // 初始化数据
  void initData() {
    CommStatusManager().isDeviceDeail = true;
  }

  // 发球控制
  void fireControll() {
    final plan = SmallRobotTask.nearFarStep();
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


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
