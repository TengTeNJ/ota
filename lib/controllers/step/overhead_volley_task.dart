import '../step_control_page.dart';
import 'controller/fire_controller.dart';

TennisMachineParams highData = TennisMachineParams.fromState(0, 0, 0, 12, 12, 40, 110, 125, 1);
TennisMachineParams lowData = TennisMachineParams.fromState(0, 0, 0, 12, 12, 40, 170, 125, 1);


class OverheadVolleyTask {

  final List<FireTask> tasks;

  OverheadVolleyTask(this.tasks);

  /// 截击凌空球发球机步伐
  factory OverheadVolleyTask.highLowVolleyStep({
    int count = 1,
    int cycles = 25,
    double gameBallAngle = 130,
    double? moveDistance, // 不传就不移动
  }) {

    final List<FireTask> tasks = [];

    // 是否需要移动
    if (moveDistance != null) {
      tasks.add(
        FireTask(
          count: 1,
          params: TennisMachineParams.fromState(
              0, moveDistance, 0, 8, 8, 40, 120, 125, 0),
        ),
      );
    }

    // 循环高低球
    for (int i = 0; i < cycles; i++) {
      tasks.add(
        FireTask(
          count: count,
          params: highData,
        ),
      );

      tasks.add(
        FireTask(
          count: 1,
          params: lowData,
        ),
      );
    }

    return OverheadVolleyTask(tasks);
  }



}