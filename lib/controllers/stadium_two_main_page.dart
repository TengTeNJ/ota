import 'package:flutter/material.dart';
import 'package:ota/constants.dart';
import 'package:ota/controllers/power_page.dart';
import 'package:ota/controllers/stadium_mode_choose_view.dart';

import 'new_battle_target_page.dart';


class StadiumTwoMainPage extends StatefulWidget {
  const StadiumTwoMainPage({super.key});

  @override
  State<StadiumTwoMainPage> createState() => _StadiumTwoMainPageState();
}

class _StadiumTwoMainPageState extends State<StadiumTwoMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
               left: 1024/2 -100,
               child: Center(
                 child: Constants.boldWhiteTextWidget("Wall Practice", 24),
               )),


           // solo mode
           Positioned(
             bottom: 150,
             left: 90,
             child: GestureDetector(onTap: (){
                print("1");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>PowerPage(type: "p1",)), // 力量训练页面
                );
             },
             child: Container(
               width: 194*1.2,
               height: 241*1.2,
               color: Colors.transparent,
               child:StadiumModeChooseView(title: "Solo Mode",
                 subTitle: "Precision Control Drills",
                 imagePath: "assets/images/solo_mode.png",
               ),

             ),
             ),
           ),

           // 2 player mode
           Positioned(
             bottom: 150,
             left: 1026/2 - 194/2,
             child: GestureDetector(onTap: (){
                 print("2");
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) =>NewBattleTargetPage()), // 目标页面
                 );
             },
               child: Container(
                 width: 194 * 1.2,
                 height: 241 * 1.2,
                 color: Colors.transparent,
                 child:StadiumModeChooseView(title: "2 Player Mode",
                   subTitle: "Precision Control Drills",
                   imagePath: "assets/images/battle_mode.png",
                 ),

               ),

             )
           ),

           // p3 mode
           Positioned(
               bottom: 150,
               right: 90,
               child:GestureDetector(onTap: (){

                 print('3');
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) =>PowerPage(type: "p3",)), // 力量训练页面
                 );
               },
               child:Container(
                 width: 194*1.2,
                 height: 241*1.2,
                 color: Colors.transparent,
                 child:StadiumModeChooseView(title: "P3 Mode",
                   subTitle: "Footwork Drills",
                   imagePath: "assets/images/p3_mode.png",
                 ),

               ),

               )
           ),


         ],
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
