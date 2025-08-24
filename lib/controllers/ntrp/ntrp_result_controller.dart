import 'package:flutter/material.dart';
import 'package:ota/controllers/ntrp/ntrp_final_result_view.dart';
import 'package:ota/controllers/ntrp/ntrp_result_data_view.dart';
import 'package:ota/model/ntrp_data_model.dart';

import '../../constants.dart';
import '../../model/Battle_user_model.dart';
import '../../utils/comm_statu_manager.dart';
import '../../utils/ota_data.dart';
import '../solo/power_data_view.dart';


class NtrpResultController extends StatefulWidget {
  NtrpDataModel rightUserModel;
  resultType type;
  NtrpResultController({
    required this.rightUserModel,
    this.type = resultType.technicalProficiencyResult,
  });

  @override
  State<NtrpResultController> createState() => NtrpResultControllerState();
}

class NtrpResultControllerState extends State<NtrpResultController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 80, left: 260),
              width: 312 * kWidhtScale + 100,
              height: 202 * kHeigthScale - 50,
              color: Color.fromRGBO(21, 56, 96, 1.0),
              child:  widget.type == resultType.finalResult ?
              NtrpFinalResultView(isWinner: widget.rightUserModel.isWinner,) :
              NtrpResultDataView(rightUserModel: widget.rightUserModel,type: widget.type,),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: (){
                    Navigator.pop(context);
                    /// 机器人位置校准回到原点
                    CommStatusManager().writerData(positionCheckData());
                  },
                    child:Container(
                      margin: EdgeInsets.only(left: 40, bottom: 40),
                      width: 127,
                      height: 55,
                      color: Color.fromRGBO(100, 100, 100, 0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/stop.png',
                            width: 26 / 2,
                            height: 22 / 2,
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Constants.boldWhiteTextWidget("Exit", 20),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 1024 - 40 - 40 - 127 - 127,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
 }

