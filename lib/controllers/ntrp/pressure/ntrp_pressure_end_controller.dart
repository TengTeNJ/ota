import 'package:flutter/material.dart';
import 'ntrp_pressure_end_view.dart';
import '../../../constants.dart';

class NtrpPressureEndController extends StatefulWidget {
  int score = 0;
  bool isNtrp = true;
  NtrpPressureEndController({required this.score,this.isNtrp = true});

  @override
  State<NtrpPressureEndController> createState() => _NtrpPressureEndControllerState();
}

class _NtrpPressureEndControllerState extends State<NtrpPressureEndController> {
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
            child: NtrpPressureEndView(count: widget.score,isNtrp: widget.isNtrp,)),

          SizedBox(
            height: 20,
          ),

          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: (){
                  Navigator.of(context).popUntil((route) =>route.isFirst);// 回到跟视图
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


              ],
            ),
          )


        ],
      ),
    );

  }
}
