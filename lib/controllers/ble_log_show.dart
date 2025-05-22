import 'dart:async';

import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            '蓝牙通讯日志',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body:  ListView.builder(
        shrinkWrap: true,
        itemCount: CommStatusManager().logDatas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(CommStatusManager().logDatas[index]),
            subtitle:  index != 0 ? Text( '数据包 $index') : null,
          );
        },
      ),
    );
  }
}
