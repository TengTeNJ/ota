import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/event_manager.dart';

class LogShow extends StatefulWidget {
  const LogShow({super.key});

  @override
  State<LogShow> createState() => _LogShowState();
}

class _LogShowState extends State<LogShow> {
  late StreamSubscription<DataUpdatedEvent> _subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus eventBus = EventBusManager().eventBus;
    _subscription = eventBus.on<DataUpdatedEvent>().listen((event) {
      setState(() {
        if (event.data == kOTATextProgress) {
          print(
              'CommStatusManager().otaStrings=${CommStatusManager().otaStrings}');
          // setState(() {
          //
          // });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            '日志输出',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView.separated(
              shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      CommStatusManager().otaStrings[index],
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    color: Color.fromRGBO(207, 207, 207, 1.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  );
                },
                itemCount: CommStatusManager().otaStrings.length),
            ElevatedButton(onPressed: (){
              if(mounted){
                setState(() {

                });
              }
            }, child: Text('刷新'))
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
