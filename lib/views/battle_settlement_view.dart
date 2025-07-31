import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../model/Battle_user_model.dart';

/// 游戏结算界面
class BattleSettlementView extends StatefulWidget {

  BattleUserModel userModel;

  BattleSettlementView({required this.userModel});

  @override
  State<BattleSettlementView> createState() => _BattleSettlementViewState();
}

class _BattleSettlementViewState extends State<BattleSettlementView> {
  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
        // 202/375 * Constants.screenHeight(context)
         SizedBox(height: 32 * Constants.screenHeight(context) / 375,),
         new CircularPercentIndicator(
           radius: 40.0,
           lineWidth: 4.0,
           percent: (widget.userModel.shotInCount/25).toDouble(),
           center:
           Text(
             '${(widget.userModel.shotInCount/25 * 100).toStringAsFixed(0)}%',
             style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
                 fontFamily: 'tengxun',
                 color: Colors.white),
           ),

           backgroundColor: Color.fromRGBO(112, 112, 112, 1.0),
           progressColor: Color.fromRGBO(21, 233, 120, 1.0),
         ),

         SizedBox(height: 4,),
         Constants.regularWhiteTextWidget("Hit Rate", 10, Colors.white),
         SizedBox(height: 31 * Constants.screenHeight(context) / 375,),

         widget.userModel.isWinner || widget.userModel.isDraw ?
         Image.asset(
           'assets/images/winner.png',
           width: 26/2,
           height: 22/2,
         ) :
         Container(
           height: 22/2,
         ),


         Text(
           '${widget.userModel.score}',
           style: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 24,
               fontFamily: 'tengxun',
               color:  widget.userModel.isWinner || widget.userModel.isDraw ? Color.fromRGBO(21, 233, 120, 1.0): Colors.white),
         ),

         SizedBox(height: 4,),
         Constants.regularWhiteTextWidget("Score", 10, Colors.white),


       ],
    );
  }
}
