import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEModel {
  String? deviceName;
  DiscoveredDevice? device; // 蓝牙设备信息
  QualifiedCharacteristic? notifyCharacteristic; // notify特征值
  QualifiedCharacteristic? writerCharacteristic; // writer特征值
  StreamSubscription<ConnectionStateUpdate>? bleStream;
  bool? hasConected; // 连接状态

  BLEModel(
      { this.deviceName,
        this.device,
        this.hasConected = false});
}