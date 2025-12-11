import '../../step_control_page.dart';
import 'fire_controller.dart';
//
TennisMachineParams farData = TennisMachineParams.fromState(0, 0, 0, 35, 35, 40, 177, 200, 1);
TennisMachineParams nearData = TennisMachineParams.fromState(0, 0, 0, 25, 25, 40, 225, 200, 1);

TennisMachineParams jiejiData = TennisMachineParams.fromState(0, 0, 0, 35, 35, 40, 225, 200, 1);


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
      // 远球
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      FireTask(
        count: 1,
        params: farData,
      ),
      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),


      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 近球
      FireTask(
        count: 1,
        params: nearData,
      ),

      // 截击
      FireTask(
        count: 1,
        params: jiejiData,
      ),

      // 截击
      FireTask(
        count: 1,
        params: jiejiData,
      ),

      // 截击
      FireTask(
        count: 1,
        params: jiejiData,
      ),

      // 截击
      FireTask(
        count: 1,
        params: jiejiData,
      ),






    ]);
  }

  static const double mode1_left = 8;
  static const double mode1_right = 8;
  static const double mode1_ball_angel = 140;
  factory FirePlan.mode1Step({int count = 10}) {
    return FirePlan([
      // 移动到左半场中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 130, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 移动到右侧中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 230, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -230, 0, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 0),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, mode1_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 140, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(20, 0, 0, mode1_left, mode1_right, 40, 140, 175, 1),
      ),
    ]);
  }

  static const double mode2_left = 10;
  static const double mode2_right = 9;
  static const double mode2_ball_angel = 140;
  factory FirePlan.mode2Step({int count = 10}) {
    return FirePlan([
      // 移动到左半场中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 130, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 移动到右侧中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 230, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -230, 0, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 0),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel ,175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      // 左右交替
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, mode2_left, mode2_right, 40, mode2_ball_angel, 175, 1),
      ),
    ]);
  }

  static const double mode2_up_slow = 10;
  static const double mode2_down_slow = 9;

  static const double mode2_up_fast = 10;
  static const double mode2_down_fast= 9;

  static const double ballAngle_slow = 160;
  static const double ballAngle_fast = 180;





  // factory FirePlan.mode2Step({int count = 10}) {
  //   return FirePlan([
  //     // 移动到中间
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 330, 0, mode2_up_slow, mode2_down_slow, 40, 170, 175, 0),
  //     ),
  //
  //     // 第一阶段左右交替 10个球
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode2_up_slow, mode2_down_slow, 40, ballAngle_slow, 175, 1),
  //     ),
  //
  //     // 10个球
  //     FireTask(
  //       count: count,
  //       params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 移动到中间
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 200, 0, mode1_left, mode1_right, 40, 170, 175, 0),
  //     ),
  //     // 10个球
  //     FireTask(
  //       count: count,
  //       params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 移动到右侧中间
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 230, 0, mode1_left, mode1_right, 40, 170, 175, 0),
  //     ),
  //     // 10个球
  //     FireTask(
  //       count: count,
  //       params: TennisMachineParams.fromState(0, 0, 0, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 移动到中间
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, -230, 0, mode1_left, mode1_right, 40, 170, 175, 0),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     // 左右交替
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, 8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //     FireTask(
  //       count: 1,
  //       params: TennisMachineParams.fromState(0, 0, -8, mode1_left, mode1_right, 40, 170, 175, 1),
  //     ),
  //   ]);
  // }
}
