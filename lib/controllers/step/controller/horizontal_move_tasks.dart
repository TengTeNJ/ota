import '../../step_control_page.dart';
import 'fire_controller.dart';
//
TennisMachineParams nearData = TennisMachineParams.fromState(0, 0, 0, 7, 6, 40, 120, 125, 1);
TennisMachineParams farData = TennisMachineParams.fromState(0, 0, 0, 12, 11, 40, 160, 125, 1);

class FirePlan {
  final List<FireTask> tasks;

  FirePlan(this.tasks);

  /// 常见模式工厂方法
  factory FirePlan.leftCenterRight({int count = 10}) {
    return FirePlan([
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 130, 0, 12, 13, 40, 180, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 13, 11, 40, 215, 175, 1),
      ),
      // 移动
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 260, 0, 13, 12, 40, 180, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 13, 11, 40, 215, 175, 1),
      ),
      // 移动
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 260, 0, 13, 13, 40, 180, 175, 0),
      ),
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 13, 11, 40, 215, 175, 1),
      ),
    ]);
  }

  factory FirePlan.leftCenterRightCenterLeft({int count = 10}) {
    return FirePlan([
      FireTask(count: count, params: TennisMachineParams.fromState(0, 150, 0, 14, 14, 40, 110, 125, 0)),
      FireTask(count: count, params: TennisMachineParams.fromState(1, 150, 0, 14, 14, 40, 110, 125, 0)),
      FireTask(count: count, params: TennisMachineParams.fromState(2, 150, 0, 14, 14, 40, 110, 125, 0)),
      FireTask(count: count, params: TennisMachineParams.fromState(1, 150, 0, 14, 14, 40, 110, 125, 0)),
      FireTask(count: count, params: TennisMachineParams.fromState(0, 150, 0, 14, 14, 40, 110, 125, 0)),
    ]);
  }

  factory FirePlan.nearAndFar({int count = 10}) {
    return FirePlan([
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 350, 0, 12, 13, 40, 180, 175, 0),
      ),
      // FireTask(
      //   count: 1,
      //   params: TennisMachineParams.fromState(0, 350, 0, 11, 12, 40, 180, 175, 0),
      // ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),
    ]);
  }

  static const double mode1_left = 10;
  static const double mode1_right = 9;

  factory FirePlan.mode1Step({int count = 10}) {
    return FirePlan([
      // 移动到左半场中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 130, 0, mode1_left, mode1_right, 40, 170, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, mode1_left, mode1_right, 40, 170, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 移动到右侧中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 230, 0, mode1_left, mode1_right, 40, 170, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -230, 0, mode1_left, mode1_right, 40, 170, 175, 0),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
      ),
    ]);
  }
}
