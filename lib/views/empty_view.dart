import 'package:flutter/material.dart';
import 'package:ota/utils/comm_statu_manager.dart';
import 'dart:io' show Platform;

import 'package:ota/views/speed_wheel.dart';
import 'package:provider/provider.dart';

import '../utils/language_model.dart';

class EmptyView extends StatefulWidget {
  const EmptyView({super.key});

  @override
  State<EmptyView> createState() => _EmptyViewState();
}

Widget _buildPlatformSpecificTips(BuildContext context) {
  if (Platform.isAndroid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1 . ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙1')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Text(
          '2. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙2')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        Text(
          ' 3. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙3')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
        ),
      ],
    );
  } else if (Platform.isIOS) {
    return Column(
      children: [
        Text(
          '1. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙1')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          '2. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙2')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          '3. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙3')}',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  } else {
    return Text(
      '1. ${Provider.of<LanguageModel>(context, listen: true).getText('蓝牙1')}',
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }
}
class _EmptyViewState extends State<EmptyView> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      // child: Container(
      //   width: 200,
      //   height: 200,
      //   child: SpeedWheel(
      //     onSpeedChanged: (x, y) {
      //       print(0.00 == 0);
      //       print('X: ${x.toStringAsFixed(2)}, Y: ${y.toStringAsFixed(2)}');
      //     },
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          _buildPlatformSpecificTips(context),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 可以在这里添加重新搜索的逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('正在重新搜索...')),
              );
              CommStatusManager().refresh();
            },
            child:Text( Provider.of<LanguageModel>(context, listen: true).getText('重新搜索')),
          ),
        ],
      ),
    );
  }
}
