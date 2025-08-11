import 'package:flutter/material.dart';
import 'package:ota/model/ntrp_data_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../constants.dart';
import '../../model/Battle_user_model.dart';

class NtrpResultDataView extends StatefulWidget {

  NtrpDataModel rightUserModel;
  NtrpResultDataView({required this.rightUserModel});

  @override
  State<NtrpResultDataView> createState() => _NtrpResultDataViewState();
}

class _NtrpResultDataViewState extends State<NtrpResultDataView> {
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
              new CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 4.0,
                percent: widget.rightUserModel.isWinner == true ? 1.0 : 0.0,
                center:
                Text(
                  widget.rightUserModel.isWinner == true ? '2.5' : "<2.5",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      fontFamily: 'tengxun',
                      color: widget.rightUserModel.isWinner == true ? Color.fromRGBO(21, 233, 120, 1.0) :
                      Color.fromRGBO(177, 177, 177, 1.0)),
                ),
                backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
                progressColor: Color.fromRGBO(21, 233, 120, 1.0),
              ),
              SizedBox(width:46  *kWidhtScale,),

              Column(
                  children: [
                    Constants.mediumWhiteTextWidget("Long Rally", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Forehand", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Backhand", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.mediumWhiteTextWidget("Volley", 10, Color.fromRGBO(93, 148, 212, 1.0)),
                  ]
              ),
              SizedBox(width:46  *kWidhtScale ,),

              Column(
                  children: [
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.longRally}", 10,
                        isHighlight: true) ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.forehand} /10", 10,
                        isHighlight: true)  ,
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.backhand} /10", 10,
                        isHighlight: true),
                    SizedBox(height:16 *kHeigthScale,),
                    Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.volley} /10", 10,
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
