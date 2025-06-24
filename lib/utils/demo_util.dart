import 'package:ota/controllers/step_control_page.dart';

class DemoUtil {

  static List<TennisMachineParams> demoStepDatas() {
    List<TennisMachineParams> _datas = [];
    // int xPosition; // 竖向位置，向上为正
    //   int yPosition; // 横向位置，向左为正
    //   int zRotation; // 旋转角度，左转为正
    //
    //   // 发球参数
    //   int topWheelSpeed; // 上发球轮速度
    //   int bottomWheelSpeed; // 下发球轮速度
    //   int turntableSpeed; // 转盘速度
    //   int ballAngle; // 发球角度
    //
    //   // 发球模式参数
    //   double ballInterval; // 发球间隔(秒)
    //   int ballCount; //
    int severing_speed_one = 16; // 14
    int severing_angle_one = 120; // 90
    int severing_speed_two = 16;
    int severing_angle_two = 120; // 发球角度
    int turntable_speeds = 40;
    int timeInteral = 250;
    int z = 13;
    int count = 2;
    List<int> xDatas = [0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    List<int> yDatas = [0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    List<int> zDatas = [0, -z,z,-z,z,-z,z,-z,z,-z,z,-z,z,-z,z,-z,z,0];
    List<int> ballCounts = [0, count,count,count,count,count,count,count,count,count,count,count,count,count,count,count,count,0];
    List<int> bottomWheelSpeeds = [
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      0
    ];
    List<int> topWheelSpeeds = [
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      severing_speed_two,
      severing_speed_one,
      severing_speed_one,
      severing_speed_two,
      0
    ];

    List<int> turntableSpeeds = [
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      0
    ];
    List<int> ballAngles = [
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      90
    ];
    List<int> ballIntervals = [
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral
    ];

    for(int i = 0; i < xDatas.length; i ++){
      TennisMachineParams params = TennisMachineParams.fromState(
          xDatas[i].toDouble(),
          yDatas[i].toDouble(),
          zDatas[i].toDouble(),
          topWheelSpeeds[i].toDouble(),
          bottomWheelSpeeds[i].toDouble(),
          turntableSpeeds[i].toDouble(),
          ballAngles[i].toDouble(),
          ballIntervals[i].toDouble(),
          ballCounts[i]);
      _datas.add(params);
    }
    return _datas;
  }

  static List<TennisMachineParams> squreStepDatas() {
    List<TennisMachineParams> _datas = [];
    // int xPosition; // 竖向位置，向上为正
    //   int yPosition; // 横向位置，向左为正
    //   int zRotation; // 旋转角度，左转为正
    //
    //   // 发球参数
    //   int topWheelSpeed; // 上发球轮速度
    //   int bottomWheelSpeed; // 下发球轮速度
    //   int turntableSpeed; // 转盘速度
    //   int ballAngle; // 发球角度
    //
    //   // 发球模式参数
    //   double ballInterval; // 发球间隔(秒)
    //   int ballCount; //
    int severing_speed_one = 16; // 14
    int severing_angle_one = 120; // 90
    int severing_speed_two = 16;
    int severing_angle_two = 120; // 发球角度
    int turntable_speeds = 40;
    int timeInteral = 250;
    int z = 13;
    int count = 1;
    List<int> xDatas = [0,0,100,0,0,0,0,-100,100,0,-100];
    List<int> yDatas = [0,0,0,0,0,-100,0,100,100,0,-100];
    List<int> zDatas = [z,-z,0,8,-8,0,10,0,0,-10,0];
    List<int> ballCounts = [count,count,count,count,count,count,count,count,count,count,0];
    List<int> bottomWheelSpeeds = [
      severing_speed_two,
      severing_speed_two,
      13,
      13,
      13,
      13,
      15,
      15,
      13,
      15,
      0
    ];
    List<int> topWheelSpeeds = [
      severing_speed_two,
      severing_speed_two,
      13,
      13,
      13,
      13,
      15,
      15,
      13,
      15,
      0
    ];

    List<int> turntableSpeeds = [
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      turntable_speeds,
      0,
    ];
    List<int> ballAngles = [
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      severing_angle_two,
      severing_angle_one,
      severing_angle_one,
      severing_angle_two,
      severing_angle_two,
      90
    ];
    List<int> ballIntervals = [
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
      timeInteral,
    ];

    for(int i = 0; i < xDatas.length; i ++){
      TennisMachineParams params = TennisMachineParams.fromState(
          xDatas[i].toDouble(),
          yDatas[i].toDouble(),
          zDatas[i].toDouble(),
          topWheelSpeeds[i].toDouble(),
          bottomWheelSpeeds[i].toDouble(),
          turntableSpeeds[i].toDouble(),
          ballAngles[i].toDouble(),
          ballIntervals[i].toDouble(),
          ballCounts[i]);
      _datas.add(params);
    }
    return _datas;
  }
}