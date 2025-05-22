import 'dart:async';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ota/controllers/factory_progress.dart';
import 'package:ota/controllers/update_progress.dart';
import '../constants.dart';
import '../model/ble_model.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';
import '../utils/ota_data.dart';
import '../utils/ota_service_data.dart';
import '../views/empty_view.dart';

class FactoryResetPage extends StatefulWidget {
  const FactoryResetPage({super.key});

  @override
  State<FactoryResetPage> createState() => _FactoryResetPageState();
}

class _FactoryResetPageState extends State<FactoryResetPage> {
  final List<CommProgress> progressDatas = [
    CommProgress.ping,
    CommProgress.eraseAll,
    CommProgress.begainWrite,
    CommProgress.sendingData,
    CommProgress.reset,
    CommProgress.finished,
  ];
  late StreamSubscription<DataUpdatedEvent> _subscription;

  DiscoveredDevice? _connectedDevice;

  bool _connected = false;

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
      if(event.data == kBLEConneted){
          initData();
        }else if(event.data == kBLEDisconneted){
          initData();
        }
      });
    });

    initData();
  }


  Future<void> _sendCommand() async {
    CommStatusManager().isOta = false;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FactoryProgress()), // 目标页面
    );
  }

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
            '烧录',
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
                child: Text("开始烧录"),
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