/// 截击凌空球训练

import 'package:flutter/material.dart';
import 'package:ota/controllers/step/overhead_volley_task.dart';

import '../../utils/comm_statu_manager.dart';
import '../../utils/system_util.dart';
import 'controller/fire_controller.dart';

class OverheadVolleyController extends StatefulWidget {
  const OverheadVolleyController({super.key});

  @override
  State<OverheadVolleyController> createState() => _OverheadVolleyControllerState();
}

class _OverheadVolleyControllerState extends State<OverheadVolleyController> {

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
    final plan = OverheadVolleyTask.highLowVolleyStep();
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
    return  Title(color: Colors.white, child: Center(
      child:Text(
        '凌空截击球训练',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 44,
            fontFamily: "SanFranciscoDisplay",
            color: Colors.black),
      ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    super.dispose();
  }
}
