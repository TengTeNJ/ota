import 'package:flutter/material.dart';
import 'package:ota/controllers/ntrp/ntrp_stage_description_controller.dart';

import '../../utils/audio_player_util.dart';
import 'ntrp_test_controller.dart';

/// ntrp 引导界面
class NtrpGuidePageController extends StatefulWidget {
  const NtrpGuidePageController({super.key});

  @override
  State<NtrpGuidePageController> createState() => _NtrpGuidePageControllerState();
}

class _NtrpGuidePageControllerState extends State<NtrpGuidePageController> {

  Future<void> _speakString(String number) async {
    await flutterTts.setLanguage("en-US"); // 设置语言
    await flutterTts.setPitch(1.0); // 设置语调
    await flutterTts.setSpeechRate(0.5); // 设置语速
    await flutterTts.speak(number.toString()); // 播放数字
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playLocalAudio('ntrp_remind.mp3', isAlwaysplay: true);
    Future.delayed(Duration(milliseconds: 10000), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>NtrpStageDescriptionController()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromRGBO(18, 83, 157, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/guide_icon.png',
            width: 120,
            height: 120,
          ),

          SizedBox(width: 12,),

          Center(
            child: Text(
              "Welcome to the NTRP Test Mode.\n"
                  "You will complete a 20-minute test consisting of 4 modules.\n"
                  "Are you ready? Let's begin!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "SanFranciscoDisplay",
                  fontSize: 24,
                  height: 2.2,
                  color: Colors.white),
            ),
          ),


         // Row(
         //   crossAxisAlignment: CrossAxisAlignment.center,
         //   mainAxisAlignment: MainAxisAlignment.center,
         //   children: [
         //     GestureDetector(onTap: (){
         //       Navigator.push(
         //         context,
         //         MaterialPageRoute(builder: (context) =>NtrpTestController()), // NTRP测试
         //       );
         //     },
         //       child:Padding(padding: EdgeInsets.only(bottom: 24,left: 64),
         //
         //          child:  Image.asset(
         //            'assets/images/stop.png',
         //            width: 16.44,
         //            height: 14,
         //          ),
         //       ),
         //
         //     ),
         //   ],
         // )





        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pause();
    release();
    playerDispose();
    super.dispose();
  }
}
