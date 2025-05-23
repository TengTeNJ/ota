import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/abount_page.dart';
import 'package:ota/controllers/ble_log_show.dart';
import 'package:ota/controllers/device_controll_page.dart';
import 'package:ota/controllers/factory_reset_page.dart';
import 'package:ota/test_controller.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:ota/utils/event_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'controllers/ota_page.dart';

class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  late StreamSubscription<DataUpdatedEvent> _subscription;

  int _currentIndex = 0;
  final List<Widget> _pages = [
    FactoryResetPage(),
    const OtaPage(),
    DeviceControlPage(),
    // AboutPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 开始蓝牙搜索
    scanBLE();
  }

  scanBLE() async {
    if (Platform.isAndroid){
      var permissionStatus = await Permission.location.request();
      PermissionStatus bleScan = await Permission.bluetoothScan.request();
      PermissionStatus bleConnect = await Permission.bluetoothConnect.request();
      if (permissionStatus.isGranted &&
          bleScan.isGranted &&
          bleConnect.isGranted) {
        Future.delayed(Duration(milliseconds: 1000), () {
          CommStatusManager().startScan();
        });
      } else {
        throw ();
      }
    }else{
      EventBus eventBus = EventBusManager().eventBus;
      _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
        if(event.data == kBLEReady){
          print('开始iOS蓝牙搜索');
          CommStatusManager().startScan();
        }
      });

    }

  }

  checkLog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BleLogShow()), // 目标页面
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: '出厂烧录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.system_update),
            label: 'OTA升级',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: '设备详情',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: '关于',
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkLog,
        tooltip: 'Increment',
        child: const Icon(Icons.view_list),
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
