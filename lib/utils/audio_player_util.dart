import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../constants.dart';
import '../controllers/step_control_page.dart';
import 'comm_statu_manager.dart';
import 'ota_data.dart';

final FlutterTts flutterTts = FlutterTts();
var globalPlayer = AudioPlayer();

// 预置工具
final rnd = Random();

// 一行生成 1-30 的 Map
// final NtrpTaskMap = Map<int, VoidCallback>.fromIterable(
//   List.generate(30, (i) => i + 1),
//   key:   (i) => i,
//   value: (i) => () => switch (i) {
//     1  => controlRobotMove(200, 0,  13, 1, 14, 13, 40, 100, 175), // 正手特殊
//     >= 2 && <= 10 => controlRobotMove(0, 0,  13, 1, 14, 13, 40, 100, 175), // 正手
//     >= 11 && <= 20 => controlRobotMove(0, 0, -13, 1, 14, 13, 40, 100, 175), // 反手
//     23 || 29 => controlRobotMove(-100, 0, randomRobotAngle[rnd.nextInt(5)], 1,  randomRobotHeight[rnd.nextInt(3)], 12, 40, 90, 175), // 左截击
//     26 || 30 => controlRobotMove( 100, 0, randomRobotAngle[rnd.nextInt(5)], 1,  randomRobotHeight[rnd.nextInt(3)], 12, 40, 90, 175), // 右截击
//     _ => controlRobotMove(0, 0, randomRobotAngle[rnd.nextInt(5)], 1, randomRobotHeight[rnd.nextInt(3)], 12, 40, 90, 175),           // 其余中间截击
//   },
// );

///布云朝克特步伐
final taskMap = {
  // 1: () => controlRobotMove(0, (150), -12, 1, 15, 15, 40, 120, 125),
  // 2: () =>
  //     controlRobotMove(0, -robotDistanceAdaptation(150), 0, 1, 15, 15, 40, 120, 125),
  // 3: () => controlRobotMove(
  //     0, -robotDistanceAdaptation(150), 12, 3, 15, 15, 40, 120, 125),
  // 4: () =>
  //     controlRobotMove(0, robotDistanceAdaptation(150), -8, 1, 15, 15, 40, 120, 125),
  // 5: () => controlRobotMove(0, 0, 12, 1, 15, 15, 40, 120, 125),
  // 6: () => controlRobotMove(0, 0, 8, 2, 15, 15, 40, 120, 125),
  // 7: () =>
  //     controlRobotMove(0, robotDistanceAdaptation(150), -8, 3, 15, 15, 40, 120, 125),
  // 8: () => controlRobotMove(
  //     200, -robotDistanceAdaptation(150), 8, 1, 15, 15, 40, 120, 125),
  // 9: () => controlRobotMove(0, 0, -8, 1, 15, 15, 40, 120, 125),
  // 10: () => controlRobotMove(
  //     -200, -robotDistanceAdaptation(150), 8, 1, 15, 15, 40, 120, 125),
  // 11: () =>
  //     controlRobotMove(0, robotDistanceAdaptation(150), 8, 1, 15, 15, 40, 120, 125),
  // 12: () => controlRobotMove(
  //     0, -robotDistanceAdaptation(150), 10, 1, 13, 13, 40, 110, 125),
  // 13: () => controlRobotMove(0, 0, 8, 2, 15, 15, 40, 120, 125),
  // 14: () =>
  //     controlRobotMove(0, robotDistanceAdaptation(150), -8, 1, 14, 14, 40, 120, 125),
  // 15: () =>
  //     controlRobotMove(0, robotDistanceAdaptation(150), -8, 1, 14, 14, 40, 120, 125),
  // 16: () => controlRobotMove(0, 0, 12, 1, 15, 15, 40, 120, 125),
  // 17: () => controlRobotMove(200, 0, 0, 1, 13, 13, 40, 115, 125),
  // 18: () => controlRobotMove(200, 0, 0, 1, 12, 12, 40, 100, 125),
  // 19: () => controlRobotMove(0, 0, 10, 1, 12, 12, 40, 100, 125),
  // 20: () => controlRobotMove(0, 0, -10, 1, 12, 12, 40, 100, 125),
  // 21: () => controlRobotMove(
  //     0, -robotDistanceAdaptation(150), 32, 1, 12, 12, 40, 100, 125),
  // 22: () => controlRobotMove(-400, 0, -12, 1, 15, 15, 40, 120, 125),
  // 23: () => controlRobotMove(0, 0, 12, 1, 15, 15, 40, 120, 125),
  // 24: () => controlRobotMove(0, 0, 0, 0, 0, 0, 40, 110, 325),
};
/// jarmikSinnerRoma 步伐
final jarmikSinnerRomaTask = {
  // 1: () => controlRobotMove(0,    100,  -7,  1, 15, 15, 40, 130, 125),
  // 2: () =>
  //     controlRobotMove(0,   -300,  12,  1, 15, 15, 40, 130, 125),
  // 3: () => controlRobotMove(0,    400, -12,  3, 15, 15, 40, 130, 125),
  // 4: () => controlRobotMove(0,    200, -15,  1, 15, 15, 40, 130, 125),
  // 5: () =>
  //     controlRobotMove(0,   -300,   15,  1, 15, 15, 40, 130, 125),
  // 6: () =>
  //     controlRobotMove(0,   300,   -15,  1, 14, 14, 40, 130, 125),
  // 7: () => controlRobotMove(0,      0, 0,  1, 14, 14, 40, 130, 125),
  // 8: () => controlRobotMove(0,   -200,  -13,  1, 12, 12, 40, 113, 125),
  // 9: () => controlRobotMove(0,   0  , 0,  0, 0, 0, 40, 110, 125),
};

List<double> randomRobotAngle = [12.0,14.0,16.0,-12.0,-14.0,-16.0];

// List<double> randomRobotHeight = [14.0,16.0,17.0,18.0];

List<double> randomRobotHeight = [9.0,8,9,7];


void playLocalAudio(String sourceName,{double volume = 1.0,isAlwaysplay = false}) async {
  var player = AudioPlayer();
  globalPlayer = player;
  player.setReleaseMode(ReleaseMode.release);

  // player.setSource(AssetSource('audio/${sourceName}'));
  await player.play(AssetSource('audio/${sourceName}'),volume: volume);
  //await player.resume();
}


void playOnceLocalAudio(String sourceName,{double volume = 1.0,isAlwaysplay = false}) async {
  final player1 = AudioPlayer();

  // if (isAlwaysplay) {
  //   player1.setReleaseMode(ReleaseMode.loop);
  // } else {
    player1.setReleaseMode(ReleaseMode.release);
  // }
  // player.setSource(AssetSource('audio/${sourceName}'));
  await player1.play(AssetSource('audio/${sourceName}'),volume: volume);
  //await player.resume();
}

void pause() {
  globalPlayer.pause();
}

void release() {
  globalPlayer.release();
}

void playerDispose() {
  globalPlayer.dispose();
}

void stop() {
  globalPlayer.stop();
}

void resumeContinue() {
  globalPlayer.resume();
}

/// TTS 文字转语音
Future<void> _commonSpeakNumber(int number) async {
  await flutterTts.setLanguage("en-US"); // 设置语言
  await flutterTts.setPitch(1.0); // 设置语调
  await flutterTts.setSpeechRate(0.5); // 设置语速
  await flutterTts.speak(number.toString()); // 播放数字
}

/// 控制机器人发球移动等
void controlRobotMove( double xPosition, double yPosition, double zRotation,
    int ballCount,
    double topWheelSpeed, double bottomWheelSpeed, double turntableSpeed,
    double ballAngle, double ballInterval) {
  TennisMachineParams params =
  TennisMachineParams.fromNewState(xPosition, yPosition, zRotation, ballCount, topWheelSpeed,
      bottomWheelSpeed, turntableSpeed, ballAngle, ballInterval);
  CommStatusManager().writerData(stepControlData(params));
}

/// 移动距离适配
double robotDistanceAdaptation(int distance) {
  var type =  CommStatusManager().siteType.toInt();
  if (type == 1) {
    print("场地类型${type}");

    return (distance + kModeDistance).toDouble();
  }
  return distance.toDouble();
}
