
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'utils/comm_statu_manager.dart';
import 'utils/ota_data.dart';
import 'utils/ota_service_data.dart';
const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
const kBLE_SERVICE_WRITER_UUID = "ffe5";
const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";
class BluetoothDebugPage extends StatefulWidget {
  @override
  State<BluetoothDebugPage> createState() => _BluetoothDebugPageState();
}

class _BluetoothDebugPageState extends State<BluetoothDebugPage> {
  //final _ble = FlutterReactiveBle();
  final _targetName = "Stickhandling"; // 只显示设备名包含该字符串的设备

  List<DiscoveredDevice> _devices = [];
  DiscoveredDevice? _connectedDevice;
  QualifiedCharacteristic? _notifyChar;
  QualifiedCharacteristic? _writeChar;

  late Stream<DiscoveredDevice> _scanStream;
  late Stream<ConnectionStateUpdate> _connectionStream;

  bool _scanning = false;
  bool _connected = false;
  int _currentStep = 0;
  final int _totalSteps = 7;
  Future<ByteData> loadBinFile() async {
    // 从 lib 目录中读取文件
   // Uint8List bytes = await File('assets/severingcan.bin').readAsBytes();
    final ByteData videoData =
    await rootBundle.load('assets/severingcan.bin');
   // Uint8List bytes = videoData.buffer as  Uint8List();
    Uint8List bytes = videoData.buffer.asUint8List();
    // Uint8List 本质上是一个 List<int>
  //  List<int> intList = uint8List.toList();
    return videoData;
  }

  void initState() {
    super.initState();
    CommStatusManager().loadBinFile();
    //loadBinFile();
      //_ble = CommStatusManager().ble;
    print('object');
  }



  @override
  void dispose() {
    CommStatusManager().ble.deinitialize();
    super.dispose();
  }

  Future<void> _startScan() async {
    PermissionStatus locationPermission = await Permission.location.request();
    PermissionStatus bleScan = await Permission.bluetoothScan.request();
    PermissionStatus bleConnect = await Permission.bluetoothConnect.request();
    setState(() {
      _devices.clear();
      _scanning = true;
    });

    _scanStream = CommStatusManager().ble.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency);

    _scanStream.listen((device) {
      if (!_devices.any((d) => d.id == device.id) && device.name.contains(_targetName)) {
        setState(() {
          _devices.add(device);
        });
      }
    }, onDone: () {
      setState(() {
        _scanning = false;
      });
    });
  }

  void _clearAndRescan() {
    CommStatusManager().ble.deinitialize(); // 停止旧的 BLE 流
    _startScan();
  }

  Future<void> _connectToDevice(DiscoveredDevice device) async {
    setState(() {
      _connectedDevice = device;
      _connected = false;
      _notifyChar = null;
      _writeChar = null;
    });

    _connectionStream = CommStatusManager().ble.connectToDevice(id: device.id, connectionTimeout: const Duration(seconds: 10));
    _connectionStream.listen((event) async {
      if (event.connectionState == DeviceConnectionState.connected) {
        setState(() => _connected = true);
        _notifyChar = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_NOTIFY_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_NOTIFY_UUID),
            deviceId: device.id);
        _writeChar = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
            deviceId: device.id);
        CommStatusManager().writeChar = _writeChar;
        print("连接成功，并获取到特征");
        CommStatusManager().ble
            .subscribeToCharacteristic(_notifyChar!)
            .listen((List<int> data) {
            print(
                "上报来的数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
            // 解析数据
            OTAServiceDataParse.parseData(data);
          // 解析270
          });
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        setState(() {
          _connected = false;
          _notifyChar = null;
          _writeChar = null;
        });
        print("设备已断开连接");
      }
    });
  }

  int crc16Update(List<int> src) {
    int crc = 0;
    for (int byte in src) {
      crc ^= byte << 8;
      for (int i = 0; i < 8; i++) {
        int temp = crc << 1;
        if ((crc & 0x8000) != 0) {
          temp ^= 0x1021;
        }
        crc = temp;
      }
    }
    return crc & 0xFFFF; // 确保结果为 16 位
  }

  List<int> realBuildWirterCommand(){
    List<int> _tempValue =  [0x5a,0xa5,0x04,0x00,0x01,0x02,0x03,0x04];
    int  _value = crc16Update(_tempValue);
    List<int> finalValue = [
      _value & 0xFF,       // 低位字节
      (_value >> 8) & 0xFF // 高位字节
    ];
    _tempValue.insert(4, finalValue.first);
    _tempValue.insert(5, finalValue.last);
    return _tempValue;
  }
  List<int> buildWirterCommand(){
    List<int> _tempValue =  [0x5a,0xa4,0x0c,0x00,0x04,0x00,0x00,0x02,0x00,0x80,0x00,0x08,0x04,0x00,0x00,0x00];
    int  _value = crc16Update(_tempValue);
    List<int> finalValue = [
      _value & 0xFF,       // 低位字节
      (_value >> 8) & 0xFF // 高位字节
    ];
    _tempValue.insert(4, finalValue.first);
    _tempValue.insert(5, finalValue.last);
    return _tempValue;
  }
  Future<void> _sendCommand() async {

    // 开始发送ping数据
    CommStatusManager().progress = CommProgress.ping;
    CommStatusManager()
        .writerData(pingData());
    return;

    // Read
    List<int> _tempValue =  [0x5a,0xa4,0x0c,0x00,0x03,0x00,0x00,0x02,0x00,0x80,0x00,0x08,0x04,0x00,0x00,0x00];
    int  _value = crc16Update(_tempValue);
    List<int> finalValue = [
      _value & 0xFF,       // 低位字节
      (_value >> 8) & 0xFF // 高位字节
    ];
    _tempValue.insert(4, finalValue.first);
    _tempValue.insert(5, finalValue.last);
    // 示例指令（可替换）
    // 握手 心跳 Ping
    final command = Uint8List.fromList([0x5a, 0xa6]);
    if (_writeChar == null) {
      print("写特征未准备好");
      return;
    }

    // 擦除所有的指令
    [0x5a ,0xa4 ,0x08 ,0x00 ,0x0c ,0x22 ,0x01,0x00,0x00,0x01,0x00 ,0x00 ,0x00,0x00];
    [0x5a,0xa1];
    // reset指令
     [
      0x5a, 0xa4, 0x04, 0x00, 0x6f, 0x46, 0x0b, 0x00, 0x00, 0x00
    ];
    [0x5a,0xa1];
     // [0x5a, 0xa6]
    await CommStatusManager().ble.writeCharacteristicWithoutResponse(_writeChar!, value:  [0x5a ,0xa4 ,0x08 ,0x00 ,0x0c ,0x22 ,0x01,0x00,0x00,0x01,0x00 ,0x00 ,0x00,0x00]);
    print("指令已发送");

    setState(() {
      _currentStep = (_currentStep + 1).clamp(0, _totalSteps);
    });
  }

  Widget _buildDeviceItem(DiscoveredDevice device) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id),
      trailing: ElevatedButton(
        onPressed: () => _connectToDevice(device),
        child: Text("连接"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("蓝牙调试工具")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _startScan,
                child: Text(_scanning ? "扫描中..." : "开始扫描"),
              ),
              ElevatedButton(
                onPressed: _clearAndRescan,
                child: Text("清除并重新扫描"),
              ),
              ElevatedButton(
                onPressed: _connected ? _sendCommand : null,
                child: Text("发送指令"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (_, index) => _buildDeviceItem(_devices[index]),
            ),
          ),
          if (_connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("当前连接设备：${_connectedDevice!.name}", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}