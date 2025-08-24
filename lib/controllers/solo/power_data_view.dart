import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../constants.dart';
import '../../model/Battle_user_model.dart';


class PowerDataView extends StatefulWidget {

  BattleUserModel rightUserModel;
  PowerDataView({required this.rightUserModel});

  @override
  State<PowerDataView> createState() => _PowerDataViewState();
}

class _PowerDataViewState extends State<PowerDataView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24 * kHeigthScale,),
        Constants.boldWhiteTextWidget("Game Shots", 20),
        SizedBox(height: 33 * kHeigthScale,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30,),
              new CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 4.0,
                percent: (widget.rightUserModel.shotInCount/50).toDouble(),
                center:
                Text(
                  '${(widget.rightUserModel.shotInCount/50 * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'tengxun',
                      color: Colors.white),
                ),

                backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
                progressColor: Color.fromRGBO(21, 233, 120, 1.0),
              ),
              SizedBox(width:46  *kWidhtScale,),

              Column(
                children: [

                  Constants.mediumWhiteTextWidget("Shots in", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                  SizedBox(height:16 *kHeigthScale,),
                  Constants.mediumWhiteTextWidget("TOP Speed", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                  SizedBox(height:16 *kHeigthScale,),
                  Constants.mediumWhiteTextWidget("Avg. Speed km/h", 10, Color.fromRGBO(93, 148, 212, 1.0)),

                ]

              ),
              SizedBox(width:46  *kWidhtScale ,),

              Column(
                  children: [
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.shotInCount}", 10,
                        isHighlight: true) ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.topSpeed} km/h", 10,
                        isHighlight: true)  ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.avgSpeed} km/h", 10,
                        isHighlight: true),
                  ]

              ),

            ],
          ),
        )




        // / shots in
        // Padding(padding:
        // EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.shotInCount}", 10,
        //           isHighlight: widget.rightUserModel.isWinner),
        //       Constants.mediumWhiteTextWidget("Shots in", 10, Color.fromRGBO(93, 148, 212, 1.0)),
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.shotInCount}", 10,
        //           isHighlight: widget.rightUserModel.isWinner),
        //     ],
        //   ),
        // ),

        /// TOP Speed km/h
        // Padding(padding:
        // EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.topSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
        //       Constants.mediumWhiteTextWidget("TOP Speed km/h", 10, Color.fromRGBO(93, 148, 212, 1.0)),
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.topSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
        //     ],
        //   ),
        // ),
        /// Avg. Speed km/h
        // Padding(padding:
        // EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.avgSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
        //       Constants.mediumWhiteTextWidget("Avg. Speed km/hh", 10, Color.fromRGBO(93, 148, 212, 1.0)),
        //       Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.avgSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
        //     ],
        //   ),
        // ),
      ],
    );

  }
}
