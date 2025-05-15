import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

// 1️⃣ 定义ota进度枚举
enum CommProgress {
  ready, // ready状态 未进行ota的阶段
  idle, // 初始化状态 未发送任何升级的指令 此时先发送一个系统复位的指令 然后继续你选哪个下面的操作
  ping, // 握手
  eraseAll, // 擦除所有
  begainWrite, // 开始写
  sendingData, // 发送bin文件数据
  reset, // reset
  finished, // 完成
  error // 出错
}

bool _loadBin = false;

// 2️⃣ 单例类
class CommStatusManager {
  // 私有构造
  CommStatusManager._internal();
  Timer? timer;

  // 单例实例
  static final CommStatusManager _instance = CommStatusManager._internal();

  // 获取单例对象
  factory CommStatusManager() {
    // if(!_loadBin){
    //   _loadBin = true;
    // }
    return _instance;
  }
  bool isOta = true;
  List<String> otaStrings = ['','','','','','',''];
  List<String> factoryStrings = ['','','','','','',];

  FlutterReactiveBle ble = FlutterReactiveBle();
  // 当前状态
  CommProgress _progress = CommProgress.ready;

  CommProgress get progress => _progress;
  QualifiedCharacteristic? writeChar;

  List<int> binData = []; //  bin文件的数据
  List<List<int>> packetBinDatas = []; // 分包过的bin文件数据

  String versionName = '1.0.0.0';
  int statu = 0;

  set progress(CommProgress progress) {
    _progress = progress;
  }

  // 设置状态（你也可以加入日志打印）
  void updateProgress(CommProgress newProgress) {
    _progress = newProgress;
    print('OTA进度更新为: $newProgress');
  }

  // 可选：添加状态监听器（适合 UI 层绑定）
  final List<void Function(CommProgress)> _listeners = [];

  void addListener(void Function(CommProgress) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(CommProgress) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_progress);
    }
  }

  void updateAndNotify(CommProgress newProgress) {
    _progress = newProgress;
    _notifyListeners();
    print('📡 通讯进度通知: $newProgress');
  }

  /**
   * 发送蓝牙数据
   */
  void writerData(List<int> data) {
    // 发送数据
    if (CommStatusManager().writeChar != null) {
      CommStatusManager().ble.writeCharacteristicWithoutResponse(
          CommStatusManager().writeChar!,
          value: data);
    } else {
      print('未准备好，不能发送数据');
    }
  }

  Future<ByteData> loadBinFile() async {
    // 从 lib 目录中读取文件
    // Uint8List bytes = await File('assets/severingcan.bin').readAsBytes();
    final ByteData videoData = await rootBundle.load('assets/severingcan.bin');
    // Uint8List bytes = videoData.buffer as  Uint8List();
    Uint8List bytes = videoData.buffer.asUint8List();
    // Uint8List 本质上是一个 List<int>
    List<int> intList = bytes.toList();
    this.binData.addAll(intList);

    this.packetBinDatas.clear();
    // List<int> chunks = [];
    int chunkSize = 128;

    for (int i = 0; i < this.binData.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > this.binData.length) {
        end = this.binData.length;
      }
      List<int> chunk = this.binData.sublist(i, end);
      this.packetBinDatas.add(chunk);
    }

    return videoData;
  }
}
