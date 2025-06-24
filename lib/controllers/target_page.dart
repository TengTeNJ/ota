import 'package:flutter/material.dart';
import 'package:ota/utils/light_controller.dart';
import 'package:ota/utils/system_util.dart';
import 'package:ota/views/target_views.dart';

import '../constants.dart';

class TargetPage extends StatefulWidget {
  const TargetPage({super.key});

  @override
  State<TargetPage> createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  List<bool> lights = [true, true, true, true, true, true, true,true];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LightController(
        onLightsChanged: (List<bool> lightDatas) {
          setState(() {
            lights = lightDatas;
          });
        },
        onAction: (int round, int action) {
          print('round=${round} -- action=${action}');
        },
        onRoundComplete: () {
          print('第一轮完成');
        },
        onAllRoundsComplete: () {
          print('全部完成');
        });
  }

  @override
  Widget build(BuildContext context) {
    double _width = (Constants.screenWidth(context) - 98 - 28 * 7) / 8;
    // print('_width=${_width}');
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                ),
                Column(
                  children: [
                    Text(
                      'Total Shots',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      '50/50',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromRGBO(21, 233, 120, 1.0)),
                    ),
                  ],
                )
              ],
            ),
            left: 16,
            right: 16,
            top: 16,
          ),
          Center(
            child: TargetViews(showIndes: lights,),
          )
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top:( Constants.screenWidth(context) - _width*2) / 2,
          //   bottom: ( Constants.screenWidth(context) - _width*2) / 2,
          //   child: TargetViews(),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemUtil.lockScreenDirection();
    super.dispose();
  }
}
