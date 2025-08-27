import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../constants.dart';
// import '../../../views/pressure/pressure_end_progress_view.dart';
import '../ntrp_common_start_controller.dart';
import 'pressure_end_progress_view.dart';

class NtrpPressureEndView extends StatefulWidget {
  int count = 0;

  NtrpPressureEndView({required this.count});

  @override
  State<NtrpPressureEndView> createState() => _NtrpPressureEndViewState();
}

class _NtrpPressureEndViewState extends State<NtrpPressureEndView> {
  int countDownSecond = 60;
  Timer ? countDownTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) async{
      if (countDownSecond == 1 ) {
        countDownTimer?.cancel();
        /// 倒计时结束，进入理论测试
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              NtrpCommonStartController(pageType: StartPageType.sixStage)), //
        );
        return;
      }
      countDownSecond --;
      print("倒计时开始了");
      if (mounted) {
        setState(() {});
      }
      setState(() {});
    });

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24 * kHeigthScale,),
        Constants.boldWhiteTextWidget("Test Completed", 20),
        SizedBox(height: 33 * kHeigthScale,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 4.0,
                    percent: countDownSecond /60.0,
                    center:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${countDownSecond}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              fontFamily: 'tengxun',
                              color: Color.fromRGBO(21, 233, 120, 1.0)),
                        ),
                        SizedBox(width: 6,),
                        Text(
                          "s",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'tengxun',
                              color: Color.fromRGBO(21, 233, 120, 1.0)),
                        ),
                      ],
                    ),



                    backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
                    progressColor: Color.fromRGBO(21, 233, 120, 1.0),
                  ),
                  SizedBox(height:20,),
                  Constants.regularWhiteTextWidget("NEXT", 10,  Color.fromRGBO(21, 233, 120, 1.0)),

                ],
              ),
              SizedBox(width:46  *kWidhtScale,),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PressureEndProgressView(count: widget.count),
                  SizedBox(height: 18,),
                  PressureEndProgressView(count: widget.count <= 4 ? 0 : widget.count -4),
                  SizedBox(height: 18,),
                  Text(
                    "${widget.count}/8",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "tengxun",
                        color: Colors.white),
                  ),


                ],
              )
            ],
          ),
        )
      ],
    );

  }
}
