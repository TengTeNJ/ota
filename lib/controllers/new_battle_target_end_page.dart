import 'package:flutter/material.dart';
import 'package:ota/model/Battle_user_model.dart';
import 'package:ota/views/battle_data_view.dart';
import 'package:ota/views/battle_settlement_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants.dart';

/// 双人对战结算界面

class NewBattleTargetEndPage extends StatefulWidget {
  BattleUserModel leftUserModel;
  BattleUserModel rightUserModel;

  NewBattleTargetEndPage({required this.leftUserModel,
    required this.rightUserModel,
  });

  @override
  State<NewBattleTargetEndPage> createState() => _NewBattleTargetEndPageState();
}

class _NewBattleTargetEndPageState extends State<NewBattleTargetEndPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 158),
            width: 106/812 * Constants.screenWidth(context),
            height: 202/375 * Constants.screenHeight(context),
            color: Color.fromRGBO(21, 56, 96, 1.0),
            child: BattleSettlementView(userModel: widget.leftUserModel,),
          ),
          SizedBox(width: 8,),

          Container(
            margin: EdgeInsets.only(top: 158),
            width: 220,
            height: 202/375 * Constants.screenHeight(context),
            color: Color.fromRGBO(21, 56, 96, 1.0),
            child: BattleDataView(leftUserModel: widget.leftUserModel,rightUserModel: widget.rightUserModel,),
          ),

          SizedBox(width: 8,),

          Container(
            margin: EdgeInsets.only(top: 158),
            width: 106/812 * Constants.screenWidth(context),
            height: 202/375 * Constants.screenHeight(context),
            color: Color.fromRGBO(21, 56, 96, 1.0),
            child: BattleSettlementView(userModel: widget.rightUserModel,),
          )

        ],
      ),
    );


  }
}
