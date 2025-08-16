import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ota/controllers/ntrp/ntrp_common_start_controller.dart';
import 'package:ota/model/ntrp_data_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


import '../../constants.dart';
import '../../model/Battle_user_model.dart';
import 'ntrp_integrate_test_controller.dart';
import 'package:ttntrp/ttntrp.dart';

class NtrpResultDataView extends StatefulWidget {
  NtrpDataModel rightUserModel;
  resultType type;
  NtrpResultDataView({required this.rightUserModel,required this.type});

  @override
  State<NtrpResultDataView> createState() => _NtrpResultDataViewState();
}

class _NtrpResultDataViewState extends State<NtrpResultDataView> {
  int countDownSecond = 60;
  Timer ? countDownTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     countDownTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) async{
      if (countDownSecond == 1 ) { /// 倒计时结束，进入理论测试
        countDownTimer?.cancel();

       if (widget.type == resultType.multiDimensionalResult) {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) =>
               NtrpCommonStartController(pageType: StartPageType.fourStage)), // 综合测试界面
         );
       }
       if (widget.type == resultType.technicalProficiencyResult) {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) =>
               NtrpCommonStartController(pageType: StartPageType.twoStage)), // 综合测试界面
         );
       }
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

              widget.type == resultType.technicalProficiencyResult ?
              Column(
                  children: [
                    Constants.mediumWhiteTextWidget("Forehand", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Avg.Speed", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),


                    Constants.mediumWhiteTextWidget("Backhand", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Avg.Speed", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Volley", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                  ]
              ) :
              Column(
                  children: [
                    Constants.mediumWhiteTextWidget("Power Control", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Avg.Speed", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Move shots IN", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Avg.Speed", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                  ]
              ),

              SizedBox(width:46  *kWidhtScale ,),


              widget.type == resultType.technicalProficiencyResult ?
              Column(
                  children: [
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.forehand/20*100}%", 10,
                        isHighlight: true)  ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.forehandAvgSpeed}km/h", 10,
                        isHighlight: true),
                    SizedBox(height:16 *kHeigthScale,),

                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.backhand/20*100}%", 10,
                        isHighlight: true)  ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.backhandAvgSpeed}km/h", 10,
                        isHighlight: true),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.volley/20.toDouble()*100}%", 10,
                        isHighlight: true),

                  ]
              ) :
              Column(
                  children: [

                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.powerControlCount/20*100}%", 10,
                        isHighlight: true)  ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.powerControlAvgSpeed}km/h", 10,
                        isHighlight: true),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${(widget.rightUserModel.moveShotsIn/30.toDouble()*100).round()}%", 10,
                        isHighlight: true),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.moveShotsInAvgSpeed}km/h", 10,
                        isHighlight: true),
                  ]
              ),

            ],
          ),
        )
      ],
    );

  }
}
