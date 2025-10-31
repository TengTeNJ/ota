import 'dart:async';
import 'package:any_loading/any_loading.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/abount_page.dart';
import 'package:ota/controllers/ble_log_show.dart';
import 'package:ota/controllers/device_controll_page.dart';
import 'package:ota/controllers/factory_reset_page.dart';
import 'package:ota/controllers/step_control_page.dart';
import 'package:ota/controllers/target_page.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'package:ota/utils/event_manager.dart';
import 'package:ota/utils/language_model.dart';
import 'package:ota/utils/service_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'controllers/ota_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/fault_statu_one.dart';

class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  late StreamSubscription<DataUpdatedEvent> _subscription;
  bool _hasRequest = true;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    FactoryResetPage(),
    const OtaPage(),
    DeviceControlPage(),
    AboutPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 模拟弹窗提示发球机故障
    // Future.delayed(Duration(milliseconds: 2), () {
    //   List<int> data = [0x01, 0x80];
    //   final status = DeviceStatus.fromBytes(data);
    //   status.printSummary();
    // });
    // 开始蓝牙搜索
    scanBLE();
    dataRequest();
// // 创建原始字节数据
//     final bytes = Uint8List(8);
//
// // 创建ByteData视图
//     final view = ByteData.view(bytes.buffer);
//
// // 通过ByteData修改
//     view.setInt32(0, 42);
//
// // Uint8List会立即反映变化
//     print(bytes[0]); // 42
//     print(bytes.sublist(0, 4)); // [42, 0, 0, 0]
//
// // 反之亦然
//     bytes[4] = 255;
//     print(view.getUint8(4)); // 255
  }

  void dataRequest() async {
    CommStatusManager().loadBinFile();
    final response =
        await http.get(Uri.parse('http://3.236.189.174:91/api/upgrade/getUrl'));
    print('Response data: ${response.body}');
    final jsonData = jsonDecode(response.body);
    // 获取 data 字段
    String data = jsonData['data'];
    String url =
        'https://potent-hockey-us.s3.us-east-1.amazonaws.com/images/20250703/6aa14410702d47d79d0598a35097a60b.bin';
    if (data != null && data.contains('http')) {
      url = data;
    }
    print('Response url: ${url}');
    AnyLoading.showLoading(
        title: Provider.of<LanguageModel>(context, listen: false)
            .getText('正在更新最新固件程序...'),
        maskType: AnyLoadingMaskType.black);
    bool _value = await downloadAndConvertBin(url);
    setState(() {
      _hasRequest = true;
    });
    if (_value) {
      AnyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Provider.of<LanguageModel>(context, listen: false)
              .getText('更新下载最新的固件成功')),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      AnyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Provider.of<LanguageModel>(context, listen: false)
              .getText('更新下载最新的固件失败，使用本地默认固件')),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  scanBLE() async {
    if (Platform.isAndroid) {
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
    } else {
      EventBus eventBus = EventBusManager().eventBus;
      _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
        if (event.data == kBLEReady) {
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
      body: _hasRequest
          ? _pages[_currentIndex]
          : Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.orange,
              size: 60,
            )),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.grey,
        /*
        * 在 Flutter 的 BottomNavigationBar 中，当 item 数量超过 3 个时，
        * 默认会切换为 shifting 类型，这会导致背景色变为白色。
        * 而 item 数量 ≤3 时默认使用 fixed 类型，背景色跟随主题色
        * */
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.copy),
            label:
                Provider.of<LanguageModel>(context, listen: true).getText('烧录'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.system_update),
            label: Provider.of<LanguageModel>(context, listen: true)
                .getText('OTA升级'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label:
                Provider.of<LanguageModel>(context, listen: true).getText('设备'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more),
            label:
                Provider.of<LanguageModel>(context, listen: true).getText('更多'),
          ),
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
