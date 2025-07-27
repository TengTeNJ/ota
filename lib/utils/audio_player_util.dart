import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();
final player = AudioPlayer();

void playLocalAudio(String sourceName,{double volume = 1.0,isAlwaysplay = false}) async {
  // if (isAlwaysplay) {
       player.setReleaseMode(ReleaseMode.release);
  // }

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
   player.pause();
}

/// TTS 文字转语音
Future<void> _speakNumber(int number) async {
  await flutterTts.setLanguage("en-US"); // 设置语言
  await flutterTts.setPitch(1.0); // 设置语调
  await flutterTts.setSpeechRate(0.5); // 设置语速
  await flutterTts.speak(number.toString()); // 播放数字
}