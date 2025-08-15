import 'package:flutter/material.dart';

import '../../constants.dart';

class NtrpFinalResultView extends StatefulWidget {
  const NtrpFinalResultView({super.key});

  @override
  State<NtrpFinalResultView> createState() => _NtrpFinalResultViewState();
}

class _NtrpFinalResultViewState extends State<NtrpFinalResultView> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /// 全屏背景图片
      Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: (202 * kHeigthScale - 50) /2,
        child: FullScreenBGImage(),
      ),

      Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 24 * kHeigthScale,
              ),
              Constants.boldWhiteTextWidget("Test Completed", 30),
              SizedBox(
                height: 33 * kHeigthScale,
              ),
              Constants.tengxunBoldWhiteTextWidget(">2.5", 36,
                  isHighlight: true),
              SizedBox(
                height: 20,
              ),
              Constants.regularWhiteTextWidget(
                  "NEXT", 10, Color.fromRGBO(21, 233, 120, 1.0)),
              SizedBox(
                height: 100,
              ),
              Constants.mediumWhiteTextWidget(
                  "Advancing beginner Level", 20, Colors.white),
            ],
          )),
    ]);

    // return Column(
    //   // mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     SizedBox(height: 24 * kHeigthScale,),
    //     Constants.boldWhiteTextWidget("Test Completed", 30),
    //     SizedBox(height: 33 * kHeigthScale,),
    //     Constants.tengxunBoldWhiteTextWidget(">2.5", 36,
    //         isHighlight: true),
    //     SizedBox(height:20,),
    //     Constants.regularWhiteTextWidget("NEXT", 10,  Color.fromRGBO(21, 233, 120, 1.0)),
    //     SizedBox(height:100,),
    //     Constants.mediumWhiteTextWidget("Advancing beginner Level", 20, Colors.white),
    //
    //   ],
    // );
  }
}

class FullScreenBGImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/final_result_bg.png'), // 替换为你的图片路径
          fit: BoxFit.cover, // 设置图片铺满全屏
        ),
      ),
    );
  }
}
