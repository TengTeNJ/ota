import 'package:flutter/material.dart';
import 'package:ota/model/Battle_user_model.dart';
import 'package:ota/views/battle_data_view.dart';
import 'package:ota/views/battle_settlement_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../constants.dart';
import '../utils/comm_statu_manager.dart';
import '../utils/ota_data.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              ),

            ],
          ),


          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40,bottom: 40),
                  width: 127,
                  height: 55,
                  color: Color.fromRGBO(100, 100, 100, 0.7),
                  child: GestureDetector(onTap: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    print("退出结算界面");
                    /// 机器人位置校准回到原点
                    CommStatusManager().writerData(positionCheckData());
                    },
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/stop.png',
                          width: 26/2,
                          height: 22/2,
                        ),
                        SizedBox(width: 11,),
                        Constants.boldWhiteTextWidget("Exit", 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 1024 - 40 -40 - 127 -127,),
                Container(
                    margin: EdgeInsets.only(right: 40,bottom: 40),
                    width: 127,
                    height: 55,
                    color: Color.fromRGBO(100, 100, 100, 0.7),
                    child: GestureDetector(onTap: (){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/stop.png',
                            width: 26/2,
                            height: 22/2,
                          ),
                          SizedBox(width: 11,),
                          Constants.boldWhiteTextWidget("Replay", 20),

                        ],
                      ),

                    )
                )

              ],
            ),
          )



        ],
      ),
    );
  }
}
