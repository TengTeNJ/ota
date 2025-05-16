import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ota/controllers/update_progress.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../utils/ota_service_data.dart';

class OtaPage extends StatefulWidget {
  const OtaPage({super.key});

  @override
  State<OtaPage> createState() => _OtaPageState();
}

class _OtaPageState extends State<OtaPage> {
  final List<CommProgress> progressDatas = [
    CommProgress.idle,
    CommProgress.ping,
    CommProgress.eraseAll,
    CommProgress.begainWrite,
    CommProgress.sendingData,
    CommProgress.reset,
    CommProgress.finished,
  ];
  late StreamSubscription<DataUpdatedEvent> _subscription;

  List<String> keys = <String>[
    '模式1',
    '模式2',
    '模式3',
  ];
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
  String selectedKey = '切换模式';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 加载bin文件
    CommStatusManager().loadBinFile();
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      setState(() {
        if (event == kOTAProgress) {
          // 更新升级进度
          setState(() {
            _currentStep = progressDatas.indexOf(CommStatusManager().progress);
          });
        } else if (event == kOTATextProgress) {
          setState(() {});
        }
      });
    });
  }

  Future<void> _startScan() async {
    setState(() {
      _devices.clear();
      _scanning = true;
    });

    _scanStream = CommStatusManager()
        .ble
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency);

    _scanStream.listen((device) {
      if (!_devices.any((d) => d.id == device.id) &&
          device.name.contains(kBLEDeviceName)) {
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
    _devices.clear();
    CommStatusManager().progress = CommProgress.idle;
    CommStatusManager().otaStrings = ['', '', '', '', '', '', ''];
    _connected = false;
    _connectedDevice = null;
    setState(() {

    });
  }

  Future<void> _sendCommand() async {
    CommStatusManager().isOta = true;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProgress()), // 目标页面
    );
  }

  Future<void> _connectToDevice(DiscoveredDevice device) async {
    setState(() {
      _connectedDevice = device;
      _connected = false;
      _notifyChar = null;
      _writeChar = null;
    });

    _connectionStream = CommStatusManager().ble.connectToDevice(
        id: device.id, connectionTimeout: const Duration(seconds: 10));
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
        CommStatusManager()
            .ble
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

  Widget _buildDeviceItem(DiscoveredDevice device) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text('${device.id}    RSSI:${device.rssi}'),
      trailing: ElevatedButton(
        onPressed: () => _connectToDevice(device),
        child: Text("连接"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'OTA',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 1,
              color: Color.fromRGBO(235, 235, 235, 1.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _startScan,
                  child: Text(_scanning ? "扫描中..." : "搜索"),
                ),
                ElevatedButton(
                  onPressed: _devices.length > 0 ? _clearAndRescan : null,
                  child: Text("刷新"),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Color.fromRGBO(235, 235, 235, 1.0),
            ),
            const SizedBox(
              height: 16,
            ),
            if (_devices.length != 0)
              Padding(padding: EdgeInsets.only(left: 16,right: 16),child: Row(
                children: [
                  Text(
                    '设备列表',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer()
                ],
              ),),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _devices.length,
              itemBuilder: (_, index) => _buildDeviceItem(_devices[index]),
            ),
            const Spacer(),
            if (_connected)
              ElevatedButton(
                onPressed: _connected ? _sendCommand : null,
                child: Text("开始升级"),
              ),
            const SizedBox(height: 32,),
            if (_connectedDevice != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("当前连接设备：${_connectedDevice!.id}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    CommStatusManager().ble.deinitialize(); // 停止旧的 BLE 流
  }
}
