import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/Battle_user_model.dart';

class BattleDataView extends StatefulWidget {
  BattleUserModel leftUserModel;
  BattleUserModel rightUserModel;


  BattleDataView({required this.leftUserModel,
    required this.rightUserModel
  });

  @override
  State<BattleDataView> createState() => _BattleDataViewState();
}

class _BattleDataViewState extends State<BattleDataView> {

  Color highColor =  Color.fromRGBO(21, 233, 120, 1.0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20 * Constants.screenHeight(context) /375,),

        Constants.boldWhiteTextWidget("Game Shots", 20),
        SizedBox(height: 20 * Constants.screenHeight(context) /375,),

        /// score
        Padding(padding:
        EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.tengxunBoldWhiteTextWidget("${widget.leftUserModel.score}", 10,isHighlight: widget.leftUserModel.isWinner),
              Constants.mediumWhiteTextWidget("Score", 10, Color.fromRGBO(93, 148, 212, 1.0)),
              Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.score}", 10,isHighlight: widget.rightUserModel.isWinner),
            ],
          ),
        ),        /// shots in
        Padding(padding:
          EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.tengxunBoldWhiteTextWidget("${widget.leftUserModel.shotInCount}", 10,isHighlight: widget.leftUserModel.isWinner),
              Constants.mediumWhiteTextWidget("Shots in", 10, Color.fromRGBO(93, 148, 212, 1.0)),
              Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.shotInCount}", 10,isHighlight: widget.rightUserModel.isWinner),
            ],
          ),
       ),

        /// TOP Speed km/h
        Padding(padding:
        EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.tengxunBoldWhiteTextWidget("${widget.leftUserModel.topSpeed}", 10,isHighlight: widget.leftUserModel.isWinner),
              Constants.mediumWhiteTextWidget("TOP Speed km/h", 10, Color.fromRGBO(93, 148, 212, 1.0)),
              Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.topSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
            ],
          ),
        ),
        /// Avg. Speed km/h
        Padding(padding:
        EdgeInsets.only(top: 16* Constants.screenHeight(context) /375,left: 27,right: 27),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Constants.tengxunBoldWhiteTextWidget("${widget.leftUserModel.avgSpeed}", 10,isHighlight: widget.leftUserModel.isWinner),
              Constants.mediumWhiteTextWidget("Avg. Speed km/hh", 10, Color.fromRGBO(93, 148, 212, 1.0)),
              Constants.tengxunBoldWhiteTextWidget("${widget.rightUserModel.avgSpeed}", 10,isHighlight: widget.rightUserModel.isWinner),
            ],
          ),
        ),
      ],
    );

  }
}
