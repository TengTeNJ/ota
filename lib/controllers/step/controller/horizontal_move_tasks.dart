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

  static const double paulo_top = 12;
  static const double paulo_bottom = 12;
  /// 常见模式工厂方法
  factory FirePlan.pauloStep() {
    return FirePlan([
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, -12, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -150, 0, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -150, 12, paulo_top, paulo_bottom, 40, 140, 125, 3),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, -8, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 12, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, paulo_top, paulo_bottom, 40, 140, 125, 2),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, -8, paulo_top, paulo_bottom, 40, 140, 125, 3),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(200, -150, 8, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -8, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(-200, -150, 8, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, 8, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -150, 10, paulo_top-2, paulo_bottom-2, 40, 130, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 8, paulo_top, paulo_bottom, 40, 140, 125, 2),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, -8, paulo_top-1, paulo_bottom-1, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 150, -8, paulo_top-1, paulo_bottom-1, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 12, paulo_top, paulo_bottom, 40, 140, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(200, 0, 0, paulo_top-2, paulo_bottom-2, 40, 135, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(200, 0, 0, paulo_top-3, paulo_bottom-3, 40, 120, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 10, paulo_top-3, paulo_bottom-3, 40, 100, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, -10, paulo_top-3, paulo_bottom-3, 40, 100, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -150, 32, paulo_top-3, paulo_bottom-3, 40, 100, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(-400, 0, -12, paulo_top, paulo_bottom, 40, 120, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 12, paulo_top, paulo_bottom, 40, 120, 125, 1),
      ),
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 0, 0, 0, 0, 40, 110, 325, 0),
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

  /**
   * 横向喂球
   */
  static double _speed = 9.0;
  factory FirePlan.lateralBallFeeding({int count = 1}) {
    return FirePlan([
      FireTask(count: 5, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(0, -206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(1, -206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(2, -206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(1, -206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(0, 206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(0, 206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(0, 206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

      FireTask(count: count, params: TennisMachineParams.fromState(0, 206, 0, _speed, _speed, 40, 110, 125, 1)),
      FireTask(count: 4, params: TennisMachineParams.fromState(1, 0, 0, _speed, _speed, 40, 110, 125, 1)),

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
