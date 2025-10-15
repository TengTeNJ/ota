import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/ntrp/ntrp_guide_page_controller.dart';
import 'package:ota/controllers/solo/power_page.dart';
import 'package:ota/controllers/gamehome/stadium_mode_choose_view.dart';

import '../../utils/comm_statu_manager.dart';
import '../battle/new_battle_target_page.dart';
import '../ntrp/pressure/ntrp_pressure_test_controller.dart';

class StadiumTwoMainPage extends StatefulWidget {
  const StadiumTwoMainPage({super.key});

  @override
  State<StadiumTwoMainPage> createState() => _StadiumTwoMainPageState();
}

class _StadiumTwoMainPageState extends State<StadiumTwoMainPage> {
  List titles = ["Solo Mode", "2 Player Mode", "NTRP Test","Pressure Mode"];
  List subTitles = [
    "Precision Control Drills",
    "Battle Training",
    "Level Test",
    "Pressure Training"
  ];
  List imagePaths = [
    "assets/images/solo_mode.png",
    "assets/images/battle_mode.png",
    "assets/images/ntrp_test.png",
    "assets/images/pressure_test.png"
  ];

  int _clickCount = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    _clickCount = 0;

    super.dispose();
  }

  Widget _buildCard(int i) => Container(
      width: (Constants.screenWidth(context) - 20 * 5) / 3,
      height: Constants.screenHeight(context) / 2,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        // color:Colors.amber[100 * (i % 8 + 1)],
      ),
      child: GestureDetector(
        onTap: () {
          // 判断有没有连接发球机
          // if (CommStatusManager().currentConnectedDevice == null) {
          //    print("发球机未连接，请检查发球机重试");
          //    Get.snackbar("提示", "发球机未连接，请检查发球机重试"); // 不需要 context
          //    return;
          // }

          if (i == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PowerPage(
                        type: "p1",
                      )), // 力量训练页面
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewBattleTargetPage()), // 双人对战页面
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NtrpGuidePageController()), // NTRP引导界面
              // MaterialPageRoute(builder: (context) =>NtrpPressureTestController()), // 压力测试界面
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>NtrpPressureTestController(isNtrp: false,)), // 压力测试界面
            );
          }
        },
        child: StadiumModeChooseView(
          title: titles[i],
          subTitle: subTitles[i],
          imagePath: imagePaths[i],
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("点击啦");
        setState(() {
          _clickCount++;
          if (_clickCount == 4) {
            // 重置计数器
            _clickCount = 0;
            // 退回到开发者的界面
            Navigator.pop(context);
          }
        });
      },
      child: Scaffold(
        body: WillPopScope(
            child: Stack(
              children: [
                /// 全屏背景图片
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: FullScreenImage(),
                ),

                Positioned(
                  top: 160,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Constants.boldWhiteTextWidget("Wall Practice", 30),
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(titles.length, (i) => _buildCard(i)),
                    ),
                  ),
                )
              ],
            ),
            onWillPop: () {
              return Future.value(false);
            }),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'), // 替换为你的图片路径
          fit: BoxFit.cover, // 设置图片铺满全屏
        ),
      ),
    );
  }
}
