import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ota/controllers/update_progress.dart';
import 'package:ota/model/ble_model.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../utils/ota_service_data.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
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

      });
    });
    initData();
  }

  initData(){
    if(CommStatusManager().currentConnectedDevice != null){
      print('++++');
      setState(() {
        _connectedDevice = CommStatusManager().currentConnectedDevice!.device;
        _connected = true;
        _devices.add(_connectedDevice!);
        _notifyChar = CommStatusManager().currentConnectedDevice!.notifyCharacteristic;
        _writeChar = CommStatusManager().currentConnectedDevice!.writerCharacteristic;
      });
    }
  }

  Future<void> _startScan() async {
    setState(() {
      _devices.clear();
      _scanning = true;
      CommStatusManager().deviceList.clear();
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

  /*
  * 连接
  * */
  Future<void> _connectToDevice(BLEModel model) async {
    // 断开连接
    if(CommStatusManager().currentConnectedDevice != null && CommStatusManager().currentConnectedDevice!.device!.id == model.device!.id){
      // 断开连接
      CommStatusManager().currentConnectedDevice!.bleStream?.cancel();
      DiscoveredDevice _device = _devices.firstWhere((_element) => _element.id == model.device!.id);
      if(_device != null){
        setState(() {
          CommStatusManager().currentConnectedDevice = null;
          _connectedDevice = null;
          _devices.remove(_device);
          _connected = false;
        });
      }
      return;
    }

  CommStatusManager().connectToDevice(model);

  }

  Widget _buildDeviceItem(BLEModel model) {
    return ListTile(
      title: Text(model.device!.name),
      subtitle: Text('${model.device!.id}    RSSI:${model.device!.rssi}'),
      trailing: ElevatedButton(
        onPressed: () => _connectToDevice(model),
        child:  Text( CommStatusManager().currentConnectedDevice != null && CommStatusManager().currentConnectedDevice!.device!.id == model.device!.id ? "断开连接" : '连接'),
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
              itemCount: CommStatusManager().deviceList.length,
              itemBuilder: (_, index) => _buildDeviceItem(CommStatusManager().deviceList[index]),
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
