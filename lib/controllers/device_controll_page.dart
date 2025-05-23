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
import '../views/empty_view.dart';

class DeviceControlPage extends StatefulWidget {
  const DeviceControlPage({super.key});

  @override
  State<DeviceControlPage> createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
  late StreamSubscription<DataUpdatedEvent> _subscription;

  List<DiscoveredDevice> _devices = [];
  DiscoveredDevice? _connectedDevice;
  bool _connected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommStatusManager().progress = CommProgress.ready;
    // 加载bin文件
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

  initData(){
    if(CommStatusManager().currentConnectedDevice != null){
      setState(() {
        _connectedDevice = CommStatusManager().currentConnectedDevice!.device;
        _connected = true;
      });
    }else{
      _connectedDevice = null;
      _connected = false;
    }
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

  /*
  * 发送数据
  * */
  void _sendBluetoothData(BuildContext context, String data) {
    CommStatusManager().writerData(changeModeData(int.parse(data)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已发送: $data'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildModeButton(BuildContext context, String text, String data) {
    return ElevatedButton(
      onPressed: () {
        // 在这里调用发送蓝牙数据的逻辑
        _sendBluetoothData(context, data);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
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
            const SizedBox(height: 32,),
            if(_connected)
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '选择模式',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildModeButton(context, '模式 1', '0'),
                      SizedBox(height: 20),
                      _buildModeButton(context, '模式 2', '1'),
                      SizedBox(height: 20),
                      _buildModeButton(context, '模式 3', '2'),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 36,),

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
