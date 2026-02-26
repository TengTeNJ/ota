import '../step/controller/fire_controller.dart';
import '../step_control_page.dart';


TennisMachineParams farData = TennisMachineParams.fromState(0, 0, 0, 34, 32, 40, 115, 200, 1);
TennisMachineParams nearData = TennisMachineParams.fromState(0, 0, 0, 30, 26, 40, 115, 200, 1);

/// 底线球
TennisMachineParams bottomLineData = TennisMachineParams.fromState(0, 0, 0, 34, 32, 40, 115, 200, 1);
/// 近网球
TennisMachineParams netPlayData = TennisMachineParams.fromState(0, 0, 0, 34, 32, 40, 115, 200, 1);
/// 截击球
TennisMachineParams volleyData = TennisMachineParams.fromState(0, 0, 0, 34, 32, 40, 115, 200, 1);

class SmallRobotTask {
  final List<FireTask> tasks;

  SmallRobotTask(this.tasks);

  /// 小型发球机远近发球
  factory SmallRobotTask.nearFarStep({int count = 1}) {
    return SmallRobotTask([
      FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),FireTask(
        count: 1,
        params: nearData,
      ),
      FireTask(
        count: count,
        params: farData,
      ),
    ]);
  }

  /// 小型发球机底线 近网 网前截击 循环发球
  factory SmallRobotTask.cycleStep({double bottomLineTopSpeed = 30,double bottomLineBottomSpeed = 30,double bottomLineAngle = 15,
    double netPlayTopSpeed = 30,double netPlayBottomSpeed = 30,double netPlayAngle = 15,
    double volleyTopSpeed = 30,double volleyBottomSpeed = 30,double volleyAngle = 15,
  }) {
    return SmallRobotTask([
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, bottomLineTopSpeed, bottomLineBottomSpeed, 40, bottomLineAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 3,
        params: TennisMachineParams.fromState(0, 0, 0, netPlayTopSpeed, netPlayBottomSpeed, 40, netPlayAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 2,
        params: TennisMachineParams.fromState(0, 0, 0, volleyTopSpeed, volleyBottomSpeed, 40, volleyAngle+75.0, 175, 1),
      ),


      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, bottomLineTopSpeed, bottomLineBottomSpeed, 40, bottomLineAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 3,
        params: TennisMachineParams.fromState(0, 0, 0, netPlayTopSpeed, netPlayBottomSpeed, 40, netPlayAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 2,
        params: TennisMachineParams.fromState(0, 0, 0, volleyTopSpeed, volleyBottomSpeed, 40, volleyAngle+75.0, 175, 1),
      ),


      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, bottomLineTopSpeed, bottomLineBottomSpeed, 40, bottomLineAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 3,
        params: TennisMachineParams.fromState(0, 0, 0, netPlayTopSpeed, netPlayBottomSpeed, 40, netPlayAngle+75.0, 175, 1),
      ),
      FireTask(
        count: 2,
        params: TennisMachineParams.fromState(0, 0, 0, volleyTopSpeed, volleyBottomSpeed, 40, volleyAngle+75.0, 175, 1),
      ),

    ]);
  }


}