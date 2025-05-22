import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ota/controllers/update_progress.dart';
import 'package:ota/model/ble_model.dart';
import 'package:ota/views/empty_view.dart';

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

  initData(){
    if(CommStatusManager().currentConnectedDevice != null){
      print('++++');
      setState(() {
        _connectedDevice = CommStatusManager().currentConnectedDevice!.device;
        _connected = true;
      });
    }else{
      _connectedDevice = null;
      _connected = false;
    }
  }

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
            _currentStep = progressDatas.indexOf(CommStatusManager().progress);
        } else if (event == kOTATextProgress) {

        }else if(event.data == kBLEConneted){
          initData();
        }else if(event.data == kBLEDisconneted){
          initData();
        }
      });
    });
   initData();
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
      BLEModel _device = CommStatusManager().deviceList.firstWhere((_element) => _element.device!.id == model.device!.id);
      if(_device != null){
        setState(() {
          CommStatusManager().currentConnectedDevice = null;
          _connectedDevice = null;
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
      body:  CommStatusManager().deviceList.length == 0 ? EmptyView(): Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            if (CommStatusManager().deviceList.length != 0)
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
    _subscription.cancel();
    super.dispose();
  }
}
