import 'package:flutter/material.dart';

import '../utils/comm_statu_manager.dart';
import '../utils/ota_data.dart';
import '../views/speed_wheel.dart';
class Sped extends StatefulWidget {
  const Sped({super.key});

  @override
  State<Sped> createState() => _SpedState();
}

class _SpedState extends State<Sped> {
  DateTime _currentTimer = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            '调节速度',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: SpeedWheel(
            onSpeedChanged: (x, y) {
              print(0.00 == 0);
//                         CommStatusManager().writerData(setSpeedData(0, 0));
// return;
              DateTime endTime = DateTime.now();
              Duration difference = endTime.difference(_currentTimer);
              int milliseconds = difference.inMilliseconds;
              if(milliseconds >= 100){
                //print('发送数据');
                _currentTimer = endTime;
                CommStatusManager().writerData(setSpeedData(x, y));
              }else{
                print('时间过短，不发送数据');
              }

              //  print('X: ${x.toStringAsFixed(2)}, Y: ${y.toStringAsFixed(2)}');
            },
          ),
        ),
      ),
    );
  }
}
