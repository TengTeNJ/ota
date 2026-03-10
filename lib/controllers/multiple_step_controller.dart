/// 步伐选择训练页面

import 'package:flutter/material.dart';
import 'package:ota/controllers/step/controller/fire_controller.dart';
import 'package:ota/controllers/step/controller/horizontal_move_tasks.dart';
import 'package:ota/controllers/step/overhead_volley_task.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/system_util.dart';


class OverheadVolleySelectionPage extends StatefulWidget {
  const OverheadVolleySelectionPage({super.key});

  @override
  State<OverheadVolleySelectionPage> createState() => _OverheadVolleySelectionPageState();
}

class _OverheadVolleySelectionPageState extends State<OverheadVolleySelectionPage> {
  // 步伐列表
  final List<String> steps = [
    "高压截击",
    "布云朝克特",
    "横向喂球",
    "快速截击",
  ];

  String? selectedStep; // 当前选择的步伐
  int currentTaskIndex = 0; // 当前第几个球
  bool inProgress = false; // 是否正在训练

  FireController? controller;

  @override
  void initState() {
    super.initState();
   // SystemUtil.lockScreenHorizontalDirection();
    CommStatusManager().isDeviceDeail = true;
  }

  // 开始发球
  void startTraining() {
    if (selectedStep == null) return;

    // 根据选择的步伐生成任务
    late final plan;
    switch (selectedStep) {
      case "高压截击":
        plan = OverheadVolleyTask.highLowVolleyStep();
        break;
      case "布云朝克特":
        plan =  FirePlan.pauloStep();
        break;
      case "横向喂球":
        plan = FirePlan.lateralBallFeeding(); // 示例
        break;
      case "快速截击":
        plan = OverheadVolleyTask.highLowVolleyStep(count: 5, gameBallAngle: 140); // 示例
        break;
      default:
        plan = OverheadVolleyTask.highLowVolleyStep();
    }

    controller = FireController(plan.tasks);

    setState(() {
      inProgress = true;
      currentTaskIndex = 0;
    });

    controller!.onProgress = (taskIndex, shotIndex) {
      print("第 $taskIndex 个点位，第 $shotIndex 球完成");
      setState(() {
       // currentTaskIndex = shotIndex;
        currentTaskIndex ++;
      });
    };

    controller!.onFinished = () {
      print("任务计划完成！");
      setState(() {
        inProgress = false;
      });
    };

    controller!.start();
  }

  // 返回选择页面
  void resetSelection() {
    //controller?.stop();
    setState(() {
      selectedStep = null;
      currentTaskIndex = 0;
      inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("凌空截击球训练"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: selectedStep == null
            ? buildStepSelection()
            : buildTrainingView(),
      ),
    );
  }

  // 步伐选择页面
  Widget buildStepSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "请选择训练步伐",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...steps.map((step) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedStep = step;
              });
            },
            child: Text(step, style: const TextStyle(fontSize: 20)),
          ),
        )),
      ],
    );
  }

  // 发球训练页面
  Widget buildTrainingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "当前步伐：$selectedStep",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          "完成第 $currentTaskIndex 球",
          style: const TextStyle(fontSize: 22, color: Colors.blue),
        ),
        const SizedBox(height: 48),
        if (!inProgress)
          ElevatedButton(
            onPressed: startTraining,
            child: const Text("开始训练", style: TextStyle(fontSize: 20)),
          ),
        if (!inProgress && currentTaskIndex > 0)
          ElevatedButton(
            onPressed: resetSelection,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("返回选择步伐", style: TextStyle(fontSize: 20)),
          ),
      ],
    );
  }

  @override
  void dispose() {
    //controller?.stop();
    SystemUtil.lockScreenDirection();
    super.dispose();
  }
}