import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/utils/comm_statu_manager.dart';

import '../utils/event_manager.dart';

class BleLogShow extends StatefulWidget {
  const BleLogShow({super.key});

  @override
  State<BleLogShow> createState() => _BleLogShowState();
}

class _BleLogShowState extends State<BleLogShow> {
  late StreamSubscription<DataUpdatedEvent> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      if (event.data == kBLElog) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            '蓝牙通讯日志',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: CommStatusManager().logDatas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(CommStatusManager().logDatas.reversed.toList()[index]),
            subtitle: Text('数据包 ${CommStatusManager().logDatas.length -1-index}'),
          );
        },
      ),
    );
  }
}
