// import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:flutter/material.dart';
import 'package:ota/controllers/ntrp/ntrp_common_start_controller.dart';
import 'package:ota/controllers/ntrp/ntrp_test_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../constants.dart';
import 'dart:async';


/// 阶段说明界面
class NtrpStageDescriptionController extends StatefulWidget {
  const NtrpStageDescriptionController({super.key});

  @override
  State<NtrpStageDescriptionController> createState() =>
      _NtrpStageDescriptionControllerState();
}

class _NtrpStageDescriptionControllerState
    extends State<NtrpStageDescriptionController> {
  bool beginCountDown = true; // 开始倒计时
  int count = 3;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      beginCountDown = true;
      /// 3s 倒计时
      var timer = Timer.periodic(Duration(milliseconds: 1000),(timer){
        if (!mounted) return;
        if(count == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                NtrpCommonStartController(pageType: StartPageType.oneStage)),
          );
          timer?.cancel();
          return;
        }
        count --;
        setState(() {});

      });
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          Center(
            child:
            beginCountDown == true ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Constants.boldWhiteTextWidget("Ready", 30),
                SizedBox(height: 20,),
                new CircularPercentIndicator(
                  radius: 64.0,
                  lineWidth: 8.0,
                  percent: 1.0,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${count}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 44,
                            fontFamily: 'SanFranciscoDisplay',
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
                  progressColor: Color.fromRGBO(21, 233, 120, 1.0),
                ),
              ],
            )
            :
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularPercentIndicator(
                  radius: 44.0,
                  lineWidth: 4.0,
                  percent: 1.0,
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "1",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontFamily: 'SanFranciscoDisplay',
                            color: Color.fromRGBO(21, 233, 120, 1.0)),
                      ),
                    ],
                  ),
                  backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
                  progressColor: Color.fromRGBO(21, 233, 120, 1.0),
                ),
                SizedBox(height: 20,),
                Constants.boldWhiteTextWidget("Technical Proficiency Test", 30),
              ],
            )
          ),

          /// stop 暂停按钮
          Positioned(
            bottom: 40,
            left: 40,
            child: GestureDetector(
                onTap: () {
                  print("123");
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/stop.png',
                        width: 16.44,
                        height: 14,
                      ),

                      SizedBox(width: 20,),

                      Text(
                        'NTRP TEST',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "tengxun",
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
