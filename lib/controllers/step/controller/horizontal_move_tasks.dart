import '../../step_control_page.dart';
import 'fire_controller.dart';

class FirePlan {
  final List<FireTask> tasks;

  FirePlan(this.tasks);

  /// 常见模式工厂方法
  factory FirePlan.leftCenterRight({int count = 10}) {
    return FirePlan([
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 11, 12, 40, 180, 175, 1),
      ),
      // 移动
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 350, 0, 11, 12, 40, 180, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 11, 12, 40, 180, 175, 1),
      ),
      // 移动
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 350, 0, 11, 12, 40, 180, 175, 0),
      ),
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, 11, 12, 40, 180, 175, 1),
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
}
