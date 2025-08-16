import 'package:flutter/material.dart';
import 'package:ota/controllers/ntrp/ntrp_integrate_test_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ttntrp/ttntrp.dart';

import '../../constants.dart';
import '../../model/ntrp_data_model.dart';
import '../../utils/comm_statu_manager.dart';
import 'ntrp_result_controller.dart';
import 'ntrp_test_controller.dart';

/// ntrp 结果类型
enum StartPageType{
  oneStage,
  twoStage,
  threeStage,
  fourStage,
  fiveStage,
  sixStage,

}

/// 通用阶段开头
class NtrpCommonStartController extends StatefulWidget {
  StartPageType pageType;

  NtrpCommonStartController({
    required this.pageType,
  });

  @override
  State<NtrpCommonStartController> createState() => _NtrpCommonStartControllerState();
}

class _NtrpCommonStartControllerState extends State<NtrpCommonStartController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 3000), () async {
      switch (widget.pageType) {
        case StartPageType.oneStage:
          // TODO: Handle this case.

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>NtrpTestController()), // 第一阶段
            // MaterialPageRoute(builder: (context) =>NtrpIntegrateTestController()), // 第二阶段

          );
          case StartPageType.twoStage:
            final result = (await NtrpAssessmentPlugin.startAssessment(context,indexes: [0,1,2,3,4,5,6,7,8,9]));
            if (result != null) {
              print('result=${result}',);
              CommStatusManager().ntrpCorrectCount += result.correctAnswers ;

              print("1阶段对了${result.correctAnswers}道题");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    NtrpCommonStartController(pageType: StartPageType.threeStage)), // 综合测试界面
              );
            }

        case StartPageType.threeStage:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>NtrpIntegrateTestController()),
          );
        case StartPageType.fourStage:
          final result = (await NtrpAssessmentPlugin.startAssessment(context,
              indexes: [10,11,12,13,14,15,16,17,18,19]));
          if (result != null) {
            print('result=${result}',);
            var correct = result.score;
            CommStatusManager().ntrpCorrectCount += result.correctAnswers ;
            print("2阶段对了${result.correctAnswers}道题");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  NtrpCommonStartController(pageType: StartPageType.fiveStage)), // 综合测试界面
            );
          }
        case StartPageType.fiveStage:
          // TODO: Handle this case.
          throw UnimplementedError();
        case StartPageType.sixStage:
          final result = await NtrpAssessmentPlugin.startAssessment(context,
              indexes: [20,21,22,23,24,25,26,27,28,29]);
          if (result != null) {
            print('result=${result}',);
            CommStatusManager().ntrpCorrectCount += result.correctAnswers;
            print("3阶段对了${result.correctAnswers}道题");

            /// 理论题60分(30道题答对18道题)
            var score = CommStatusManager().ntrpCorrectCount;
            print("一共答对了多少道题${score}");
            var isWinner = false;
            if ( CommStatusManager().ntrpTechnicalProficiencyResult
                && CommStatusManager().ntrpMultiDimensionalResult
                && score >=18) {
              isWinner = true;
            }

            var model = NtrpDataModel(forehand: 3,
                forehandAvgSpeed: 100,
                backhand: 5,
                backhandAvgSpeed: 90,
                volley: 6,
                isWinner:isWinner
            );

            /// // 最终的结算页面
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>NtrpResultController(
                rightUserModel: model,type: resultType.finalResult,
              )),
            );

            /// 得分清0
            CommStatusManager().ntrpCorrectCount = 0;
          }
      }



    });
  }

  String getString(StartPageType pageType) {
    switch (pageType) {
      case StartPageType.oneStage: return "Technical Proficiency Test";
      case StartPageType.twoStage:  return "Tennis Theory Test";
      case StartPageType.threeStage: return "Multi-Dimensional Test";
      case StartPageType.fourStage:
        return "Tennis Theory Test";
      case StartPageType.fiveStage:
        // TODO: Handle this case.
        return "Match Simulation";
      case StartPageType.sixStage:
        return "Tennis Theory Test";
    }
  }

  String getSerialNumber(StartPageType pageType) {
    switch (pageType) {
      case StartPageType.oneStage: return "1";
      case StartPageType.twoStage:  return "2";
      case StartPageType.threeStage: return "3";
      case StartPageType.fourStage:
        return "4";
      case StartPageType.fiveStage:
      // TODO: Handle this case.
        return "5";
      case StartPageType.sixStage:
        return "6";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 83, 157, 1.0),
      body: Stack(
        children: [
          Center(
              child:
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
                          "${getSerialNumber(widget.pageType)}",
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
                  Constants.boldWhiteTextWidget("${getString(widget.pageType)}", 30),
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
                  if (widget.pageType == StartPageType.fiveStage) {
                    /// 直接调到阶段6
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          NtrpCommonStartController(pageType: StartPageType.sixStage)), //
                    );
                  }
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
