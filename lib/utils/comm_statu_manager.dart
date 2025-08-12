import 'dart:async';
import 'dart:io';
import 'package:any_loading/any_loading.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ota/constants.dart';
import 'package:ota/model/ble_model.dart';
import 'package:ota/utils/service_util.dart';
import 'package:path_provider/path_provider.dart';

import 'event_manager.dart';
import 'ota_service_data.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


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
    _instance.listenBLEStatu();
    return _instance;
  }

  Stream<DiscoveredDevice>? scanStream;
  StreamSubscription? _bleListen;
  StreamSubscription? _bleStatuListen;

  List<String> logDatas = ['-'];
  bool isDeviceDeail = false;

  int powerValue = 100; // 电池电量

  int targetInteral = 6; // 时间间隔

  List<int> targetIndex = [];/// 击中标靶的索引
  bool isOta = true;
  List<String> otaStrings = ['', '', '', '', '', '', ''];
  List<String> factoryStrings = [
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List<BLEModel> deviceList = [];
  BLEModel? currentConnectedDevice;
  BLEModel? myspeedzConnectedDevice;

  FlutterReactiveBle ble = FlutterReactiveBle();
  Stream<DiscoveredDevice>? _scanStream;
  double maxSpeed = 2;

  double siteType = 2; /// 场地类型（1号场 2号场 3 号场）

  double stepType = 1; /// 步伐类型（p1 2 3 4）

  int totalDataLength = 0;
  int hasSendDataLength = 0;

  int currentSpeed = 0;

  bool isStepControlling = false; // 步伐控制中
  // 当前状态
  CommProgress _progress = CommProgress.ready;

  CommProgress get progress => _progress;
  QualifiedCharacteristic? writeChar;
  QualifiedCharacteristic? notifyChar;

  List<int> binData = []; //  bin文件的数据
  List<List<int>> packetBinDatas = []; // 分包过的bin文件数据

  String versionName = '1.0.0.0';
  int statu = 0;

  set progress(CommProgress progress) {
    _progress = progress;
  }

  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
        this.deviceList.where((element) => element.device!.id == id);
    bool value = filteredDevice != null && filteredDevice.length > 0;
    return value;
  }

  refresh() {
    CommStatusManager().ble.deinitialize(); // 停止旧的 BLE 流
    _scanStream = null;
    // CommStatusManager().deviceList.clear();
    // CommStatusManager().currentConnectedDevice = null;
    startScan();
    // EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEDisconneted));
  }

  /*开始扫描*/
  Future<void> startScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      return;
    }

    if (_scanStream == null) {
      _scanStream = ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      );
      _bleListen = _scanStream!.listen((DiscoveredDevice event) {
        // 处理扫描到的蓝牙设备
        if (event.name.isEmpty) {
          return;
        }
        // print('event.name=${event.name}====${event.name.length}');
        if (event.name.contains(kBLEDeviceName) ||
            event.name.contains(kBLENewDeviceName) ||  event.name.contains('NB')) {
          // 如果设备列表数组中无，则添加
          if (!hasDevice(event.id)) {
            print('添加新设备--${event.id}----${event.name}');
            this
                .deviceList
                .add(BLEModel(deviceName: event.name, device: event));
            EventBusManager().eventBus.fire(DataUpdatedEvent(kFindNewDevice));
          }
        } else if (event.name.contains(kBLEMySpeedzName)) {
          if(this.myspeedzConnectedDevice  != null){
            print('已发现测速器---${event.name}');
            return;
          }
          // 测速器
          // 保存测速器变量
          print('发现测速器---');
          this.myspeedzConnectedDevice = BLEModel(deviceName: event.name, device: event);
          Future.delayed(Duration(milliseconds: 1000),(){
            connectToMyspeedzDevice();
          });
        }
      });
    }
  }

  /*
  * 蓝牙状态监听
  * */
  listenBLEStatu() {
    if (_bleStatuListen == null) {
      _bleStatuListen = FlutterReactiveBle().statusStream.listen((status) {
        print('蓝牙状态status===${status}');
        if (status == BleStatus.poweredOff) {
          // 蓝牙开关关闭
          _instance._bleListen?.cancel();
          _instance._bleListen = null;
          _instance._scanStream = null;
        } else if (status == BleStatus.locationServicesDisabled) {
          // 安卓位置权限不允许
        } else if (status == BleStatus.unauthorized) {
          // 未授权蓝牙权限
        } else if (status == BleStatus.ready) {
          EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEReady));
        }
      });
    }
  }

  /*
  * 连接
  * */
  Future<void> connectToDevice(BLEModel model) async {
    late StreamSubscription<ConnectionStateUpdate> stream;
    var notifyChar;
    var writeChar;
    stream = CommStatusManager()
        .ble
        .connectToDevice(
            id: model.device!.id,
            connectionTimeout: const Duration(seconds: 10))
        .listen((event) async {
      if (event.connectionState == DeviceConnectionState.connected) {
        if(model.deviceName.toString().contains(kBLEDeviceName)){
           // 摄像头主机
          notifyChar = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_CAMERA_SERVICE_NOTIFY_UUID),
              characteristicId: Uuid.parse(kBLE_CAMERA_CHARACTERISTIC_NOTIFY_UUID),
              deviceId: model.device!.id);
          writeChar = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_CAMERA_SERVICE_WRITER_UUID),
              characteristicId: Uuid.parse(kBLE_CAMERA_CHARACTERISTIC_WRITER_UUID),
              deviceId: model.device!.id);
          print("摄像头主机连接成功，并获取到特征");
          AnyLoading.showSuccess("Camera connection successful");


          CommStatusManager()
              .ble
              .subscribeToCharacteristic(notifyChar!)
              .listen((List<int> data) {
            print(
                "上报来的数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
            // 解析数据
            if(logDatas.length == 1 && logDatas.contains('-')){
              logDatas.remove('-');
            }
            this.logDatas.add(
                '${data.map((toElement) => toElement.toRadixString(16)).toList()}');
            EventBusManager().eventBus.fire(DataUpdatedEvent(kBLElog));
            OTAServiceDataParse.parseCameraData(data);
            // 解析270
          });
          EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEConneted));
          return;
        }
        notifyChar = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_NOTIFY_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_NOTIFY_UUID),
            deviceId: model.device!.id);
        writeChar = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
            deviceId: model.device!.id);
        CommStatusManager().writeChar = writeChar;
        CommStatusManager().notifyChar = notifyChar;

        BLEModel currentModel = model;
        currentModel.device = model.device!;
        currentModel.writerCharacteristic = writeChar;
        currentModel.bleStream = stream;
        currentModel.hasConected = true;
        currentModel.notifyCharacteristic = notifyChar;
        CommStatusManager().currentConnectedDevice = currentModel;

        // kBLEConneted
        EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEConneted));

        print("连接成功，并获取到特征");
        CommStatusManager()
            .ble
            .subscribeToCharacteristic(notifyChar!)
            .listen((List<int> data) {
          print(
              "上报来的数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
          // 解析数据
          if(logDatas.length == 1 && logDatas.contains('-')){
            logDatas.remove('-');
          }
          this.logDatas.add(
              '${data.map((toElement) => toElement.toRadixString(16)).toList()}');
          EventBusManager().eventBus.fire(DataUpdatedEvent(kBLElog));
          OTAServiceDataParse.parseData(data);
          // 解析270
        });
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        // 移除元素
        try {
          BLEModel firstEven = this
              .deviceList
              .firstWhere((element) => element.device!.id == model.device!.id);
          this.deviceList.remove(firstEven);
          CommStatusManager().currentConnectedDevice = null;
          EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEDisconneted));
        } catch (e) {
          print('没有找到满足条件的元素');
        }
        print("设备已断开连接");
      }
    });
  }

  Future<void> connectToMyspeedzDevice() async {
    if(this.myspeedzConnectedDevice == null){
      print('测速器未在线');
      return;
    }
    BLEModel model = this.myspeedzConnectedDevice!;
    late StreamSubscription<ConnectionStateUpdate> stream;
    var notifyChar;
    stream = CommStatusManager()
        .ble
        .connectToDevice(
        id: model.device!.id,
        connectionTimeout: const Duration(seconds: 10))
        .listen((event) async {
      if (event.connectionState == DeviceConnectionState.connected) {
        notifyChar = QualifiedCharacteristic(
            serviceId: Uuid.parse(KBLE_MYSPEEDZ_SERVICE_UUID),
            characteristicId: Uuid.parse(KBLE_MYSPEEDZ_CHARACTERISTIC_NOTIFY_UUID),
            deviceId: model.device!.id);
        CommStatusManager().myspeedzConnectedDevice?.notifyCharacteristic = notifyChar;

        BLEModel currentModel = model;
        currentModel.device = model.device!;
        currentModel.bleStream = stream;
        currentModel.hasConected = true;
        currentModel.notifyCharacteristic = notifyChar;
        CommStatusManager().myspeedzConnectedDevice = currentModel;

        // kBLEConneted
        EventBusManager().eventBus.fire(DataUpdatedEvent(kBLEConneted));
        print("连接测速器成功，并获取到特征");
        AnyLoading.showSuccess("My Speedz connection successful");


        CommStatusManager()
            .ble
            .subscribeToCharacteristic(notifyChar!)
            .listen((List<int> data) {
          print(
              "上报来的数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
          if(logDatas.length == 1 && logDatas.contains('-')){
            logDatas.remove('-');
          }
          // 解析数据
          this.logDatas.add(
              '${data.map((toElement) => toElement.toRadixString(16)).toList()}');
          EventBusManager().eventBus.fire(DataUpdatedEvent(kBLElog));
          int value = data.first;
          print('测速器的值--${value}');
          CommStatusManager().currentSpeed = value;
          EventBusManager().eventBus.fire(DataUpdatedEvent(kSpeedValue));
          // 解析270
        });
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        // 移除元素
        try {
          CommStatusManager().myspeedzConnectedDevice = null;
        } catch (e) {
          print('没有找到满足条件的元素');
        }
        print("设备已断开连接");
      }
    });
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
    if (CommStatusManager().currentConnectedDevice != null) {
      CommStatusManager().ble.writeCharacteristicWithoutResponse(
          CommStatusManager().currentConnectedDevice!.writerCharacteristic!,
          value: data);
    } else {
      print('未准备好，不能发送数据');
    }
  }

  Future<ByteData> loadBinFile() async {
    this.binData.clear();
    this.packetBinDatas.clear();

    // 从 lib 目录中读取文件
    // Uint8List bytes = await File('assets/severingcan.bin').readAsBytes();

    final dir = await getTemporaryDirectory();
    final file = File(path.join(dir.path, 'downloaded.bin'));

    // 4. 读取文件字节数据
    Uint8List bytes;
    ByteData videoData;
    try {
      bytes = await file.readAsBytes();
      videoData = bytes.buffer.asByteData();
      List<int> intList = bytes.toList();
      this.binData.addAll(intList);
    } catch (e) {
      //throw Exception('读取文件失败: $e');
      videoData = await rootBundle.load('assets/severingcan.bin');
      bytes = videoData.buffer.asUint8List();
      // Uint8List 本质上是一个 List<int>
      List<int> intList = bytes.toList();
      this.binData.addAll(intList);
    }

    //final ByteData videoData = await rootBundle.load('assets/severingcan.bin');
    // Uint8List bytes = videoData.buffer.asUint8List();
    // Uint8List 本质上是一个 List<int>

    // List<int> chunks = [];
    int chunkSize = 128;

    totalDataLength = this.binData.length; // 总数据长度

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
