import '../step/controller/fire_controller.dart';
import '../step_control_page.dart';


TennisMachineParams farData = TennisMachineParams.fromState(0, 0, 0, 34, 32, 40, 160, 200, 1);
TennisMachineParams nearData = TennisMachineParams.fromState(0, 0, 0, 30, 26, 40, 166, 200, 1);

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

}