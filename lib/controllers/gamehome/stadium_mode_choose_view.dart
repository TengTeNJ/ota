import 'package:flutter/material.dart';
import 'package:ota/constants.dart';

class StadiumModeChooseView extends StatefulWidget {
  String title = "";
  String subTitle = "";
  String imagePath = "";

   StadiumModeChooseView({required this.title,
     required this.subTitle,
     required this.imagePath,
   });

  @override
  State<StadiumModeChooseView> createState() => _StadiumModeChooseViewState();
}

class _StadiumModeChooseViewState extends State<StadiumModeChooseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: FullScreenImage1()),

          Positioned(
              top: 35 * 2,
              left:  widget.title == "P3 Mode" ? 194/ 2 + 4: 194/ 2 - 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    '${widget.imagePath}',
                    width: 65 * 1.5,
                    height: 65 * 1.5,
                  ),
                  SizedBox(height: 13*2,),
                  Constants.boldWhiteTextWidget("${widget.title}", 20),
                  SizedBox(height: 5*2,),
                  Constants.regularWhiteTextWidget("${widget.subTitle}", 13,
                      Color.fromRGBO(233, 100, 21, 1.0),
                  ),
                ],

              )

          )

        ],
      ),
    );
  }
}

class FullScreenImage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/choose_mode_bg.png'), // 替换为你的图片路径
          fit: BoxFit.cover, // 设置图片铺满全屏
        ),
      ),
    );
  }
}