import '../step/controller/fire_controller.dart';
import '../step_control_page.dart';

class SoloFirePlan {

  final List<FireTask> tasks;

  SoloFirePlan(this.tasks);

  /// 草地发球机步伐
  factory SoloFirePlan.grassLandStep({int count = 10,int lastPositionCount = 20, double gameTopWheelSpeed = 8, double gameBottomWheelSpeed = 8,double gameBallAngle = 130}) {
    return SoloFirePlan([
      // 移动到中线中间位置
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 250, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 125, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往前移动两米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(100, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 10个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往前移动两米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(100, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 20个球

      FireTask(
        count: lastPositionCount,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
    ]);
  }

  /// 新的草地发球机步伐
  factory SoloFirePlan.newGrassLandStep({int count = 10,int lastPositionCount = 20, double gameTopWheelSpeed = 8, double gameBottomWheelSpeed = 8,double gameBallAngle = 130}) {
    return SoloFirePlan([
      // 移动到中线中间位置
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 250, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 125, 0),
      ),
      // 移动到中间
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往前移动一米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(100, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 往左发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0,-13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往右发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往前移动一米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(100, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),

      // 往左发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, -13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往右发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),

      // 往左平移1m
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -100, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),

      // 发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),

      // 往右平移1m(中线) + 1m（中线右侧）
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 200, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),


      // 往左移动1m
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, -100, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),

      // 退回1.5m
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(-150, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),

      // 往左发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, -13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往右发 5个球
      FireTask(
        count: 5,
        params: TennisMachineParams.fromState(0, 0, 13, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
    ]);
  }



  /// 硬地发球机步伐
  factory SoloFirePlan.hardCountStep({int firstCount = 12,int secondCount = 18 ,int count = 20, double gameTopWheelSpeed = 8, double gameBottomWheelSpeed = 8,double gameBallAngle = 130}) {
    return SoloFirePlan([
      // 移动到中线位置
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(0, 310, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40,
            gameBallAngle, 125, 0),
      ),
      // 12个球
      FireTask(
        count: firstCount,
        params: TennisMachineParams.fromState(0, 0, 0,
            gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 1),
      ),
      // 往前移动两米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(200, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 18个球
      FireTask(
        count: secondCount,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed - 1, gameBottomWheelSpeed - 1, 40, gameBallAngle -5, 175, 1),
      ),
      // 往前移动两米
      FireTask(
        count: 1,
        params: TennisMachineParams.fromState(200, 0, 0, gameTopWheelSpeed, gameBottomWheelSpeed, 40, gameBallAngle, 175, 0),
      ),
      // 20个球
      FireTask(
        count: count,
        params: TennisMachineParams.fromState(0, 0, 0, gameTopWheelSpeed - 1, gameBottomWheelSpeed - 1, 40, gameBallAngle - 5, 175, 1),
      ),

    ]);
  }


}