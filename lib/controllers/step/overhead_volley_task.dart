import '../step_control_page.dart';
import 'controller/fire_controller.dart';

TennisMachineParams highData = TennisMachineParams.fromState(0, 0, 13, 8, 8, 40, 110, 125, 1);
TennisMachineParams lowData = TennisMachineParams.fromState(0, 0, 13, 8, 8, 40, 130, 125, 1);


class OverheadVolleyTask {

  final List<FireTask> tasks;

  OverheadVolleyTask(this.tasks);

  /// 截击凌空球发球机步伐
  factory OverheadVolleyTask.highLowVolleyStep({int count = 1, double gameBallAngle = 130}) {
    return OverheadVolleyTask([
      // 移动到中线中间位置
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 310, 0, 8, 8, 40, 120, 125, 0),
      ),
      // 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),
      // 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),// 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),
      // 高的截击球
      FireTask(
        count: count,
        params: highData,
      ),
      // 低的截击球
      FireTask(
        count: 1,
        params: lowData,
      ),


    ]);
  }



}